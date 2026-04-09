-- Query ID: 01c399f8-0112-6544-0000-e307218b0986
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:12:55.657000+00:00
-- Elapsed: 4634ms
-- Environment: FES

select DATETRUNC_132 "Day", IF_137 "% OSB- State Eligible to FTU", NULL_EQ_133, IF_138 "% FTU Eligible with Xsell Interaction", NULL_EQ_135 from (select date_trunc(day, Q1.DATETRUNC_50) DATETRUNC_132, equal_null(min(Q2.DIV_125), max(Q2.DIV_125)) NULL_EQ_133, equal_null(min(Q2.DIV_122), max(Q2.DIV_122)) NULL_EQ_135, iff(NULL_EQ_133, max(Q2.DIV_125), null) IF_137, iff(NULL_EQ_135, max(Q2.DIV_122), null) IF_138 from (select dateadd('day', -1, date_trunc(week, dateadd('day', 1, AMPLITUDE_EVENT_DATE::timestamp_ltz))) DATETRUNC_50 from FES_USERS.DYLAN_TUCH.FTU_FUNNEL where date_trunc(day, AMPLITUDE_EVENT_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-15T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, AMPLITUDE_EVENT_DATE::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q1 left join (select dateadd('day', -1, date_trunc(week, dateadd('day', 1, AMPLITUDE_EVENT_DATE::timestamp_ltz))) DATETRUNC_116, count(distinct TOTAL_FTU_XSELL_USERS) / nullif(count(distinct TOTAL_FTU_ELIGIBLE_USERS), 0) DIV_122, count(distinct TOTAL_FTU_ELIGIBLE_USERS) / nullif(count(distinct OSB_STATE_USERS), 0) DIV_125 from FES_USERS.DYLAN_TUCH.FTU_FUNNEL where date_trunc(day, AMPLITUDE_EVENT_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-15T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, AMPLITUDE_EVENT_DATE::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_116) Q2 on equal_null(Q1.DATETRUNC_50, Q2.DATETRUNC_116) group by DATETRUNC_132) Q4 order by DATETRUNC_132 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/FTU-Funnel-Dashboard-6RCwOJspMrBYPKxZJTSjGR?:displayNodeId=TnkeP1PhwL","kind":"adhoc","request-id":"g019d741744327d9383dab6ffdd7533e0","user-id":"hB2tvj6fdX8ZeSJLNj3TQqBHtHqng","email":"ben.horgan@betfanatics.com"}
