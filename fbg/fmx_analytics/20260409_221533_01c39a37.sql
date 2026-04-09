-- Query ID: 01c39a37-0212-67a9-24dd-070319416e43
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:15:33.221000+00:00
-- Elapsed: 123292ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.orders_fmx_account_hourly_metrics
    
    
    
    as (WITH execution_report_status AS ( --noqa: disable=all
    SELECT
        order_id,
        UPPER(report_type) AS order_report_type
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports
    QUALIFY ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY created_at DESC) = 1
),

ledger_source AS (
    SELECT
        s.acco_id::varchar AS acco_id,
        s.link_trans_ref AS order_id,
        s.jurisdictions_id AS jurisdiction_id,
        s.amount,
        o.symbol,
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', s.trans_date)) AS trans_hour_alk,
        DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', s.trans_date)) AS trans_date_alk,
        UPPER(s.trans) AS trans_type,
        ABS(s.amount) AS amount_abs,
        COALESCE(ers.order_report_type, 'UNKNOWN') AS order_report_type,
        COALESCE(cm.trading_status, 'UNKNOWN') AS trading_status
    FROM FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS s
    LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts AS a
        ON s.acco_id::varchar = a.acco_id
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_orders AS o
        ON s.link_trans_ref = o.order_id
    LEFT JOIN execution_report_status AS ers
        ON s.link_trans_ref = ers.order_id
    LEFT JOIN FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS cm
        ON o.symbol = cm.symbol
    WHERE
        s.trans_date IS NOT NULL
        AND COALESCE(a.is_test_account, 0) = 0
        AND UPPER(s.trans) IN (
            'FEX_ORDER_INITIATED',
            'FEX_ORDER_PRICE_IMPROVED',
            'FEX_ORDER_REVERTED',
            'FEX_ORDER_SOLD',
            'FEX_ORDER_PURCHASE_FEE',
            'FEX_ORDER_PURCHASE_FEE_REFUND',
            'FEX_ORDER_PURCHASE_FEE_REVERT',
            'FEX_ORDER_SALE_FEE',
            'FEX_ORDER_SALE_FEE_REFUND',
            'FEX_ORDER_SALE_FEE_REVERT',
            'FEX_ORDER_SETTLED',
            'DEPOSIT',
            'DEPOSIT_FEE',
            'WITHDRAWAL_COMPLETED',
            'FINANCE_CORRECTION_WITHDRAWAL',
            'REFUND_DEPOSIT_SUCCESS'
        )
),

ledger_metrics AS (
    SELECT
        trans_hour_alk,
        trans_date_alk,
        acco_id,
        jurisdiction_id,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_INITIATED'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN 1
            END
        ) AS order_buy_initiated_count,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_INITIATED'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN amount_abs
            END
        ) AS initiated_order_volume_usd,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_REVERTED'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN 1
            END
        ) AS order_buy_reverted_count,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_SOLD'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN 1
            END
        ) AS order_sold_count,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_INITIATED'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_PRICE_IMPROVED', 'FEX_ORDER_REVERTED')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN -amount_abs
            END
        ) AS total_order_buys,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_INITIATED'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_PRICE_IMPROVED', 'FEX_ORDER_REVERTED')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN -amount_abs
            END
        ) AS total_order_buys_settled,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_PURCHASE_FEE'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_PURCHASE_FEE_REFUND', 'FEX_ORDER_PURCHASE_FEE_REVERT')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN -amount_abs
            END
        ) AS total_order_buy_fees,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_PURCHASE_FEE'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_PURCHASE_FEE_REFUND', 'FEX_ORDER_PURCHASE_FEE_REVERT')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN -amount_abs
            END
        ) AS total_order_buy_fees_settled,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_SOLD'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN amount_abs
            END
        ) AS total_order_sold,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_SOLD'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN amount_abs
            END
        ) AS total_order_sold_settled,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_SALE_FEE'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_SALE_FEE_REFUND', 'FEX_ORDER_SALE_FEE_REVERT')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    THEN -amount_abs
            END
        ) AS total_order_sale_fees,
        SUM(
            CASE
                WHEN
                    trans_type = 'FEX_ORDER_SALE_FEE'
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN amount_abs
                WHEN
                    trans_type IN ('FEX_ORDER_SALE_FEE_REFUND', 'FEX_ORDER_SALE_FEE_REVERT')
                    AND COALESCE(order_report_type, 'UNKNOWN') <> 'REJECTED'
                    AND COALESCE(UPPER(trading_status), 'UNKNOWN') = 'SETTLED'
                    THEN -amount_abs
            END
        ) AS total_order_sale_fees_settled,
        SUM(CASE WHEN trans_type = 'FEX_ORDER_SETTLED' THEN amount_abs END) AS total_settlement,
        SUM(CASE WHEN trans_type = 'DEPOSIT' THEN amount_abs END) AS total_deposits,
        SUM(CASE WHEN trans_type = 'DEPOSIT' THEN 1 END) AS total_deposit_count,
        COUNT(DISTINCT CASE WHEN trans_type = 'DEPOSIT' THEN acco_id END) AS total_deposit_user_count,
        SUM(CASE WHEN trans_type = 'DEPOSIT_FEE' THEN amount_abs END) AS total_deposit_fees,
        SUM(
            CASE
                WHEN
                    trans_type IN ('WITHDRAWAL_COMPLETED', 'FINANCE_CORRECTION_WITHDRAWAL', 'REFUND_DEPOSIT_SUCCESS')
                    THEN amount_abs
            END
        ) AS total_withdrawals,
        SUM(
            CASE
                WHEN
                    trans_type IN ('WITHDRAWAL_COMPLETED', 'FINANCE_CORRECTION_WITHDRAWAL', 'REFUND_DEPOSIT_SUCCESS')
                    THEN 1
            END
        ) AS total_withdrawal_count
    FROM ledger_source
    GROUP BY 1, 2, 3, 4
),

execution_qty AS (
    SELECT
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', er.created_at)) AS trans_hour_alk,
        o.account_id::varchar AS acco_id,
        SUM(
            CASE
                WHEN UPPER(o.action) = 'BUY' AND UPPER(o.side) = 'YES' THEN er.quantity
                WHEN UPPER(o.action) = 'SELL' AND UPPER(o.side) = 'NO' THEN er.quantity
                ELSE 0
            END
        ) AS contracts_buy_qty,
        SUM(
            CASE
                WHEN UPPER(o.action) = 'SELL' AND UPPER(o.side) = 'YES' THEN er.quantity
                WHEN UPPER(o.action) = 'BUY' AND UPPER(o.side) = 'NO' THEN er.quantity
                ELSE 0
            END
        ) AS contracts_sold_qty
    FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er
    INNER JOIN FMX_ANALYTICS.STAGING.stg_fmx_orders AS o
        ON er.order_id = o.order_id
    LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts AS a
        ON o.account_id::varchar = a.acco_id
    WHERE
        er.quantity > 0
        AND COALESCE(a.is_test_account, 0) = 0
    GROUP BY 1, 2
),

ledger_fee_detail AS (
    SELECT
        trans_hour_alk,
        acco_id,
        order_id,
        CASE
            WHEN trans_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE') THEN amount_abs
            WHEN
                trans_type IN (
                    'FEX_ORDER_PURCHASE_FEE_REFUND',
                    'FEX_ORDER_PURCHASE_FEE_REVERT',
                    'FEX_ORDER_SALE_FEE_REFUND',
                    'FEX_ORDER_SALE_FEE_REVERT'
                )
                THEN -amount_abs
        END AS fee_amount
    FROM ledger_source
    WHERE trans_type IN (
        'FEX_ORDER_PURCHASE_FEE',
        'FEX_ORDER_PURCHASE_FEE_REFUND',
        'FEX_ORDER_PURCHASE_FEE_REVERT',
        'FEX_ORDER_SALE_FEE',
        'FEX_ORDER_SALE_FEE_REFUND',
        'FEX_ORDER_SALE_FEE_REVERT'
    )
        AND order_id IS NOT NULL
),

execution_fee_schedule AS (
    SELECT
        er_detail.order_id,
        CASE
            WHEN SUM(er_detail.quantity * er_detail.total_fee_per_contract) > 0 THEN SUM(
                er_detail.quantity * er_detail.provider_fee_per_contract
            ) / SUM(er_detail.quantity * er_detail.total_fee_per_contract)
        END AS provider_fee_ratio
    FROM (
        SELECT
            er.order_id,
            er.quantity,
            er.report_price / 100.0 AS price_pct,
            
    CASE
      WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', er.created_at) <= '2026-01-16 17:00:00'::timestamp THEN
        CASE
          WHEN (er.report_price / 100.0) >= 0.97 THEN 0.01
          WHEN ROUND(0.5 * (er.report_price / 100.0), 4) < 0.02 THEN 0.5 * (er.report_price / 100.0)
          ELSE 0.02
        END 
      ELSE
        -- Latest document as of 13 Jan 2026: https://docs.google.com/spreadsheets/d/1bYS6fI1hg5aa6QfQX0hOqysAx7BZs4Xs/edit?gid=726268343#gid=726268343
        CASE
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.01 AND 0.04
            THEN ROUND(0.34 * ROUND((er.report_price / 100.0), 2), 4)    
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.05 AND 0.20
            THEN ROUND(0.012 + 0.04 * ROUND((er.report_price / 100.0), 2), 4)    
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.21 AND 0.80
            THEN 0.0200 
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.81 AND 0.96
            THEN ROUND(0.0520 - 0.04 * ROUND((er.report_price / 100.0), 2), 4)   
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.97 AND 0.99
            THEN ROUND(0.0460 - 0.04 * ROUND((er.report_price / 100.0), 2), 4)   
          ELSE 0.00
        END
    END
 AS total_fee_per_contract,
            LEAST(
                CASE
                    WHEN er.report_price / 100.0 >= 0.81 THEN (1 - (er.report_price / 100.0)) * 0.1
                    WHEN er.report_price / 100.0 >= 0.20 THEN 0.02
                    ELSE (er.report_price / 100.0) * 0.1
                END
                * 0.4,
                
    CASE
      WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', er.created_at) <= '2026-01-16 17:00:00'::timestamp THEN
        CASE
          WHEN (er.report_price / 100.0) >= 0.97 THEN 0.01
          WHEN ROUND(0.5 * (er.report_price / 100.0), 4) < 0.02 THEN 0.5 * (er.report_price / 100.0)
          ELSE 0.02
        END 
      ELSE
        -- Latest document as of 13 Jan 2026: https://docs.google.com/spreadsheets/d/1bYS6fI1hg5aa6QfQX0hOqysAx7BZs4Xs/edit?gid=726268343#gid=726268343
        CASE
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.01 AND 0.04
            THEN ROUND(0.34 * ROUND((er.report_price / 100.0), 2), 4)    
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.05 AND 0.20
            THEN ROUND(0.012 + 0.04 * ROUND((er.report_price / 100.0), 2), 4)    
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.21 AND 0.80
            THEN 0.0200 
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.81 AND 0.96
            THEN ROUND(0.0520 - 0.04 * ROUND((er.report_price / 100.0), 2), 4)   
          WHEN ROUND((er.report_price / 100.0), 2) BETWEEN 0.97 AND 0.99
            THEN ROUND(0.0460 - 0.04 * ROUND((er.report_price / 100.0), 2), 4)   
          ELSE 0.00
        END
    END

            ) AS provider_fee_per_contract
        FROM FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er
        INNER JOIN FMX_ANALYTICS.STAGING.stg_fmx_orders AS o
            ON er.order_id = o.order_id
        INNER JOIN FMX_ANALYTICS.STAGING.stg_fmx_order_status AS os
            ON er.order_id = os.fbg_order_id
        LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts AS a
            ON o.account_id::varchar = a.acco_id
        WHERE
            er.quantity > 0
            AND er.report_price IS NOT NULL
            AND COALESCE(UPPER(er.report_type), 'UNKNOWN') = 'TRADE'
            AND COALESCE(UPPER(os.ord_status), 'UNKNOWN') NOT IN ('REJECTED', 'CANCELLED')
            AND COALESCE(a.is_test_account, 0) = 0
    ) AS er_detail
    GROUP BY 1
),

order_fee_components AS (
    SELECT
        fee_detail.trans_hour_alk,
        fee_detail.acco_id,
        SUM(fee_detail.fmx_fee_amt) AS total_order_fee_fmx_amt,
        SUM(fee_detail.provider_fee_amt) AS total_order_fee_provider_amt
    FROM (
        SELECT
            fee_calc.trans_hour_alk,
            fee_calc.acco_id,
            CASE
                WHEN
                    fee_calc.provider_fee_ratio IS NOT NULL
                    AND fee_calc.fee_amount IS NOT NULL
                THEN ROUND(fee_calc.fee_amount * fee_calc.provider_fee_ratio, 2)
                ELSE 0
            END AS provider_fee_amt,
            CASE
                WHEN
                    fee_calc.provider_fee_ratio IS NOT NULL
                    AND fee_calc.fee_amount IS NOT NULL
                THEN fee_calc.fee_amount - ROUND(fee_calc.fee_amount * fee_calc.provider_fee_ratio, 2)
                ELSE COALESCE(fee_calc.fee_amount, 0)
            END AS fmx_fee_amt
        FROM (
            SELECT
                lf.trans_hour_alk,
                lf.acco_id,
                lf.fee_amount,
                efs.provider_fee_ratio
            FROM ledger_fee_detail AS lf
            LEFT JOIN execution_fee_schedule AS efs
                ON lf.order_id = efs.order_id
            WHERE lf.fee_amount IS NOT NULL
        ) AS fee_calc
    ) AS fee_detail
    GROUP BY 1, 2
)

SELECT
    lm.trans_hour_alk,
    lm.trans_date_alk,
    lm.acco_id,
    lm.jurisdiction_id,
    COALESCE(lm.total_order_buys, 0) AS total_order_buys,
    COALESCE(lm.total_order_buy_fees, 0) AS total_order_buy_fees,
    COALESCE(lm.total_order_sold, 0) AS total_order_sold,
    COALESCE(lm.total_order_sale_fees, 0) AS total_order_sale_fees,
    COALESCE(lm.total_settlement, 0) AS total_settlement,
    COALESCE(lm.total_deposits, 0) AS total_deposits,
    COALESCE(lm.total_deposit_count, 0) AS total_deposit_count,
    COALESCE(lm.total_deposit_user_count, 0) AS total_deposit_user_count,
    COALESCE(lm.total_deposit_fees, 0) AS total_deposit_fees,
    COALESCE(lm.total_withdrawals, 0) AS total_withdrawals,
    COALESCE(lm.total_withdrawal_count, 0) AS total_withdrawal_count,
    COALESCE(lm.total_order_sold_settled, 0)
    + COALESCE(lm.total_settlement, 0)
    - COALESCE(lm.total_order_buys_settled, 0)
    - COALESCE(lm.total_order_buy_fees_settled, 0)
    - COALESCE(lm.total_order_sale_fees_settled, 0) AS customer_pnl_amt,
    COALESCE(lm.order_buy_initiated_count, 0) AS attempted_order_buy_count,
    COALESCE(lm.initiated_order_volume_usd, 0) AS initiated_order_volume_usd,
    GREATEST(
        COALESCE(lm.order_buy_initiated_count, 0) - COALESCE(lm.order_buy_reverted_count, 0),
        0
    ) AS total_order_buy_count,
    COALESCE(lm.order_sold_count, 0) AS total_order_sold_count,
    COALESCE(lm.order_sold_count, 0) AS attempted_order_sold_count,
    COALESCE(eq.contracts_buy_qty, 0) AS total_contracts_buy_qty,
    COALESCE(eq.contracts_sold_qty, 0) AS total_contracts_sold_qty,
    COALESCE(ofc.total_order_fee_fmx_amt, 0) AS total_order_fee_fmx_amt,
    COALESCE(ofc.total_order_fee_provider_amt, 0) AS total_order_fee_provider_amt,
    COALESCE(ofc.total_order_fee_fmx_amt, 0) + COALESCE(lm.total_deposit_fees, 0) AS revenue_amt
FROM ledger_metrics AS lm
LEFT JOIN execution_qty AS eq
    ON
        lm.trans_hour_alk = eq.trans_hour_alk
        AND lm.acco_id = eq.acco_id
LEFT JOIN order_fee_components AS ofc
    ON
        lm.trans_hour_alk = ofc.trans_hour_alk
        AND lm.acco_id = ofc.acco_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.orders_fmx_account_hourly_metrics", "profile_name": "user", "target_name": "default"} */
