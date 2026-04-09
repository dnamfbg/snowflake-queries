-- Query ID: 01c39a50-0212-67a8-24dd-070319469f33
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:40:38.512000+00:00
-- Elapsed: 232ms
-- Environment: FBG

select IS_VIP_ACCOUNT "TopK Value", COUNT_124 "TopK Count" from (select IS_VIP_ACCOUNT, count(1) COUNT_124 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT group by IS_VIP_ACCOUNT) Q1 order by COUNT_124 desc, IS_VIP_ACCOUNT asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0","kind":"adhoc","request-id":"g019d746791157b02b3935c7f911fb24b","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
