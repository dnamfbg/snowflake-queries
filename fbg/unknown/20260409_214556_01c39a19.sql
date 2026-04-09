-- Query ID: 01c39a19-0212-6cb9-24dd-0703193ab82f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:45:56.402000+00:00
-- Elapsed: 242ms
-- Environment: FBG

with W1 as (select Q2."DATE", count(Q3.EHOLD_BUCKET) COUNT_43 from (select "DATE" from (select "DATE", row_number() over (partition by "DATE" order by '' asc) ROWNUMBER_18 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST qualify ROWNUMBER_18 = 1) Q1) Q2 left join FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS Q3 on Q2."DATE" = Q3.EHOLD_BUCKET group by Q2."DATE") select COUNT_50 "Count of Date", SUM_51 "CountIf of Calc", SUM_52 "CountIf of Calc (1)", SUM_53 "CountIf of Calc (2)", "DATE" "Date", GT_44 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_45 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q8."DATE", Q8.GT_44, Q8.EQ_45, Q10.COUNT_50, Q10.SUM_51, Q10.SUM_52, Q10.SUM_53 from (select "DATE", COUNT_43 > 1 GT_44, COUNT_43 = 0 EQ_45 from (select * from W1 Q6 order by "DATE" asc limit 10001) Q7) Q8 cross join (select count("DATE") COUNT_50, sum(iff(COUNT_43 = 0, 1, 0)) SUM_51, sum(iff(COUNT_43 = 1, 1, 0)) SUM_52, sum(iff(COUNT_43 > 1, 1, 0)) SUM_53 from W1 Q9) Q10) Q12 order by "DATE" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=n1Smi8t39d","kind":"adhoc","request-id":"g019d74357cb773cc89f7eda487fad014","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
