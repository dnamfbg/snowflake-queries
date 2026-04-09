-- Query ID: 01c399cc-0212-67a9-24dd-070319287f93
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:28:17.006000+00:00
-- Elapsed: 751ms
-- Environment: FBG

WITH fee_transactions AS (
    SELECT
        transaction_amount AS actual_fee_collected,
        ROUND(order_final_price, 2) AS final_px,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
      AND current_order_status = 'TRADE'
      AND order_final_price > 0
      AND order_exec_initial_price > 0
      AND order_final_qty > 0
      AND trans_date_alk >= '2026-02-01'
      AND trans_date_alk < '2026-03-01'
),
with_calc AS (
    SELECT
        actual_fee_collected,
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
    FROM fee_transactions
)
SELECT
    'TRANS_DATE_ALK' AS time_basis,
    COUNT(*) AS total_orders,
    ROUND(SUM(ABS(actual_fee_collected)), 2) AS total_fees_collected,
    ROUND(SUM(ABS(actual_fee_collected)) * 0.60, 2) AS fmx_fees_collected,
    ROUND(SUM(fee_at_initial), 2) AS total_calc_at_initial,
    ROUND(SUM(fee_at_initial) * 0.60, 2) AS fmx_calc_at_initial,
    ROUND(SUM(fee_at_final), 2) AS total_calc_at_final,
    ROUND(SUM(fee_at_final) * 0.60, 2) AS fmx_calc_at_final,
    ROUND(SUM(fee_at_final) - SUM(ABS(actual_fee_collected)), 2) AS gap_final_vs_actual,
    ROUND((SUM(fee_at_final) - SUM(ABS(actual_fee_collected))) * 0.60, 2) AS fmx_gap_final_vs_actual,
    ROUND(SUM(fee_at_final) - SUM(fee_at_initial), 2) AS gap_slippage,
    ROUND((SUM(fee_at_final) - SUM(fee_at_initial)) * 0.60, 2) AS fmx_gap_slippage
FROM with_calc
