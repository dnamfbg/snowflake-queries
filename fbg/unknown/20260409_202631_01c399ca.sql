-- Query ID: 01c399ca-0212-6cb9-24dd-07031928496b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:26:31.082000+00:00
-- Elapsed: 95ms
-- Environment: FBG

with W1 as (select Q2."DATE", count(Q3.DATE_TARGET) COUNT_55 from (select "DATE" from (select "DATE", row_number() over (partition by "DATE" order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_TARGETS Q3 on Q2."DATE" = Q3.DATE_TARGET group by Q2."DATE") select COUNT_62 "Count of Date", SUM_63 "CountIf of Calc", SUM_64 "CountIf of Calc (1)", SUM_65 "CountIf of Calc (2)", "DATE" "Date", GT_56 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_57 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8."DATE", Q8.GT_56, Q8.EQ_57, Q10.COUNT_62, Q10.SUM_63, Q10.SUM_64, Q10.SUM_65 from (select "DATE", COUNT_55 > 1 GT_56, COUNT_55 = 0 EQ_57 from (select * from W1 Q6 order by "DATE" asc limit 10001) Q7) Q8 cross join (select count("DATE") COUNT_62, sum(iff(COUNT_55 = 0, 1, 0)) SUM_63, sum(iff(COUNT_55 = 1, 1, 0)) SUM_64, sum(iff(COUNT_55 > 1, 1, 0)) SUM_65 from W1 Q9) Q10) Q12 order by "DATE" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=wZxGlcdzsc","kind":"adhoc","request-id":"g019d73ecc87170a292f8b49eef98a2dc","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
