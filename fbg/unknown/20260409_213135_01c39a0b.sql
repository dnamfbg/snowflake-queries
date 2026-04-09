-- Query ID: 01c39a0b-0212-67a8-24dd-070319376107
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:31:35.147000+00:00
-- Elapsed: 446ms
-- Environment: FBG

WITH fee_rows AS (
    SELECT
        transaction_link_reference,
        transaction_type,
        transaction_amount,
        order_final_qty,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        ROUND(order_final_price, 2) AS final_px,
        COUNT(*) OVER (PARTITION BY transaction_link_reference, transaction_type) AS rows_per_order_type
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
      AND current_order_status = 'TRADE'
      AND order_final_price > 0
      AND order_exec_initial_price > 0
      AND order_final_qty > 0
      AND trans_date_alk >= '2026-03-01'
      AND trans_date_alk < '2026-04-01'
),
dupes_only AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY transaction_link_reference, transaction_type ORDER BY ABS(transaction_amount) DESC) AS rn
    FROM fee_rows
    WHERE rows_per_order_type = 2
)
SELECT
    COUNT(*) AS duplicate_rows,
    ROUND(SUM(ABS(transaction_amount)), 2) AS actual_fees_on_dupes,
    ROUND(SUM(
        CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END * order_final_qty
    ), 2) AS macro_calc_on_all_dupe_rows,
    ROUND(SUM(CASE WHEN rn = 1 THEN
        CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END * order_final_qty
    ELSE 0 END), 2) AS macro_calc_deduped,
    ROUND(SUM(
        CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END * order_final_qty
    ), 2) - ROUND(SUM(CASE WHEN rn = 1 THEN
        CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END * order_final_qty
    ELSE 0 END), 2) AS over_calculation_from_dupes
FROM dupes_only
