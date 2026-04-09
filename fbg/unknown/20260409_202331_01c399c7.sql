-- Query ID: 01c399c7-0212-67a9-24dd-07031927f727
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:23:31.708000+00:00
-- Elapsed: 265ms
-- Environment: FBG

with W1 as (select Q5.YEAR_NUMBER, count(NEW_SEGMENTS_WEEKLY_FORECAST.WEEK_NUMBER) COUNT_44 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_WEEKLY_FORECAST right join (select YEAR_NUMBER from (select NEW_SEGMENTS_MONTHY_FORECAST.YEAR_NUMBER, row_number() over (partition by NEW_SEGMENTS_MONTHY_FORECAST.YEAR_NUMBER order by '' asc) ROWNUMBER_43 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_MONTHY_FORECAST left join (select HIGH_LEVEL_SEGMENT, BUS_MONTH::timestamp_ltz CAST_40 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MONTHLY_ACTUAL_DS) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_MONTHY_FORECAST.MONTH_DATE) = Q3.CAST_40 and NEW_SEGMENTS_MONTHY_FORECAST.USER_SEGMENT = Q3.HIGH_LEVEL_SEGMENT qualify ROWNUMBER_43 = 1) Q2) Q5 on NEW_SEGMENTS_WEEKLY_FORECAST.WEEK_NUMBER = Q5.YEAR_NUMBER group by Q5.YEAR_NUMBER) select COUNT_51 "Count of Year Number", SUM_52 "CountIf of Calc", SUM_53 "CountIf of Calc (1)", SUM_54 "CountIf of Calc (2)", YEAR_NUMBER "Year Number", GT_45 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_46 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q9.YEAR_NUMBER, Q9.GT_45, Q9.EQ_46, Q11.COUNT_51, Q11.SUM_52, Q11.SUM_53, Q11.SUM_54 from (select YEAR_NUMBER, COUNT_44 > 1 GT_45, COUNT_44 = 0 EQ_46 from (select * from W1 Q7 order by YEAR_NUMBER asc limit 10001) Q8) Q9 cross join (select count(YEAR_NUMBER) COUNT_51, sum(iff(COUNT_44 = 0, 1, 0)) SUM_52, sum(iff(COUNT_44 = 1, 1, 0)) SUM_53, sum(iff(COUNT_44 > 1, 1, 0)) SUM_54 from W1 Q10) Q11) Q13 order by YEAR_NUMBER asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=iqdzFCq3ql","kind":"adhoc","request-id":"g019d73ea0712793e8793bca3f1958be6","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
