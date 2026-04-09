-- Query ID: 01c399f6-0212-67a9-24dd-070319327457
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:10:56.851000+00:00
-- Elapsed: 297ms
-- Environment: FBG

WITH filled_fees AS (
    SELECT
        ABS(transaction_amount) AS actual_fee,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty,
        ROUND(actual_fee / order_final_qty, 6) AS source_per_contract
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
        WHEN qty < 10 THEN 'A: 1-9'
        WHEN qty < 100 THEN 'B: 10-99'
        WHEN qty < 500 THEN 'C: 100-499'
        WHEN qty < 1000 THEN 'D: 500-999'
        WHEN qty < 5000 THEN 'E: 1000-4999'
        WHEN qty < 10000 THEN 'F: 5000-9999'
        ELSE 'G: 10000+'
    END AS qty_bucket,
    COUNT(*) AS order_count,
    ROUND(SUM(actual_fee), 2) AS total_source_fee,
    ROUND(AVG(source_per_contract), 6) AS avg_source_per_contract,
    ROUND(AVG(actual_fee), 2) AS avg_order_fee
FROM filled_fees
GROUP BY qty_bucket
ORDER BY qty_bucket
