-- Query ID: 01c39a56-0212-6e7d-24dd-07031947cb67
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:46:28.830000+00:00
-- Elapsed: 3936ms
-- Environment: FBG

SELECT "Custom SQL Query"."CUSTOMERS" AS "CUSTOMERS",
  "Custom SQL Query"."CUSTOMERS_CONTACTED" AS "CUSTOMERS_CONTACTED",
  "Custom SQL Query"."DAY_OF_WEEK" AS "DAY_OF_WEEK",
  "Custom SQL Query"."DOW_NUM" AS "DOW_NUM",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."NUM_DAYS" AS "NUM_DAYS",
  "Custom SQL Query"."STAGENAME" AS "STAGENAME",
  "Custom SQL Query"."TOTAL_CONTACTS" AS "TOTAL_CONTACTS"
FROM (
  WITH reactivation_users AS (
  SELECT DISTINCT
  TO_DATE(TO_TIMESTAMP_NTZ(a.CREATEDDATE, 'YYYY-MM-DDTHH24:MI:SS.FF3TZHTZM')) AS entry_date
  , b.name AS fbg_name
  , a.*
  , CASE WHEN a.isclosed = 'True' THEN TO_DATE(DATE_TRUNC('DAY', TRY_TO_TIMESTAMP(a.laststagechangedate, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'))) END AS reactivation_end_date
  FROM fbg_source.salesforce.o_opportunity AS a
  INNER JOIN fbg_source.salesforce.o_user AS b
      ON a.ownerid = b.id
  WHERE a.type IN ('Re-Activation', 'Reactivation')
  AND entry_date >= '2025-06-01'
  AND b.name IN ('Bobby Greves', 'Will Rolapp', 'Matthew Fleisher', 'Amelco Integration')
  )
  
  , reactivation_users_cohorts AS (
  SELECT DISTINCT 
  DATE_TRUNC('WEEK', r.entry_date) AS reactivation_entry_week
  , r.entry_date
  , r.reactivation_end_date
  , r.nats_id__c AS acco_id
  , r.fbg_name
  , r.stagename
  FROM reactivation_users AS r
  --WHERE r.reactivation_end_date IS NULL
  --WHERE DATEDIFF(WEEK, reactivation_entry_week, DATE_TRUNC('WEEK', CURRENT_DATE)) <= 8
  )
  
  , reactivation_users_cohorts_metrics AS (
  SELECT DISTINCT 
  t.calendar_date AS date
  , a.fbg_name
  , a.stagename
  , COUNT(DISTINCT a.acco_id) AS customers
  FROM reactivation_users_cohorts AS a 
  INNER JOIN fbg_analytics.product_and_customer.t_calendar AS t 
      ON t.calendar_date >= a.entry_date
      AND t.calendar_date <= COALESCE(a.reactivation_end_date, '9999-01-01')
  WHERE t.calendar_date >= '2025-06-01'
  AND t.calendar_date <= CURRENT_DATE
  GROUP BY ALL
  )
  
  , contacts AS (
  SELECT DISTINCT 
  DATE_TRUNC('DAY', c.message_date) AS day
  , c.acco_id
  , c.fbg_name
  , r.stagename
  , COUNT(DISTINCT c.message_id) AS outbound_contacts
  FROM fbg_analytics.vip.vip_contact_history AS c 
  -- INNER JOIN reactivation_users_cohorts_metrics AS a 
  --     ON DATE_TRUNC('WEEK', c.message_date) = a.date
  INNER JOIN reactivation_users_cohorts AS r 
      ON c.acco_id = r.acco_id
      AND c.fbg_name = r.fbg_name
      AND c.message_date >= r.entry_date
      AND c.message_date <= COALESCE(r.reactivation_end_date, '9999-01-01')
  WHERE c.outbound = 1
  --AND c.fbg_name IN ('Bobby Greves', 'Will Rolapp')
  GROUP BY ALL
  )
  
  , final AS (
  SELECT DISTINCT 
  a.date
  , DAYNAME(DATE_TRUNC('DAY', a.date)::DATE) AS day_of_week
  , DAYOFWEEK(DATE_TRUNC('DAY', a.date)::DATE) AS dow_num
  , a.fbg_name
  , a.stagename
  , a.customers 
  , COUNT(DISTINCT c.acco_id) AS customers_contacted
  , MEDIAN(c.outbound_contacts) AS median_contacts_per_customer
  , SUM(c.outbound_contacts) AS total_contacts
  FROM reactivation_users_cohorts_metrics AS a 
  LEFT JOIN contacts AS c 
      ON a.date = c.day
      AND a.fbg_name = c.fbg_name
      AND a.stagename = c.stagename
  WHERE DATEDIFF(DAY, a.date, CURRENT_DATE) <= 30
  GROUP BY ALL
  )
  
  SELECT DISTINCT 
  day_of_week
  , dow_num
  , fbg_name AS name
  , stagename
  , COUNT(DISTINCT date) AS num_days
  , SUM(customers) AS customers
  , SUM(customers_contacted) AS customers_contacted
  , SUM(COALESCE(total_contacts, 0)) AS total_contacts
  FROM final 
  GROUP BY ALL
) "Custom SQL Query"
