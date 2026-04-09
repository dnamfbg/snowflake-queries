-- Query ID: 01c39a3e-0212-67a8-24dd-07031942dd0f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T22:22:54.183000+00:00
-- Elapsed: 10607ms
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
,$31
,$32
,$33
,$34
,$35
,$36
,$37
,$38
,$39
,$40
,$41
,$42
,$43
,$44
,$45
,$46
,$47
,$48
,$49
,$50
,$51
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $20)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $45)
,DATEDIFF(day, DATE('1970-01-01', 'YYYY-MM-DD'), $46)
 FROM TABLE(RESULT_SCAN('01c39a1f-0212-67a9-24dd-0703193b9d97'))),
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
,COUNT($6)
,COUNT($7)
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
,COUNT($11)
,MIN($11)
,MAX($11)
,SUM($11)
,AVG($11)
,COUNT($12)
,COUNT($13)
,COUNT($14)
,MIN($14)
,MAX($14)
,SUM($14)
,AVG($14)
,COUNT($15)
,COUNT($16)
,MIN($16)
,MAX($16)
,SUM($16)
,AVG($16)
,COUNT($17)
,COUNT($18)
,MIN($18)
,MAX($18)
,SUM($18)
,AVG($18)
,COUNT($19)
,COUNT($20)
,MIN($20)
,MAX($20)
,MIN($52)
,MAX($52)
,COUNT($21)
,MIN($21)
,MAX($21)
,SUM($21)
,AVG($21)
,COUNT($22)
,COUNT($23)
,COUNT($24)
,MIN($24)
,MAX($24)
,SUM($24)
,AVG($24)
,COUNT($25)
,MIN($25)
,MAX($25)
,SUM($25)
,AVG($25)
,COUNT($26)
,MIN($26)
,MAX($26)
,SUM($26)
,AVG($26)
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
,SUM($29)
,AVG($29)
,COUNT($30)
,COUNT($31)
,COUNT($32)
,COUNT($33)
,MIN($33)
,MAX($33)
,SUM($33)
,AVG($33)
,COUNT($34)
,MIN($34)
,MAX($34)
,SUM($34)
,AVG($34)
,COUNT($35)
,COUNT($36)
,MIN($36)
,MAX($36)
,SUM($36)
,AVG($36)
,COUNT($37)
,COUNT($38)
,MIN($38)
,MAX($38)
,SUM($38)
,AVG($38)
,COUNT($39)
,COUNT($40)
,MIN($40)
,MAX($40)
,SUM($40)
,AVG($40)
,COUNT($41)
,COUNT($42)
,MIN($42)
,MAX($42)
,SUM($42)
,AVG($42)
,COUNT($43)
,COUNT($44)
,MIN($44)
,MAX($44)
,SUM($44)
,AVG($44)
,COUNT($45)
,MIN($45)
,MAX($45)
,MIN($53)
,MAX($53)
,COUNT($46)
,MIN($46)
,MAX($46)
,MIN($54)
,MAX($54)
,COUNT($47)
,MIN($47)
,MAX($47)
,SUM($47)
,AVG($47)
,COUNT($48)
,MIN($48)
,MAX($48)
,SUM($48)
,AVG($48)
,COUNT($49)
,MIN($49)
,MAX($49)
,SUM($49)
,AVG($49)
,COUNT($50)
,MIN($50)
,MAX($50)
,SUM($50)
,AVG($50)
,COUNT($51)
,MIN($51)
,MAX($51)
,SUM($51)
,AVG($51)
 FROM results)
 ,buckets1 AS (SELECT CASE WHEN stats.$2 = stats.$3 THEN 1 ELSE WIDTH_BUCKET(results.$1, stats.$2, stats.$3 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats1 AS (SELECT OBJECT_AGG(b, c) FROM buckets1)
 ,buckets2 AS (SELECT results.$2 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats2 AS (SELECT OBJECT_AGG(b, c) FROM buckets2)
 ,buckets3 AS (SELECT results.$3 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats3 AS (SELECT OBJECT_AGG(b, c) FROM buckets3)
 ,buckets4 AS (SELECT CASE WHEN stats.$9 = stats.$10 THEN 1 ELSE WIDTH_BUCKET(results.$4, stats.$9, stats.$10 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats4 AS (SELECT OBJECT_AGG(b, c) FROM buckets4)
 ,buckets5 AS (SELECT results.$5 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats5 AS (SELECT OBJECT_AGG(b, c) FROM buckets5)
 ,buckets6 AS (SELECT results.$6 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats6 AS (SELECT OBJECT_AGG(b, c) FROM buckets6)
 ,buckets7 AS (SELECT results.$7 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats7 AS (SELECT OBJECT_AGG(b, c) FROM buckets7)
 ,buckets8 AS (SELECT CASE WHEN stats.$17 = stats.$18 THEN 1 ELSE WIDTH_BUCKET(results.$8, stats.$17, stats.$18 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats8 AS (SELECT OBJECT_AGG(b, c) FROM buckets8)
 ,buckets9 AS (SELECT CASE WHEN stats.$22 = stats.$23 THEN 1 ELSE WIDTH_BUCKET(results.$9, stats.$22, stats.$23 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats9 AS (SELECT OBJECT_AGG(b, c) FROM buckets9)
 ,buckets10 AS (SELECT results.$10 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats10 AS (SELECT OBJECT_AGG(b, c) FROM buckets10)
 ,buckets11 AS (SELECT CASE WHEN stats.$28 = stats.$29 THEN 1 ELSE WIDTH_BUCKET(results.$11, stats.$28, stats.$29 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats11 AS (SELECT OBJECT_AGG(b, c) FROM buckets11)
 ,buckets12 AS (SELECT results.$12 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats12 AS (SELECT OBJECT_AGG(b, c) FROM buckets12)
 ,buckets13 AS (SELECT results.$13 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats13 AS (SELECT OBJECT_AGG(b, c) FROM buckets13)
 ,buckets14 AS (SELECT CASE WHEN stats.$35 = stats.$36 THEN 1 ELSE WIDTH_BUCKET(results.$14, stats.$35, stats.$36 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats14 AS (SELECT OBJECT_AGG(b, c) FROM buckets14)
 ,buckets15 AS (SELECT results.$15 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats15 AS (SELECT OBJECT_AGG(b, c) FROM buckets15)
 ,buckets16 AS (SELECT CASE WHEN stats.$41 = stats.$42 THEN 1 ELSE WIDTH_BUCKET(results.$16, stats.$41, stats.$42 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats16 AS (SELECT OBJECT_AGG(b, c) FROM buckets16)
 ,buckets17 AS (SELECT results.$17 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats17 AS (SELECT OBJECT_AGG(b, c) FROM buckets17)
 ,buckets18 AS (SELECT CASE WHEN stats.$47 = stats.$48 THEN 1 ELSE WIDTH_BUCKET(results.$18, stats.$47, stats.$48 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats18 AS (SELECT OBJECT_AGG(b, c) FROM buckets18)
 ,buckets19 AS (SELECT results.$19 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats19 AS (SELECT OBJECT_AGG(b, c) FROM buckets19)
 ,buckets20 AS (SELECT CASE WHEN stats.$55 = stats.$56 THEN 1 ELSE WIDTH_BUCKET(results.$52, stats.$55, stats.$56 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats20 AS (SELECT OBJECT_AGG(b, c) FROM buckets20)
 ,buckets21 AS (SELECT CASE WHEN stats.$58 = stats.$59 THEN 1 ELSE WIDTH_BUCKET(results.$21, stats.$58, stats.$59 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats21 AS (SELECT OBJECT_AGG(b, c) FROM buckets21)
 ,buckets22 AS (SELECT results.$22 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats22 AS (SELECT OBJECT_AGG(b, c) FROM buckets22)
 ,buckets23 AS (SELECT results.$23 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats23 AS (SELECT OBJECT_AGG(b, c) FROM buckets23)
 ,buckets24 AS (SELECT CASE WHEN stats.$65 = stats.$66 THEN 1 ELSE WIDTH_BUCKET(results.$24, stats.$65, stats.$66 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats24 AS (SELECT OBJECT_AGG(b, c) FROM buckets24)
 ,buckets25 AS (SELECT CASE WHEN stats.$70 = stats.$71 THEN 1 ELSE WIDTH_BUCKET(results.$25, stats.$70, stats.$71 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats25 AS (SELECT OBJECT_AGG(b, c) FROM buckets25)
 ,buckets26 AS (SELECT CASE WHEN stats.$75 = stats.$76 THEN 1 ELSE WIDTH_BUCKET(results.$26, stats.$75, stats.$76 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats26 AS (SELECT OBJECT_AGG(b, c) FROM buckets26)
 ,buckets27 AS (SELECT CASE WHEN stats.$80 = stats.$81 THEN 1 ELSE WIDTH_BUCKET(results.$27, stats.$80, stats.$81 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats27 AS (SELECT OBJECT_AGG(b, c) FROM buckets27)
 ,buckets28 AS (SELECT CASE WHEN stats.$85 = stats.$86 THEN 1 ELSE WIDTH_BUCKET(results.$28, stats.$85, stats.$86 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats28 AS (SELECT OBJECT_AGG(b, c) FROM buckets28)
 ,buckets29 AS (SELECT CASE WHEN stats.$90 = stats.$91 THEN 1 ELSE WIDTH_BUCKET(results.$29, stats.$90, stats.$91 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats29 AS (SELECT OBJECT_AGG(b, c) FROM buckets29)
 ,buckets30 AS (SELECT results.$30 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats30 AS (SELECT OBJECT_AGG(b, c) FROM buckets30)
 ,buckets31 AS (SELECT results.$31 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats31 AS (SELECT OBJECT_AGG(b, c) FROM buckets31)
 ,buckets32 AS (SELECT results.$32 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats32 AS (SELECT OBJECT_AGG(b, c) FROM buckets32)
 ,buckets33 AS (SELECT CASE WHEN stats.$98 = stats.$99 THEN 1 ELSE WIDTH_BUCKET(results.$33, stats.$98, stats.$99 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats33 AS (SELECT OBJECT_AGG(b, c) FROM buckets33)
 ,buckets34 AS (SELECT CASE WHEN stats.$103 = stats.$104 THEN 1 ELSE WIDTH_BUCKET(results.$34, stats.$103, stats.$104 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats34 AS (SELECT OBJECT_AGG(b, c) FROM buckets34)
 ,buckets35 AS (SELECT results.$35 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats35 AS (SELECT OBJECT_AGG(b, c) FROM buckets35)
 ,buckets36 AS (SELECT CASE WHEN stats.$109 = stats.$110 THEN 1 ELSE WIDTH_BUCKET(results.$36, stats.$109, stats.$110 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats36 AS (SELECT OBJECT_AGG(b, c) FROM buckets36)
 ,buckets37 AS (SELECT results.$37 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats37 AS (SELECT OBJECT_AGG(b, c) FROM buckets37)
 ,buckets38 AS (SELECT CASE WHEN stats.$115 = stats.$116 THEN 1 ELSE WIDTH_BUCKET(results.$38, stats.$115, stats.$116 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats38 AS (SELECT OBJECT_AGG(b, c) FROM buckets38)
 ,buckets39 AS (SELECT results.$39 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats39 AS (SELECT OBJECT_AGG(b, c) FROM buckets39)
 ,buckets40 AS (SELECT CASE WHEN stats.$121 = stats.$122 THEN 1 ELSE WIDTH_BUCKET(results.$40, stats.$121, stats.$122 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats40 AS (SELECT OBJECT_AGG(b, c) FROM buckets40)
 ,buckets41 AS (SELECT results.$41 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats41 AS (SELECT OBJECT_AGG(b, c) FROM buckets41)
 ,buckets42 AS (SELECT CASE WHEN stats.$127 = stats.$128 THEN 1 ELSE WIDTH_BUCKET(results.$42, stats.$127, stats.$128 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats42 AS (SELECT OBJECT_AGG(b, c) FROM buckets42)
 ,buckets43 AS (SELECT results.$43 AS b, COUNT(*) as c FROM results GROUP BY b ORDER BY c DESC LIMIT 100)
 ,stats43 AS (SELECT OBJECT_AGG(b, c) FROM buckets43)
 ,buckets44 AS (SELECT CASE WHEN stats.$133 = stats.$134 THEN 1 ELSE WIDTH_BUCKET(results.$44, stats.$133, stats.$134 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats44 AS (SELECT OBJECT_AGG(b, c) FROM buckets44)
 ,buckets45 AS (SELECT CASE WHEN stats.$140 = stats.$141 THEN 1 ELSE WIDTH_BUCKET(results.$53, stats.$140, stats.$141 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats45 AS (SELECT OBJECT_AGG(b, c) FROM buckets45)
 ,buckets46 AS (SELECT CASE WHEN stats.$145 = stats.$146 THEN 1 ELSE WIDTH_BUCKET(results.$54, stats.$145, stats.$146 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats46 AS (SELECT OBJECT_AGG(b, c) FROM buckets46)
 ,buckets47 AS (SELECT CASE WHEN stats.$148 = stats.$149 THEN 1 ELSE WIDTH_BUCKET(results.$47, stats.$148, stats.$149 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats47 AS (SELECT OBJECT_AGG(b, c) FROM buckets47)
 ,buckets48 AS (SELECT CASE WHEN stats.$153 = stats.$154 THEN 1 ELSE WIDTH_BUCKET(results.$48, stats.$153, stats.$154 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats48 AS (SELECT OBJECT_AGG(b, c) FROM buckets48)
 ,buckets49 AS (SELECT CASE WHEN stats.$158 = stats.$159 THEN 1 ELSE WIDTH_BUCKET(results.$49, stats.$158, stats.$159 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats49 AS (SELECT OBJECT_AGG(b, c) FROM buckets49)
 ,buckets50 AS (SELECT CASE WHEN stats.$163 = stats.$164 THEN 1 ELSE WIDTH_BUCKET(results.$50, stats.$163, stats.$164 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats50 AS (SELECT OBJECT_AGG(b, c) FROM buckets50)
 ,buckets51 AS (SELECT CASE WHEN stats.$168 = stats.$169 THEN 1 ELSE WIDTH_BUCKET(results.$51, stats.$168, stats.$169 + 1, 10) END AS b, COUNT(*) AS c FROM results, stats GROUP BY b)
 ,stats51 AS (SELECT OBJECT_AGG(b, c) FROM buckets51)
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
 ,stats31
 ,stats32
 ,stats33
 ,stats34
 ,stats35
 ,stats36
 ,stats37
 ,stats38
 ,stats39
 ,stats40
 ,stats41
 ,stats42
 ,stats43
 ,stats44
 ,stats45
 ,stats46
 ,stats47
 ,stats48
 ,stats49
 ,stats50
 ,stats51
