-- Query ID: 01c39a5b-0212-6e7d-24dd-0703194911f3
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T22:51:11.982000+00:00
-- Elapsed: 5152ms
-- Run Count: 10
-- Environment: FBG

SELECT "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."DEPOSITS" AS "DEPOSITS"
FROM (
  SELECT 
      CONVERT_TIMEZONE('UTC','America/Anchorage',Created) AS Date,
      SUM(Amount) AS Deposits
  FROM FBG_SOURCE.OSB_SOURCE.Deposits D
  INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS A
      ON D.Acco_ID = A.ID
  WHERE 
      DATE(CONVERT_TIMEZONE('UTC','America/Anchorage',Created)) >= DATEADD(Day,-9,CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE()))
      AND D.STATUS = 'DEPOSIT_SUCCESS'
      AND A.Test = 0
  GROUP BY 1
) "Custom SQL Query"
