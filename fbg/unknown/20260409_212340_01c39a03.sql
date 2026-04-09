-- Query ID: 01c39a03-0212-6b00-24dd-0703193553b3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:23:40.963000+00:00
-- Elapsed: 155ms
-- Environment: FBG

with W1 as (select Q2.CAST_18, count(Q3.CAST_59) COUNT_62 from (select CAST_18 from (select try_to_timestamp_ltz("DATE") CAST_18, row_number() over (partition by CAST_18 order by '' asc) ROWNUMBER_19 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_19 = 1) Q1) Q2 left join (select BUS_DATE::timestamp_ltz CAST_59 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MTD_PL_DS) Q3 on Q2.CAST_18 = Q3.CAST_59 group by Q2.CAST_18) select COUNT_69 "Count of Date", SUM_70 "CountIf of Calc", SUM_71 "CountIf of Calc (1)", SUM_72 "CountIf of Calc (2)", CAST_18 "Date", GT_63 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_64 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8.CAST_18, Q8.GT_63, Q8.EQ_64, Q10.COUNT_69, Q10.SUM_70, Q10.SUM_71, Q10.SUM_72 from (select CAST_18, COUNT_62 > 1 GT_63, COUNT_62 = 0 EQ_64 from (select * from W1 Q6 order by CAST_18 asc limit 10001) Q7) Q8 cross join (select count(CAST_18) COUNT_69, sum(iff(COUNT_62 = 0, 1, 0)) SUM_70, sum(iff(COUNT_62 = 1, 1, 0)) SUM_71, sum(iff(COUNT_62 > 1, 1, 0)) SUM_72 from W1 Q9) Q10) Q12 order by CAST_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=O-t22pVlL1","kind":"adhoc","request-id":"g019d74211e4b742d96d9bf4fc1c11329","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
