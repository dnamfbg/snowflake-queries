-- Query ID: 01c399f8-0212-644a-24dd-07031932f1db
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:12:54.070000+00:00
-- Elapsed: 82ms
-- Environment: FBG

select ACCO_ID "TopK Value", COUNT_158 "TopK Count", ISNULL_163 "TopK Null Sort" from (select *, ACCO_ID is null ISNULL_163 from (select ACCO_ID, count(1) COUNT_158 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_REPORTING where (not LEAD_OWNER in ('Taylor OBrien', 'Will Rolapp', 'Teddy Moeller', 'Pete Donahue', 'Michael Hermalyn', 'Michael Bernstein', 'Jack Shuster', 'Griffen Colton', 'Ekin VanWinkle', 'Darren OBrien', 'Admin User') or LEAD_OWNER is null) and VIP_HOST = 'Aidan Feeney' group by ACCO_ID) Q1) Q2 order by ISNULL_163 desc, ACCO_ID asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanaticsONE-Tier-Point-Tracker-34xRCyFUIYDTAc49GkmZLs","kind":"adhoc","request-id":"g019d741739867cfc873993dec5e5cf56","user-id":"6useOh6eJqLtUcfgP4w8RGGqFGcIS","email":"derek.dubose@betfanatics.com"}
