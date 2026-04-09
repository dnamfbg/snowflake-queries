-- Query ID: 01c399d9-0212-644a-24dd-0703192bb7c3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:41:56.063000+00:00
-- Elapsed: 494ms
-- Environment: FBG

select SWITCH_56 "View", DATEFORMAT_58 "Date Level of Case Created EST", DIV_62 "Containment %", COUNTDISTINCT_59 "Case Count" from (select case IS_AI_AGENT when 'False' then 'Chatbot' when 'True' then 'AI Agent' else null end SWITCH_56, to_char(date_trunc(day, CASE_CREATED_EST::timestamp_ltz), 'Mon" "DD", "YY') DATEFORMAT_58, count(distinct CASE_ID) COUNTDISTINCT_59, sum(CONTAINMENT) / nullif(COUNTDISTINCT_59, 0) DIV_62 from FBG_ANALYTICS.OPERATIONS.CHATBOT_CASES where date_trunc(day, CASE_CREATED_EST::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and CASE_TYPE in ('Account', 'Withdrawal', 'Deposit', 'Responsible Gaming', 'Taxes', 'FanaticsONE', 'FanApp', 'FanCash', 'Casino Payout', 'Casino Credit', 'Casino Errors') and RESOLUTION in ('Bot Resolved', 'Bot Created Email Case', 'Agent Resolved', 'Bot Completed', 'Bot Unresolved', 'Agent Completed', 'Full Unresolved', 'Abandoned') and case IS_AI_AGENT when 'False' then 'Chatbot' when 'True' then 'AI Agent' else null end is not null and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) >= to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by SWITCH_56, DATEFORMAT_58) Q1 order by SWITCH_56 asc, DATEFORMAT_58 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Net-Zero-Health-Dashboard-3LBzlYO0NmPkyIBsM3GWZp?:displayNodeId=RLsDGpoab3","kind":"adhoc","request-id":"g019d73fae1407fe1966773c7b32e12e4","user-id":"FtGGBxLcALxCM9j7UBd51zQIMS7qp","email":"neshat.mohammadi@betfanatics.com"}
