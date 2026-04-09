-- Query ID: 01c399f7-0212-6cb9-24dd-07031932872f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:11:28.061000+00:00
-- Elapsed: 911ms
-- Environment: FBG

SELECT
    transaction_account_id::VARCHAR AS acct_id,
    COUNT(*) AS order_count,
    ROUND(SUM(order_final_qty), 0) AS total_qty,
    ROUND(SUM(ABS(transaction_amount)), 2) AS total_actual_fee,
    ROUND(AVG(ABS(transaction_amount) / NULLIF(order_final_qty, 0)), 6) AS avg_per_contract_fee
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
  AND current_order_status = 'TRADE'
  AND order_final_price > 0
  AND order_exec_initial_price > 0
  AND order_final_qty > 0
  AND trans_date_alk >= '2026-03-01'
  AND trans_date_alk < '2026-04-01'
  AND order_final_qty > 5000
  AND ABS(transaction_amount) / order_final_qty < 0.001
GROUP BY acct_id
ORDER BY total_qty DESC
