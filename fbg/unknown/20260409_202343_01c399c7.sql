-- Query ID: 01c399c7-0212-67a8-24dd-07031927d8e7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:43.147000+00:00
-- Elapsed: 246ms
-- Environment: FBG

with W1 as (select Q2.USER_SEGMENT, count(Q3.USER_SEGMENT) COUNT_44 from (select USER_SEGMENT from (select USER_SEGMENT, row_number() over (partition by USER_SEGMENT order by '' asc) ROWNUMBER_16 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_FORECAST qualify ROWNUMBER_16 = 1) Q1) Q2 left join (select NEW_SEGMENTS_MONTHY_FORECAST.USER_SEGMENT from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_MONTHY_FORECAST left join (select HIGH_LEVEL_SEGMENT, BUS_MONTH::timestamp_ltz CAST_41 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MONTHLY_ACTUAL_DS) Q4 on try_to_timestamp_ltz(NEW_SEGMENTS_MONTHY_FORECAST.MONTH_DATE) = Q4.CAST_41 and NEW_SEGMENTS_MONTHY_FORECAST.USER_SEGMENT = Q4.HIGH_LEVEL_SEGMENT) Q3 on Q2.USER_SEGMENT = Q3.USER_SEGMENT group by Q2.USER_SEGMENT) select COUNT_51 "Count of User Segment", SUM_52 "CountIf of Calc", SUM_53 "CountIf of Calc (1)", SUM_54 "CountIf of Calc (2)", USER_SEGMENT "User Segment", GT_45 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_46 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q10.USER_SEGMENT, Q10.GT_45, Q10.EQ_46, Q12.COUNT_51, Q12.SUM_52, Q12.SUM_53, Q12.SUM_54 from (select USER_SEGMENT, COUNT_44 > 1 GT_45, COUNT_44 = 0 EQ_46 from (select * from W1 Q8 order by USER_SEGMENT asc limit 10001) Q9) Q10 cross join (select count(USER_SEGMENT) COUNT_51, sum(iff(COUNT_44 = 0, 1, 0)) SUM_52, sum(iff(COUNT_44 = 1, 1, 0)) SUM_53, sum(iff(COUNT_44 > 1, 1, 0)) SUM_54 from W1 Q11) Q12) Q14 order by USER_SEGMENT asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=2jY_f_psvr","kind":"adhoc","request-id":"g019d73ea381579dbaac8036581508af4","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
