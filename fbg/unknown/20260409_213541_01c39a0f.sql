-- Query ID: 01c39a0f-0212-6e7d-24dd-0703193881b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:35:41.336000+00:00
-- Elapsed: 56ms
-- Environment: FBG

with W1 as (select Q3.CAST_29, count(try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE")) COUNT_31 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select CAST_29 from (select BUS_DATE_FC::timestamp_ltz CAST_29, row_number() over (partition by CAST_29 order by '' asc) ROWNUMBER_30 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_FAIRNESS_DS qualify ROWNUMBER_30 = 1) Q2) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_DAILY_FORECAST."DATE") = Q3.CAST_29 group by Q3.CAST_29) select COUNT_38 "Count of Bus Date Fc", SUM_39 "CountIf of Calc", SUM_40 "CountIf of Calc (1)", SUM_41 "CountIf of Calc (2)", CAST_29 "Bus Date Fc", GT_32 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_33 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.CAST_29, Q7.GT_32, Q7.EQ_33, Q9.COUNT_38, Q9.SUM_39, Q9.SUM_40, Q9.SUM_41 from (select CAST_29, COUNT_31 > 1 GT_32, COUNT_31 = 0 EQ_33 from (select * from W1 Q5 order by CAST_29 asc limit 10001) Q6) Q7 cross join (select count(CAST_29) COUNT_38, sum(iff(COUNT_31 = 0, 1, 0)) SUM_39, sum(iff(COUNT_31 = 1, 1, 0)) SUM_40, sum(iff(COUNT_31 > 1, 1, 0)) SUM_41 from W1 Q8) Q9) Q11 order by CAST_29 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=eV_wZwVa6s","kind":"adhoc","request-id":"g019d742c1c50734e9ff71b7131394f0b","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
