-- Query ID: 01c399f6-0212-6b00-24dd-070319325457
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:10:42.556000+00:00
-- Elapsed: 409ms
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
        END, 4) AS per_contract_fee,
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
    initial_px,
    per_contract_fee AS our_per_contract,
    ROUND(actual_fee / qty, 4) AS source_per_contract,
    ROUND(per_contract_fee - actual_fee / qty, 4) AS per_contract_delta,
    qty,
    actual_fee,
    calc_fee,
    ROUND(calc_fee - actual_fee, 4) AS order_delta
FROM filled_fees
WHERE ABS(calc_fee - actual_fee) > 0.001
ORDER BY ABS(calc_fee - actual_fee) DESC
LIMIT 20
