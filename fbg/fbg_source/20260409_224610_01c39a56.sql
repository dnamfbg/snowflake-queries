-- Query ID: 01c39a56-0212-6e7d-24dd-07031947c883
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Last Executed: 2026-04-09T22:46:10.164000+00:00
-- Elapsed: 66475ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."FTU_DATE" AS "FTU_DATE",
  "Custom SQL Query"."PRODUCT" AS "PRODUCT",
  "Custom SQL Query"."UPDATE_TIME" AS "UPDATE_TIME"
FROM (
  --OC FTUS
  WITH oc AS (
  SELECT
      a.acco_id,
      CASE 
          WHEN a.game_id IS NULL THEN 'sbk' 
          ELSE 'casino' 
      END AS product,
      DATE_TRUNC(
          'hour',
          CONVERT_TIMEZONE('UTC', 'America/Anchorage', a.trans_date)
      ) AS ftu_date,
      CONVERT_TIMEZONE('UTC','America/Anchorage', sysdate()) AS Update_Time
  FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS AS a
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON a.acco_id = acc.id
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j
      ON acc.current_jurisdictions_id = j.id
  WHERE a.trans IN ('STAKE', 'FREE_SPIN_STAKE', 'FREEBET_STAKE')
    AND acc.test = 0
  QUALIFY ROW_NUMBER() OVER (
      PARTITION BY a.acco_id 
      ORDER BY a.trans_date ASC
  ) = 1
  )
  
  select*
  from oc
  WHERE product = 'casino'
  group by all
  order by 1 desc
) "Custom SQL Query"
