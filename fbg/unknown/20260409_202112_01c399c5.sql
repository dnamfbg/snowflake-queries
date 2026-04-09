-- Query ID: 01c399c5-0212-644a-24dd-0703192794a7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:21:12.745000+00:00
-- Elapsed: 3225ms
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
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $2)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $4)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $5)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $7)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $8)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $10)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $19)
 FROM TABLE(RESULT_SCAN('01c399c4-0212-6e7d-24dd-07031926f887'))),
 stats as (SELECT
COUNT($1)
,COUNT($2)
,MIN($2)
,MAX($2)
,MIN($21)
,MAX($21)
,COUNT($3)
,COUNT($4)
,MIN($4)
,MAX($4)
,MIN($22)
,MAX($22)
,COUNT($5)
,MIN($5)
,MAX($5)
,MIN($23)
,MAX($23)
,COUNT($6)
,COUNT($7)
,MIN($7)
,MAX($7)
,MIN($24)
,MAX($24)
,COUNT($8)
,MIN($8)
,MAX($8)
,MIN($25)
,MAX($25)
,COUNT($9)
,COUNT($10)
,MIN($10)
,MAX($10)
,MIN($26)
,MAX($26)
,COUNT($11)
,MIN($11)
,MAX($11)
,SUM($11)
,AVG($11)
,COUNT($12)
,COUNT($13)
,MIN($13)
,MAX($13)
,SUM($13)
,AVG($13)
,COUNT($14)
,COUNT($15)
,MIN($15)
,MAX($15)
,SUM($15)
,AVG($15)
,COUNT($16)
,MIN($16)
,MAX($16)
,SUM($16)
,AVG($16)
,COUNT($17)
,COUNT($18)
,COUNT($19)
,MIN($19)
,MAX($19)
,MIN($27)
,MAX($27)
,COUNT($20)
 FROM results)
 ,buckets1 AS (SELECT results.$1 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT CASE WHEN stats.$5 = stats.$6 THEN 1 ELSE WIDTH_BUCKET(results.$21, stats.$5, stats.$6 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$11 = stats.$12 THEN 1 ELSE WIDTH_BUCKET(results.$22, stats.$11, stats.$12 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$16 = stats.$17 THEN 1 ELSE WIDTH_BUCKET(results.$23, stats.$16, stats.$17 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT results.$6 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT CASE WHEN stats.$22 = stats.$23 THEN 1 ELSE WIDTH_BUCKET(results.$24, stats.$22, stats.$23 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT CASE WHEN stats.$27 = stats.$28 THEN 1 ELSE WIDTH_BUCKET(results.$25, stats.$27, stats.$28 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT results.$9 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT CASE WHEN stats.$33 = stats.$34 THEN 1 ELSE WIDTH_BUCKET(results.$26, stats.$33, stats.$34 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT CASE WHEN stats.$36 = stats.$37 THEN 1 ELSE WIDTH_BUCKET(results.$11, stats.$36, stats.$37 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT results.$12 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT CASE WHEN stats.$42 = stats.$43 THEN 1 ELSE WIDTH_BUCKET(results.$13, stats.$42, stats.$43 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT results.$14 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT CASE WHEN stats.$48 = stats.$49 THEN 1 ELSE WIDTH_BUCKET(results.$15, stats.$48, stats.$49 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT CASE WHEN stats.$53 = stats.$54 THEN 1 ELSE WIDTH_BUCKET(results.$16, stats.$53, stats.$54 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT results.$17 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT results.$18 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT CASE WHEN stats.$62 = stats.$63 THEN 1 ELSE WIDTH_BUCKET(results.$27, stats.$62, stats.$63 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT results.$20 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
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
