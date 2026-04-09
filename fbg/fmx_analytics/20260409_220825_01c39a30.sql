-- Query ID: 01c39a30-0212-644a-24dd-0703193ff37f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:25.368000+00:00
-- Elapsed: 39927ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_order_pnl
    
    
    
    as (-- This model calculates order specific PNL for the customer, as well as will be used for 
-- a base for fees and profit for FMX. This has been split out to reduce the complexity of 
-- the core orders model, and to allow for more focused development and testing around PNL and fees calculations.
-- We use a FIFO approach to allocate buys to sells, and then calculate PNL based on the matched quantities. 
-- i.e a customer sells 10 contracts, we will look back at their previous buys to determine how much of that sell is
-- closing which buy, and calculate PNL based on the price difference between the matched buy and sell quantities.
-- We also allocate settlement payouts to remaining open quantities to ensure we capture PNL for positions that 
-- are still open at the end of the period.
WITH orders_base AS (

    SELECT
        order_id,
        exchange_user_id,
        created_at AS order_created_at,
        symbol AS market_symbol,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', created_at) AS order_created_at_alk,
        CAST(account_id AS VARCHAR) AS account_id,
        UPPER(action) AS trade_action,
        UPPER(side) AS trade_side,
        fmx_fees_withheld / 100.0 AS fmx_fees_withheld_usd
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_orders

),

execution_reports AS (

    SELECT
        order_id,
        CAST(
            CASE
                WHEN SUM(CASE WHEN report_type = 'TRADE' THEN quantity ELSE 0 END) > 0
                    THEN
                        SUM(CASE WHEN report_type = 'TRADE' THEN order_side_price * quantity ELSE 0 END)
                        / NULLIF(SUM(CASE WHEN report_type = 'TRADE' THEN quantity ELSE 0 END), 0) / 100.0
            END AS NUMBER(36, 6)
        ) AS avg_execution_price_usd,
        SUM(CASE WHEN report_type = 'TRADE' THEN quantity ELSE 0 END) AS filled_quantity,
        CAST(SUM(CASE WHEN report_type = 'TRADE' THEN COALESCE(fmx_fees, 0) ELSE 0 END) / 100.0 AS NUMBER(36, 6))
            AS filled_fmx_fees_usd,
        CAST(SUM(CASE WHEN report_type = 'TRADE' THEN COALESCE(exchange_fees, 0) ELSE 0 END) / 100.0 AS NUMBER(36, 6))
            AS filled_exchange_fees_usd

    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports
    GROUP BY 1

),

settlement_reports AS (

    SELECT
        symbol AS market_symbol,
        exchange_user_id,
        MAX(settlement_report_id) AS settlement_report_id,
        CAST(SUM(payout_change) / 100.0 AS NUMBER(36, 4)) AS total_settlement_payout_usd
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_settlement_reports
    GROUP BY 1, 2

),

fmx_portfolio AS (

    SELECT
        symbol AS market_symbol,
        CAST(account_id AS VARCHAR) AS account_id,
        COALESCE(total_sell_gain / 100.0, 0)
        + COALESCE(settlement_gain / 100.0, 0)
        - COALESCE(total_buy_cost / 100.0, 0) AS portfolio_pnl_before_fees,
        COALESCE(total_sell_gain / 100.0, 0)
        + COALESCE(settlement_gain / 100.0, 0)
        - COALESCE(total_buy_cost / 100.0, 0)
        - COALESCE(total_fmx_buy_fees / 100.0, 0)
        - COALESCE(total_fmx_sale_fees / 100.0, 0) AS portfolio_pnl_after_fees
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_user_portfolio

),

base AS (

    SELECT
        ob.order_id,
        ob.account_id,
        ob.exchange_user_id,
        sr.settlement_report_id,
        ob.market_symbol,
        ob.trade_side,
        ob.trade_action,
        ob.order_created_at,
        ob.order_created_at_alk,
        ROW_NUMBER() OVER (
            PARTITION BY ob.account_id
            ORDER BY ob.order_created_at ASC, ob.order_id ASC
        ) AS customer_completed_trade_number,
        COALESCE(er.filled_quantity, 0) AS filled_quantity,
        COALESCE(er.avg_execution_price_usd, 0) AS filled_price_usd,
        COALESCE(er.filled_quantity * er.avg_execution_price_usd, 0) AS filled_contract_amount_usd,
        COALESCE(ob.fmx_fees_withheld_usd, 0) AS attempted_fmx_fees_usd,
        COALESCE(er.filled_fmx_fees_usd, 0) AS filled_fmx_fees_usd,
        CASE
            WHEN attempted_fmx_fees_usd = 0 THEN filled_fmx_fees_usd
            WHEN filled_fmx_fees_usd = 0 THEN attempted_fmx_fees_usd
            ELSE LEAST(attempted_fmx_fees_usd, filled_fmx_fees_usd)
        END AS fmx_fees_charged_after_refunds_and_clawbacks_usd,
        COALESCE(er.filled_exchange_fees_usd, 0) AS filled_exchange_fees_usd,
        COALESCE(
            COALESCE(LEAST(ob.fmx_fees_withheld_usd, er.filled_fmx_fees_usd), 0)
            + COALESCE(er.filled_exchange_fees_usd, 0),
            0
        ) AS filled_total_fees_usd,
        CASE
            WHEN ob.trade_action = 'SELL' THEN COALESCE(er.filled_quantity * er.avg_execution_price_usd, 0)
            ELSE
                COALESCE(er.filled_quantity * er.avg_execution_price_usd, 0)
                + CASE
                    WHEN COALESCE(ob.fmx_fees_withheld_usd, 0) = 0 THEN COALESCE(er.filled_fmx_fees_usd, 0)
                    WHEN COALESCE(er.filled_fmx_fees_usd, 0) = 0 THEN COALESCE(ob.fmx_fees_withheld_usd, 0)
                    ELSE LEAST(COALESCE(ob.fmx_fees_withheld_usd, 0), COALESCE(er.filled_fmx_fees_usd, 0))
                END
                + COALESCE(er.filled_exchange_fees_usd, 0)
        END AS filled_handle_usd,
        COALESCE(sr.total_settlement_payout_usd, 0) AS total_settlement_payout_usd,
        COALESCE(fp.portfolio_pnl_before_fees, 0) AS portfolio_pnl_before_fees,
        COALESCE(fp.portfolio_pnl_after_fees, 0) AS portfolio_pnl_after_fees
    FROM
        orders_base AS ob
    LEFT JOIN execution_reports AS er
        ON ob.order_id = er.order_id
    LEFT JOIN settlement_reports AS sr
        ON
            ob.market_symbol = sr.market_symbol
            AND ob.exchange_user_id = sr.exchange_user_id
    LEFT JOIN fmx_portfolio AS fp
        ON
            ob.account_id = fp.account_id
            AND ob.market_symbol = fp.market_symbol
    WHERE COALESCE(er.filled_quantity, 0) > 0

),

vip AS (

    SELECT
        account_id,
        IFF(
            SUM(filled_handle_usd + filled_fmx_fees_usd) >= 99999999
            OR (
                SUM(filled_fmx_fees_usd * 0.44)
                / NULLIF(
                    COUNT(DISTINCT IFF(
                        COALESCE(filled_handle_usd, 0) > 0
                        OR COALESCE(filled_fmx_fees_usd, 0) > 0,
                        CAST(DATE_TRUNC('WEEK', order_created_at_alk) AS DATE),
                        NULL
                    )),
                    0
                )
            ) >= 300,
            'Yes',
            'No'
        ) AS is_fmx_vip
    FROM
        base
    GROUP BY 1

),

pos AS (

    SELECT
        *,
        IFF(trade_action = 'BUY', filled_quantity, -filled_quantity) AS signed_qty,
        SUM(IFF(trade_action = 'BUY', filled_quantity, -filled_quantity)) OVER (
            PARTITION BY exchange_user_id, market_symbol, trade_side
            ORDER BY order_created_at, order_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS pos_after_qty
    FROM
        base

),

labeled AS (

    SELECT
        *,
        CAST(pos_after_qty - signed_qty AS NUMBER(36, 6)) AS pos_before_qty,
        CASE
            WHEN trade_action = 'SELL'
                THEN LEAST(filled_quantity, GREATEST(CAST(pos_after_qty - signed_qty AS NUMBER(36, 6)), 0))
            ELSE 0
        END AS close_qty,
        CASE
            WHEN
                trade_action = 'SELL'
                AND COALESCE(pos_after_qty, 0) < 0
                THEN LEAST(COALESCE(filled_quantity, 0), ABS(COALESCE(pos_after_qty, 0)))
            ELSE 0
        END AS oversell_qty
    FROM
        pos

),

keys_with_sells AS (

    SELECT DISTINCT
        exchange_user_id,
        market_symbol,
        trade_side
    FROM
        labeled
    WHERE
        close_qty > 0
        OR settlement_report_id IS NOT NULL

),

buys AS (

    SELECT
        l.exchange_user_id,
        l.market_symbol,
        l.trade_side,
        l.order_id AS buy_order_id,
        l.order_created_at AS buy_ts,
        l.filled_quantity AS buy_qty,
        l.filled_price_usd AS buy_price,
        SUM(l.filled_quantity) OVER (
            PARTITION BY l.exchange_user_id, l.market_symbol, l.trade_side
            ORDER BY l.order_created_at, l.order_id
        ) AS buy_cum_qty,
        SUM(l.filled_quantity) OVER (
            PARTITION BY l.exchange_user_id, l.market_symbol, l.trade_side
            ORDER BY l.order_created_at, l.order_id
        ) - l.filled_quantity AS buy_cum_prev
    FROM
        labeled AS l
    INNER JOIN keys_with_sells AS k
        ON
            l.exchange_user_id = k.exchange_user_id
            AND l.market_symbol = k.market_symbol
            AND l.trade_side = k.trade_side
    WHERE
        l.trade_action = 'BUY'

),

sells AS (

    SELECT
        l.exchange_user_id,
        l.market_symbol,
        l.trade_side,
        l.order_id AS sell_order_id,
        l.order_created_at AS sell_ts,
        l.close_qty AS sell_close_qty,
        l.filled_price_usd AS sell_price,
        SUM(l.close_qty) OVER (
            PARTITION BY l.exchange_user_id, l.market_symbol, l.trade_side
            ORDER BY l.order_created_at, l.order_id
        ) AS sell_cum_qty,
        SUM(l.close_qty) OVER (
            PARTITION BY l.exchange_user_id, l.market_symbol, l.trade_side
            ORDER BY l.order_created_at, l.order_id
        ) - l.close_qty AS sell_cum_prev
    FROM
        labeled AS l
    INNER JOIN keys_with_sells AS k
        ON
            l.exchange_user_id = k.exchange_user_id
            AND l.market_symbol = k.market_symbol
            AND l.trade_side = k.trade_side
    WHERE
        l.trade_action = 'SELL'
        AND l.close_qty > 0

),

fifo_matches AS (

    SELECT
        s.exchange_user_id,
        s.market_symbol,
        s.trade_side,
        s.sell_order_id,
        b.buy_order_id,
        b.buy_price,
        s.sell_price,
        GREATEST(
            0,
            LEAST(b.buy_cum_qty, s.sell_cum_qty) - GREATEST(b.buy_cum_prev, s.sell_cum_prev)
        ) AS matched_qty
    FROM
        sells AS s
    INNER JOIN buys AS b
        ON
            s.exchange_user_id = b.exchange_user_id
            AND s.market_symbol = b.market_symbol
            AND s.trade_side = b.trade_side
            AND s.sell_cum_prev < b.buy_cum_qty
            AND s.sell_cum_qty > b.buy_cum_prev

),

realized_by_sell AS (

    SELECT
        exchange_user_id,
        market_symbol,
        trade_side,
        sell_order_id AS order_id,
        SUM(matched_qty) AS fifo_close_qty,
        SUM(matched_qty * buy_price) AS fifo_cost_closed_usd,
        SUM(matched_qty * (sell_price - buy_price)) AS realized_price_pnl_usd
    FROM
        fifo_matches
    WHERE matched_qty > 0
    GROUP BY 1, 2, 3, 4

),

position_state AS (

    SELECT
        exchange_user_id,
        market_symbol,
        trade_side,
        SUM(IFF(trade_action = 'BUY', filled_quantity, 0)) AS total_buy_qty,
        SUM(IFF(trade_action = 'SELL', close_qty, 0)) AS total_close_qty,
        GREATEST(
            SUM(IFF(trade_action = 'BUY', filled_quantity, 0))
            - SUM(IFF(trade_action = 'SELL', close_qty, 0)),
            0
        ) AS open_qty
    FROM
        labeled
    GROUP BY 1, 2, 3

),

remaining_lots AS (

    SELECT
        b.exchange_user_id,
        b.market_symbol,
        b.trade_side,
        b.buy_order_id AS order_id,
        b.buy_price,
        GREATEST(
            0,
            LEAST(b.buy_cum_qty, ps.total_buy_qty) - GREATEST(b.buy_cum_prev, ps.total_close_qty)
        ) AS remaining_qty
    FROM
        buys AS b
    INNER JOIN position_state AS ps
        ON
            b.exchange_user_id = ps.exchange_user_id
            AND b.market_symbol = ps.market_symbol
            AND b.trade_side = ps.trade_side

),

settlement_unit AS (

    SELECT
        l.exchange_user_id,
        l.market_symbol,
        l.trade_side,
        ps.open_qty,
        MAX(IFF(l.settlement_report_id IS NOT NULL, l.total_settlement_payout_usd, NULL))
            AS total_settlement_payout_usd,
        IFF(
            ps.open_qty > 0,
            MAX(IFF(l.settlement_report_id IS NOT NULL, l.total_settlement_payout_usd, NULL))
            / NULLIF(ps.open_qty, 0),
            NULL
        ) AS settlement_unit_payout_usd
    FROM
        labeled AS l
    INNER JOIN position_state AS ps
        ON
            l.exchange_user_id = ps.exchange_user_id
            AND l.market_symbol = ps.market_symbol
            AND l.trade_side = ps.trade_side
    GROUP BY 1, 2, 3, 4

),

settlement_alloc_to_buy AS (

    SELECT
        rl.exchange_user_id,
        rl.market_symbol,
        rl.trade_side,
        rl.order_id,
        SUM(rl.remaining_qty * (su.settlement_unit_payout_usd - rl.buy_price)) AS settlement_pnl_usd
    FROM
        remaining_lots AS rl
    INNER JOIN settlement_unit AS su
        ON
            rl.exchange_user_id = su.exchange_user_id
            AND rl.market_symbol = su.market_symbol
            AND rl.trade_side = su.trade_side
    WHERE
        rl.remaining_qty > 0
        AND su.settlement_unit_payout_usd IS NOT NULL
    GROUP BY 1, 2, 3, 4

),

fees_totals AS (

    SELECT
        exchange_user_id,
        market_symbol,
        SUM(filled_total_fees_usd) AS total_fees_usd
    FROM
        labeled
    GROUP BY 1, 2

),

realized_totals AS (

    SELECT
        exchange_user_id,
        market_symbol,
        SUM(realized_price_pnl_usd) AS realized_total_price_pnl_usd
    FROM
        realized_by_sell
    GROUP BY 1, 2

),

settlement_totals AS (

    SELECT
        exchange_user_id,
        market_symbol,
        SUM(settlement_pnl_usd) AS settlement_total_pnl_usd
    FROM
        settlement_alloc_to_buy
    GROUP BY 1, 2

),

position_flags AS (

    SELECT
        ps.exchange_user_id,
        ps.market_symbol,
        ps.trade_side,
        IFF(COALESCE(ps.total_close_qty, 0) > 0, TRUE, FALSE) AS has_exit,
        MAX(CASE WHEN l.settlement_report_id IS NOT NULL THEN 1 ELSE 0 END) = 1 AS has_settlement
    FROM
        position_state AS ps
    LEFT JOIN labeled AS l
        ON
            ps.exchange_user_id = l.exchange_user_id
            AND ps.market_symbol = l.market_symbol
            AND ps.trade_side = l.trade_side
    GROUP BY 1, 2, 3, 4

),

buy_remaining AS (

    SELECT
        exchange_user_id,
        market_symbol,
        trade_side,
        order_id,
        SUM(remaining_qty) AS buy_remaining_qty
    FROM
        remaining_lots
    GROUP BY 1, 2, 3, 4

),

position_totals AS (

    SELECT
        ps.exchange_user_id,
        ps.market_symbol,
        ps.trade_side,
        COALESCE(rt.realized_total_price_pnl_usd, 0) AS realized_total_price_pnl_usd,
        COALESCE(stt.settlement_total_pnl_usd, 0) AS settlement_total_pnl_usd,
        COALESCE(ft.total_fees_usd, 0) AS total_fees_usd,
        COALESCE(pf.has_exit, FALSE) AS has_exit,
        COALESCE(pf.has_settlement, FALSE) AS has_settlement
    FROM
        position_state AS ps
    LEFT JOIN realized_totals AS rt
        ON
            ps.exchange_user_id = rt.exchange_user_id
            AND ps.market_symbol = rt.market_symbol
    LEFT JOIN settlement_totals AS stt
        ON
            ps.exchange_user_id = stt.exchange_user_id
            AND ps.market_symbol = stt.market_symbol
    LEFT JOIN fees_totals AS ft
        ON
            ps.exchange_user_id = ft.exchange_user_id
            AND ps.market_symbol = ft.market_symbol
    LEFT JOIN position_flags AS pf
        ON
            ps.exchange_user_id = pf.exchange_user_id
            AND ps.market_symbol = pf.market_symbol
            AND ps.trade_side = pf.trade_side

),

pnl_calc AS (

    SELECT
        l.order_id,
        l.account_id,
        v.is_fmx_vip,
        l.exchange_user_id,
        l.settlement_report_id,
        l.market_symbol,
        l.trade_side,
        l.trade_action,
        l.order_created_at,
        l.order_created_at_alk,
        l.customer_completed_trade_number,
        pt.has_exit,
        pt.has_settlement,
        l.filled_quantity,
        l.filled_price_usd,
        l.attempted_fmx_fees_usd,
        l.filled_fmx_fees_usd,
        l.fmx_fees_charged_after_refunds_and_clawbacks_usd,
        l.filled_exchange_fees_usd,
        l.filled_total_fees_usd,
        l.filled_contract_amount_usd,
        l.filled_handle_usd,
        l.total_settlement_payout_usd,
        l.pos_before_qty,
        l.pos_after_qty,
        l.close_qty,
        l.oversell_qty,
        ps.open_qty AS position_open_qty,
        l.portfolio_pnl_before_fees AS reconciliation_pnl_before_fees,
        l.portfolio_pnl_after_fees AS reconciliation_pnl_after_fees,
        IFF(l.trade_action = 'BUY', COALESCE(br.buy_remaining_qty, l.filled_quantity), NULL) AS buy_remaining_qty,
        CASE
            WHEN l.trade_action = 'BUY'
                THEN
                    IFF(
                        COALESCE(l.filled_quantity, 0) > 0,
                        1
                        - (
                            COALESCE(br.buy_remaining_qty, l.filled_quantity)
                            / NULLIF(l.filled_quantity, 0)
                        ),
                        NULL
                    )
        END AS position_closed_pct,
        CASE
            WHEN l.trade_action = 'BUY'
                THEN
                    CASE
                        WHEN COALESCE(br.buy_remaining_qty, l.filled_quantity) = 0
                            THEN 'FULLY_CLOSED'
                        WHEN COALESCE(br.buy_remaining_qty, l.filled_quantity) < l.filled_quantity
                            THEN 'PARTIALLY_CLOSED'
                        WHEN l.settlement_report_id IS NOT NULL THEN 'SETTLED'
                        ELSE 'OPEN'
                    END
            WHEN l.trade_action = 'SELL'
                THEN
                    CASE
                        WHEN COALESCE(l.oversell_qty, 0) > 0 THEN 'OVERSELL'
                        WHEN COALESCE(l.close_qty, 0) = 0 THEN 'NO_CHANGE_SALE'
                        WHEN COALESCE(l.pos_after_qty, 0) = 0 THEN 'FULL_SALE'
                        WHEN COALESCE(l.pos_after_qty, 0) > 0 THEN 'PARTIAL_SALE'
                        ELSE 'OTHER'
                    END
            ELSE 'OTHER'
        END AS position_status_type,
        IFF(
            l.trade_action = 'BUY',
            -(
                COALESCE(l.filled_contract_amount_usd, 0)
                + COALESCE(l.filled_total_fees_usd, 0)
            ),
            (
                COALESCE(l.filled_contract_amount_usd, 0)
                - COALESCE(l.filled_total_fees_usd, 0)
            )
        ) AS filled_cashflow_usd,
        IFF(
            l.trade_action = 'SELL' AND COALESCE(rbs.fifo_close_qty, 0) > 0,
            rbs.fifo_cost_closed_usd / NULLIF(rbs.fifo_close_qty, 0),
            NULL
        ) AS avg_entry_price_usd_before,
        COALESCE(rbs.realized_price_pnl_usd, 0) AS realized_price_pnl_usd,
        COALESCE(sab.settlement_pnl_usd, 0) AS settlement_pnl_usd,
        -COALESCE(l.filled_total_fees_usd, 0) AS fees_pnl_usd,
        COALESCE(rbs.realized_price_pnl_usd, 0)
        + COALESCE(sab.settlement_pnl_usd, 0) AS order_pnl_before_fees_usd,
        COALESCE(rbs.realized_price_pnl_usd, 0)
        + COALESCE(sab.settlement_pnl_usd, 0)
        - COALESCE(l.filled_total_fees_usd, 0) AS order_pnl_after_fees_usd,
        COALESCE(pt.realized_total_price_pnl_usd, 0)
        + COALESCE(pt.settlement_total_pnl_usd, 0) AS position_pnl_before_fees_usd,
        COALESCE(pt.realized_total_price_pnl_usd, 0)
        + COALESCE(pt.settlement_total_pnl_usd, 0)
        - COALESCE(pt.total_fees_usd, 0) AS position_pnl_after_fees_usd,
        CASE
            WHEN COALESCE(pt.has_exit, FALSE) OR COALESCE(pt.has_settlement, FALSE)
                THEN
                    ROUND(l.portfolio_pnl_before_fees, 0)
                    = ROUND(
                        COALESCE(pt.realized_total_price_pnl_usd, 0)
                        + COALESCE(pt.settlement_total_pnl_usd, 0),
                        0
                    )
        END AS pnl_before_fees_recon_match,
        CASE
            WHEN COALESCE(pt.has_exit, FALSE) OR COALESCE(pt.has_settlement, FALSE)
                THEN
                    ROUND(l.portfolio_pnl_after_fees, 0)
                    = ROUND(
                        COALESCE(pt.realized_total_price_pnl_usd, 0)
                        + COALESCE(pt.settlement_total_pnl_usd, 0)
                        - COALESCE(pt.total_fees_usd, 0),
                        0
                    )
        END AS pnl_after_fees_recon_match,
        SUM(l.filled_handle_usd) OVER (PARTITION BY l.account_id) AS lifetime_handle_usd,
        COUNT(DISTINCT l.order_id) OVER (PARTITION BY l.account_id) AS lifetime_order_count
    FROM
        labeled AS l
    LEFT JOIN realized_by_sell AS rbs
        ON
            l.exchange_user_id = rbs.exchange_user_id
            AND l.market_symbol = rbs.market_symbol
            AND l.trade_side = rbs.trade_side
            AND l.order_id = rbs.order_id
    LEFT JOIN settlement_alloc_to_buy AS sab
        ON
            l.exchange_user_id = sab.exchange_user_id
            AND l.market_symbol = sab.market_symbol
            AND l.trade_side = sab.trade_side
            AND l.order_id = sab.order_id
    LEFT JOIN position_state AS ps
        ON
            l.exchange_user_id = ps.exchange_user_id
            AND l.market_symbol = ps.market_symbol
            AND l.trade_side = ps.trade_side
    LEFT JOIN position_totals AS pt
        ON
            l.exchange_user_id = pt.exchange_user_id
            AND l.market_symbol = pt.market_symbol
            AND l.trade_side = pt.trade_side
    LEFT JOIN buy_remaining AS br
        ON
            l.exchange_user_id = br.exchange_user_id
            AND l.market_symbol = br.market_symbol
            AND l.trade_side = br.trade_side
            AND l.order_id = br.order_id
    LEFT JOIN vip AS v
        ON
            l.account_id = v.account_id

)

SELECT * FROM pnl_calc
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_order_pnl", "profile_name": "user", "target_name": "default"} */
