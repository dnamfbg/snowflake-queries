-- Query ID: 01c39a06-0212-6e7d-24dd-070319358ed7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:26:08.445000+00:00
-- Elapsed: 728ms
-- Environment: FBG

with W1 as (select Q2.USER_SEGMENT, Q2.CAST_18, count(Q3.CAST_50) COUNT_56 from (select USER_SEGMENT, CAST_18 from (select USER_SEGMENT, try_to_timestamp_ltz("DATE") CAST_18, row_number() over (partition by CAST_18, USER_SEGMENT order by '' asc) ROWNUMBER_19 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_19 = 1) Q1) Q2 left join (select OSB_SEGMENT, BUS_DATE::timestamp_ltz CAST_50 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_DAILY_DS) Q3 on Q2.CAST_18 = Q3.CAST_50 and Q2.USER_SEGMENT = Q3.OSB_SEGMENT group by Q2.CAST_18, Q2.USER_SEGMENT) select COUNT_63 "Count of Date", SUM_64 "CountIf of Calc", SUM_65 "CountIf of Calc (1)", SUM_66 "CountIf of Calc (2)", CAST_18 "Date", USER_SEGMENT "User Segment", GT_57 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_58 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8.USER_SEGMENT, Q8.CAST_18, Q8.GT_57, Q8.EQ_58, Q10.COUNT_63, Q10.SUM_64, Q10.SUM_65, Q10.SUM_66 from (select USER_SEGMENT, CAST_18, COUNT_56 > 1 GT_57, COUNT_56 = 0 EQ_58 from (select * from W1 Q6 order by CAST_18 asc, USER_SEGMENT asc limit 10001) Q7) Q8 cross join (select count(CAST_18) COUNT_63, sum(iff(COUNT_56 = 0, 1, 0)) SUM_64, sum(iff(COUNT_56 = 1, 1, 0)) SUM_65, sum(iff(COUNT_56 > 1, 1, 0)) SUM_66 from W1 Q9) Q10) Q12 order by CAST_18 asc, USER_SEGMENT asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-1-34rdU89t8adkDkUiTTTdmE?:displayNodeId=FLzROCDphH","kind":"adhoc","request-id":"g019d74235e62739fad698271e98623d8","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
