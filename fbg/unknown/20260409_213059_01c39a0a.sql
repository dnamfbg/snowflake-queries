-- Query ID: 01c39a0a-0212-67a8-24dd-07031936dc7b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:30:59.246000+00:00
-- Elapsed: 581ms
-- Environment: FBG

SELECT
    transaction_link_reference,
    transaction_type,
    transaction_amount,
    order_exec_initial_price,
    order_final_price,
    order_final_qty,
    order_exec_total_fees,
    source_bk
FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
WHERE transaction_account_id = 6224940
  AND order_market_ticker = 'NX.F.OPT.CBB-00010-260318-M.O.1.2'
  AND transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
  AND current_order_status = 'TRADE'
ORDER BY transaction_type, transaction_amount
