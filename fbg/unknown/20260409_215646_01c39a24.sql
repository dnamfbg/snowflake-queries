-- Query ID: 01c39a24-0212-6e7d-24dd-0703193ccc3b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:56:46.319000+00:00
-- Elapsed: 16158ms
-- Environment: FBG

select AGENT_NAME "Agent Name", DATETRUNC_146 "Day of Agent Join Time", AVG_147 "Avg of Qualityscore" from (select Q5.AGENT_NAME, date_trunc(day, Q1.AGENT_JOIN_TIME::timestamp_ltz) DATETRUNC_146, avg(Q1.QUALITYSCORE) AVG_147 from (select * from FBG_ANALYTICS.OPERATIONS.AGENT_QUALITY_BASE where date_trunc(day, AGENT_JOIN_TIME::timestamp_ltz) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, AGENT_JOIN_TIME::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 left join FBG_ANALYTICS.OPERATIONS.CS_CASES Q2 on Q1.CASE_NUMBER = Q2.CASE_NUMBER left join FBG_ANALYTICS.OPERATIONS.AGENT_MASTER_ROSTER Q5 on Q1.AGENTID = Q5.SALESFORCE_ID group by Q5.AGENT_NAME, DATETRUNC_146) Q4 order by AGENT_NAME asc, DATETRUNC_146 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Agent-Quality-TL-Dashboard-9zSxzwNdWS4QhrvXf6NW2?:displayNodeId=qveD5HF1dn","kind":"adhoc","request-id":"g019d743f65b87d57a5cc0e8adc9677c6","user-id":"oVUu77Xwwdsv3pRfk30aywFxPUuBg","email":"eli.herrera@betfanatics.com"}
