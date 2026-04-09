-- Query ID: 01c399e8-0212-644a-24dd-0703192e9653
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:56:01.940000+00:00
-- Elapsed: 118ms
-- Environment: FBG

select SUM_18 "FTUs (Grand Total)", SUM_19 "Qualified Players (Grand Total)", SUM_20 "Commissions (Grand Total)", DATETRUNC_11 "Date", CAMPAIGN "Campaign", "STATE" "State", SUM_13 "FTUs", SUM_14 "Qualified Players", SUM_12 "Commissions" from (select Q1."STATE", Q1.CAMPAIGN, Q1.DATETRUNC_11, Q1.SUM_12, Q1.SUM_13, Q1.SUM_14, Q2.SUM_18, Q2.SUM_19, Q2.SUM_20 from (select "STATE", CAMPAIGN, date_trunc(day, "DATE"::timestamp_ltz) DATETRUNC_11, sum(TOTAL_CAC) SUM_12, sum(FTUS) SUM_13, sum(QUALIFIED_PLAYERS) SUM_14 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.AFFILIATE_CATENA where date_trunc(day, "DATE"::timestamp_ltz) >= to_timestamp_ltz('2026-04-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, "DATE"::timestamp_ltz) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_11, CAMPAIGN, "STATE" order by DATETRUNC_11 asc, CAMPAIGN asc, "STATE" asc limit 10001) Q1 cross join (select sum(FTUS) SUM_18, sum(QUALIFIED_PLAYERS) SUM_19, sum(TOTAL_CAC) SUM_20 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.AFFILIATE_CATENA where date_trunc(day, "DATE"::timestamp_ltz) >= to_timestamp_ltz('2026-04-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, "DATE"::timestamp_ltz) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q2) Q4 order by DATETRUNC_11 asc, CAMPAIGN asc, "STATE" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affiliate-Performance-Catena-2Qxa4pGIilLltwDiX1ZMMw?:displayNodeId=Mywu4gt6hh","kind":"adhoc","request-id":"g019d7407cdac7fa9bed201ec45d23d4f","user-id":"QGaYewFds19HGgeD8Q6yk0KmPmiWD","email":"jackie.radin@betfanatics.com"}
