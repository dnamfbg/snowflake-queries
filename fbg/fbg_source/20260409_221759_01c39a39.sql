-- Query ID: 01c39a39-0212-6dbe-24dd-0703194230e7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T22:17:59.087000+00:00
-- Elapsed: 108ms
-- Environment: FBG

SELECT "Custom SQL Query"."AS_OF_DATE" AS "AS_OF_DATE",
  "Custom SQL Query"."ATTRIBUTION" AS "ATTRIBUTION",
  "Custom SQL Query"."CAMPAIGN_NAME" AS "CAMPAIGN_NAME",
  "Custom SQL Query"."CHANGE_TYPE" AS "CHANGE_TYPE",
  "Custom SQL Query"."LEAD_CREATION_DATE" AS "LEAD_CREATION_DATE",
  "Custom SQL Query"."LEAD_ID" AS "LEAD_ID",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LEAD_SOURCE" AS "LEAD_SOURCE",
  "Custom SQL Query"."LEAD_SUBSOURCE" AS "LEAD_SUBSOURCE",
  "Custom SQL Query"."P250_LEAD_ID" AS "P250_LEAD_ID",
  "Custom SQL Query"."PREV_ATTRIBUTION" AS "PREV_ATTRIBUTION",
  "Custom SQL Query"."PREV_LEAD_OWNER" AS "PREV_LEAD_OWNER"
FROM (
  WITH changes_ AS (
    SELECT
        lead_id,
        as_of_date,
        lead_creation_date,
        lead_owner,
        attribution,
  
        LAG(lead_owner)    OVER (PARTITION BY lead_id ORDER BY as_of_date) AS prev_lead_owner,
        LAG(attribution)   OVER (PARTITION BY lead_id ORDER BY as_of_date) AS prev_attribution
    FROM fbg_analytics.vip.leads_daily
  ),
  
  recent_changes AS (
    SELECT
        *
      , CASE
          -- New lead (first time we see a non-null owner)
          WHEN prev_lead_owner IS NULL AND lead_owner IS NOT NULL
               AND lead_creation_date >= DATEADD(day, -30, CURRENT_DATE)
            THEN 'New Lead'
  
          -- Owner changed (handles nulls safely too)
          WHEN COALESCE(lead_owner,'') <> COALESCE(prev_lead_owner,'')
            THEN 'Owner Change'
  
          -- Attribution changed into Disqualified (your original requirement)
          WHEN COALESCE(attribution,'') <> COALESCE(prev_attribution,'')
               AND attribution = 'Disqualified'
            THEN 'Disqualified'
        END AS change_type
    FROM changes_
    WHERE as_of_date >= DATEADD(day, -30, CURRENT_DATE)
      AND (
           -- include new leads (first owner assignment) within last 30 days of creation
           (prev_lead_owner IS NULL AND lead_owner IS NOT NULL
            AND lead_creation_date >= DATEADD(day, -30, CURRENT_DATE))
  
           OR
  
           -- owner changed
           (COALESCE(lead_owner,'') <> COALESCE(prev_lead_owner,''))
  
           OR
  
           -- attribution changed into disqualified
           (COALESCE(attribution,'') <> COALESCE(prev_attribution,'')
            AND attribution = 'Disqualified')
      )
  )
  
  SELECT rc.*
  , p.lead_id AS p250_lead_id
  , p.campaign_name
  , lm.lead_source
  , lm.lead_subsource
  FROM recent_changes AS rc 
  INNER JOIN fbg_analytics.vip.lead_machine AS lm         
      ON rc.lead_id = lm.lead_id
  LEFT JOIN fbg_analytics.vip.project_250_campaigns AS p 
      ON rc.lead_id = p.lead_id
  WHERE rc.lead_owner IN ('Taylor OBrien', 'Kyle McQuillan', 'Taylor Gwiazdon', 'Darren OBrien','Chris Bukowski','Michael Del Zotto','Will Rolapp','Jamie Fitzsimmons','Matthew Fleisher','Michael Hermalyn','Robert Ferrara','Pete Donahue','Gregg Hiller','Dan Barzottini','Tim Riley','Dana White','Michael Bernstein')
) "Custom SQL Query"
