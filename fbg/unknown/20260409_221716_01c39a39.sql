-- Query ID: 01c39a39-0212-67a8-24dd-07031941aaf3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:17:16.911000+00:00
-- Elapsed: 394ms
-- Environment: FBG

select VIP_HOST "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, VIP_HOST is null ISNULL_163 from (select VIP_HOST, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where ACCO_ID = 299144 and LOYALTY_TIER is null and LEAD_OWNER is null and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) group by VIP_HOST) Q1) Q2 order by ISNULL_163 desc, VIP_HOST asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d74522c577e679c73baa32fd1f3e9","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
