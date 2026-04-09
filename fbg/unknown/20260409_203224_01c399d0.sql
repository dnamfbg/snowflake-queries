-- Query ID: 01c399d0-0212-6cb9-24dd-070319295ecf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:32:24.630000+00:00
-- Elapsed: 98ms
-- Environment: FBG

select UILJUEFF2O "Account Id", YREYXM1E3E "Action Date", EXH6HDWVQU "Action Level", TZAFTVJEXP "Lvl 1 Notes", Q6X8FVWE00 "Lvl 2 Notes", V_XTREXBWQ "Lvl 3 Notes", UPDATED_AT "Last updated at", UPDATED_BY "Last updated by", CAST_18 "ID", CAST_19 SEQ_NUM, ROW_VERSION from (select ROW_VERSION, UPDATED_BY, UPDATED_AT, UILJUEFF2O, YREYXM1E3E, EXH6HDWVQU, TZAFTVJEXP, Q6X8FVWE00, V_XTREXBWQ, "ID"::text CAST_18, SEQ_NUM::text CAST_19 from (select "ID", SEQ_NUM, ROW_VERSION, TOMBSTONE_VERSION, UPDATED_BY, UPDATED_AT, UILJUEFF2O, YREYXM1E3E, EXH6HDWVQU, TZAFTVJEXP, Q6X8FVWE00, V_XTREXBWQ, row_number() over (partition by "ID" order by ROW_VERSION desc) ROWNUMBER_17 from FBG_ANALYTICS.SIGMA_FBG."SIGDS_70babfd3_a463_46a7_b341_6b0828445022" where ROW_VERSION <= 71 qualify ROWNUMBER_17 = 1 and TOMBSTONE_VERSION is null) Q1) Q2 order by CAST_19 asc limit 67201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear?:displayNodeId=Bz3ljc6t6R","kind":"adhoc","request-id":"g019d73f22b0c74888ec3b321a397e28f","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
