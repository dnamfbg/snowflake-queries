-- Query ID: 01c39a16-0212-6cb9-24dd-0703193a3393
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:42:31.607000+00:00
-- Elapsed: 478ms
-- Environment: FBG

with W1 as (select Q2.CAST_18, count(Q3.CAST_31) COUNT_32 from (select CAST_18 from (select try_to_timestamp_ltz(WEEK_NUM) CAST_18, row_number() over (partition by CAST_18 order by '' asc) ROWNUMBER_19 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_19 = 1) Q1) Q2 left join (select BUS_DATE_FC::timestamp_ltz CAST_31 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_FAIRNESS_DS) Q3 on Q2.CAST_18 = Q3.CAST_31 group by Q2.CAST_18) select COUNT_39 "Count of Week Num", SUM_40 "CountIf of Calc", SUM_41 "CountIf of Calc (1)", SUM_42 "CountIf of Calc (2)", CAST_18 "Week Num", GT_33 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_34 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8.CAST_18, Q8.GT_33, Q8.EQ_34, Q10.COUNT_39, Q10.SUM_40, Q10.SUM_41, Q10.SUM_42 from (select CAST_18, COUNT_32 > 1 GT_33, COUNT_32 = 0 EQ_34 from (select * from W1 Q6 order by CAST_18 asc limit 10001) Q7) Q8 cross join (select count(CAST_18) COUNT_39, sum(iff(COUNT_32 = 0, 1, 0)) SUM_40, sum(iff(COUNT_32 = 1, 1, 0)) SUM_41, sum(iff(COUNT_32 > 1, 1, 0)) SUM_42 from W1 Q9) Q10) Q12 order by CAST_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=6amerOeiPY","kind":"adhoc","request-id":"g019d74325efb7f52ad045eed6c56c625","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
