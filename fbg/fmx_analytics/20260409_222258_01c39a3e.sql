-- Query ID: 01c39a3e-0212-67a9-24dd-07031943112f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:58.196000+00:00
-- Elapsed: 11905ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.MARKET_MAKER.sigma_daily_reporting_mm
    
    
    
    as (WITH params AS (
    SELECT
        date_trunc(
            'day',
            to_timestamp_tz(
                convert_timezone('UTC', 'America/Anchorage', current_timestamp())
            )
        )
            AS today_start_alk,
        date_trunc('day', dateadd(
            DAY,
            -1,
            to_timestamp_tz(
                convert_timezone('UTC', 'America/Anchorage', current_timestamp())
            )
        )) AS yesterday_start_alk,
        date_trunc(
            'month',
            to_timestamp_tz(
                convert_timezone('UTC', 'America/Anchorage', current_timestamp())
            )
        ) AS month_start_alk
),

fix_data AS (
    SELECT
        id AS message_id,
        max(CASE WHEN split_part(f.value, '=', 1) = '8' THEN split_part(f.value, '=', 2) END) AS begin_string,
        max(CASE WHEN split_part(f.value, '=', 1) = '9' THEN split_part(f.value, '=', 2) END) AS body_length,
        max(CASE WHEN split_part(f.value, '=', 1) = '34' THEN split_part(f.value, '=', 2) END) AS msg_seq_num,
        max(CASE WHEN split_part(f.value, '=', 1) = '49' THEN split_part(f.value, '=', 2) END) AS sender_comp_id,
        max(CASE WHEN split_part(f.value, '=', 1) = '56' THEN split_part(f.value, '=', 2) END) AS target_comp_id,
        max(CASE WHEN split_part(f.value, '=', 1) = '6' THEN split_part(f.value, '=', 2) END) AS avg_px,
        max(CASE WHEN split_part(f.value, '=', 1) = '31' THEN split_part(f.value, '=', 2) END) AS last_px,
        max(CASE WHEN split_part(f.value, '=', 1) = '44' THEN split_part(f.value, '=', 2) END) AS price,
        max(CASE WHEN split_part(f.value, '=', 1) = '32' THEN split_part(f.value, '=', 2) END) AS quantity,
        max(CASE WHEN split_part(f.value, '=', 1) = '14' THEN split_part(f.value, '=', 2) END) AS last_qty,
        max(CASE WHEN split_part(f.value, '=', 1) = '151' THEN split_part(f.value, '=', 2) END) AS leaves_qty,
        max(CASE WHEN split_part(f.value, '=', 1) = '54' THEN split_part(f.value, '=', 2) END) AS side,
        max(CASE WHEN split_part(f.value, '=', 1) = '55' THEN split_part(f.value, '=', 2) END) AS symbol,
        max(CASE WHEN split_part(f.value, '=', 1) = '59' THEN split_part(f.value, '=', 2) END) AS time_in_force,
        max(CASE WHEN split_part(f.value, '=', 1) = '39' THEN split_part(f.value, '=', 2) END) AS order_status,
        try_to_timestamp(
            max(CASE WHEN split_part(f.value, '=', 1) = '60' THEN split_part(f.value, '=', 2) END),
            'YYYYMMDD-HH24:MI:SS.FF3'
        ) AS sending_time,
        max(CASE WHEN split_part(f.value, '=', 1) = '11' THEN split_part(f.value, '=', 2) END) AS qset_number,
        max(CASE WHEN split_part(f.value, '=', 1) = '10' THEN split_part(f.value, '=', 2) END) AS checksum,
        max(CASE WHEN split_part(f.value, '=', 1) = '150' THEN split_part(f.value, '=', 2) END) AS exec_type
    FROM FMX_ANALYTICS.STAGING.stg_fmx_mm_fix_inbound_messages_scd AS m,
        LATERAL flatten(input => split(replace(m.raw_message, chr(1), '|'), '|')) AS f
    WHERE
        m.msg_type = '8'
        AND f.value LIKE '%=%'
        AND id IS NOT NULL
    GROUP BY id
),

settlement_report AS (
    SELECT
        tradeable_symbol_id AS symbol,
        posting_time AS settlement_time,
        business_date,
        side_id,
        ledger_item_reason_id,
        amount,
        CASE
            WHEN amount = 0 AND side_id = 'LONG' THEN 'LOSE'
            WHEN amount = 0 AND side_id = 'SHORT' THEN 'WIN'
            WHEN amount > 0 AND side_id = 'LONG' THEN 'WIN'
            WHEN amount > 0 AND side_id = 'SHORT' THEN 'LOSE'
        END AS result_,
        CASE
            WHEN amount = 0 AND side_id = 'LONG' THEN 0
            WHEN amount = 0 AND side_id = 'SHORT' THEN 1
            WHEN amount > 0 AND side_id = 'LONG' THEN 1
            WHEN amount > 0 AND side_id = 'SHORT' THEN 0
        END AS settlement_value
    FROM FBG_SOURCE.CRYPTO.TRADE_REGISTER
    WHERE
        business_date < '2026-03-28'
        AND ledger_item_reason_id = 'SETTLEMENT_PAYOUT'

    UNION ALL

    SELECT
        max(CASE WHEN split_part(f.value, '=', 1) = '55' THEN split_part(f.value, '=', 2) END) AS symbol,
        try_to_timestamp(
            max(CASE WHEN split_part(f.value, '=', 1) = '52' THEN split_part(f.value, '=', 2) END),
            'YYYYMMDD-HH24:MI:SS.FF3'
        ) AS settlement_time,
        cast(
            try_to_timestamp(
                max(CASE WHEN split_part(f.value, '=', 1) = '52' THEN split_part(f.value, '=', 2) END),
                'YYYYMMDD-HH24:MI:SS.FF3'
            ) AS date
        ) AS business_date,
        NULL AS side_id,
        'SETTLEMENT_PAYOUT' AS ledger_item_reason_id,
        NULL AS amount,
        CASE
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END))
                = 1
                AND coalesce(
                    try_to_number(
                        max(CASE WHEN split_part(f.value, '=', 1) = '705' THEN split_part(f.value, '=', 2) END)
                    ),
                    0
                )
                = 0
                THEN 'WIN'
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '705' THEN split_part(f.value, '=', 2) END))
                = 1
                AND coalesce(
                    try_to_number(
                        max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END)
                    ),
                    0
                )
                = 0
                THEN 'LOSE'
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END))
                = 1
                THEN 'WIN'
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END))
                = 0
                THEN 'LOSE'
        END AS result_,
        CASE
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END))
                > 0
                AND try_to_number(
                    max(CASE WHEN split_part(f.value, '=', 1) = '730' THEN split_part(f.value, '=', 2) END)
                )
                > 0
                THEN 1
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '704' THEN split_part(f.value, '=', 2) END))
                > 0
                AND try_to_number(
                    max(CASE WHEN split_part(f.value, '=', 1) = '730' THEN split_part(f.value, '=', 2) END)
                )
                = 0
                THEN 0
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '705' THEN split_part(f.value, '=', 2) END))
                > 0
                AND try_to_number(
                    max(CASE WHEN split_part(f.value, '=', 1) = '730' THEN split_part(f.value, '=', 2) END)
                )
                > 0
                THEN 0
            WHEN
                try_to_number(max(CASE WHEN split_part(f.value, '=', 1) = '705' THEN split_part(f.value, '=', 2) END))
                > 0
                AND try_to_number(
                    max(CASE WHEN split_part(f.value, '=', 1) = '730' THEN split_part(f.value, '=', 2) END)
                )
                = 0
                THEN 1
        END AS settlement_value
    FROM FMX_ANALYTICS.STAGING.stg_fmx_mm_fix_inbound_messages_scd AS m,
        LATERAL flatten(input => split(replace(m.raw_message, chr(1), '|'), '|')) AS f
    WHERE
        m.msg_type = 'AP'
        AND f.value LIKE '%=%'
    GROUP BY record_lsn
    HAVING
        max(CASE WHEN split_part(f.value, '=', 1) = '731' THEN split_part(f.value, '=', 2) END) = '1'
        AND try_to_timestamp(
            max(CASE WHEN split_part(f.value, '=', 1) = '52' THEN split_part(f.value, '=', 2) END),
            'YYYYMMDD-HH24:MI:SS.FF3'
        )
        >= '2026-03-28'
),

trades AS (
    SELECT
        'TRADE_REGISTER' AS source,
        posting_time AS utc_time,
        tradeable_symbol_id AS symbol,
        side_id AS side,
        quantity AS last_qty,
        price AS last_px,
        ledger_item_reason_id,
        execution_id,
        order_id,
        transaction_id,
        quote_id,
        NULL AS message_id,
        NULL AS qset_number,
        NULL AS begin_string,
        NULL AS body_length,
        NULL AS msg_seq_num,
        NULL AS sender_comp_id,
        NULL AS target_comp_id,
        NULL AS avg_px,
        NULL AS last_qty_fix,
        NULL AS leaves_qty,
        NULL AS time_in_force,
        NULL AS order_status,
        NULL AS checksum,
        NULL AS exec_type
    FROM FBG_SOURCE.CRYPTO.TRADE_REGISTER
    WHERE business_date < '2026-03-28'

    UNION ALL

    SELECT
        'FIX_PARSED' AS source,
        sending_time AS utc_time,
        symbol,
        CASE WHEN side = '1' THEN 'BUY' WHEN side = '2' THEN 'SELL' ELSE side END AS side,
        quantity AS last_qty,
        price AS last_px,
        NULL AS ledger_item_reason_id,
        NULL AS execution_id,
        NULL AS order_id,
        NULL AS transaction_id,
        NULL AS quote_id,
        message_id,
        qset_number,
        begin_string,
        body_length,
        msg_seq_num,
        sender_comp_id,
        target_comp_id,
        avg_px,
        last_qty,
        leaves_qty,
        time_in_force,
        order_status,
        checksum,
        exec_type
    FROM fix_data
    WHERE
        quantity != 0
        AND sending_time >= '2026-03-28'
),

snapshot_defs AS (
    SELECT
        'OVERALL' AS snapshot_type,
        NULL::timestamp_tz AS cutoff_ts
    UNION ALL
    SELECT
        'PRE_TODAY',
        today_start_alk
    FROM params
    UNION ALL
    SELECT
        'PRE_YESTERDAY',
        yesterday_start_alk
    FROM params
    UNION ALL
    SELECT
        'MONTH_TO_DATE',
        month_start_alk
    FROM params

),

trade_stream AS (
    SELECT
        s.snapshot_type,
        s.cutoff_ts,
        t.utc_time,
        t.symbol,
        cm.title,
        cm.sports_grouping,
        cm.predict_contract_type,
        cm.event_date,
        t.side,
        t.last_px,
        t.last_qty,
        t.ledger_item_reason_id,
        CASE WHEN t.utc_time > cm.event_date THEN 1 ELSE 0 END AS in_play_indicator,
        coalesce(
            to_varchar(t.message_id),
            t.execution_id,
            t.order_id,
            t.transaction_id,
            t.quote_id,
            t.qset_number,
            to_varchar(t.utc_time)
        ) AS trade_id
    FROM trades AS t
    LEFT JOIN FBG_SOURCE.FMX_SOURCE.CRYPTO_MARKETS AS cm
        ON t.symbol = cm.symbol
    CROSS JOIN snapshot_defs AS s
    WHERE
        (t.ledger_item_reason_id != 'SETTLEMENT_PAYOUT' OR t.ledger_item_reason_id IS NULL)
        AND (s.cutoff_ts IS NULL OR t.utc_time < s.cutoff_ts)
),

fifo_parts AS (
    SELECT
        *,
        row_number() OVER (
            PARTITION BY snapshot_type, symbol
            ORDER BY utc_time, trade_id
        ) AS trade_seq,
        coalesce(
            sum(CASE WHEN side = 'BUY' THEN last_qty WHEN side = 'SELL' THEN -last_qty END) OVER (
                PARTITION BY snapshot_type, symbol
                ORDER BY utc_time, trade_id
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 0
        ) AS prior_position,
        CASE
            WHEN
                coalesce(
                    sum(CASE WHEN side = 'BUY' THEN last_qty WHEN side = 'SELL' THEN -last_qty END) OVER (
                        PARTITION BY snapshot_type, symbol
                        ORDER BY utc_time, trade_id
                        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                    ), 0
                ) > 0 AND side = 'SELL'
                THEN least(
                    coalesce(
                        sum(CASE WHEN side = 'BUY' THEN last_qty WHEN side = 'SELL' THEN -last_qty END) OVER (
                            PARTITION BY snapshot_type, symbol
                            ORDER BY utc_time, trade_id
                            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                        ), 0
                    ),
                    last_qty
                )
            WHEN
                coalesce(
                    sum(CASE WHEN side = 'BUY' THEN last_qty WHEN side = 'SELL' THEN -last_qty END) OVER (
                        PARTITION BY snapshot_type, symbol
                        ORDER BY utc_time, trade_id
                        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                    ), 0
                ) < 0 AND side = 'BUY'
                THEN least(
                    abs(
                        coalesce(
                            sum(CASE WHEN side = 'BUY' THEN last_qty WHEN side = 'SELL' THEN -last_qty END) OVER (
                                PARTITION BY snapshot_type, symbol
                                ORDER BY utc_time, trade_id
                                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
                            ), 0
                        )
                    ),
                    last_qty
                )
            ELSE 0
        END AS close_qty
    FROM trade_stream
),

fifo_realized AS (
    SELECT
        snapshot_type,
        symbol,
        sum(
            CASE
                WHEN lot_direction = 'LONG' THEN matched_qty * (close_px - open_px)
                WHEN lot_direction = 'SHORT' THEN matched_qty * (open_px - close_px)
            END
        ) AS fifo_realized_trade_pnl
    FROM (
        SELECT
            o.snapshot_type,
            o.symbol,
            o.lot_direction,
            o.open_px,
            c.close_px,
            greatest(0, least(o.cum_end, c.cum_end) - greatest(o.cum_start, c.cum_start)) AS matched_qty
        FROM (
            SELECT
                snapshot_type,
                symbol,
                utc_time,
                trade_seq,
                trade_id,
                last_px AS open_px,
                (last_qty - close_qty) AS open_qty,
                CASE WHEN side = 'BUY' THEN 'LONG' ELSE 'SHORT' END AS lot_direction,
                sum(last_qty - close_qty) OVER (
                    PARTITION BY snapshot_type, symbol, CASE WHEN side = 'BUY' THEN 'LONG' ELSE 'SHORT' END
                    ORDER BY utc_time, trade_seq, trade_id
                ) - (last_qty - close_qty) AS cum_start,
                sum(last_qty - close_qty) OVER (
                    PARTITION BY snapshot_type, symbol, CASE WHEN side = 'BUY' THEN 'LONG' ELSE 'SHORT' END
                    ORDER BY utc_time, trade_seq, trade_id
                ) AS cum_end
            FROM fifo_parts
            WHERE last_qty - close_qty > 0
        ) AS o
        INNER JOIN (
            SELECT
                snapshot_type,
                symbol,
                utc_time,
                trade_seq,
                trade_id,
                last_px AS close_px,
                close_qty,
                CASE WHEN side = 'SELL' THEN 'LONG' ELSE 'SHORT' END AS lot_direction,
                sum(close_qty) OVER (
                    PARTITION BY snapshot_type, symbol, CASE WHEN side = 'SELL' THEN 'LONG' ELSE 'SHORT' END
                    ORDER BY utc_time, trade_seq, trade_id
                ) - close_qty AS cum_start,
                sum(close_qty) OVER (
                    PARTITION BY snapshot_type, symbol, CASE WHEN side = 'SELL' THEN 'LONG' ELSE 'SHORT' END
                    ORDER BY utc_time, trade_seq, trade_id
                ) AS cum_end
            FROM fifo_parts
            WHERE close_qty > 0
        ) AS c
            ON
                o.snapshot_type = c.snapshot_type
                AND o.symbol = c.symbol
                AND o.lot_direction = c.lot_direction
                AND least(o.cum_end, c.cum_end) > greatest(o.cum_start, c.cum_start)
    )
    WHERE matched_qty > 0
    GROUP BY 1, 2
),

portfolio_value AS (
    SELECT
        ts.snapshot_type,
        ts.symbol,
        ts.title,
        ts.sports_grouping,
        ts.predict_contract_type,
        ts.event_date,
        ts.in_play_indicator,
        qdh.last_best_price,
        qdh.activity_hour_alk,
        sr.settlement_time,
        sr.side_id,
        sr.ledger_item_reason_id,
        sr.amount,
        sr.result_,
        sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
            AS net_contracts_position,
        sum(
            CASE
                WHEN ts.side = 'SELL' THEN ts.last_qty * ts.last_px WHEN ts.side = 'BUY' THEN -ts.last_qty * ts.last_px
            END
        ) AS purchased_value_of_position,
        sum(ts.last_qty) AS total_contracts_traded,
        sum(
            CASE
                WHEN ts.side = 'BUY' THEN ts.last_qty * (1 - ts.last_px) WHEN
                    ts.side = 'SELL'
                    THEN ts.last_qty * ts.last_px
            END
        ) AS total_handle,
        count(last_qty) AS completed_trades,
        CASE WHEN sr.result_ = 'LOSE' THEN -1 WHEN sr.result_ = 'WIN' THEN 1 END AS market_resolution,
        CASE
            WHEN
                sr.settlement_value IS NOT NULL
                THEN
                    sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
                    * sr.settlement_value
            WHEN
                (qdh.last_best_price IS NOT NULL AND qdh.last_best_price != 0)
                THEN
                    sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
                    * last_best_price
        END AS current_pos_value,
        sum(
            CASE
                WHEN ts.side = 'SELL' THEN ts.last_qty * ts.last_px WHEN ts.side = 'BUY' THEN -ts.last_qty * ts.last_px
            END
        )
        + sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
        * last_best_price AS mtm_pnl,
        CASE
            WHEN sr.settlement_value IS NOT NULL THEN
                sum(
                    CASE
                        WHEN ts.side = 'SELL' THEN ts.last_qty * ts.last_px WHEN
                            ts.side = 'BUY'
                            THEN -ts.last_qty * ts.last_px
                    END
                )
                + sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
                * sr.settlement_value
        END AS final_settlement_pnl,
        CASE
            WHEN sr.settlement_value IS NOT NULL
                THEN
                    sum(
                        CASE
                            WHEN ts.side = 'SELL' THEN ts.last_qty * ts.last_px WHEN
                                ts.side = 'BUY'
                                THEN -ts.last_qty * ts.last_px
                        END
                    )
                    + sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
                    * sr.settlement_value
            ELSE
                sum(
                    CASE
                        WHEN ts.side = 'SELL' THEN ts.last_qty * ts.last_px WHEN
                            ts.side = 'BUY'
                            THEN -ts.last_qty * ts.last_px
                    END
                )
                + sum(CASE WHEN ts.side = 'SELL' THEN -ts.last_qty WHEN ts.side = 'BUY' THEN ts.last_qty END)
                * last_best_price
        END AS net_profit_1,
        --Manual fix for the pnl difference in missing trades from CDNA reports
        CASE
            WHEN ts.symbol = 'NX.F.OPT.NBA-00004-260219-M.O.1.7' AND ts.in_play_indicator = 0
                THEN net_profit_1 + 38.98
            ELSE net_profit_1
        END AS net_profit
    -------
    FROM trade_stream AS ts
    LEFT JOIN FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_detail_hourly AS qdh
        ON ts.symbol = qdh.symbol
    LEFT JOIN settlement_report AS sr
        ON ts.symbol = sr.symbol
    WHERE
        qdh.last_best_price IS NOT NULL
        AND qdh.last_best_price != 0
        AND (
            ts.cutoff_ts IS NULL
            OR convert_timezone('America/Anchorage', 'UTC', qdh.activity_date_alk) < ts.cutoff_ts
        )
        AND (
            ts.cutoff_ts IS NULL
            OR sr.settlement_time < ts.cutoff_ts
            OR sr.settlement_time IS NULL
        )
    GROUP BY
        ts.snapshot_type,
        ts.symbol,
        ts.title,
        ts.sports_grouping,
        ts.predict_contract_type,
        ts.event_date,
        ts.in_play_indicator,
        qdh.activity_hour_alk, qdh.last_best_price,
        sr.settlement_time,
        sr.side_id,
        sr.ledger_item_reason_id,
        sr.amount,
        sr.result_,
        sr.settlement_value,
        sr.settlement_time
    QUALIFY row_number() OVER (
        PARTITION BY ts.snapshot_type, ts.symbol, ts.in_play_indicator
        ORDER BY qdh.activity_hour_alk DESC, sr.settlement_time DESC NULLS LAST
    ) = 1
),

enriched AS (
    SELECT
        pv.* EXCLUDE (net_profit_1),
        coalesce(fr.fifo_realized_trade_pnl, 0) AS fifo_realized_trade_pnl,
        CASE
            WHEN pv.result_ IS NOT NULL THEN pv.net_profit
            ELSE coalesce(fr.fifo_realized_trade_pnl, 0)
        END AS realized_pnl,
        CASE
            WHEN pv.result_ IS NOT NULL THEN 0
            ELSE pv.net_profit - coalesce(fr.fifo_realized_trade_pnl, 0)
        END AS unrealized_pnl
    FROM portfolio_value AS pv
    LEFT JOIN fifo_realized AS fr
        ON
            pv.snapshot_type = fr.snapshot_type
            AND pv.symbol = fr.symbol
)

SELECT
    o.*,
    convert_timezone('UTC', 'America/Anchorage', current_timestamp()) AS refresh_time_alk,
    pt.net_profit - coalesce(py.net_profit, 0) AS yesterday_net_profit,
    pt.total_contracts_traded - coalesce(py.total_contracts_traded, 0) AS yesterday_contracts_traded,
    pt.total_handle - coalesce(py.total_handle, 0) AS yesterday_total_handle,
    pt.realized_pnl - coalesce(py.realized_pnl, 0) AS yesterday_realized_pnl,
    pt.unrealized_pnl - coalesce(py.unrealized_pnl, 0) AS yesterday_unrealized_pnl,

    o.net_profit - coalesce(pt.net_profit, 0) AS today_net_profit,
    o.total_contracts_traded - coalesce(pt.total_contracts_traded, 0) AS today_contracts_traded,
    o.total_handle - coalesce(pt.total_handle, 0) AS today_total_handle,
    o.realized_pnl - coalesce(pt.realized_pnl, 0) AS today_realized_pnl,
    o.unrealized_pnl - coalesce(pt.unrealized_pnl, 0) AS today_unrealized_pnl,

    o.net_profit - coalesce(pm.net_profit, 0) AS mtd_net_profit,
    o.total_contracts_traded - coalesce(pm.total_contracts_traded, 0) AS mtd_contracts_traded,
    o.total_handle - coalesce(pm.total_handle, 0) AS mtd_total_handle,
    o.realized_pnl - coalesce(pm.realized_pnl, 0) AS mtd_realized_pnl,
    o.unrealized_pnl - coalesce(pm.unrealized_pnl, 0) AS mtd_unrealized_pnl

FROM enriched AS o
LEFT JOIN enriched AS pt
    ON
        pt.snapshot_type = 'PRE_TODAY'
        AND o.symbol = pt.symbol
        AND o.in_play_indicator = pt.in_play_indicator
LEFT JOIN enriched AS py
    ON
        py.snapshot_type = 'PRE_YESTERDAY'
        AND o.symbol = py.symbol
        AND o.in_play_indicator = py.in_play_indicator
LEFT JOIN enriched AS pm
    ON
        pm.snapshot_type = 'MONTH_TO_DATE'
        AND o.symbol = pm.symbol
        AND o.in_play_indicator = pm.in_play_indicator
WHERE o.snapshot_type = 'OVERALL'
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.sigma_daily_reporting_mm", "profile_name": "user", "target_name": "default"} */
