-- Query ID: 01c39a06-0212-67a9-24dd-0703193604eb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:26:56.120000+00:00
-- Elapsed: 121ms
-- Environment: FBG

with W1 as (select Q5."DATE" DATE_18, Q5.DATE_63, count(NEW_SEGMENTS_DAILY_FORECAST."DATE") COUNT_65 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select "DATE", DATE_63 from (select NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE", NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" DATE_63, row_number() over (partition by NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" order by '' asc) ROWNUMBER_64 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_57 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q3 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q3.CAST_57 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q3.EHOLD_BUCKET qualify ROWNUMBER_64 = 1) Q2) Q5 on NEW_SEGMENTS_DAILY_FORECAST."DATE" = Q5."DATE" and NEW_SEGMENTS_DAILY_FORECAST."MONTH" = Q5.DATE_63 group by Q5."DATE", Q5.DATE_63) select COUNT_72 "Count of Date", SUM_73 "CountIf of Calc", SUM_74 "CountIf of Calc (1)", SUM_75 "CountIf of Calc (2)", DATE_18 "Date", DATE_63 "Date (1)", GT_66 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_67 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q9.DATE_18, Q9.DATE_63, Q9.GT_66, Q9.EQ_67, Q11.COUNT_72, Q11.SUM_73, Q11.SUM_74, Q11.SUM_75 from (select DATE_18, DATE_63, COUNT_65 > 1 GT_66, COUNT_65 = 0 EQ_67 from (select * from W1 Q7 order by DATE_18 asc, DATE_63 asc limit 10001) Q8) Q9 cross join (select count(DATE_18) COUNT_72, sum(iff(COUNT_65 = 0, 1, 0)) SUM_73, sum(iff(COUNT_65 = 1, 1, 0)) SUM_74, sum(iff(COUNT_65 > 1, 1, 0)) SUM_75 from W1 Q10) Q11) Q13 order by DATE_18 asc, DATE_63 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=LeRBPZwPq_","kind":"adhoc","request-id":"g019d742417537c3e86529f30dac8f249","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
