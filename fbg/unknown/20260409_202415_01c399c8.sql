-- Query ID: 01c399c8-0212-6dbe-24dd-07031927bfef
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:24:15.546000+00:00
-- Elapsed: 311ms
-- Environment: FBG

with W1 as (select Q5.USER_SEGMENT USER_SEGMENT_17, count(NEW_SEGMENTS_WEEKLY_FORECAST.USER_SEGMENT) COUNT_29 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_FORECAST right join (select USER_SEGMENT from (select NEW_SEGMENTS_WEEKLY_RETENTION.USER_SEGMENT, row_number() over (partition by NEW_SEGMENTS_WEEKLY_RETENTION.USER_SEGMENT order by '' asc) ROWNUMBER_28 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_RETENTION right join (select HIGH_LEVEL_SEGMENT, SPORTSLIFECYCLE, CHURN_WEEK::timestamp_ltz CAST_27 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_WEEKLY_RETENTION_DS) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_WEEKLY_RETENTION.WEEK_DATE) = Q3.CAST_27 and NEW_SEGMENTS_WEEKLY_RETENTION.USER_SEGMENT = Q3.HIGH_LEVEL_SEGMENT and NEW_SEGMENTS_WEEKLY_RETENTION.LIFECYCLE = Q3.SPORTSLIFECYCLE qualify ROWNUMBER_28 = 1) Q2) Q5 on NEW_SEGMENTS_WEEKLY_FORECAST.USER_SEGMENT = Q5.USER_SEGMENT group by Q5.USER_SEGMENT) select COUNT_36 "Count of User Segment", SUM_37 "CountIf of Calc", SUM_38 "CountIf of Calc (1)", SUM_39 "CountIf of Calc (2)", USER_SEGMENT_17 "User Segment", GT_30 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_31 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q9.USER_SEGMENT_17, Q9.GT_30, Q9.EQ_31, Q11.COUNT_36, Q11.SUM_37, Q11.SUM_38, Q11.SUM_39 from (select USER_SEGMENT_17, COUNT_29 > 1 GT_30, COUNT_29 = 0 EQ_31 from (select * from W1 Q7 order by USER_SEGMENT_17 asc limit 10001) Q8) Q9 cross join (select count(USER_SEGMENT_17) COUNT_36, sum(iff(COUNT_29 = 0, 1, 0)) SUM_37, sum(iff(COUNT_29 = 1, 1, 0)) SUM_38, sum(iff(COUNT_29 > 1, 1, 0)) SUM_39 from W1 Q10) Q11) Q13 order by USER_SEGMENT_17 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=bWD9jQcekM","kind":"adhoc","request-id":"g019d73eab6ec7fdeaa7e7327fa19af42","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
