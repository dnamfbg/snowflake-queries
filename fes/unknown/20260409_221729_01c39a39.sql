-- Query ID: 01c39a39-0112-6b51-0000-e307218d4186
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:17:29.509000+00:00
-- Elapsed: 1006ms
-- Environment: FES

select CAST_9 "Date", PLACEMENT_LABEL "Placement Label", MEDIA_SPEND "Media Spend", TOTAL_INSTALLS "Total Installs", TOTAL_INSTALLS_OSB_STATE "Total Installs Osb State", LOGGED_IN_INSTALLS "Logged in Installs", TOTAL_LOGGED_IN_INSTALLS_OSB_STATE "Total Logged in Installs Osb State", LOGGED_IN_INSTALLS_NEW_TO_ECOSYSTEM "Logged in Installs New to Ecosystem", LOGGED_IN_INSTALLS_NEW_TO_OPCO "Logged in Installs New to Opco", DATETRUNC_11 "Switch Date", V_10 "Switch Grouping" from (select PLACEMENT_LABEL, MEDIA_SPEND, TOTAL_INSTALLS, TOTAL_INSTALLS_OSB_STATE, LOGGED_IN_INSTALLS, TOTAL_LOGGED_IN_INSTALLS_OSB_STATE, LOGGED_IN_INSTALLS_NEW_TO_ECOSYSTEM, LOGGED_IN_INSTALLS_NEW_TO_OPCO, "DATE"::timestamp_ltz CAST_9, 'Incomplete formula.' V_10, date_trunc(year, CAST_9) DATETRUNC_11 from FES_USERS.SANDBOX.FANAPP_PAID_SPEND where "DATE" >= to_date('2025-01-01', 'YYYY-MM-DD') and "DATE" <= to_date('2026-12-31', 'YYYY-MM-DD')) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=JrSdaU0URS","kind":"adhoc","request-id":"g019d745251d07e3980de0995ff267675.2","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
