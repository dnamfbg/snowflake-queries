-- Query ID: 01c39a39-0212-6cb9-24dd-070319422167
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:17:23.076000+00:00
-- Elapsed: 76ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, ACCO_ID is null ISNULL_163 from (select ACCO_ID, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where LOYALTY_TIER is null and LEAD_OWNER is null and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) group by ACCO_ID) Q1) Q2 order by ISNULL_163 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d745244ea76d4ae4fba4eb1e8839e","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
