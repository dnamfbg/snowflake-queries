-- Query ID: 01c39a3a-0212-644a-24dd-070319426147
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:18:13.098000+00:00
-- Elapsed: 408ms
-- Environment: FBG

select LEAD_OWNER "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, LEAD_OWNER is null ISNULL_163 from (select LEAD_OWNER, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where ACCO_ID = 299144 and LOYALTY_TIER is null and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST is null group by LEAD_OWNER) Q1) Q2 order by ISNULL_163 desc, LEAD_OWNER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d745308767c58935a3a25bc3f96ab","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
