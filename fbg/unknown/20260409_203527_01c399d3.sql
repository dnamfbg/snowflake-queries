-- Query ID: 01c399d3-0212-6b00-24dd-0703192a573f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:35:27.875000+00:00
-- Elapsed: 1436ms
-- Environment: FBG

SELECT
    transaction_type,
    COUNT(*) AS txn_count,
    ROUND(SUM(transaction_amount), 2) AS total_amount,
    ROUND(SUM(ABS(transaction_amount)), 2) AS total_abs_amount,
    MIN(transaction_amount) AS min_amt,
    MAX(transaction_amount) AS max_amt
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_type IN (
    'FEX_ORDER_PURCHASE_FEE',
    'FEX_ORDER_PURCHASE_FEE_REVERT',
    'FEX_ORDER_PURCHASE_FEE_REFUND',
    'FEX_ORDER_SALE_FEE'
)
AND trading_day_est >= '2026-02-01'
AND trading_day_est < '2026-03-01'
GROUP BY transaction_type
ORDER BY transaction_type
