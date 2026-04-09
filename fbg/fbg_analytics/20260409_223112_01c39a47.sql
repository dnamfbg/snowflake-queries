-- Query ID: 01c39a47-0212-6dbe-24dd-070319447d6f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:31:12.552000+00:00
-- Elapsed: 1522ms
-- Environment: FBG

SELECT "Custom SQL Query6"."ACCO_ID" AS "ACCO_ID (Custom SQL Query6)"
FROM (
  WITH daily_handle AS (
    SELECT
      a.acco_id,
      DATE(cvp.date) AS activity_date,
      ROUND(SUM(COALESCE(cvp.osb_cash_handle, 0) + COALESCE(cvp.oc_cash_handle, 0))) AS day_handle,
      a.fast_track_start_date,
      a.fast_track_end_date
    FROM fbg_analytics.product_and_customer.fast_track_attribute a
    LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT cvp
      ON cvp.acco_id = a.acco_id
     AND DATE(cvp.date) BETWEEN a.fast_track_start_date
                           AND DATEADD(day, 30, a.fast_track_end_date)
    GROUP BY
      a.acco_id,
      DATE(cvp.date),
      a.fast_track_start_date,
      a.fast_track_end_date
  ),
  daily_flags AS (
    SELECT
      acco_id,
      fast_track_start_date,
      fast_track_end_date,
      activity_date,
      IFF(day_handle > 0, 1, 0) AS is_active_day
    FROM daily_handle
  )
  SELECT
    a.acco_id,
    a.TYPE,
    a.FAST_TRACK_START_DATE,
    /* active days during fast track */
    COALESCE(SUM(IFF(df.activity_date BETWEEN a.fast_track_start_date AND a.fast_track_end_date,
                     df.is_active_day, 0)), 0) AS active_days_in_fast_track,
  
    /* active days from end date through +30 days */
    COALESCE(SUM(IFF(df.activity_date BETWEEN a.fast_track_end_date AND DATEADD(day, 30, a.fast_track_end_date),
                     df.is_active_day, 0)), 0) AS active_days_0_to_30_post_end
  
  FROM fbg_analytics.product_and_customer.fast_track_attribute a
  LEFT JOIN daily_flags df
    ON df.acco_id = a.acco_id
  GROUP BY all
) "Custom SQL Query6"
