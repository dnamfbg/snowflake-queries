-- Query ID: 01c39a03-0212-644a-24dd-07031935645f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:23:57.979000+00:00
-- Elapsed: 60ms
-- Environment: FBG

with W1 as (select Q3.OSB_SEGMENT, Q3.CAST_57, count(try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE")) COUNT_61 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select OSB_SEGMENT, CAST_57 from (select OSB_SEGMENT, BUS_DATE::timestamp_ltz CAST_57, row_number() over (partition by CAST_57, OSB_SEGMENT order by '' asc) ROWNUMBER_60 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MTD_PL_DS qualify ROWNUMBER_60 = 1) Q2) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE") = Q3.CAST_57 and NEW_SEGMENTS_DAILY_FORECAST.USER_SEGMENT = Q3.OSB_SEGMENT group by Q3.CAST_57, Q3.OSB_SEGMENT) select COUNT_68 "Count of Bus Date", SUM_69 "CountIf of Calc", SUM_70 "CountIf of Calc (1)", SUM_71 "CountIf of Calc (2)", CAST_57 "Bus Date", OSB_SEGMENT "Osb Segment", GT_62 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_63 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.OSB_SEGMENT, Q7.CAST_57, Q7.GT_62, Q7.EQ_63, Q9.COUNT_68, Q9.SUM_69, Q9.SUM_70, Q9.SUM_71 from (select OSB_SEGMENT, CAST_57, COUNT_61 > 1 GT_62, COUNT_61 = 0 EQ_63 from (select * from W1 Q5 order by CAST_57 asc, OSB_SEGMENT asc limit 10001) Q6) Q7 cross join (select count(CAST_57) COUNT_68, sum(iff(COUNT_61 = 0, 1, 0)) SUM_69, sum(iff(COUNT_61 = 1, 1, 0)) SUM_70, sum(iff(COUNT_61 > 1, 1, 0)) SUM_71 from W1 Q8) Q9) Q11 order by CAST_57 asc, OSB_SEGMENT asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=PYX5Zu9_P6","kind":"adhoc","request-id":"g019d742160d77b5da72c8458a7b90553","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
