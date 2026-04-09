-- Query ID: 01c39a2a-0212-6dbe-24dd-0703193e808f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:25.112000+00:00
-- Elapsed: 2335ms
-- Environment: FBG

SELECT "Custom SQL Query8"."ACCO_ID" AS "ACCO_ID (Custom SQL Query8)",
  "Custom SQL Query8"."FBG_NAME" AS "FBG_NAME",
  "Custom SQL Query8"."MESSAGE_DATE" AS "MESSAGE_DATE",
  "Custom SQL Query8"."MESSAGE_ID" AS "MESSAGE_ID",
  "Custom SQL Query8"."OUTREACH_TYPE" AS "OUTREACH_TYPE"
FROM (
  WITH msgs AS (
    SELECT
        a.*
    FROM fbg_analytics.vip.vip_contact_history a
    JOIN fbg_analytics.product_and_customer.fast_track_attribute c
      on a.acco_id = c.acco_id
    WHERE 1=1
      --AND a.message_type = 'Text'
      --AND b.host_type IN ('AM', 'AAM')
    AND date(message_date) between date(fast_track_start_date) and date(fast_track_end_date)
    AND fbg_name in ('Gaby Breyburg', 'Ethan Eliason', 'Sameer Khaled', 'Sam Burgess', 'Pauline Cook', 'Britney Swedelson')
  ),
  
  -- Get the most recent inbound BEFORE each message (per account)
  with_last_inbound AS (
    SELECT
        m.*,
        MAX( IFF(INBOUND = 1, MESSAGE_DATE, NULL) )
          OVER (
            PARTITION BY ACCO_ID
            ORDER BY MESSAGE_DATE
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
          ) AS last_inbound_time
    FROM msgs m
  ),
  type as (
      SELECT
          MESSAGE_ID,
          ACCO_ID,
          MESSAGE_DATE,
          DESCRIPTION,
          OUTBOUND,
          INBOUND,
          CASE
            WHEN OUTBOUND = 1
                 AND last_inbound_time IS NOT NULL
                 AND DATEDIFF('hour', last_inbound_time, MESSAGE_DATE) <= 12
              THEN 'Reactive'
            WHEN OUTBOUND = 1
              THEN 'Proactive'
            ELSE NULL  -- keep NULL for inbound rows (you can filter to OUTBOUND=1 if you want only rep texts)
          END AS outreach_type,
          last_inbound_time,
          fbg_name
      FROM with_last_inbound
      ORDER BY ACCO_ID, MESSAGE_DATE
  )
  
  select
  acco_id,
  message_id,
  date(MESSAGE_DATE) as message_date, 
  outreach_type,
  fbg_name
  from type
  where outreach_type is not null
  --group by all
  order by date(message_date) desc, outreach_type
) "Custom SQL Query8"
