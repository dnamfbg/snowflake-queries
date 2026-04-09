-- Query ID: 01c39a3a-0212-67a8-24dd-070319424237
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:18:16.721000+00:00
-- Elapsed: 122ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, ACCO_ID is null ISNULL_163 from (select ACCO_ID, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where LOYALTY_TIER is null and LEAD_OWNER is null and (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST is null group by ACCO_ID) Q1) Q2 order by ISNULL_163 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d745316b67602a75b11ad4f852d13","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
