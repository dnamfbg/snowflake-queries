-- Query ID: 01c39a07-0212-6b00-24dd-07031935db83
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:27:06.308000+00:00
-- Elapsed: 125ms
-- Environment: FBG

with W1 as (select Q2."DATE", Q2.USER_SEGMENT, count(Q3."DATE") COUNT_64 from (select "DATE", USER_SEGMENT from (select "DATE", USER_SEGMENT, row_number() over (partition by "DATE", USER_SEGMENT order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join (select NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_58 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q4 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q4.CAST_58 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q4.EHOLD_BUCKET) Q3 on Q2."DATE" = Q3."DATE" and Q2.USER_SEGMENT = Q3."DATE" group by Q2."DATE", Q2.USER_SEGMENT) select COUNT_71 "Count of Date", SUM_72 "CountIf of Calc", SUM_73 "CountIf of Calc (1)", SUM_74 "CountIf of Calc (2)", "DATE" "Date", USER_SEGMENT "User Segment", GT_65 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_66 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q10."DATE", Q10.USER_SEGMENT, Q10.GT_65, Q10.EQ_66, Q12.COUNT_71, Q12.SUM_72, Q12.SUM_73, Q12.SUM_74 from (select "DATE", USER_SEGMENT, COUNT_64 > 1 GT_65, COUNT_64 = 0 EQ_66 from (select * from W1 Q8 order by "DATE" asc, USER_SEGMENT asc limit 10001) Q9) Q10 cross join (select count("DATE") COUNT_71, sum(iff(COUNT_64 = 0, 1, 0)) SUM_72, sum(iff(COUNT_64 = 1, 1, 0)) SUM_73, sum(iff(COUNT_64 > 1, 1, 0)) SUM_74 from W1 Q11) Q12) Q14 order by "DATE" asc, USER_SEGMENT asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=FLzROCDphH","kind":"adhoc","request-id":"g019d7424401c7e3a8e642ad87e8b3803","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
