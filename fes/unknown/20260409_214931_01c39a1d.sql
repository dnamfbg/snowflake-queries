-- Query ID: 01c39a1d-0112-6ccc-0000-e307218bd662
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:49:31.500000+00:00
-- Elapsed: 1043ms
-- Environment: FES

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
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $6)
 FROM TABLE(RESULT_SCAN('01c39a1d-0112-6ccc-0000-e307218bd64a'))),
 stats as (SELECT
COUNT($1)
,COUNT($2)
,COUNT($3)
,COUNT($4)
,MIN($4)
,MAX($4)
,SUM($4)
,AVG($4)
,COUNT($5)
,COUNT($6)
,MIN($6)
,MAX($6)
,MIN($11)
,MAX($11)
,COUNT($7)
,COUNT($8)
,COUNT($9)
,COUNT($10)
 FROM results)
 ,buckets1 AS (SELECT results.$1 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT results.$2 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$5 = stats.$6 THEN 1 ELSE WIDTH_BUCKET(results.$4, stats.$5, stats.$6 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT results.$5 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT CASE WHEN stats.$13 = stats.$14 THEN 1 ELSE WIDTH_BUCKET(results.$11, stats.$13, stats.$14 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT results.$7 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT results.$8 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT results.$9 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT results.$10 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
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
