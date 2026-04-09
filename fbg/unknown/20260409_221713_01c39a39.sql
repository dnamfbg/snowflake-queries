-- Query ID: 01c39a39-0212-6cb9-24dd-0703194220a7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:17:13.895000+00:00
-- Elapsed: 240ms
-- Environment: FBG

select LOYALTY_TIER "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, LOYALTY_TIER is null ISNULL_163 from (select LOYALTY_TIER, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where ACCO_ID = 299144 and LEAD_OWNER is null and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST = 'Aidan Feeney' group by LOYALTY_TIER) Q1) Q2 order by ISNULL_163 desc, LOYALTY_TIER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d74521f6e7d1ea923335c3c91af8d","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
