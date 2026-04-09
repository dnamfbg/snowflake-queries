-- Query ID: 01c399da-0212-67a8-24dd-0703192c006b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:42:15.112000+00:00
-- Elapsed: 219ms
-- Environment: FBG

select CASE_TYPE_56 "View", DATEFORMAT_58 "Date Level of Case Created EST", MEDIAN_60 "Median Bot Handle Time", COUNTDISTINCT_59 "Case Count", DIV_63 "Containment %" from (select CASE_TYPE CASE_TYPE_56, to_char(date_trunc(day, CASE_CREATED_EST::timestamp_ltz), 'Mon" "DD", "YY') DATEFORMAT_58, count(distinct CASE_ID) COUNTDISTINCT_59, median(abs(datediff(second, coalesce(least(LAST_BOT_MESSAGE_TIME::timestamp_ltz, FIRST_AGENT_MESSAGE_TIME::timestamp_ltz), LAST_BOT_MESSAGE_TIME::timestamp_ltz), FIRST_MESSAGE_TIME::timestamp_ltz)) / 60) MEDIAN_60, sum(CONTAINMENT) / nullif(COUNTDISTINCT_59, 0) DIV_63 from FBG_ANALYTICS.OPERATIONS.CHATBOT_CASES where date_trunc(day, CASE_CREATED_EST::timestamp_ltz) < to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and CASE_TYPE in ('Account', 'Withdrawal', 'Deposit', 'Responsible Gaming', 'Taxes', 'FanaticsONE', 'FanApp', 'FanCash', 'Casino Payout', 'Casino Credit', 'Casino Errors') and RESOLUTION in ('Bot Resolved', 'Bot Created Email Case', 'Agent Resolved', 'Bot Completed', 'Bot Unresolved', 'Agent Completed', 'Full Unresolved', 'Abandoned') and case IS_AI_AGENT when 'False' then 'Chatbot' when 'True' then 'AI Agent' else null end is not null and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) >= to_timestamp_ltz('2026-04-02T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, CASE_CREATED_EST::timestamp_ltz) <= to_timestamp_ltz('2026-04-09T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by CASE_TYPE, DATEFORMAT_58) Q1 order by CASE_TYPE_56 asc, DATEFORMAT_58 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Net-Zero-Health-Dashboard-3LBzlYO0NmPkyIBsM3GWZp?:displayNodeId=dAPikyYsX_","kind":"adhoc","request-id":"g019d73fb2cbd7d5698d9d89538eb4833","user-id":"FtGGBxLcALxCM9j7UBd51zQIMS7qp","email":"neshat.mohammadi@betfanatics.com"}
