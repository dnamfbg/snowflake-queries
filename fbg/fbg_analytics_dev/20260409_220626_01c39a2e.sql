-- Query ID: 01c39a2e-0212-6cb9-24dd-0703193f3807
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:06:26.252000+00:00
-- Elapsed: 3263ms
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
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $4)
 FROM TABLE(RESULT_SCAN('01c39a2b-0212-67a9-24dd-0703193e5e4f'))),
 stats as (SELECT
COUNT($1)
,MIN($1)
,MAX($1)
,SUM($1)
,AVG($1)
,COUNT($2)
,MIN($2)
,MAX($2)
,SUM($2)
,AVG($2)
,COUNT($3)
,COUNT($4)
,MIN($4)
,MAX($4)
,MIN($9)
,MAX($9)
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
,COUNT($8)
 FROM results)
 ,buckets1 AS (SELECT CASE WHEN stats.$2 = stats.$3 THEN 1 ELSE WIDTH_BUCKET(results.$1, stats.$2, stats.$3 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT CASE WHEN stats.$7 = stats.$8 THEN 1 ELSE WIDTH_BUCKET(results.$2, stats.$7, stats.$8 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$15 = stats.$16 THEN 1 ELSE WIDTH_BUCKET(results.$9, stats.$15, stats.$16 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$18 = stats.$19 THEN 1 ELSE WIDTH_BUCKET(results.$5, stats.$18, stats.$19 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT CASE WHEN stats.$23 = stats.$24 THEN 1 ELSE WIDTH_BUCKET(results.$6, stats.$23, stats.$24 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT results.$7 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT results.$8 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 SELECT * FROM stats
 ,stats1
 ,stats2
 ,stats3
 ,stats4
 ,stats5
 ,stats6
 ,stats7
 ,stats8
