-- Query ID: 01c399f7-0212-6e7d-24dd-07031932937b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:11:07.449000+00:00
-- Elapsed: 602ms
-- Environment: FBG

SELECT
    ABS(transaction_amount) AS actual_fee,
    ROUND(order_exec_initial_price, 2) AS initial_px,
    order_final_qty AS qty,
    ROUND(ABS(transaction_amount) / order_final_qty, 6) AS source_per_contract,
    trans_date_utc,
    trans_date_alk,
    order_exec_total_fees,
    transaction_type,
    order_side
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
  AND current_order_status = 'TRADE'
  AND order_final_price > 0
  AND order_exec_initial_price > 0
  AND order_final_qty > 0
  AND trans_date_alk >= '2026-03-01'
  AND trans_date_alk < '2026-04-01'
  AND order_final_qty > 10000
  AND ABS(transaction_amount) < 5
ORDER BY order_final_qty DESC
LIMIT 15
