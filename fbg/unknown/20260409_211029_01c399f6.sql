-- Query ID: 01c399f6-0212-6cb9-24dd-0703193280ab
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:10:29.203000+00:00
-- Elapsed: 851ms
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
        END, 4) * order_final_qty AS calc_fee,
        ROUND(CASE
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.01 AND 0.04 THEN 0.34 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * ROUND(order_exec_initial_price, 2)
            WHEN ROUND(order_exec_initial_price, 2) BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * ROUND(order_exec_initial_price, 2)
            ELSE 0
        END, 4) AS per_contract_fee
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
    CASE
        WHEN calc_fee = actual_fee THEN 'A: exact match'
        WHEN ABS(calc_fee - actual_fee) < 0.01 THEN 'B: <$0.01'
        WHEN ABS(calc_fee - actual_fee) < 0.10 THEN 'C: $0.01-0.10'
        WHEN ABS(calc_fee - actual_fee) < 1.00 THEN 'D: $0.10-1.00'
        WHEN ABS(calc_fee - actual_fee) < 10.00 THEN 'E: $1-10'
        WHEN ABS(calc_fee - actual_fee) < 100.00 THEN 'F: $10-100'
        ELSE 'G: $100+'
    END AS delta_bucket,
    COUNT(*) AS order_count,
    ROUND(SUM(calc_fee - actual_fee), 2) AS total_delta,
    ROUND(AVG(qty), 1) AS avg_qty
FROM filled_fees
GROUP BY delta_bucket
ORDER BY delta_bucket
