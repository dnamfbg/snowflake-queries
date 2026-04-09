-- Query ID: 01c39a19-0212-6cb9-24dd-0703193ab81b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:45:55.848000+00:00
-- Elapsed: 261ms
-- Environment: FBG

with W1 as (select Q3.EHOLD_BUCKET, count(NEW_SEGMENTS_DAILY_FORECAST."DATE") COUNT_43 from FBG_SHEETZU."DEFAULT".NEW_SEGMENTS_DAILY_FORECAST right join (select EHOLD_BUCKET from (select EHOLD_BUCKET, row_number() over (partition by EHOLD_BUCKET order by '' asc) ROWNUMBER_42 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.SBK_FORECASTING_REVENUE_FLOW_DS qualify ROWNUMBER_42 = 1) Q2) Q3 on NEW_SEGMENTS_DAILY_FORECAST."DATE" = Q3.EHOLD_BUCKET group by Q3.EHOLD_BUCKET) select COUNT_50 "Count of Ehold Bucket", SUM_51 "CountIf of Calc", SUM_52 "CountIf of Calc (1)", SUM_53 "CountIf of Calc (2)", EHOLD_BUCKET "Ehold Bucket", GT_44 "__cond_JOIN_AGGR_MULTI_MATCHED_CF", EQ_45 "__cond_JOIN_AGGR_UNMATCHED_CF" from (select Q7.EHOLD_BUCKET, Q7.GT_44, Q7.EQ_45, Q9.COUNT_50, Q9.SUM_51, Q9.SUM_52, Q9.SUM_53 from (select EHOLD_BUCKET, COUNT_43 > 1 GT_44, COUNT_43 = 0 EQ_45 from (select * from W1 Q5 order by EHOLD_BUCKET asc limit 10001) Q6) Q7 cross join (select count(EHOLD_BUCKET) COUNT_50, sum(iff(COUNT_43 = 0, 1, 0)) SUM_51, sum(iff(COUNT_43 = 1, 1, 0)) SUM_52, sum(iff(COUNT_43 > 1, 1, 0)) SUM_53 from W1 Q8) Q9) Q11 order by EHOLD_BUCKET asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/NEW-Sportsbook-Forecasting-Report_Data-Model-Sample-34rdU89t8adkDkUiTTTdmE?:displayNodeId=6zpBaxERaQ","kind":"adhoc","request-id":"g019d74357cb7735893fe1fa60189befb","user-id":"L3vHZYjsyKujxXKFJJVEoOSTC4m5s","email":"sai.manish@squadrondata.com"}
