-- Query ID: 01c39a23-0212-6e7d-24dd-0703193c6fdf
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:55:01.889000+00:00
-- Elapsed: 2951ms
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
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $2)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $7)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $9)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $13)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $14)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $17)
 FROM TABLE(RESULT_SCAN('01c361be-0212-3441-24dd-07030cdabce3'))),
 stats as (SELECT
COUNT($1)
,MIN($1)
,MAX($1)
,SUM($1)
,AVG($1)
,COUNT($2)
,MIN($2)
,MAX($2)
,MIN($28)
,MAX($28)
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
,COUNT($7)
,MIN($7)
,MAX($7)
,MIN($29)
,MAX($29)
,COUNT($8)
,MIN($8)
,MAX($8)
,SUM($8)
,AVG($8)
,COUNT($9)
,MIN($9)
,MAX($9)
,MIN($30)
,MAX($30)
,COUNT($10)
,MIN($10)
,MAX($10)
,SUM($10)
,AVG($10)
,COUNT($11)
,COUNT($12)
,MIN($12)
,MAX($12)
,SUM($12)
,AVG($12)
,COUNT($13)
,MIN($13)
,MAX($13)
,MIN($31)
,MAX($31)
,COUNT($14)
,MIN($14)
,MAX($14)
,MIN($32)
,MAX($32)
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
,MIN($17)
,MAX($17)
,MIN($33)
,MAX($33)
,COUNT($18)
,COUNT($19)
,COUNT($20)
,COUNT($21)
,COUNT($22)
,COUNT($23)
,COUNT($24)
,COUNT($25)
,COUNT($26)
,COUNT($27)
,MIN($27)
,MAX($27)
,SUM($27)
,AVG($27)
 FROM results)
 ,buckets1 AS (SELECT CASE WHEN stats.$2 = stats.$3 THEN 1 ELSE WIDTH_BUCKET(results.$1, stats.$2, stats.$3 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT CASE WHEN stats.$9 = stats.$10 THEN 1 ELSE WIDTH_BUCKET(results.$28, stats.$9, stats.$10 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$13 = stats.$14 THEN 1 ELSE WIDTH_BUCKET(results.$4, stats.$13, stats.$14 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT CASE WHEN stats.$18 = stats.$19 THEN 1 ELSE WIDTH_BUCKET(results.$5, stats.$18, stats.$19 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT results.$6 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT CASE WHEN stats.$26 = stats.$27 THEN 1 ELSE WIDTH_BUCKET(results.$29, stats.$26, stats.$27 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT CASE WHEN stats.$29 = stats.$30 THEN 1 ELSE WIDTH_BUCKET(results.$8, stats.$29, stats.$30 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT CASE WHEN stats.$36 = stats.$37 THEN 1 ELSE WIDTH_BUCKET(results.$30, stats.$36, stats.$37 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT CASE WHEN stats.$39 = stats.$40 THEN 1 ELSE WIDTH_BUCKET(results.$10, stats.$39, stats.$40 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT results.$11 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT CASE WHEN stats.$45 = stats.$46 THEN 1 ELSE WIDTH_BUCKET(results.$12, stats.$45, stats.$46 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT CASE WHEN stats.$52 = stats.$53 THEN 1 ELSE WIDTH_BUCKET(results.$31, stats.$52, stats.$53 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT CASE WHEN stats.$57 = stats.$58 THEN 1 ELSE WIDTH_BUCKET(results.$32, stats.$57, stats.$58 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT CASE WHEN stats.$60 = stats.$61 THEN 1 ELSE WIDTH_BUCKET(results.$15, stats.$60, stats.$61 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT CASE WHEN stats.$65 = stats.$66 THEN 1 ELSE WIDTH_BUCKET(results.$16, stats.$65, stats.$66 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT CASE WHEN stats.$72 = stats.$73 THEN 1 ELSE WIDTH_BUCKET(results.$33, stats.$72, stats.$73 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT results.$18 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT results.$19 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT results.$20 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats20 AS (SELECT OBJECT_AGG(b, c) FROM buckets20)
 ,buckets21 AS (SELECT results.$21 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats21 AS (SELECT OBJECT_AGG(b, c) FROM buckets21)
 ,buckets22 AS (SELECT results.$22 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats22 AS (SELECT OBJECT_AGG(b, c) FROM buckets22)
 ,buckets23 AS (SELECT results.$23 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats23 AS (SELECT OBJECT_AGG(b, c) FROM buckets23)
 ,buckets24 AS (SELECT results.$24 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats24 AS (SELECT OBJECT_AGG(b, c) FROM buckets24)
 ,buckets25 AS (SELECT results.$25 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats25 AS (SELECT OBJECT_AGG(b, c) FROM buckets25)
 ,buckets26 AS (SELECT results.$26 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats26 AS (SELECT OBJECT_AGG(b, c) FROM buckets26)
 ,buckets27 AS (SELECT CASE WHEN stats.$84 = stats.$85 THEN 1 ELSE WIDTH_BUCKET(results.$27, stats.$84, stats.$85 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats27 AS (SELECT OBJECT_AGG(b, c) FROM buckets27)
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
