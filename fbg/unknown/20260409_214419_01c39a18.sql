-- Query ID: 01c39a18-0212-6cb9-24dd-0703193a3c67
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:44:19.972000+00:00
-- Elapsed: 57ms
-- Environment: FBG

with W1 as (select Q2."DATE", count(Q3.FTU_LIFECYCLE) COUNT_61 from (select "DATE" from (select "DATE", row_number() over (partition by "DATE" order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_MTD_PL_DS Q3 on Q2."DATE" = Q3.FTU_LIFECYCLE group by Q2."DATE") select COUNT_68 "Count of Date", SUM_69 "CountIf of Calc", SUM_70 "CountIf of Calc (1)", SUM_71 "CountIf of Calc (2)", "DATE" "Date", GT_62 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_63 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8."DATE", Q8.GT_62, Q8.EQ_63, Q10.COUNT_68, Q10.SUM_69, Q10.SUM_70, Q10.SUM_71 from (select "DATE", COUNT_61 > 1 GT_62, COUNT_61 = 0 EQ_63 from (select * from W1 Q6 order by "DATE" asc limit 10001) Q7) Q8 cross join (select count("DATE") COUNT_68, sum(iff(COUNT_61 = 0, 1, 0)) SUM_69, sum(iff(COUNT_61 = 1, 1, 0)) SUM_70, sum(iff(COUNT_61 > 1, 1, 0)) SUM_71 from W1 Q9) Q10) Q12 order by "DATE" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=S2ZfaEhyiJ","kind":"adhoc","request-id":"g019d7434063b7ecda0fde44d393d04b2","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
