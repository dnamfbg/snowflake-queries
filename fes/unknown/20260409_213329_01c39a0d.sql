-- Query ID: 01c39a0d-0112-6f44-0000-e307218bc012
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:33:29.403000+00:00
-- Elapsed: 2156ms
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
,$11
,$12
,$13
,$14
,$15
,$16
,$17
,$18
,$19
,$20
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $6)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $12)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $15)
 FROM TABLE(RESULT_SCAN('01c39a0d-0112-6029-0000-e307218b8526'))),
 stats as (SELECT
COUNT($1)
,COUNT($2)
,COUNT($3)
,COUNT($4)
,COUNT($5)
,MIN($5)
,MAX($5)
,SUM($5)
,AVG($5)
,COUNT($6)
,MIN($6)
,MAX($6)
,MIN($21)
,MAX($21)
,COUNT($7)
,MIN($7)
,MAX($7)
,SUM($7)
,AVG($7)
,COUNT($8)
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
,COUNT($12)
,MIN($12)
,MAX($12)
,MIN($22)
,MAX($22)
,COUNT($13)
,COUNT($14)
,MIN($14)
,MAX($14)
,SUM($14)
,AVG($14)
,COUNT($15)
,MIN($15)
,MAX($15)
,MIN($23)
,MAX($23)
,COUNT($16)
,MIN($16)
,MAX($16)
,SUM($16)
,AVG($16)
,COUNT($17)
,MIN($17)
,MAX($17)
,SUM($17)
,AVG($17)
,COUNT($18)
,MIN($18)
,MAX($18)
,SUM($18)
,AVG($18)
,COUNT($19)
,COUNT($20)
,MIN($20)
,MAX($20)
,SUM($20)
,AVG($20)
 FROM results)
 ,buckets1 AS (SELECT results.$1 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT results.$2 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT results.$4 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$6 = stats.$7 THEN 1 ELSE WIDTH_BUCKET(results.$5, stats.$6, stats.$7 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT CASE WHEN stats.$13 = stats.$14 THEN 1 ELSE WIDTH_BUCKET(results.$21, stats.$13, stats.$14 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT CASE WHEN stats.$16 = stats.$17 THEN 1 ELSE WIDTH_BUCKET(results.$7, stats.$16, stats.$17 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT results.$8 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT CASE WHEN stats.$22 = stats.$23 THEN 1 ELSE WIDTH_BUCKET(results.$9, stats.$22, stats.$23 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT CASE WHEN stats.$27 = stats.$28 THEN 1 ELSE WIDTH_BUCKET(results.$10, stats.$27, stats.$28 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT CASE WHEN stats.$32 = stats.$33 THEN 1 ELSE WIDTH_BUCKET(results.$11, stats.$32, stats.$33 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT CASE WHEN stats.$39 = stats.$40 THEN 1 ELSE WIDTH_BUCKET(results.$22, stats.$39, stats.$40 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT results.$13 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT CASE WHEN stats.$43 = stats.$44 THEN 1 ELSE WIDTH_BUCKET(results.$14, stats.$43, stats.$44 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT CASE WHEN stats.$50 = stats.$51 THEN 1 ELSE WIDTH_BUCKET(results.$23, stats.$50, stats.$51 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT CASE WHEN stats.$53 = stats.$54 THEN 1 ELSE WIDTH_BUCKET(results.$16, stats.$53, stats.$54 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT CASE WHEN stats.$58 = stats.$59 THEN 1 ELSE WIDTH_BUCKET(results.$17, stats.$58, stats.$59 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT CASE WHEN stats.$63 = stats.$64 THEN 1 ELSE WIDTH_BUCKET(results.$18, stats.$63, stats.$64 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT results.$19 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT CASE WHEN stats.$69 = stats.$70 THEN 1 ELSE WIDTH_BUCKET(results.$20, stats.$69, stats.$70 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats20 AS (SELECT OBJECT_AGG(b, c) FROM buckets20)
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
 ,stats12
 ,stats13
 ,stats14
 ,stats15
 ,stats16
 ,stats17
 ,stats18
 ,stats19
 ,stats20
