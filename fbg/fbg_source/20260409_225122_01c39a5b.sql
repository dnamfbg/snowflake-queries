-- Query ID: 01c39a5b-0212-67a9-24dd-0703194904bf
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Last Executed: 2026-04-09T22:51:22.910000+00:00
-- Elapsed: 5830ms
-- Run Count: 10
-- Environment: FBG

SELECT "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."WITHDRAWALS" AS "WITHDRAWALS"
FROM (
  SELECT CONVERT_TIMEZONE('UTC','America/Anchorage',Completed_At) AS Date,
  SUM(Amount) AS Withdrawals
  FROM FBG_SOURCE.OSB_SOURCE.Withdrawals W
  INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS A
  ON W.Account_ID = A.ID
  WHERE (DATE(CONVERT_TIMEZONE('UTC','America/Anchorage',Completed_At)) >= DATEADD(Day,-9,CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE()))) 
  AND W.STATUS = 'WITHDRAWAL_COMPLETED'
  AND A.Test = 0 
  GROUP BY 1
) "Custom SQL Query"
