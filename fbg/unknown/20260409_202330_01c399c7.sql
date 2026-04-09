-- Query ID: 01c399c7-0212-67a9-24dd-07031927f70b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:30.536000+00:00
-- Elapsed: 334ms
-- Environment: FBG

with W1 as (select Q2.WEEK_NUMBER, count(Q3.YEAR_NUMBER) COUNT_44 from (select WEEK_NUMBER from (select WEEK_NUMBER, row_number() over (partition by WEEK_NUMBER order by '' asc) ROWNUMBER_16 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_FORECAST qualify ROWNUMBER_16 = 1) Q1) Q2 left join (select NEW_SEGMENTS_MONTHY_FORECAST.YEAR_NUMBER from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_MONTHY_FORECAST left join (select HIGH_LEVEL_SEGMENT, BUS_MONTH::timestamp_ltz CAST_41 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MONTHLY_ACTUAL_DS) Q4 on try_to_timestamp_ltz(NEW_SEGMENTS_MONTHY_FORECAST.MONTH_DATE) = Q4.CAST_41 and NEW_SEGMENTS_MONTHY_FORECAST.USER_SEGMENT = Q4.HIGH_LEVEL_SEGMENT) Q3 on Q2.WEEK_NUMBER = Q3.YEAR_NUMBER group by Q2.WEEK_NUMBER) select COUNT_51 "Count of Week Number", SUM_52 "CountIf of Calc", SUM_53 "CountIf of Calc (1)", SUM_54 "CountIf of Calc (2)", WEEK_NUMBER "Week Number", GT_45 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_46 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q10.WEEK_NUMBER, Q10.GT_45, Q10.EQ_46, Q12.COUNT_51, Q12.SUM_52, Q12.SUM_53, Q12.SUM_54 from (select WEEK_NUMBER, COUNT_44 > 1 GT_45, COUNT_44 = 0 EQ_46 from (select * from W1 Q8 order by WEEK_NUMBER asc limit 10001) Q9) Q10 cross join (select count(WEEK_NUMBER) COUNT_51, sum(iff(COUNT_44 = 0, 1, 0)) SUM_52, sum(iff(COUNT_44 = 1, 1, 0)) SUM_53, sum(iff(COUNT_44 > 1, 1, 0)) SUM_54 from W1 Q11) Q12) Q14 order by WEEK_NUMBER asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=2jY_f_psvr","kind":"adhoc","request-id":"g019d73ea07127250aa71f4a4c65828f9","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
