-- Query ID: 01c399cd-0212-644a-24dd-07031928bd3b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:29:10.601000+00:00
-- Elapsed: 489ms
-- Environment: FBG

select DATETRUNC_24 "Time Period", DIV_27 "KYC Success Rate", LAG_28 "KYC Success Rate Previous Period" from (select DATETRUNC_24, SUM_25 / nullif(COUNT_26, 0) DIV_27, lag(DIV_27, 1) over ( order by DATETRUNC_24 asc) LAG_28 from (select date_trunc(day, CREATED_AT_ALK::timestamp_ltz) DATETRUNC_24, sum(iff(DECISION = 'VERIFIED', 1, 0)) SUM_25, count(1) COUNT_26 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_KYC_RESULTS where REGISTRATION_STATE in ('CA', 'FL', 'TX', 'TN', 'NY', 'NC', 'GA', 'PA', 'MI', 'AZ', 'LA', 'NJ', 'WA', 'IL', 'CO', 'MA', 'SC', 'WI', 'AL', 'OH', 'MN', 'VA', 'UT', 'MS', 'MD', 'DE', 'MO', 'IA', 'IN', 'CT', 'OK', 'OR', 'NH', 'WV', 'ID', 'KS', 'RI', 'NM', 'HI', 'NE', 'WY', 'ME', 'KY', 'ND', 'SD', 'AR', 'AK', 'PR', 'NV', 'VT', 'DC', 'MT', 'GU', 'VI') and CREATED_AT_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and CREATED_AT_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, CREATED_AT_ALK::timestamp_ltz) is not null group by DATETRUNC_24) Q1) Q2 order by DATETRUNC_24 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=Ikz1TJ-8_s","kind":"adhoc","request-id":"g019d73ef36d7711bb70fdabde6c28ac1","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
