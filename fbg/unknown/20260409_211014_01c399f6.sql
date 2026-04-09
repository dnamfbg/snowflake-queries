-- Query ID: 01c399f6-0212-6dbe-24dd-070319320aaf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:10:14.465000+00:00
-- Elapsed: 1674ms
-- Environment: FBG

WITH filled_fees AS (
    SELECT
        ABS(transaction_amount) AS actual_fee,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty,
        ROUND(CASE
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.01 AND 0.04 THEN 0.34 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * ROUND(order_exec_initial_price, 2)
            ELSE 0
        END, 4) * order_final_qty AS calc_fee
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
      AND current_order_status = 'TRADE'
      AND order_final_price > 0
      AND order_exec_initial_price > 0
      AND order_final_qty > 0
      AND trans_date_alk >= '2026-03-01'
      AND trans_date_alk < '2026-04-01'
)
SELECT
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN calc_fee = actual_fee THEN 1 END) AS exact_match,
    COUNT(CASE WHEN calc_fee > actual_fee THEN 1 END) AS macro_higher,
    COUNT(CASE WHEN calc_fee < actual_fee THEN 1 END) AS macro_lower,
    ROUND(AVG(calc_fee - actual_fee), 6) AS avg_delta,
    ROUND(MEDIAN(calc_fee - actual_fee), 6) AS median_delta,
    ROUND(MIN(calc_fee - actual_fee), 4) AS min_delta,
    ROUND(MAX(calc_fee - actual_fee), 4) AS max_delta,
    ROUND(SUM(calc_fee - actual_fee), 2) AS total_delta
FROM filled_fees
