-- Query ID: 01c399ec-0212-6dbe-24dd-0703192f55eb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:00:11.139000+00:00
-- Elapsed: 247ms
-- Environment: FBG

select AGENT_NAME_78 "Agent Name", ACTIVE_STATUS_79 "Active Status", START_DATE_80 "Start Date", SNAPSHOT_81 "Snapshot", IF_121 "Avg Quality Score", NULL_EQ_74, IF_123 "Leaderboard Case Count", NULL_EQ_73, IF_122 "Avg Handle Time Minutes", NULL_EQ_72 from (select equal_null(min(AVG_HANDLE_TIME_MINUTES), max(AVG_HANDLE_TIME_MINUTES)) NULL_EQ_72, equal_null(min(LEADERBOARD_CASE_COUNT), max(LEADERBOARD_CASE_COUNT)) NULL_EQ_73, equal_null(min(AVG_QUALITY_SCORE), max(AVG_QUALITY_SCORE)) NULL_EQ_74, AGENT_NAME AGENT_NAME_78, ACTIVE_STATUS ACTIVE_STATUS_79, START_DATE START_DATE_80, "SNAPSHOT" SNAPSHOT_81, iff(NULL_EQ_74, max(AVG_QUALITY_SCORE), null) IF_121, iff(NULL_EQ_72, max(AVG_HANDLE_TIME_MINUTES), null) IF_122, iff(NULL_EQ_73, max(LEADERBOARD_CASE_COUNT), null) IF_123 from FBG_ANALYTICS.OPERATIONS.AGENT_NEW_HIRE_DASH_SUMMARY group by AGENT_NAME, ACTIVE_STATUS, "SNAPSHOT", START_DATE) Q1 order by AGENT_NAME_78 asc, ACTIVE_STATUS_79 asc, START_DATE_80 asc, SNAPSHOT_81 desc nulls last limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/L-and-D-New-Hire-Dashboard-5gbGBrT4XPKc71Zc6BYm0F?:displayNodeId=6xUdofc81S","kind":"adhoc","request-id":"g019d740b94ea74709a4b57ca22fce880","user-id":"TIC7p6LA32Ty5nNBfrAFztiHyDey0","email":"bryan.howard@betfanatics.com"}
