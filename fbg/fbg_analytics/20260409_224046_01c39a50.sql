-- Query ID: 01c39a50-0212-67a9-24dd-07031946baef
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:40:46.993000+00:00
-- Elapsed: 125458ms
-- Environment: FBG

SELECT "Custom SQL Query"."Casino FTUs" AS "Casino FTUs",
  "Custom SQL Query"."FTU Time(EST)" AS "FTU Time(EST)",
  "Custom SQL Query"."JURISDICTION_NAME" AS "JURISDICTION_NAME",
  "Custom SQL Query"."SBK FTUs" AS "SBK FTUs",
  "Custom SQL Query"."Total FTUs" AS "Total FTUs"
FROM (
  with ftu AS(
      select
      a.acco_id,
      jurisdiction_name,
      CASE WHEN a.game_id is null THEN 'sbk' ELSE 'casino' END as product,
      date_trunc('hour',convert_timezone('UTC','America/New_York',a.trans_date)) as ftu_date
      FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS as a
      
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON a.acco_id = acc.id
      
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS J
      on acc.current_jurisdictions_id = j.Id
      
      where a.trans in ('STAKE', 'FREE_SPIN_STAKE', 'FREEBET_STAKE')
      and acc.test = 0
      
      QUALIFY row_number() OVER (PARTITION BY a.acco_id ORDER BY a.trans_date ASC) = 1
  )
  
  select
  ftu_date as "FTU Time(EST)",
  jurisdiction_name,
  COUNT(distinct CASE WHEN product = 'sbk' THEN acco_id ELSE NULL END) as "SBK FTUs",
  COUNT(distinct CASE WHEN product = 'casino' THEN acco_id ELSE NULL END) as "Casino FTUs",
  count(*) as "Total FTUs"
  from ftu
  group by all
  order by 1 desc
) "Custom SQL Query"
