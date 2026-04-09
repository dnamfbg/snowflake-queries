-- Query ID: 01c39a52-0212-6e7d-24dd-07031947422f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:42:45.506000+00:00
-- Elapsed: 104ms
-- Environment: FBG

with W1 as (select Q3.FTU_LIFECYCLE, count(NEW_SEGMENTS_DAILY_FORECAST.WEEK_NUM) COUNT_61 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select FTU_LIFECYCLE from (select FTU_LIFECYCLE, row_number() over (partition by FTU_LIFECYCLE order by '' asc) ROWNUMBER_60 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MTD_PL_DS qualify ROWNUMBER_60 = 1) Q2) Q3 on NEW_SEGMENTS_DAILY_FORECAST.WEEK_NUM = Q3.FTU_LIFECYCLE group by Q3.FTU_LIFECYCLE) select COUNT_68 "Count of Ftu Lifecycle", SUM_69 "CountIf of Calc", SUM_70 "CountIf of Calc (1)", SUM_71 "CountIf of Calc (2)", FTU_LIFECYCLE "Ftu Lifecycle", GT_62 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_63 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.FTU_LIFECYCLE, Q7.GT_62, Q7.EQ_63, Q9.COUNT_68, Q9.SUM_69, Q9.SUM_70, Q9.SUM_71 from (select FTU_LIFECYCLE, COUNT_61 > 1 GT_62, COUNT_61 = 0 EQ_63 from (select * from W1 Q5 order by FTU_LIFECYCLE asc limit 10001) Q6) Q7 cross join (select count(FTU_LIFECYCLE) COUNT_68, sum(iff(COUNT_61 = 0, 1, 0)) SUM_69, sum(iff(COUNT_61 = 1, 1, 0)) SUM_70, sum(iff(COUNT_61 > 1, 1, 0)) SUM_71 from W1 Q8) Q9) Q11 order by FTU_LIFECYCLE asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=jKwkw549m7","kind":"adhoc","request-id":"g019d746983537eb5a4550e03eff70422","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
