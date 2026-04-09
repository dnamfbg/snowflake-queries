-- Query ID: 01c39a4f-0212-67a8-24dd-07031946965b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:39:39.208000+00:00
-- Elapsed: 174ms
-- Environment: FBG

select DATETRUNC_126 "Time Period Filter", COUNTDISTINCT_127 "# Actives", LAG_128 "# Actives period before" from (select DATETRUNC_126, COUNTDISTINCT_127, lag(COUNTDISTINCT_127, 1) over ( order by DATETRUNC_126 asc) LAG_128 from (select date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) DATETRUNC_126, count(distinct iff(ORDER_STATUS = 'COMPLETED', ACCOUNT_ID, null)) COUNTDISTINCT_127 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and IS_FIRST_ATTEMPTED_TRADE is not null and (ORDER_SOURCE = 'MOBILE' or ORDER_SOURCE is null) and TRADE_ACTION in ('BUY', 'SELL') and ORDER_STATE_CODE in ('CA', 'TX', 'FL', 'GA', 'WA', 'WI', 'SC', 'AL', 'MN', 'MS', 'ID', 'OK', 'UT', 'OR', 'NE', 'HI', 'DE', 'RI', 'NH', 'NM', 'ME', 'SD', 'ND', 'AK', 'PR', 'VI') and MARKETS_GROUPING in ('CBB', 'NBA', 'NFL', 'NHL', 'SOCCER', 'CFB', 'TENNIS', 'MMA', 'WBC', 'GOLF', 'WOLY', 'CRYPT', 'CULTURE', 'ELECTIONS', 'FLAGFB', 'F1', 'ECONOMY', 'BOXING', 'MLB', 'COMPANIES', 'NSCAR', 'CWBB', 'CLIM') and (ORDER_CREATED_AT_ALK >= to_timestamp_ntz('2026-04-08 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and ORDER_CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') or ORDER_CREATED_AT_ALK is null) and date_trunc(day, ORDER_CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_126) Q1) Q2 order by DATETRUNC_126 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=olX7ZmOeNG","kind":"adhoc","request-id":"g019d7466a9997d25ac7342c1b0435cc9","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
