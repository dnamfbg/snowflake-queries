-- Query ID: 01c399da-0212-6b00-24dd-0703192bf15b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:42:02.490000+00:00
-- Elapsed: 327ms
-- Environment: FBG

WITH refunds AS (
    SELECT
        transaction_amount AS refund_amount,
        ROUND(order_final_price, 2) AS final_px,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty,
        ROUND(CASE
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.01 AND 0.04 THEN 0.34 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * ROUND(order_exec_initial_price, 2)
            ELSE 0
        END, 4) * order_final_qty AS fee_at_initial,
        ROUND(CASE
            WHEN ROUND(order_final_price, 2) BETWEEN 0.01 AND 0.04 THEN 0.34 * ROUND(order_final_price, 2)
            WHEN ROUND(order_final_price, 2) BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * ROUND(order_final_price, 2)
            WHEN ROUND(order_final_price, 2) BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN ROUND(order_final_price, 2) BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * ROUND(order_final_price, 2)
            WHEN ROUND(order_final_price, 2) BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * ROUND(order_final_price, 2)
            ELSE 0
        END, 4) * order_final_qty AS fee_at_final
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type = 'FEX_ORDER_PURCHASE_FEE_REFUND'
      AND trans_date_alk >= '2026-02-01'
      AND trans_date_alk < '2026-03-01'
)
SELECT
    COUNT(*) AS refund_count,
    ROUND(SUM(refund_amount), 2) AS total_refunded,
    ROUND(SUM(fee_at_initial), 2) AS sum_fee_at_initial,
    ROUND(SUM(fee_at_final), 2) AS sum_fee_at_final,
    ROUND(SUM(fee_at_initial) - SUM(fee_at_final), 2) AS calc_slippage_diff,
    ROUND(AVG(refund_amount), 4) AS avg_refund,
    ROUND(AVG(fee_at_initial - fee_at_final), 4) AS avg_calc_slippage
FROM refunds
