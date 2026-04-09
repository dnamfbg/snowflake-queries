-- Query ID: 01c399cc-0212-6cb9-24dd-07031928e923
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:28:49.412000+00:00
-- Elapsed: 1212ms
-- Environment: FBG

select DATETRUNC_42 "Time Period", COUNTDISTINCT_44 "Open Markets", LAG_58 "Period Before of Open Markets", DIV_53 "Dormant Markets", LAG_59 "Period Before of Innactive Markets", DIV_54 "Innactive Markets", LAG_60 "Period Before of Innactive Markets (1)", DIV_55 "Unhealthy Markets", LAG_61 "Period Before of Unhealthy Markets", DIV_56 "Healthy Markets", LAG_62 "Period Before of Healthy Markets" from (select DATETRUNC_42, COUNTDISTINCT_44, COUNTDISTINCT_45 / nullif(COUNTDISTINCT_44, 0) DIV_53, COUNTDISTINCT_46 / nullif(COUNTDISTINCT_44, 0) DIV_54, COUNTDISTINCT_47 / nullif(COUNTDISTINCT_44, 0) DIV_55, COUNTDISTINCT_48 / nullif(COUNTDISTINCT_44, 0) DIV_56, lag(COUNTDISTINCT_44, 1) over ( order by DATETRUNC_42 asc) LAG_58, lag(DIV_53, 1) over ( order by DATETRUNC_42 asc) LAG_59, lag(DIV_54, 1) over ( order by DATETRUNC_42 asc) LAG_60, lag(DIV_55, 1) over ( order by DATETRUNC_42 asc) LAG_61, lag(DIV_56, 1) over ( order by DATETRUNC_42 asc) LAG_62 from (select date_trunc(day, ACTIVITY_DATE_ALK::timestamp_ltz) DATETRUNC_42, count(distinct SYMBOL) COUNTDISTINCT_44, count(distinct iff(HEALTH_STATUS = 'DORMANT', SYMBOL, null)) COUNTDISTINCT_45, count(distinct iff(HEALTH_STATUS = 'UNTRADED', SYMBOL, null)) COUNTDISTINCT_46, count(distinct iff(HEALTH_STATUS = 'UNHEALTHY', SYMBOL, null)) COUNTDISTINCT_47, count(distinct iff(HEALTH_STATUS = 'HEALTHY', SYMBOL, null)) COUNTDISTINCT_48 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CRYPTO_MARKET_STATS_DAILY where date_trunc(day, ACTIVITY_DATE_ALK::timestamp_ltz) is not null group by DATETRUNC_42) Q1) Q2 order by DATETRUNC_42 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=o7lNVpP28T","kind":"adhoc","request-id":"g019d73eee40c73c5adef1e3db42c442d","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
