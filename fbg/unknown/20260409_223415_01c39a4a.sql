-- Query ID: 01c39a4a-0212-6dbe-24dd-0703194580a3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T22:34:15.678000+00:00
-- Elapsed: 1767ms
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
,$12
,$13
,$14
,$15
,$16
,$17
,$18
,$19
,$20
,$21
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $2)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $13)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $15)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $17)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $19)
 FROM TABLE(RESULT_SCAN('01c39a45-0212-6dbe-24dd-07031944718b'))),
 stats as (SELECT
COUNT($1)
,COUNT($2)
,MIN($2)
,MAX($2)
,MIN($22)
,MAX($22)
,COUNT($3)
,COUNT($4)
,COUNT($5)
,MIN($5)
,MAX($5)
,SUM($5)
,AVG($5)
,COUNT($6)
,COUNT($7)
,COUNT($8)
,COUNT($9)
,COUNT($10)
,COUNT($11)
,COUNT($12)
,COUNT($13)
,MIN($13)
,MAX($13)
,MIN($23)
,MAX($23)
,COUNT($14)
,COUNT($15)
,MIN($15)
,MAX($15)
,MIN($24)
,MAX($24)
,COUNT($16)
,MIN($16)
,MAX($16)
,SUM($16)
,AVG($16)
,COUNT($17)
,MIN($17)
,MAX($17)
,MIN($25)
,MAX($25)
,COUNT($18)
,MIN($18)
,MAX($18)
,SUM($18)
,AVG($18)
,COUNT($19)
,MIN($19)
,MAX($19)
,MIN($26)
,MAX($26)
,COUNT($20)
,MIN($20)
,MAX($20)
,SUM($20)
,AVG($20)
,COUNT($21)
,MIN($21)
,MAX($21)
,SUM($21)
,AVG($21)
 FROM results)
 ,buckets1 AS (SELECT results.$1 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT CASE WHEN stats.$5 = stats.$6 THEN 1 ELSE WIDTH_BUCKET(results.$22, stats.$5, stats.$6 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT results.$4 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$10 = stats.$11 THEN 1 ELSE WIDTH_BUCKET(results.$5, stats.$10, stats.$11 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT results.$6 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT results.$7 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT results.$8 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT results.$9 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT results.$10 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT results.$11 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT results.$12 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT CASE WHEN stats.$24 = stats.$25 THEN 1 ELSE WIDTH_BUCKET(results.$23, stats.$24, stats.$25 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT results.$14 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT CASE WHEN stats.$30 = stats.$31 THEN 1 ELSE WIDTH_BUCKET(results.$24, stats.$30, stats.$31 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT CASE WHEN stats.$33 = stats.$34 THEN 1 ELSE WIDTH_BUCKET(results.$16, stats.$33, stats.$34 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT CASE WHEN stats.$40 = stats.$41 THEN 1 ELSE WIDTH_BUCKET(results.$25, stats.$40, stats.$41 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT CASE WHEN stats.$43 = stats.$44 THEN 1 ELSE WIDTH_BUCKET(results.$18, stats.$43, stats.$44 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT CASE WHEN stats.$50 = stats.$51 THEN 1 ELSE WIDTH_BUCKET(results.$26, stats.$50, stats.$51 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT CASE WHEN stats.$53 = stats.$54 THEN 1 ELSE WIDTH_BUCKET(results.$20, stats.$53, stats.$54 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats20 AS (SELECT OBJECT_AGG(b, c) FROM buckets20)
 ,buckets21 AS (SELECT CASE WHEN stats.$58 = stats.$59 THEN 1 ELSE WIDTH_BUCKET(results.$21, stats.$58, stats.$59 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats21 AS (SELECT OBJECT_AGG(b, c) FROM buckets21)
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
 ,stats21
