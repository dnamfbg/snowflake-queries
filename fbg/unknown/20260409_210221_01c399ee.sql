-- Query ID: 01c399ee-0212-6b00-24dd-0703192fe5db
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:02:21.559000+00:00
-- Elapsed: 598ms
-- Environment: FBG

select AGENT_NAME_80 "Agent Name", ACTIVE_STATUS_81 "Active Status", START_DATE_82 "Start Date", SNAPSHOT_83 "Snapshot", IF_135 "Avg Quality Score", NULL_EQ_74, IF_137 "Avg Handle Time Minutes", NULL_EQ_75, IF_138 "Leaderboard Case Count", NULL_EQ_72, IF_136 "Quality Cases Reviewed", NULL_EQ_73 from (select equal_null(min(LEADERBOARD_CASE_COUNT), max(LEADERBOARD_CASE_COUNT)) NULL_EQ_72, equal_null(min(QUALITY_CASES_REVIEWED), max(QUALITY_CASES_REVIEWED)) NULL_EQ_73, equal_null(min(AVG_QUALITY_SCORE), max(AVG_QUALITY_SCORE)) NULL_EQ_74, equal_null(min(AVG_HANDLE_TIME_MINUTES), max(AVG_HANDLE_TIME_MINUTES)) NULL_EQ_75, AGENT_NAME AGENT_NAME_80, ACTIVE_STATUS ACTIVE_STATUS_81, START_DATE START_DATE_82, "SNAPSHOT" SNAPSHOT_83, iff(NULL_EQ_74, max(AVG_QUALITY_SCORE), null) IF_135, iff(NULL_EQ_73, max(QUALITY_CASES_REVIEWED), null) IF_136, iff(NULL_EQ_75, max(AVG_HANDLE_TIME_MINUTES), null) IF_137, iff(NULL_EQ_72, max(LEADERBOARD_CASE_COUNT), null) IF_138 from FBG_ANALYTICS.OPERATIONS.AGENT_NEW_HIRE_DASH_SUMMARY group by "SNAPSHOT", AGENT_NAME, ACTIVE_STATUS, START_DATE) Q1 order by AGENT_NAME_80 asc, ACTIVE_STATUS_81 asc, START_DATE_82 asc, SNAPSHOT_83 desc nulls last limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/L-and-D-New-Hire-Dashboard-5gbGBrT4XPKc71Zc6BYm0F?:displayNodeId=6xUdofc81S","kind":"adhoc","request-id":"g019d740d95ef759ab34eaf1c37bc3cbf","user-id":"TIC7p6LA32Ty5nNBfrAFztiHyDey0","email":"bryan.howard@betfanatics.com"}
