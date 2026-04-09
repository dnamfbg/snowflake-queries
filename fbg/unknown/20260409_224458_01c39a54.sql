-- Query ID: 01c39a54-0212-67a8-24dd-07031947d057
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:44:58.871000+00:00
-- Elapsed: 954ms
-- Environment: FBG

select "TYPE", DATETRUNC_4 "Earn Month", SUM_5 "Total Earned" from (select "TYPE", date_trunc(day, EARN_MONTH::timestamp_ltz) DATETRUNC_4, sum(TOTAL_EARNED) SUM_5 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FINANCE_FC_EARN_BY_TYPE where date_trunc(day, EARN_MONTH::timestamp_ltz) >= to_timestamp_ltz('2025-05-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, EARN_MONTH::timestamp_ltz) <= to_timestamp_ltz('2026-04-30T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by "TYPE", DATETRUNC_4) Q1 order by "TYPE" asc, DATETRUNC_4 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Finance-Model-Export-Tool-5XYjEL60JysSIUGpTBDi9X?:displayNodeId=eA6CqN7dN5","kind":"adhoc","request-id":"g019d746b881e7403b179dbe186ff9fc5","user-id":"U2RvjAkSbmS8niZ4E9SE71lO95k1A","email":"jordan.pluchar@betfanatics.com"}
