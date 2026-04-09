-- Query ID: 01c39a10-0212-6cb9-24dd-07031938934f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:36:02.206000+00:00
-- Elapsed: 94ms
-- Environment: FBG

with W1 as (select Q3.OSB_SEGMENT, Q3.CAST_48, count(try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE")) COUNT_55 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select OSB_SEGMENT, CAST_48 from (select OSB_SEGMENT, BUS_DATE::timestamp_ltz CAST_48, row_number() over (partition by CAST_48, OSB_SEGMENT order by '' asc) ROWNUMBER_54 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_DAILY_DS qualify ROWNUMBER_54 = 1) Q2) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE") = Q3.CAST_48 and NEW_SEGMENTS_DAILY_FORECAST.USER_SEGMENT = Q3.OSB_SEGMENT group by Q3.CAST_48, Q3.OSB_SEGMENT) select COUNT_62 "Count of Bus Date", SUM_63 "CountIf of Calc", SUM_64 "CountIf of Calc (1)", SUM_65 "CountIf of Calc (2)", CAST_48 "Bus Date", OSB_SEGMENT "OSB_SEGMENT (Custom SQL Query1)", GT_56 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_57 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.OSB_SEGMENT, Q7.CAST_48, Q7.GT_56, Q7.EQ_57, Q9.COUNT_62, Q9.SUM_63, Q9.SUM_64, Q9.SUM_65 from (select OSB_SEGMENT, CAST_48, COUNT_55 > 1 GT_56, COUNT_55 = 0 EQ_57 from (select * from W1 Q5 order by CAST_48 asc, OSB_SEGMENT asc limit 10001) Q6) Q7 cross join (select count(CAST_48) COUNT_62, sum(iff(COUNT_55 = 0, 1, 0)) SUM_63, sum(iff(COUNT_55 = 1, 1, 0)) SUM_64, sum(iff(COUNT_55 > 1, 1, 0)) SUM_65 from W1 Q8) Q9) Q11 order by CAST_48 asc, OSB_SEGMENT asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=eV_wZwVa6s","kind":"adhoc","request-id":"g019d742c6c7b724e82f9d6577aefcab1","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
