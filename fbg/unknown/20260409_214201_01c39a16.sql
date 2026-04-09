-- Query ID: 01c39a16-0212-67a8-24dd-0703193a1453
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:42:01.689000+00:00
-- Elapsed: 78ms
-- Environment: FBG

with W1 as (select Q3.DATE_TARGET, count(NEW_SEGMENTS_DAILY_FORECAST."DATE") COUNT_54 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select DATE_TARGET from (select DATE_TARGET, row_number() over (partition by DATE_TARGET order by '' asc) ROWNUMBER_53 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_TARGETS qualify ROWNUMBER_53 = 1) Q2) Q3 on NEW_SEGMENTS_DAILY_FORECAST."DATE" = Q3.DATE_TARGET group by Q3.DATE_TARGET) select COUNT_61 "Count of Date Target", SUM_62 "CountIf of Calc", SUM_63 "CountIf of Calc (1)", SUM_64 "CountIf of Calc (2)", DATE_TARGET "Date Target", GT_55 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_56 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.DATE_TARGET, Q7.GT_55, Q7.EQ_56, Q9.COUNT_61, Q9.SUM_62, Q9.SUM_63, Q9.SUM_64 from (select DATE_TARGET, COUNT_54 > 1 GT_55, COUNT_54 = 0 EQ_56 from (select * from W1 Q5 order by DATE_TARGET asc limit 10001) Q6) Q7 cross join (select count(DATE_TARGET) COUNT_61, sum(iff(COUNT_54 = 0, 1, 0)) SUM_62, sum(iff(COUNT_54 = 1, 1, 0)) SUM_63, sum(iff(COUNT_54 > 1, 1, 0)) SUM_64 from W1 Q8) Q9) Q11 order by DATE_TARGET asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=0QDpRofAsY","kind":"adhoc","request-id":"g019d7431ea1e7e1c86bdc55862566875","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
