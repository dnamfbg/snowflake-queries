-- Query ID: 01c39a56-0212-6cb9-24dd-07031948014f
-- Database: FBG_SOURCE
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Executed: 2026-04-09T22:46:14.746000+00:00
-- Elapsed: 4988ms
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
      (
          DATE(CONVERT_TIMEZONE('UTC','America/Anchorage',Created)) >= DATEADD(Day,-2,current_Date)
          OR DATE(CONVERT_TIMEZONE('UTC','America/Anchorage',Created)) = DATEADD(Day,-7,current_Date)
          OR DATE(CONVERT_TIMEZONE('UTC','America/Anchorage',Created)) = DATEADD(Day,-8,current_Date)
      )
      AND D.STATUS = 'DEPOSIT_SUCCESS'
      AND A.Test = 0
  GROUP BY 1
) "Custom SQL Query"
