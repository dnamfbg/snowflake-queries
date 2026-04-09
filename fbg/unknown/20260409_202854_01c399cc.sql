-- Query ID: 01c399cc-0212-6cb9-24dd-07031928e9b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:28:54.406000+00:00
-- Elapsed: 254ms
-- Environment: FBG

select SPORT_CATEGORY_18 "Sport Category", LEAGUE_19 "League", SUM_18 "Kalshi Buy Volume", DIV_20 "% From Total", MUL_22 "Volume at Target Market Share" from (select Q1.SPORT_CATEGORY_18, Q1.LEAGUE_19, Q1.SUM_17 / nullif(Q2.SUM_14, 0) DIV_20, Q1.SUM_17 SUM_18, Q1.SUM_17 * 0.01 MUL_22 from (select sum(iff(GAP_TYPE = 'BREADTH', KALSHI_VOLUME_USD, null)) SUM_17, SPORT_CATEGORY SPORT_CATEGORY_18, LEAGUE LEAGUE_19 from FMX_ANALYTICS.CUSTOMER.FCT_COMPETITIVE_EXCHANGE_MAPPING where ACTIVITY_DATE >= to_date('2026-03-10', 'YYYY-MM-DD') and ACTIVITY_DATE <= to_date('2026-04-08', 'YYYY-MM-DD') group by SPORT_CATEGORY, LEAGUE having SUM_17 is not null) Q1 cross join (select sum(KALSHI_VOLUME_USD) SUM_14 from FMX_ANALYTICS.CUSTOMER.FCT_COMPETITIVE_EXCHANGE_MAPPING where ACTIVITY_DATE >= to_date('2026-03-10', 'YYYY-MM-DD') and ACTIVITY_DATE <= to_date('2026-04-08', 'YYYY-MM-DD')) Q2) Q4 order by SUM_18 desc nulls last, SPORT_CATEGORY_18 asc, LEAGUE_19 asc limit 218401

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=4bQB2Tsijc","kind":"adhoc","request-id":"g019d73eef7877cf4a0531cecafffaa5a","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
