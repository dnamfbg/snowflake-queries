-- Query ID: 01c39a53-0212-67a8-24dd-070319475683
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:43:30.307000+00:00
-- Elapsed: 78ms
-- Environment: FBG

with W1 as (select Q2."DATE", count(Q3."DATE") COUNT_64 from (select "DATE" from (select "DATE", row_number() over (partition by "DATE" order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join (select NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE" from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_REVENUE_FLOW_THROUGH left join (select EHOLD_BUCKET, BUS_DATE::timestamp_ltz CAST_58 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS) Q4 on try_to_timestamp_ltz(NEW_SEGMENTS_REVENUE_FLOW_THROUGH."DATE") = Q4.CAST_58 and NEW_SEGMENTS_REVENUE_FLOW_THROUGH.HOLD_BUCKET = Q4.EHOLD_BUCKET) Q3 on Q2."DATE" = Q3."DATE" group by Q2."DATE") select COUNT_71 "Count of Date", SUM_72 "CountIf of Calc", SUM_73 "CountIf of Calc (1)", SUM_74 "CountIf of Calc (2)", "DATE" "Date", GT_65 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_66 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q10."DATE", Q10.GT_65, Q10.EQ_66, Q12.COUNT_71, Q12.SUM_72, Q12.SUM_73, Q12.SUM_74 from (select "DATE", COUNT_64 > 1 GT_65, COUNT_64 = 0 EQ_66 from (select * from W1 Q8 order by "DATE" asc limit 10001) Q9) Q10 cross join (select count("DATE") COUNT_71, sum(iff(COUNT_64 = 0, 1, 0)) SUM_72, sum(iff(COUNT_64 = 1, 1, 0)) SUM_73, sum(iff(COUNT_64 > 1, 1, 0)) SUM_74 from W1 Q11) Q12) Q14 order by "DATE" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=wXyEoMCTtP","kind":"adhoc","request-id":"g019d746a32ac7657ad0597be00dc6854","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
