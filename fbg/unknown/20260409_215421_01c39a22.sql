-- Query ID: 01c39a22-0212-6cb9-24dd-0703193c7983
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:54:21.250000+00:00
-- Elapsed: 131ms
-- Environment: FBG

with W1 as (select Q1.CAST_46, iff(Q2.LVL2_ACTION_DATE = Q1.CAST_46, 1, 0) IF_63, iff(Q2.LVL3_ACTION_DATE = Q1.CAST_46, 1, 0) IF_64, iff(Q2.LVL1_ACTION_DATE = Q1.CAST_46, 1, 0) IF_65 from (select ACCO_ID, TRANSACTION_DATE::timestamp_ltz CAST_46 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_CENTRALIZE_DATA) Q1 left join FBG_GOVERNANCE.GOVERNANCE.SIGMA_AFFORDABILITY_CONDENSED Q2 on Q1.ACCO_ID = Q2.ACCO_ID) select SUM_74 "Sum of Action 1 Completion (Grand Total)", SUM_76 "Sum of Action 2 Completion (Grand Total)", SUM_75 "Sum of Action 3 Completion (Grand Total)", DATETRUNC_73 "Week of Transaction Date", SUM_71 "Sum of Action 1 Completion", SUM_70 "Sum of Action 2 Completion", SUM_72 "Sum of Action 3 Completion" from (select Q6.SUM_70, Q6.SUM_71, Q6.SUM_72, Q6.DATETRUNC_73, Q8.SUM_74, Q8.SUM_75, Q8.SUM_76 from (select sum(IF_63) SUM_70, sum(IF_65) SUM_71, sum(IF_64) SUM_72, dateadd('day', -1, date_trunc(week, dateadd('day', 1, CAST_46))) DATETRUNC_73 from W1 Q5 where dateadd('day', -1, date_trunc(week, dateadd('day', 1, CAST_46))) >= to_timestamp_ltz('2026-01-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_73 order by DATETRUNC_73 asc limit 10001) Q6 cross join (select sum(IF_65) SUM_74, sum(IF_64) SUM_75, sum(IF_63) SUM_76 from W1 Q7 where dateadd('day', -1, date_trunc(week, dateadd('day', 1, CAST_46))) >= to_timestamp_ltz('2026-01-01T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM')) Q8) Q10 order by DATETRUNC_73 asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear?:displayNodeId=IJR49dyOlg","kind":"adhoc","request-id":"g019d743d30e67d949efa3a8fea1a28a2","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
