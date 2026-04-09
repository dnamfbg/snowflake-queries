-- Query ID: 01c39a0b-0212-644a-24dd-0703193707db
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:31:15.917000+00:00
-- Elapsed: 687ms
-- Environment: FBG

WITH fee_rows AS (
    SELECT
        transaction_link_reference,
        transaction_type,
        transaction_amount,
        order_final_qty,
        COUNT(*) OVER (PARTITION BY transaction_link_reference, transaction_type) AS rows_per_order_type
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
    rows_per_order_type,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_link_reference) AS distinct_orders,
    ROUND(SUM(ABS(transaction_amount)), 2) AS total_fees,
    ROUND(SUM(order_final_qty), 0) AS total_qty_counted
FROM fee_rows
GROUP BY rows_per_order_type
ORDER BY rows_per_order_type
