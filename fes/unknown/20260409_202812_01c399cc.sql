-- Query ID: 01c399cc-0112-6b51-0000-e3072189ba46
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:28:12.288000+00:00
-- Elapsed: 118ms
-- Environment: FES

select LOYALTY_TIER "Loyalty Tier", MEMBERS_AS_OF_DATE "Members", PRIOR_DAY_ACTUAL "DoD", PRIOR_DAY_FORECAST "DoD FC", PRIOR_DAY_VARIANCE_PCT "DoD vs FC", MTD_ACTUAL "MoM", MTD_FORECAST "MoM FC", MTD_VARIANCE_PCT "MoM vs FC", GT_14 "Kw5RLg1EAI_HmAHby_jkW", GT_15 "Kw5RLg1EAI_Nw0RVR77Pp", LT_16 "d31T6czkQb_HmAHby_jkW", LT_17 "d31T6czkQb_Nw0RVR77Pp" from (select LOYALTY_TIER, MEMBERS_AS_OF_DATE, PRIOR_DAY_ACTUAL, MTD_ACTUAL, PRIOR_DAY_FORECAST, MTD_FORECAST, PRIOR_DAY_VARIANCE_PCT, MTD_VARIANCE_PCT, PRIOR_DAY_VARIANCE_PCT > 0 GT_14, MTD_VARIANCE_PCT > 0 GT_15, PRIOR_DAY_VARIANCE_PCT < 0 LT_16, MTD_VARIANCE_PCT < 0 LT_17 from FES_USERS.SANDBOX.F1_LOYALTY_TIER_MEMBERS_PACING where LOYALTY_TIER is not null) Q1 order by MEMBERS_AS_OF_DATE asc nulls last limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Ecosystem-Loyalty-Daily-Flash-7nkvc8qbnPuvFnRD03zGxC?:displayNodeId=P_iYk9ZKW2","kind":"adhoc","request-id":"g019d73ee4d3f74d196f4151f344d6fa0","user-id":"wZRGZQm14iba077ESkXJ9CQ0n8417","email":"Brady.Burns@betfanatics.com"}
