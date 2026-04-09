-- Query ID: 01c39a35-0112-6806-0000-e307218c9fca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:13:53.402000+00:00
-- Elapsed: 1191ms
-- Environment: FES

select CAST_10 "Date", PLACEMENT_LABEL "Placement Label", SOURCE_LABEL_OTHER "Source Label Other", MEDIA_SPEND "Media Spend", TOTAL_INSTALLS "Total Installs", TOTAL_INSTALLS_OSB_STATE "Total Installs Osb State", LOGGED_IN_INSTALLS "Logged in Installs", TOTAL_LOGGED_IN_INSTALLS_OSB_STATE "Total Logged in Installs Osb State", LOGGED_IN_INSTALLS_NEW_TO_ECOSYSTEM "Logged in Installs New to Ecosystem", LOGGED_IN_INSTALLS_NEW_TO_OPCO "Logged in Installs New to Opco", DATETRUNC_12 "Switch Date", PLACEMENT_LABEL_11 "Switch Grouping" from (select PLACEMENT_LABEL, SOURCE_LABEL_OTHER, MEDIA_SPEND, TOTAL_INSTALLS, TOTAL_INSTALLS_OSB_STATE, LOGGED_IN_INSTALLS, TOTAL_LOGGED_IN_INSTALLS_OSB_STATE, LOGGED_IN_INSTALLS_NEW_TO_ECOSYSTEM, LOGGED_IN_INSTALLS_NEW_TO_OPCO, "DATE"::timestamp_ltz CAST_10, PLACEMENT_LABEL PLACEMENT_LABEL_11, date_trunc(year, CAST_10) DATETRUNC_12 from FES_USERS.ROHAN_GULATI.DBFORK_____FES_USERS__ROHAN_GULATI__FANAPP_PAID_SPEND where SOURCE_LABEL_OTHER = 'Paid' and "DATE" >= to_date('2025-01-01', 'YYYY-MM-DD') and "DATE" <= to_date('2026-12-31', 'YYYY-MM-DD')) Q1 limit 84501

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Paid-Marketing-4WKq59tTLLZFhq9BkSRcQr?:displayNodeId=JrSdaU0URS","kind":"adhoc","request-id":"g019d744f15cd75bba74309b710d09a8a","user-id":"zCXCAe92hSiEIq8F2LowKaBSAkku9","email":"rohan.gulati@betfanatics.com"}
