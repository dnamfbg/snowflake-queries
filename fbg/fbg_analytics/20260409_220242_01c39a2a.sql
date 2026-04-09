-- Query ID: 01c39a2a-0212-6cb9-24dd-0703193e7bc7
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:42.825000+00:00
-- Elapsed: 7893ms
-- Environment: FBG

SELECT "Custom SQL Query10"."ACCO_ID" AS "ACCO_ID (Custom SQL Query10)",
  "Custom SQL Query10"."ACTIVITY_MONTH" AS "ACTIVITY_MONTH",
  "Custom SQL Query10"."BET_DAYS_IN_MONTH" AS "BET_DAYS_IN_MONTH",
  "Custom SQL Query10"."COHORT_MONTH" AS "COHORT_MONTH",
  "Custom SQL Query10"."FAST_TRACK_START_DATE" AS "FAST_TRACK_START_DATE (Custom SQL Query10)",
  "Custom SQL Query10"."MONTH_NUMBER" AS "MONTH_NUMBER",
  "Custom SQL Query10"."TOTAL_CASH_HANDLE_IN_MONTH" AS "TOTAL_CASH_HANDLE_IN_MONTH"
FROM (
  WITH ft_custs AS (
      SELECT
          acco_id,
          fast_track_start_date,
          DATE_TRUNC('month', fast_track_start_date) AS cohort_month
      FROM fbg_analytics.product_and_customer.fast_track_attribute
      WHERE DATE(fast_track_start_date) >= '2025-07-01'
        AND type = 'Fast Track'
  ),
  
  /* Month bounds: from July 2025 through current month */
  params AS (
      SELECT
          DATE_TRUNC('month', DATE('2025-07-01')) AS min_month,
          DATE_TRUNC('month', CURRENT_DATE())     AS max_month
  ),
  
  /* Month calendar spine */
  months AS (
      SELECT
          DATEADD(month, seq4(), p.min_month) AS activity_month
      FROM params p,
           TABLE(GENERATOR(ROWCOUNT => 240))
      WHERE DATEADD(month, seq4(), p.min_month) <= p.max_month
  ),
  
  /*
    Account-month spine: ensures months with no activity still exist (retention-ready)
  */
  acct_month_spine AS (
      SELECT
          f.acco_id,
          f.cohort_month,
          f.fast_track_start_date,
          m.activity_month,
          DATEDIFF(month, f.cohort_month, m.activity_month) AS month_number
      FROM ft_custs f
      JOIN months m
        ON m.activity_month >= f.cohort_month
  ),
  
  /*
    Daily CVP rollup (in case CVP has multiple rows per day per account)
  */
  daily_cvp AS (
      SELECT
          cvp.acco_id,
          DATE(cvp.date) AS activity_date,
          SUM(COALESCE(cvp.OSB_CASH_HANDLE, 0) + COALESCE(cvp.OC_CASH_HANDLE, 0)) AS total_cash_handle
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
      JOIN ft_custs f
        ON cvp.acco_id = f.acco_id
       AND DATE(cvp.date) >= f.fast_track_start_date
      WHERE DATE(cvp.date) >= '2025-07-01'
      GROUP BY 1,2
  ),
  
  /*
    Monthly “bets” = count of distinct days where total_cash_handle > 0
  */
  monthly_bet_days AS (
      SELECT
          acco_id,
          DATE_TRUNC('month', activity_date) AS activity_month,
          COUNT_IF(total_cash_handle > 0) AS bet_days_in_month,
          SUM(total_cash_handle) AS total_cash_handle_in_month
      FROM daily_cvp
      GROUP BY 1,2
  )
  
  SELECT
      s.acco_id,
      s.fast_track_start_date,
      s.cohort_month,
      s.activity_month,
      s.month_number,
      COALESCE(m.bet_days_in_month, 0) AS bet_days_in_month,
      COALESCE(m.total_cash_handle_in_month, 0) AS total_cash_handle_in_month
  FROM acct_month_spine s
  LEFT JOIN monthly_bet_days m
    ON s.acco_id = m.acco_id
   AND s.activity_month = m.activity_month
  ORDER BY s.cohort_month, s.acco_id, s.activity_month
) "Custom SQL Query10"
