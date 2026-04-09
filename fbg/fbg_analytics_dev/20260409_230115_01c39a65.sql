-- Query ID: 01c39a65-0212-67a9-24dd-0703194abf3b
-- Database: FBG_ANALYTICS_DEV
-- Schema: ZACK_ASHLEY
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T23:01:15.465000+00:00
-- Elapsed: 7689ms
-- Run Count: 15
-- Environment: FBG

CREATE OR REPLACE TEMPORARY TABLE Cas_Lifetime AS
SELECT c.acco_id, 
SUM(GGR) AS Cas_GGR
FROM FBG_ANALYTICS_ENGINEERING.casino.casino_daily_settled_agg C
INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
ON A.ID = C.Acco_ID
WHERE A.Test = 0
GROUP BY ALL
