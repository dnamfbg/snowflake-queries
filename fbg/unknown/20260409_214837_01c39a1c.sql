-- Query ID: 01c39a1c-0212-67a8-24dd-0703193b2a1b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:48:37.666000+00:00
-- Elapsed: 707ms
-- Environment: FBG

select ACCO_ID_NECCTON "Acco Id", V_26 "RG Notes Add", CAST_25 "Trigger Date", ONE_K_FLAG "One K Flag", MONETARY_RISK_FLAG "Monetary Risk Flag", NSF_FLAG "Insufficient Funds Flag", ONE_K_TRIGGER_VALUE "One K Trigger Value", MONETARY_RISK_VALUE "Monetary Risk Value", CAST_23 "Last Non Risk Day", NSF_ALERT_DAY_NUMBER "Insufficient Funds Alert Day #", NSF_FLAG_STATUS "Insufficient Funds Flag Status", CHECK_VIP "Check Vip", ACCO_STATUS "Acco Status", "STATE" "State", CAST_22 "Dob", AGE "Age", CAST_24 "Registration Date Utc", VIP_HOST "Vip Host", EST_NET_WORTH "Est Net Worth", IS_VIP "Is OSB Vip", IS_CASINO_VIP "Is Casino Vip" from (select ACCO_ID_NECCTON, ONE_K_FLAG, MONETARY_RISK_FLAG, NSF_FLAG, ONE_K_TRIGGER_VALUE, MONETARY_RISK_VALUE, NSF_ALERT_DAY_NUMBER, NSF_FLAG_STATUS, IS_VIP, IS_CASINO_VIP, CHECK_VIP, ACCO_STATUS, "STATE", AGE, VIP_HOST, EST_NET_WORTH, DOB::timestamp_ltz CAST_22, LAST_NON_RISK_DAY::timestamp_ltz CAST_23, REGISTRATION_DATE_UTC::timestamp_ltz CAST_24, TRIGGER_DATE_NECCTON::timestamp_ltz CAST_25, '✏️' V_26 from FBG_GOVERNANCE.GOVERNANCE.AFFORDABILITY_NECCTON_TRACK where TRIGGER_DATE_NECCTON >= to_date('2026-04-03', 'YYYY-MM-DD') and TRIGGER_DATE_NECCTON <= to_date('2026-04-09', 'YYYY-MM-DD')) Q1 order by ACCO_ID_NECCTON asc limit 78201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear?:displayNodeId=CStK5liQzP","kind":"adhoc","request-id":"g019d7437f2c57208b88de85b3b0a6dc4","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
