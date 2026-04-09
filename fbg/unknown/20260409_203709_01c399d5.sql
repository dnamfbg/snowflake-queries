-- Query ID: 01c399d5-0212-6b00-24dd-0703192ad1df
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:37:09.356000+00:00
-- Elapsed: 36065ms
-- Environment: FBG

select CAST_11 "Gaming Day", CATEGORY "Category", "Free Bets Wagered (Retail)" "Free Bets Wagered Retail", "Total Payments (Retail)" "Total Payments Retail", "Total Wagers Accepted (Retail)" "Total Wagers Accepted Retail" from (select distinct CATEGORY, "Total Wagers Accepted (Retail)", "Free Bets Wagered (Retail)", "Total Payments (Retail)", "Gaming Day"::timestamp_ltz CAST_11 from FBG_REPORTS.REGULATORY.KY_DETAILED_DAILY where "Gaming Day" >= to_date('2026-04-01', 'YYYY-MM-DD') and "Gaming Day" <= to_date('2026-04-01', 'YYYY-MM-DD')) Q1 order by CAST_11 asc, CATEGORY asc, "Free Bets Wagered (Retail)" asc, "Total Payments (Retail)" asc, "Total Wagers Accepted (Retail)" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/KY-Regulatory-Reporting-4gfQzcSoWlzRxtgGMSuZ8q?:displayNodeId=dQaAZDgqSR","kind":"adhoc","request-id":"g019d73f684367b45b0a914e43c834e20","user-id":"DPKxzyCylYg9tiUNxNygASY92VR1B","email":"john.zhu@betfanatics.com"}
