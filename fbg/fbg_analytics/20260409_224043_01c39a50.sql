-- Query ID: 01c39a50-0212-6e7d-24dd-07031946f0ef
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Last Executed: 2026-04-09T22:40:43.530000+00:00
-- Elapsed: 191772ms
-- Run Count: 7
-- Environment: FBG

SELECT 'Totals' AS "Calculation_6387019114511745027"
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
      on a.jurisdictions_id = j.Id
      
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
HAVING (COUNT(1) > 0)
