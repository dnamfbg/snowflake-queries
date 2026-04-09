-- Query ID: 01c399cd-0212-6cb9-24dd-07031928eb5b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:29:11.070000+00:00
-- Elapsed: 232ms
-- Environment: FBG

select DATETRUNC_124 "Time Period", COUNTDISTINCT_125 "FTUs", LAG_126 "FTUs Previos Period" from (select DATETRUNC_124, COUNTDISTINCT_125, lag(COUNTDISTINCT_125, 1) over ( order by DATETRUNC_124 asc) LAG_126 from (select date_trunc(day, CAST_114) DATETRUNC_124, count(distinct ACCOUNT_ID) COUNTDISTINCT_125 from (select ACCOUNT_ID, IS_TEST_ACCOUNT, REGISTRATION_STATE, IS_FIRST_COMPLETED_TRADE, ORDER_CREATED_AT_ALK::timestamp_ltz CAST_114 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT and (not IS_TEST_ACCOUNT and REGISTRATION_STATE in ('CA', 'FL', 'TX', 'TN', 'NY', 'NC', 'GA', 'PA', 'MI', 'AZ', 'LA', 'NJ', 'WA', 'IL', 'CO', 'MA', 'SC', 'WI', 'AL', 'OH', 'MN', 'VA', 'UT', 'MS', 'MD', 'DE', 'MO', 'IA', 'IN', 'CT', 'OK', 'OR', 'NH', 'WV', 'ID', 'KS', 'RI', 'NM', 'HI', 'NE', 'WY', 'ME', 'KY', 'ND', 'SD', 'AR', 'AK', 'PR', 'NV', 'VT', 'DC', 'MT', 'GU', 'VI') and (IS_FIRST_COMPLETED_TRADE or IS_FIRST_COMPLETED_TRADE is null) and CAST_114 >= to_timestamp_ltz('2026-03-10T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and CAST_114 <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) and date_trunc(day, CAST_114) is not null) Q1 group by DATETRUNC_124) Q2) Q3 order by DATETRUNC_124 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=TCUlZow3V-","kind":"adhoc","request-id":"g019d73ef38ad780daa5f56440f34ab2a","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
