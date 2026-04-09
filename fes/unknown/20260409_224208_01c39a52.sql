-- Query ID: 01c39a52-0112-6bf9-0000-e307218da04a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:42:08.406000+00:00
-- Elapsed: 9657ms
-- Environment: FES

select AUDIENCE_NAME_23 "Audience Name", COUNTDISTINCT_22 "CountDistinct of Fangraph Id", V_18 "Snapshotted At", V_3 "Gender", V_4 "Age", V_5 "Age Bucket", V_6 "Income Hh", V_7 "Is Age 18 20", V_8 "Is Age 21 30", V_9 "Is Age 31 40", V_10 "Is Age 41 50", V_11 "Is Age 51 60", V_12 "Is Age 61 70", V_13 "Is Age 71 80", V_14 "Is Age 80 Plus", V_15 "Is Male", V_16 "Is Female", V_17 "Has Income Data", FANGRAPH_ID "Fangraph Id" from (select null::text FANGRAPH_ID, null::text V_3, null::bigint V_4, null::text V_5, null::text V_6, V_4 V_7, V_4 V_8, V_4 V_9, V_4 V_10, V_4 V_11, V_4 V_12, V_4 V_13, V_4 V_14, V_4 V_15, V_4 V_16, V_4 V_17, null::timestamp_ltz V_18, count(distinct FANGRAPH_ID) COUNTDISTINCT_22, AUDIENCE_NAME AUDIENCE_NAME_23 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS where AUDIENCE_NAME = 'Total Fans' group by AUDIENCE_NAME) Q1 order by AUDIENCE_NAME_23 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-14te0ej1HkDLM5uHJU5Dzw?:displayNodeId=OqGa5W5CVc","kind":"adhoc","request-id":"g019d7468f1f97cd485f4856de3561deb","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
