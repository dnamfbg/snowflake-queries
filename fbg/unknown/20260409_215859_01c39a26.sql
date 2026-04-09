-- Query ID: 01c39a26-0212-67a9-24dd-0703193cfd6f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Last Executed: 2026-04-09T21:58:59.906000+00:00
-- Elapsed: 799ms
-- Run Count: 2
-- Environment: FBG

WITH 
results as (SELECT
$1
,$2
,$3
,$4
,$5
,$6
,$7
,$8
,$9
,$10
,$11
 FROM TABLE(RESULT_SCAN('01c39a24-0212-6cb9-24dd-0703193ce62f'))),
 stats as (SELECT
COUNT($1)
,MIN($1)
,MAX($1)
,SUM($1)
,AVG($1)
,COUNT($2)
,COUNT($3)
,COUNT($4)
,MIN($4)
,MAX($4)
,SUM($4)
,AVG($4)
,COUNT($5)
,MIN($5)
,MAX($5)
,SUM($5)
,AVG($5)
,COUNT($6)
,MIN($6)
,MAX($6)
,SUM($6)
,AVG($6)
,COUNT($7)
,MIN($7)
,MAX($7)
,SUM($7)
,AVG($7)
,COUNT($8)
,MIN($8)
,MAX($8)
,SUM($8)
,AVG($8)
,COUNT($9)
,MIN($9)
,MAX($9)
,SUM($9)
,AVG($9)
,COUNT($10)
,MIN($10)
,MAX($10)
,SUM($10)
,AVG($10)
,COUNT($11)
,MIN($11)
,MAX($11)
,SUM($11)
,AVG($11)
 FROM results)
 ,buckets1 AS (SELECT CASE WHEN stats.$2 = stats.$3 THEN 1 ELSE WIDTH_BUCKET(results.$1, stats.$2, stats.$3 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT results.$2 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$9 = stats.$10 THEN 1 ELSE WIDTH_BUCKET(results.$4, stats.$9, stats.$10 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$14 = stats.$15 THEN 1 ELSE WIDTH_BUCKET(results.$5, stats.$14, stats.$15 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT CASE WHEN stats.$19 = stats.$20 THEN 1 ELSE WIDTH_BUCKET(results.$6, stats.$19, stats.$20 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT CASE WHEN stats.$24 = stats.$25 THEN 1 ELSE WIDTH_BUCKET(results.$7, stats.$24, stats.$25 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT CASE WHEN stats.$29 = stats.$30 THEN 1 ELSE WIDTH_BUCKET(results.$8, stats.$29, stats.$30 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT CASE WHEN stats.$34 = stats.$35 THEN 1 ELSE WIDTH_BUCKET(results.$9, stats.$34, stats.$35 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT CASE WHEN stats.$39 = stats.$40 THEN 1 ELSE WIDTH_BUCKET(results.$10, stats.$39, stats.$40 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT CASE WHEN stats.$44 = stats.$45 THEN 1 ELSE WIDTH_BUCKET(results.$11, stats.$44, stats.$45 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 SELECT * FROM stats
 ,stats1
 ,stats2
 ,stats3
 ,stats4
 ,stats5
 ,stats6
 ,stats7
 ,stats8
 ,stats9
 ,stats10
 ,stats11
