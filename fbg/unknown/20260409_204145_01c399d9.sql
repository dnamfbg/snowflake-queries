-- Query ID: 01c399d9-0212-67a9-24dd-0703192bab2f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:41:45.747000+00:00
-- Elapsed: 1110ms
-- Environment: FBG

SELECT
    transaction_type,
    current_order_status,
    COUNT(*) AS cnt,
    COUNT(CASE WHEN order_final_price > 0 AND order_exec_initial_price > 0 THEN 1 END) AS has_both_prices,
    COUNT(CASE WHEN order_final_price != order_exec_initial_price AND order_final_price > 0 AND order_exec_initial_price > 0 THEN 1 END) AS prices_differ,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_type IN (
    'FEX_ORDER_PURCHASE_FEE_REVERT',
    'FEX_ORDER_PURCHASE_FEE_REFUND'
)
AND trans_date_alk >= '2026-02-01'
AND trans_date_alk < '2026-03-01'
GROUP BY transaction_type, current_order_status
ORDER BY transaction_type, current_order_status
