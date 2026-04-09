-- Query ID: 01c39a29-0212-6dbe-24dd-0703193e2877
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:01:37.040000+00:00
-- Elapsed: 904ms
-- Environment: FBG

select PROMO_GROUP "TopK Value", COUNT_82 "TopK Count", ISNULL_87 "TopK Null Sort" from (select *, PROMO_GROUP is null ISNULL_87 from (select PROMO_GROUP, count(1) COUNT_82 from FBG_ANALYTICS_DEV.GHIBRIAN_AVILA.OFFER_USAGE where iff(dayofweekiso(DT::timestamp_ltz) % 7 + 1 > 1, dateadd(day, 1, dateadd('day', -1, date_trunc(week, dateadd('day', 1, DT::timestamp_ltz)))), dateadd(day, -6, dateadd('day', -1, date_trunc(week, dateadd('day', 1, DT::timestamp_ltz))))) >= to_timestamp_ltz('2026-03-16T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and iff(dayofweekiso(DT::timestamp_ltz) % 7 + 1 > 1, dateadd(day, 1, dateadd('day', -1, date_trunc(week, dateadd('day', 1, DT::timestamp_ltz)))), dateadd(day, -6, dateadd('day', -1, date_trunc(week, dateadd('day', 1, DT::timestamp_ltz))))) <= to_timestamp_ltz('2026-04-12T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by PROMO_GROUP) Q1) Q2 order by ISNULL_87 desc, COUNT_82 desc, PROMO_GROUP asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/EL-Investment-Cl7xQmMRFAhrYMdKDR3bA","kind":"adhoc","request-id":"g019d7443d98875dbbd532d1231347522","user-id":"GocIzjpNR3hAS4lJ5esTmcagxPBmf","email":"ghibrian.avila@betfanatics.com"}
