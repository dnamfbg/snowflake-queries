-- Query ID: 01c399cc-0212-6dbe-24dd-07031928f68b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:28:55.130000+00:00
-- Elapsed: 601ms
-- Environment: FBG

select MIN_20 "ESBCfzRwTW-min", MAX_21 "ESBCfzRwTW-max", MIN_22 "1GYRXT5UQF-min", MAX_23 "1GYRXT5UQF-max", PAYMENT_METHOD_13 "Payment Method", SUM_26 "sort-l9QWFDXEot-0", "Deposit/Withdrawal_Method_14" "Deposit Withdrawal Method", SUM_12 "Amount", SUM_11 "Transaction Count" from (select SUM_11, SUM_12, PAYMENT_METHOD_13, "Deposit/Withdrawal_Method_14", MIN_20, MAX_21, MIN_22, MAX_23, SUM_26 from (select Q1.SUM_11, Q1.SUM_12, Q1.PAYMENT_METHOD_13, Q1."Deposit/Withdrawal_Method_14", Q3.MIN_20, Q3.MAX_21, Q3.MIN_22, Q3.MAX_23, Q6.PAYMENT_METHOD_25, Q6.SUM_26 from (select sum(TRANSACTION_COUNT) SUM_11, sum(AMOUNT) SUM_12, PAYMENT_METHOD PAYMENT_METHOD_13, "Deposit/Withdrawal_Method" "Deposit/Withdrawal_Method_14" from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 2241182 group by PAYMENT_METHOD, "Deposit/Withdrawal_Method") Q1 cross join (select min(SUM_12) MIN_20, max(SUM_12) MAX_21, min(SUM_11) MIN_22, max(SUM_11) MAX_23 from (select sum(TRANSACTION_COUNT) SUM_11, sum(AMOUNT) SUM_12 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 2241182 group by PAYMENT_METHOD, "Deposit/Withdrawal_Method") Q2) Q3 left join (select PAYMENT_METHOD PAYMENT_METHOD_25, sum(AMOUNT) SUM_26 from FBG_GOVERNANCE.GOVERNANCE.WALLET_HISTORY where ACCOUNT_ID = 2241182 group by PAYMENT_METHOD) Q6 on equal_null(Q1.PAYMENT_METHOD_13, Q6.PAYMENT_METHOD_25) order by Q6.SUM_26 desc nulls last, Q1.PAYMENT_METHOD_13 asc, Q1."Deposit/Withdrawal_Method_14" asc limit 10001) Q5) Q8 order by SUM_26 desc nulls last, PAYMENT_METHOD_13 asc, "Deposit/Withdrawal_Method_14" asc limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Withdrawal-Review-Dashboard-2NUdxvnoRn7VZK5BPtvRBA?:displayNodeId=ZjRZyQzE3r","kind":"adhoc","request-id":"g019d73eef857786386a208cfc714c5b3.2","user-id":"zmNf9h66aBZT20t7V3BzC2LbZz0l9","email":"luke.donofrio@betfanatics.com"}
