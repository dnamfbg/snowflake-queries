-- Query ID: 01c39a24-0212-67a8-24dd-0703193d21c7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:56:55.156000+00:00
-- Elapsed: 11529ms
-- Environment: FBG

select AGENTNAME "TopK Value", COUNT_151 "TopK Count", ISNULL_156 "TopK Null Sort", AGENTNAME_157 "Text Seach Column" from (select *, AGENTNAME is null ISNULL_156, AGENTNAME AGENTNAME_157 from (select Q1.AGENTNAME, count(1) COUNT_151 from (select * from FBG_ANALYTICS.OPERATIONS.AGENT_QUALITY_BASE where contains(lower(AGENTNAME), lower('gaga')) and date_trunc(day, AGENT_JOIN_TIME::timestamp_ltz) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, AGENT_JOIN_TIME::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 left join FBG_ANALYTICS.OPERATIONS.CS_CASES Q2 on Q1.CASE_NUMBER = Q2.CASE_NUMBER left join FBG_ANALYTICS.OPERATIONS.AGENT_MASTER_ROSTER Q5 on Q1.AGENTID = Q5.SALESFORCE_ID group by Q1.AGENTNAME) Q4) Q7 order by ISNULL_156 desc, COUNT_151 desc, AGENTNAME asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Agent-Quality-TL-Dashboard-9zSxzwNdWS4QhrvXf6NW2","kind":"adhoc","request-id":"g019d743f8a0e7dd5a7b6f74a1da4ef9f","user-id":"oVUu77Xwwdsv3pRfk30aywFxPUuBg","email":"eli.herrera@betfanatics.com"}
