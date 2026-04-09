-- Query ID: 01c39a30-0112-6544-0000-e307218cc24a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:08:41.971000+00:00
-- Elapsed: 1378ms
-- Environment: FES

select FANGRAPH_ID "Fangraph Id", AUDIENCE_NAME "Audience Name", CAST_18 "Snapshotted At", GENDER "Gender", AGE "Age", AGE_BUCKET "Age Bucket", INCOME_HH "Income Hh", IS_AGE_18_20 "Is Age 18 20", IS_AGE_21_30 "Is Age 21 30", IS_AGE_31_40 "Is Age 31 40", IS_AGE_41_50 "Is Age 41 50", IS_AGE_51_60 "Is Age 51 60", IS_AGE_61_70 "Is Age 61 70", IS_AGE_71_80 "Is Age 71 80", IS_AGE_80_PLUS "Is Age 80 Plus", IS_MALE "Is Male", IS_FEMALE "Is Female", HAS_INCOME_DATA "Has Income Data" from (select FANGRAPH_ID, AUDIENCE_NAME, GENDER, AGE, AGE_BUCKET, INCOME_HH, IS_AGE_18_20, IS_AGE_21_30, IS_AGE_31_40, IS_AGE_41_50, IS_AGE_51_60, IS_AGE_61_70, IS_AGE_71_80, IS_AGE_80_PLUS, IS_MALE, IS_FEMALE, HAS_INCOME_DATA, SNAPSHOTTED_AT::timestamp_ltz CAST_18 from FES_USERS.TYLER_KUNKEL.GROWTH_LOOP_AUDIENCE_INSIGHTS) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/t/GROWTH_LOOP_AUDIENCE_INSIGHTS-1vZGmINubjCpW53I6n9riU","kind":"adhoc","request-id":"g019d744a53d27efb9117e04bd31a33c4","user-id":"WhAsQqz2m2JgjN7yvMils0xHXidF4","email":"tkunkel@fanaticsinc.com"}
