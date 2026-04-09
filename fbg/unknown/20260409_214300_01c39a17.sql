-- Query ID: 01c39a17-0212-6cb9-24dd-0703193a35c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:43:00.962000+00:00
-- Elapsed: 1321ms
-- Environment: FBG

select COUNT_155 "count", SUM_156 "sum", SUM_157 "nullCount", COUNTDISTINCT_158 "ndv", MIN_159 "min", PERCENTILECONT_160 "p25", MEDIAN_161 "median", PERCENTILECONT_162 "p75", MAX_163 "max", AVG_164 "avg", STDDEV_165 "stddev", VARIANCE_166 "variance" from (select count(COUNTDISTINCT_37) COUNT_155, sum(COUNTDISTINCT_37) SUM_156, sum(iff(COUNTDISTINCT_37 is null, 1, 0)) SUM_157, count(distinct COUNTDISTINCT_37) COUNTDISTINCT_158, min(COUNTDISTINCT_37) MIN_159, percentile_cont(0.25) within group (order by COUNTDISTINCT_37 asc) PERCENTILECONT_160, median(COUNTDISTINCT_37) MEDIAN_161, percentile_cont(0.75) within group (order by COUNTDISTINCT_37 asc) PERCENTILECONT_162, max(COUNTDISTINCT_37) MAX_163, avg(COUNTDISTINCT_37) AVG_164, stddev_samp(COUNTDISTINCT_37) STDDEV_165, var_samp(COUNTDISTINCT_37) VARIANCE_166 from (select count(distinct BET_ID) COUNTDISTINCT_37 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FANCASH_MULTIS where TIER is not null and date_trunc(day, SETTLED_DATE_ALK::timestamp_ltz) >= to_timestamp_ltz('2026-01-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, SETTLED_DATE_ALK::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by X_MULTIPLIER, ATS_ACCOUNT_ID) Q1) Q2

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FanCash-Loyalty-Report-2Txc2ivoGjIwZ2PP9h6ynB?:displayNodeId=EAjRPtmNPh","kind":"adhoc","request-id":"g019d7432d12f7e30958d269fa29d82cf","user-id":"1ob9mcmKybrCoq32r1DMUmaXfv3vH","email":"andrew.tsentner@betfanatics.com"}
