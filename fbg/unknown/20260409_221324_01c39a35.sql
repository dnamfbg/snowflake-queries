-- Query ID: 01c39a35-0212-6cb9-24dd-0703194106bb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:13:24.017000+00:00
-- Elapsed: 53ms
-- Environment: FBG

select MAX_156 "Last Updated" from (select max(LAST_UPDATED::timestamp_ltz) MAX_156 from FBG_ANALYTICS.TRADING.USER_AGGREGATED_REPORT_DATASOURCE) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp?:displayNodeId=A7DA-TnZ9f","kind":"adhoc","request-id":"g019d744ea25a7b578cddc632bd58ca64","user-id":"ZF390mND5StXOsyQkAEUqG8havXDi","email":"andy.morrissey@betfanatics.com"}
