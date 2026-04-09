-- Query ID: 01c39a3a-0212-6dbe-24dd-0703194235c3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:18:50.214000+00:00
-- Elapsed: 65ms
-- Environment: FBG

with W1 as (select Q2.WEEK_NUM, count(Q3."DATE") COUNT_64 from (select WEEK_NUM from (select WEEK_NUM, row_number() over (partition by WEEK_NUM order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join (select NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_58 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q4 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q4.CAST_58 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q4.EHOLD_BUCKET) Q3 on Q2.WEEK_NUM = Q3."DATE" group by Q2.WEEK_NUM) select COUNT_71 "Count of Week Num", SUM_72 "CountIf of Calc", SUM_73 "CountIf of Calc (1)", SUM_74 "CountIf of Calc (2)", WEEK_NUM "Week Num", GT_65 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_66 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q10.WEEK_NUM, Q10.GT_65, Q10.EQ_66, Q12.COUNT_71, Q12.SUM_72, Q12.SUM_73, Q12.SUM_74 from (select WEEK_NUM, COUNT_64 > 1 GT_65, COUNT_64 = 0 EQ_66 from (select * from W1 Q8 order by WEEK_NUM asc limit 10001) Q9) Q10 cross join (select count(WEEK_NUM) COUNT_71, sum(iff(COUNT_64 = 0, 1, 0)) SUM_72, sum(iff(COUNT_64 = 1, 1, 0)) SUM_73, sum(iff(COUNT_64 > 1, 1, 0)) SUM_74 from W1 Q11) Q12) Q14 order by WEEK_NUM asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=81mI0oD3dy","kind":"adhoc","request-id":"g019d74539d1d7618b528e9cd1d715f78","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
