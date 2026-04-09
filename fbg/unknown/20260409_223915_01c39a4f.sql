-- Query ID: 01c39a4f-0212-6e7d-24dd-070319468483
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:39:15.474000+00:00
-- Elapsed: 108ms
-- Environment: FBG

select ORDER_SOURCE "TopK Value", COUNT_126 "TopK Count", ORDER_SOURCE_127 "TopK Display" from (select ORDER_SOURCE, count(1) COUNT_126, ORDER_SOURCE ORDER_SOURCE_127 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_CORE_ORDERS where not IS_TEST_ACCOUNT group by ORDER_SOURCE) Q1 order by COUNT_126 desc, ORDER_SOURCE_127 asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0","kind":"adhoc","request-id":"g019d74664ed876afbabc3ac7fcd2b260","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
