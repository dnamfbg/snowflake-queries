-- Query ID: 01c39a08-0212-6b00-24dd-070319366393
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:28:15.316000+00:00
-- Elapsed: 558ms
-- Environment: FBG

SELECT
    transaction_type,
    ABS(transaction_amount) AS actual_fee,
    order_exec_initial_price,
    order_final_price,
    order_final_qty,
    order_exec_total_fees,
    ROUND(ABS(transaction_amount) / NULLIF(order_final_qty, 0), 6) AS per_contract_actual,
    ROUND(order_exec_total_fees / NULLIF(order_final_qty, 0), 4) AS total_fees_per_contract,
    order_side,
    order_market_ticker,
    trans_date_alk::DATE AS alk_date
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_account_id = 6224940
  AND transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
  AND current_order_status = 'TRADE'
  AND trans_date_alk >= '2026-03-01'
  AND trans_date_alk < '2026-04-01'
ORDER BY order_final_qty DESC
