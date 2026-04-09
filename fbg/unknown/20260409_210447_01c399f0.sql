-- Query ID: 01c399f0-0212-644a-24dd-07031930e2e3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:04:47.018000+00:00
-- Elapsed: 1594ms
-- Environment: FBG

WITH filled_fees AS (
    SELECT
        transaction_amount AS actual_fee,
        ROUND(order_final_price, 2) AS final_px,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
      AND current_order_status = 'TRADE'
      AND order_final_price > 0
      AND order_exec_initial_price > 0
      AND order_final_qty > 0
      AND trading_day_est >= '2026-03-01'
      AND trading_day_est < '2026-04-01'
),
filled_calc AS (
    SELECT
        actual_fee,
        ROUND(CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END, 4) * qty AS fee_at_initial,
        ROUND(CASE
            WHEN final_px BETWEEN 0.01 AND 0.04 THEN 0.34 * final_px
            WHEN final_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * final_px
            WHEN final_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN final_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * final_px
            WHEN final_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * final_px
            ELSE 0
        END, 4) * qty AS fee_at_final
    FROM filled_fees
),
refunds AS (
    SELECT SUM(transaction_amount) AS total_refunded
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type = 'FEX_ORDER_PURCHASE_FEE_REFUND'
      AND trading_day_est >= '2026-03-01'
      AND trading_day_est < '2026-04-01'
)
SELECT
    'TRADING_DAY_EST' AS time_basis,
    (SELECT COUNT(*) FROM filled_calc) AS total_orders,
    ROUND(SUM(ABS(actual_fee)), 2) AS gross_fees_collected,
    ROUND((SELECT total_refunded FROM refunds), 2) AS refunds,
    ROUND(SUM(ABS(actual_fee)) - COALESCE((SELECT total_refunded FROM refunds), 0), 2) AS net_fees_collected,
    ROUND((SUM(ABS(actual_fee)) - COALESCE((SELECT total_refunded FROM refunds), 0)) * 0.60, 2) AS fmx_net_collected,
    ROUND(SUM(fee_at_initial), 2) AS calc_at_initial,
    ROUND(SUM(fee_at_initial) * 0.60, 2) AS fmx_calc_at_initial,
    ROUND(SUM(fee_at_final), 2) AS calc_at_final,
    ROUND(SUM(fee_at_final) * 0.60, 2) AS fmx_calc_at_final,
    ROUND(SUM(fee_at_final) - (SUM(ABS(actual_fee)) - COALESCE((SELECT total_refunded FROM refunds), 0)), 2) AS gap_final_vs_net,
    ROUND((SUM(fee_at_final) - (SUM(ABS(actual_fee)) - COALESCE((SELECT total_refunded FROM refunds), 0))) * 0.60, 2) AS fmx_gap_final_vs_net,
    ROUND(SUM(fee_at_final) - SUM(fee_at_initial), 2) AS gap_slippage,
    ROUND((SUM(fee_at_final) - SUM(fee_at_initial)) * 0.60, 2) AS fmx_gap_slippage
FROM filled_calc
