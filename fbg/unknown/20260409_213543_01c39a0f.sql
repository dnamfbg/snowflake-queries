-- Query ID: 01c39a0f-0212-67a9-24dd-07031938569f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:35:43.047000+00:00
-- Elapsed: 65ms
-- Environment: FBG

with W1 as (select Q5."DATE" DATE_18, count(NEW_SEGMENTS_DAILY_FORECAST."DATE") COUNT_64 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select "DATE" from (select NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE", row_number() over (partition by NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" order by '' asc) ROWNUMBER_63 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_57 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q3.CAST_57 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q3.EHOLD_BUCKET qualify ROWNUMBER_63 = 1) Q2) Q5 on NEW_SEGMENTS_DAILY_FORECAST."DATE" = Q5."DATE" group by Q5."DATE") select COUNT_71 "Count of Date", SUM_72 "CountIf of Calc", SUM_73 "CountIf of Calc (1)", SUM_74 "CountIf of Calc (2)", DATE_18 "Date", GT_65 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_66 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q9.DATE_18, Q9.GT_65, Q9.EQ_66, Q11.COUNT_71, Q11.SUM_72, Q11.SUM_73, Q11.SUM_74 from (select DATE_18, COUNT_64 > 1 GT_65, COUNT_64 = 0 EQ_66 from (select * from W1 Q7 order by DATE_18 asc limit 10001) Q8) Q9 cross join (select count(DATE_18) COUNT_71, sum(iff(COUNT_64 = 0, 1, 0)) SUM_72, sum(iff(COUNT_64 = 1, 1, 0)) SUM_73, sum(iff(COUNT_64 > 1, 1, 0)) SUM_74 from W1 Q10) Q11) Q13 order by DATE_18 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=eV_wZwVa6s","kind":"adhoc","request-id":"g019d742c22fb7f508cc76bf3c70125e2","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
