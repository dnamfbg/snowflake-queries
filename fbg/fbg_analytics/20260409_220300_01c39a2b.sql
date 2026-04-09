-- Query ID: 01c39a2b-0212-6cb9-24dd-0703193e7f3f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:03:00.347000+00:00
-- Elapsed: 10628ms
-- Environment: FBG

SELECT "Custom SQL Query7"."ACCO_ID" AS "ACCO_ID (Custom SQL Query7)",
  "Custom SQL Query7"."DATE" AS "DATE",
  "Custom SQL Query7"."DAY_COUNT" AS "DAY_COUNT",
  "Custom SQL Query7"."FAST_TRACK_END_DATE" AS "FAST_TRACK_END_DATE (Custom SQL Query7)",
  "Custom SQL Query7"."FAST_TRACK_START_DATE" AS "FAST_TRACK_START_DATE (Custom SQL Query7)",
  "Custom SQL Query7"."OC_CASH_GGR" AS "OC_CASH_GGR",
  "Custom SQL Query7"."OC_CASH_HANDLE" AS "OC_CASH_HANDLE",
  "Custom SQL Query7"."OC_ENGR" AS "OC_ENGR",
  "Custom SQL Query7"."OSB_CASH_GGR" AS "OSB_CASH_GGR",
  "Custom SQL Query7"."OSB_CASH_HANDLE" AS "OSB_CASH_HANDLE",
  "Custom SQL Query7"."OSB_ENGR" AS "OSB_ENGR",
  "Custom SQL Query7"."TOTAL_GGR" AS "TOTAL_GGR"
FROM (
  with ft_custs as (
  select
  acco_id,
  fast_track_start_date,
  fast_track_end_date
  from fbg_analytics.product_and_customer.fast_track_attribute
  ),
  
  fast_track_metrics_before_ft AS (
    SELECT
      o.*,
      DATE(cvp.date) as date,
      ROUND(SUM(COALESCE(cvp.OSB_ENGR, 0))) AS osb_engr,
      ROUND(SUM(COALESCE(cvp.OC_ENGR, 0))) AS oc_engr,
      ROUND(SUM(COALESCE(cvp.OSB_CASH_HANDLE, 0))) AS osb_cash_handle,
      ROUND(SUM(COALESCE(cvp.OC_CASH_HANDLE, 0))) as oc_cash_handle,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) as osb_cash_ggr,
      ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as oc_cash_ggr,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) + ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as total_ggr,
      datediff(day, o.fast_track_start_date, DATE(cvp.date)) + 30 as day_count
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
    JOIN ft_custs o
      ON cvp.acco_id = o.acco_id
      AND DATE(cvp.date) >= DATEADD(day, -30, o.fast_track_start_date) AND DATE(cvp.date) < o.fast_track_start_date
    GROUP BY 1,2,3,4
  ),
  
  fast_track_metrics_during_ft AS (
    SELECT
      o.*,
      DATE(cvp.date) as date,
      ROUND(SUM(COALESCE(cvp.OSB_ENGR, 0))) AS osb_engr,
      ROUND(SUM(COALESCE(cvp.OC_ENGR, 0))) AS oc_engr,
      ROUND(SUM(COALESCE(cvp.OSB_CASH_HANDLE, 0))) AS osb_cash_handle,
      ROUND(SUM(COALESCE(cvp.OC_CASH_HANDLE, 0))) as oc_cash_handle,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) as osb_cash_ggr,
      ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as oc_cash_ggr,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) + ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as total_ggr,
      datediff(day, o.fast_track_start_date, DATE(cvp.date)) + 30 as day_count
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
    JOIN ft_custs o
      ON cvp.acco_id = o.acco_id
      AND DATE(cvp.date) BETWEEN o.fast_track_start_date AND o.fast_track_end_date
    GROUP BY 1,2,3,4
  ),
  
  fast_track_metrics_90_days_after_ft AS (
    SELECT
      o.*,
      DATE(cvp.date) as date,
      ROUND(SUM(COALESCE(cvp.OSB_ENGR, 0))) AS osb_engr,
      ROUND(SUM(COALESCE(cvp.OC_ENGR, 0))) AS oc_engr,
      ROUND(SUM(COALESCE(cvp.OSB_CASH_HANDLE, 0))) AS osb_cash_handle,
      ROUND(SUM(COALESCE(cvp.OC_CASH_HANDLE, 0))) as oc_cash_handle,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) as osb_cash_ggr,
      ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as oc_cash_ggr,
      ROUND(SUM(COALESCE(cvp.osb_cash_ggr, 0))) + ROUND(SUM(COALESCE(cvp.oc_cash_ggr, 0))) as total_ggr,
      datediff(day, o.fast_track_end_date, DATE(cvp.date)) + 60 as day_count
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
    JOIN ft_custs o
      ON cvp.acco_id = o.acco_id
      AND DATE(cvp.date) > o.fast_track_end_date AND DATE(cvp.date) <= DATEADD(day, 90, o.fast_track_end_date)
    GROUP BY 1,2,3,4
  )
  
  select * 
  from fast_track_metrics_before_ft
  union all 
  select * 
  from fast_track_metrics_during_ft
  union all 
  select * 
  from fast_track_metrics_90_days_after_ft
) "Custom SQL Query7"
