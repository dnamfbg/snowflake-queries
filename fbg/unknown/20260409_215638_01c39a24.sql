-- Query ID: 01c39a24-0212-6e7d-24dd-0703193ccb63
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:56:38.139000+00:00
-- Elapsed: 2742ms
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
,$22
,$23
,$24
,$25
,$26
,$27
,$28
,$29
,$30
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $5)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $12)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $18)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $22)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $23)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $29)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $30)
 FROM TABLE(RESULT_SCAN('01c39a24-0212-67a8-24dd-0703193d203f'))),
 stats as (SELECT
COUNT($1)
,COUNT($2)
,COUNT($3)
,COUNT($4)
,COUNT($5)
,MIN($5)
,MAX($5)
,MIN($31)
,MAX($31)
,COUNT($6)
,MIN($6)
,MAX($6)
,SUM($6)
,AVG($6)
,COUNT($7)
,COUNT($8)
,COUNT($9)
,MIN($9)
,MAX($9)
,SUM($9)
,AVG($9)
,COUNT($10)
,COUNT($11)
,COUNT($12)
,MIN($12)
,MAX($12)
,MIN($32)
,MAX($32)
,COUNT($13)
,COUNT($14)
,MIN($14)
,MAX($14)
,SUM($14)
,AVG($14)
,COUNT($15)
,COUNT($16)
,COUNT($17)
,COUNT($18)
,MIN($18)
,MAX($18)
,MIN($33)
,MAX($33)
,COUNT($19)
,COUNT($20)
,COUNT($21)
,COUNT($22)
,MIN($22)
,MAX($22)
,MIN($34)
,MAX($34)
,COUNT($23)
,MIN($23)
,MAX($23)
,MIN($35)
,MAX($35)
,COUNT($24)
,COUNT($25)
,COUNT($26)
,COUNT($27)
,MIN($27)
,MAX($27)
,SUM($27)
,AVG($27)
,COUNT($28)
,MIN($28)
,MAX($28)
,SUM($28)
,AVG($28)
,COUNT($29)
,MIN($29)
,MAX($29)
,MIN($36)
,MAX($36)
,COUNT($30)
,MIN($30)
,MAX($30)
,MIN($37)
,MAX($37)
 FROM results)
 ,buckets1 AS (SELECT results.$1 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT results.$2 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT results.$4 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$8 = stats.$9 THEN 1 ELSE WIDTH_BUCKET(results.$31, stats.$8, stats.$9 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT CASE WHEN stats.$11 = stats.$12 THEN 1 ELSE WIDTH_BUCKET(results.$6, stats.$11, stats.$12 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT results.$7 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT results.$8 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT CASE WHEN stats.$18 = stats.$19 THEN 1 ELSE WIDTH_BUCKET(results.$9, stats.$18, stats.$19 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT results.$10 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT results.$11 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT CASE WHEN stats.$27 = stats.$28 THEN 1 ELSE WIDTH_BUCKET(results.$32, stats.$27, stats.$28 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT results.$13 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT CASE WHEN stats.$31 = stats.$32 THEN 1 ELSE WIDTH_BUCKET(results.$14, stats.$31, stats.$32 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT results.$15 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT results.$16 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT results.$17 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT CASE WHEN stats.$41 = stats.$42 THEN 1 ELSE WIDTH_BUCKET(results.$33, stats.$41, stats.$42 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT results.$19 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT results.$20 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats20 AS (SELECT OBJECT_AGG(b, c) FROM buckets20)
 ,buckets21 AS (SELECT results.$21 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats21 AS (SELECT OBJECT_AGG(b, c) FROM buckets21)
 ,buckets22 AS (SELECT CASE WHEN stats.$49 = stats.$50 THEN 1 ELSE WIDTH_BUCKET(results.$34, stats.$49, stats.$50 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats22 AS (SELECT OBJECT_AGG(b, c) FROM buckets22)
 ,buckets23 AS (SELECT CASE WHEN stats.$54 = stats.$55 THEN 1 ELSE WIDTH_BUCKET(results.$35, stats.$54, stats.$55 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats23 AS (SELECT OBJECT_AGG(b, c) FROM buckets23)
 ,buckets24 AS (SELECT results.$24 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats24 AS (SELECT OBJECT_AGG(b, c) FROM buckets24)
 ,buckets25 AS (SELECT results.$25 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats25 AS (SELECT OBJECT_AGG(b, c) FROM buckets25)
 ,buckets26 AS (SELECT results.$26 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats26 AS (SELECT OBJECT_AGG(b, c) FROM buckets26)
 ,buckets27 AS (SELECT CASE WHEN stats.$60 = stats.$61 THEN 1 ELSE WIDTH_BUCKET(results.$27, stats.$60, stats.$61 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats27 AS (SELECT OBJECT_AGG(b, c) FROM buckets27)
 ,buckets28 AS (SELECT CASE WHEN stats.$65 = stats.$66 THEN 1 ELSE WIDTH_BUCKET(results.$28, stats.$65, stats.$66 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats28 AS (SELECT OBJECT_AGG(b, c) FROM buckets28)
 ,buckets29 AS (SELECT CASE WHEN stats.$72 = stats.$73 THEN 1 ELSE WIDTH_BUCKET(results.$36, stats.$72, stats.$73 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats29 AS (SELECT OBJECT_AGG(b, c) FROM buckets29)
 ,buckets30 AS (SELECT CASE WHEN stats.$77 = stats.$78 THEN 1 ELSE WIDTH_BUCKET(results.$37, stats.$77, stats.$78 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats30 AS (SELECT OBJECT_AGG(b, c) FROM buckets30)
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
 ,stats22
 ,stats23
 ,stats24
 ,stats25
 ,stats26
 ,stats27
 ,stats28
 ,stats29
 ,stats30
