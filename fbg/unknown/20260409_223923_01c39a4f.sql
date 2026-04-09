-- Query ID: 01c39a4f-0212-6e7d-24dd-0703194685c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:39:23.565000+00:00
-- Elapsed: 136ms
-- Environment: FBG

select IS_VIP_ACCOUNT "TopK Value", COUNT_126 "TopK Count" from (select IS_VIP_ACCOUNT, count(1) COUNT_126 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT group by IS_VIP_ACCOUNT) Q1 order by COUNT_126 desc, IS_VIP_ACCOUNT asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0","kind":"adhoc","request-id":"g019d74666e79701cac112ec5b47cc14f","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
