-- Query ID: 01c39a56-0212-6dbe-24dd-07031947f0e7
-- Database: FBG_SOURCE
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Last Executed: 2026-04-09T22:46:07.113000+00:00
-- Elapsed: 5376ms
-- Run Count: 3
-- Environment: FBG

SELECT "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."WITHDRAWALS" AS "WITHDRAWALS"
FROM (
  SELECT CONVERT_TIMEZONE('UTC','America/New_York',Completed_At) AS Date,
  SUM(Amount) AS Withdrawals
  FROM FBG_SOURCE.OSB_SOURCE.Withdrawals W
  INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS A
  ON W.Account_ID = A.ID
  WHERE (DATE(CONVERT_TIMEZONE('UTC','America/New_York',Completed_At)) >= DATEADD(Day,-2,current_Date) OR 
  DATE(CONVERT_TIMEZONE('UTC','America/New_York',Completed_At)) = DATEADD(Day,-7,current_Date) OR 
  DATE(CONVERT_TIMEZONE('UTC','America/New_York',Completed_At)) = DATEADD(Day,-8,current_Date)) 
  AND W.STATUS = 'WITHDRAWAL_COMPLETED'
  AND A.Test = 0 
  GROUP BY 1
) "Custom SQL Query"
