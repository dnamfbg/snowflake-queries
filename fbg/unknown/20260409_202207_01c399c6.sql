-- Query ID: 01c399c6-0212-6cb9-24dd-07031927c18b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:22:07.221000+00:00
-- Elapsed: 657ms
-- Environment: FBG

WITH fee_transactions AS (
    SELECT
        trans_date_alk::DATE AS alk_date,
        trading_day_est,
        transaction_type,
        transaction_amount AS actual_fee_collected,
        ROUND(order_final_price, 2) AS final_px,
        ROUND(order_exec_initial_price, 2) AS initial_px,
        order_final_qty AS qty
    FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_ONLINE_FMX_TRANSACTIONS
    WHERE transaction_type IN ('FEX_ORDER_PURCHASE_FEE', 'FEX_ORDER_SALE_FEE')
      AND current_order_status = 'TRADE'
      AND order_final_price > 0
      AND order_exec_initial_price > 0
      AND order_final_qty > 0
      AND trans_date_alk >= '2026-02-01'
      AND trans_date_alk < '2026-03-01'
),
with_calc AS (
    SELECT
        alk_date,
        trading_day_est,
        actual_fee_collected,
        ROUND(CASE
            WHEN initial_px BETWEEN 0.01 AND 0.04 THEN 0.34 * initial_px
            WHEN initial_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * initial_px
            WHEN initial_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN initial_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * initial_px
            WHEN initial_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * initial_px
            ELSE 0
        END, 4) * qty AS fee_at_initial,
        ROUND(CASE
            WHEN final_px BETWEEN 0.01 AND 0.04 THEN 0.34 * final_px
            WHEN final_px BETWEEN 0.05 AND 0.20 THEN 0.012 + 0.04 * final_px
            WHEN final_px BETWEEN 0.21 AND 0.80 THEN 0.02
            WHEN final_px BETWEEN 0.81 AND 0.96 THEN 0.052 - 0.04 * final_px
            WHEN final_px BETWEEN 0.97 AND 0.99 THEN 0.046 - 0.04 * final_px
            ELSE 0
        END, 4) * qty AS fee_at_final
    FROM fee_transactions
)
SELECT 'TRANS_DATE_ALK' AS time_basis,
    ROUND(SUM(ABS(actual_fee_collected)), 2) AS total_fees_collected,
    ROUND(SUM(ABS(actual_fee_collected)) * 0.60, 2) AS fmx_fees_collected,
    ROUND(SUM(fee_at_initial), 2) AS total_calc_at_initial,
    ROUND(SUM(fee_at_final), 2) AS total_calc_at_final,
    ROUND(SUM(fee_at_final) * 0.60, 2) AS fmx_calc_at_final,
    ROUND(SUM(fee_at_final) - SUM(ABS(actual_fee_collected)), 2) AS gap_final_vs_actual,
    ROUND((SUM(fee_at_final) - SUM(ABS(actual_fee_collected))) * 0.60, 2) AS fmx_gap_final_vs_actual,
    ROUND(SUM(fee_at_final) - SUM(fee_at_initial), 2) AS gap_slippage,
    ROUND((SUM(fee_at_final) - SUM(fee_at_initial)) * 0.60, 2) AS fmx_gap_slippage
FROM with_calc
UNION ALL
SELECT 'TRADING_DAY_EST' AS time_basis,
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN ABS(actual_fee_collected) END), 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN ABS(actual_fee_collected) END) * 0.60, 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_initial END), 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final END), 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final END) * 0.60, 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final - ABS(actual_fee_collected) END), 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final - ABS(actual_fee_collected) END) * 0.60, 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final - fee_at_initial END), 2),
    ROUND(SUM(CASE WHEN trading_day_est >= '2026-02-01' AND trading_day_est < '2026-03-01' THEN fee_at_final - fee_at_initial END) * 0.60, 2)
FROM with_calc
