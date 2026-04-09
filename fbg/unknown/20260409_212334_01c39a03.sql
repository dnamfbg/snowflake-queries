-- Query ID: 01c39a03-0212-6cb9-24dd-0703193542f7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:23:34.273000+00:00
-- Elapsed: 79ms
-- Environment: FBG

select ACCO_ID "Acco Id", LVL1_ACTION_DATE "Lvl 1 Action Date", LVL1_NOTES "Lvl 1 Notes", CAST_13 "L 1 Cooldown End", LVL2_ACTION_DATE "Lvl 2 Action Date", LVL2_NOTES "Lvl 2 Notes", CAST_14 "L 2 Cooldown End", LVL3_ACTION_DATE "Lvl 3 Action Date", LVL3_NOTES "Lvl 3 Notes", CAST_15 "L 3 Cooldown End", MONETARY_PTS_THRESH "Monetary Pts Thresh", MON_PTS_ACTION_DATE "Mon Pts Action Date", MON_PTS_REASONING "Mon Pts Reasoning", GREATEST_16 "Latest Actioned Date" from (select ACCO_ID, LVL1_ACTION_DATE, LVL1_NOTES, LVL2_ACTION_DATE, LVL2_NOTES, LVL3_ACTION_DATE, LVL3_NOTES, MONETARY_PTS_THRESH, MON_PTS_REASONING, MON_PTS_ACTION_DATE, L1_COOLDOWN_END::timestamp_ltz CAST_13, L2_COOLDOWN_END::timestamp_ltz CAST_14, L3_COOLDOWN_END::timestamp_ltz CAST_15, greatest(coalesce(LVL1_ACTION_DATE, try_to_timestamp_ltz('1900-01-01')), coalesce(LVL2_ACTION_DATE, try_to_timestamp_ltz('1900-01-01')), coalesce(LVL3_ACTION_DATE, try_to_timestamp_ltz('1900-01-01'))) GREATEST_16 from FBG_GOVERNANCE.GOVERNANCE.SIGMA_AFFORDABILITY_CONDENSED) Q1 order by LVL1_ACTION_DATE desc nulls last limit 83801

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Affordability-Dashboard-Central-RG-1lxIZPpETvGxFDYFD2Rear?:displayNodeId=g59nSNwO9E","kind":"adhoc","request-id":"g019d742103ef7703b02413735e746ff2","user-id":"n4W8ScmrfmcfhvhUymXzaOuFfij0V","email":"abraham.mieses@betfanatics.com"}
