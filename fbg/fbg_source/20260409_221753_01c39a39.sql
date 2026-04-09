-- Query ID: 01c39a39-0212-67a9-24dd-070319420d37
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:17:53.770000+00:00
-- Elapsed: 123ms
-- Environment: FBG

SELECT "Custom SQL Query"."FBG_NAME" AS "FBG_NAME",
  "Custom SQL Query"."INCREMENTAL_TP_EARN" AS "INCREMENTAL_TP_EARN",
  "Custom SQL Query"."INC_BASE" AS "INC_BASE",
  "Custom SQL Query"."PCT_TO_TARGET" AS "PCT_TO_TARGET",
  "Custom SQL Query"."TARGET" AS "TARGET",
  "Custom SQL Query"."TOTAL_POINTS" AS "TOTAL_POINTS",
  "Custom SQL Query"."TP_10000" AS "TP_10000",
  "Custom SQL Query"."TP_20000" AS "TP_20000",
  "Custom SQL Query"."TP_2500" AS "TP_2500"
FROM (
  SELECT DISTINCT 
  fbg_name 
  , SUM(inc_base) AS inc_base
  , SUM(inc_og) AS tp_2500
  , SUM(inc_op) AS tp_10000
  , SUM(inc_ob) AS tp_20000
  , SUM(inc_extra) AS incremental_tp_earn
  , SUM(quarter_points_capped) AS total_points
  , t.target
  , total_points / t.target AS pct_to_target
  FROM fbg_analytics.vip.vip_acquisition_comp_plan_quarterly AS a
  INNER JOIN fbg_analytics.vip.vip_quarterly_acquisition_targets AS t 
      ON a.fbg_name = t.name
      AND a.quarter_start = t.quarter
  WHERE a.quarter_start = DATE_TRUNC('QUARTER', CURRENT_DATE)
  GROUP BY ALL
) "Custom SQL Query"
