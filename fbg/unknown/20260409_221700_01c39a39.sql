-- Query ID: 01c39a39-0212-67a9-24dd-070319420637
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:17:00.992000+00:00
-- Elapsed: 554ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort", CAST_164 "Text Seach Column" from (select *, ACCO_ID is null ISNULL_163, ACCO_ID::text CAST_164 from (select ACCO_ID, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST = 'Aidan Feeney' and contains(lower(ACCO_ID::text), lower('299144')) group by ACCO_ID) Q1) Q2 order by ISNULL_163 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d7451ed0671359c0748fadfbfd8ad","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
