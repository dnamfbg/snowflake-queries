-- Query ID: 01c399cc-0112-6b51-0000-e3072189ba5e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:21.086000+00:00
-- Elapsed: 1326ms
-- Environment: FES

select BONUS_TYPE "Bonus Type", DATETRUNC_21 "Day of Date Alk", SUM_22 "Sum of Amount" from (select BONUS_TYPE, date_trunc(day, DATE_ALK::timestamp_ltz) DATETRUNC_21, sum(AMOUNT) SUM_22 from FBG_FDE.FBG_USERS.V_F1_PROMO_LEDGER where "TRANSACTION" = 'awarded' and date_trunc(day, DATE_ALK::timestamp_ltz) >= to_timestamp_ltz('2026-03-26T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, DATE_ALK::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by BONUS_TYPE, DATETRUNC_21) Q1 order by BONUS_TYPE asc, DATETRUNC_21 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=qPyEyxuBaA","kind":"adhoc","request-id":"g019d73ee6f997561b4b3fa00f502fa61","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
