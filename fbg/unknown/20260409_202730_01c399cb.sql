-- Query ID: 01c399cb-0212-6e7d-24dd-07031928c543
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:27:30.160000+00:00
-- Elapsed: 877ms
-- Environment: FBG

select BONUS_CAMPAIGN_ID "TopK Value", COUNT_82 "TopK Count", ISNULL_87 "TopK Null Sort" from (select *, BONUS_CAMPAIGN_ID is null ISNULL_87 from (select BONUS_CAMPAIGN_ID, count(1) COUNT_82 from FBG_ANALYTICS.CASINO.REPORTING_RTC_PROMO_COSTS where CASINO_SUPER_VIP = 0 and TRANSACTION_DATE >= to_date('2026-04-01', 'YYYY-MM-DD') and TRANSACTION_DATE <= to_date('2026-04-30', 'YYYY-MM-DD') and PROMO_GROUP is null group by BONUS_CAMPAIGN_ID) Q1) Q2 order by ISNULL_87 desc, COUNT_82 desc, BONUS_CAMPAIGN_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Casino-RTC-and-Promo-Cost-1FEMf1IJrRNC8f9cKLS2ZS","kind":"adhoc","request-id":"g019d73edaef07922866c54d598467c36","user-id":"KKDGDtQrKFI0Z3ZyUgNTC4Pa8D0Vc","email":"stephen.waters@betfanatics.com"}
