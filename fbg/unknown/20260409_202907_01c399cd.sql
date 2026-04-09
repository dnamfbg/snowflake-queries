-- Query ID: 01c399cd-0212-6dbe-24dd-07031928f783
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:29:07.985000+00:00
-- Elapsed: 550ms
-- Environment: FBG

select DATETRUNC_80 "Time Period", DIV_84 "Registration to Trade CVR", LAG_85 "Registration to Trade CVR Previous Period" from (select DATETRUNC_80, SUM_81 / nullif(COUNT_82, 0) DIV_84, lag(DIV_84, 1) over ( order by DATETRUNC_80 asc) LAG_85 from (select date_trunc(day, REGISTRATION_DATE_ALK::timestamp_ltz) DATETRUNC_80, sum(iff(datediff(day, REGISTRATION_DATE_ALK::timestamp_ltz, FIRST_COMPLETED_ORDER_CREATED_AT_ALK::timestamp_ltz) <= 1, HAS_COMPLETED_ORDER, null)) SUM_81, count(ACCO_ID) COUNT_82 from FMX_ANALYTICS.CUSTOMER.DIM_FMX_CORE_CUSTOMER where REGISTRATION_DATE_ALK >= to_timestamp_ntz('2026-03-10 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and REGISTRATION_DATE_ALK <= to_timestamp_ntz('2026-04-08 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and date_trunc(day, REGISTRATION_DATE_ALK::timestamp_ltz) is not null group by DATETRUNC_80) Q1) Q2 order by DATETRUNC_80 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=92bmMLrY-K","kind":"adhoc","request-id":"g019d73ef2ca77e998c34eefdb7f1a6f2","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
