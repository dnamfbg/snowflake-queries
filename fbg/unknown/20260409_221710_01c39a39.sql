-- Query ID: 01c39a39-0212-6cb9-24dd-070319422067
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:17:10.894000+00:00
-- Elapsed: 124ms
-- Environment: FBG

select LEAD_OWNER "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, LEAD_OWNER is null ISNULL_163 from (select LEAD_OWNER, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where ACCO_ID = 299144 and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST = 'Aidan Feeney' group by LEAD_OWNER) Q1) Q2 order by ISNULL_163 desc, LEAD_OWNER asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d745212847e9cbafe426f8cee2a98","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
