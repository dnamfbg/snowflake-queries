-- Query ID: 01c399cc-0212-6dbe-24dd-07031928f33f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:28:16.014000+00:00
-- Elapsed: 273ms
-- Environment: FBG

select RESOLUTION "Resolution", COUNTDISTINCT_58 "CountDistinct of Case Id", COUNTDISTINCT_59 "sort-ygzips0o49-0" from (select RESOLUTION, count(distinct CASE_ID) COUNTDISTINCT_58, COUNTDISTINCT_58 COUNTDISTINCT_59 from FBG_ANALYTICS.OPERATIONS.CHATBOT_CASES where date_trunc(day, CASE_CREATED_EST::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and CASE_TYPE in ('Account', 'Withdrawal', 'Deposit', 'Responsible Gaming', 'Taxes', 'FanaticsONE', 'FanApp', 'FanCash', 'Casino Payout', 'Casino Credit', 'Casino Errors') and RESOLUTION in ('Bot Resolved', 'Bot Created Email Case', 'Agent Resolved', 'Bot Completed', 'Bot Unresolved', 'Agent Completed', 'Full Unresolved', 'Abandoned') and case IS_AI_AGENT when 'False' then 'Chatbot' when 'True' then 'AI Agent' else null end is not null and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) >= to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by RESOLUTION) Q1 order by COUNTDISTINCT_59 desc, RESOLUTION asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Net-Zero-Health-Dashboard-3LBzlYO0NmPkyIBsM3GWZp?:displayNodeId=lA6agnLIwF","kind":"adhoc","request-id":"g019d73ee61307e3491cc4e6d64afc3dd","user-id":"FtGGBxLcALxCM9j7UBd51zQIMS7qp","email":"neshat.mohammadi@betfanatics.com"}
