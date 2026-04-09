-- Query ID: 01c399f9-0212-67a8-24dd-07031932dbd3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:13:18.312000+00:00
-- Elapsed: 439ms
-- Environment: FBG

select ACCO_ID "Account ID", CURRENT_YEAR_TIER_POINTS "Current Year Tier Points", LOYALTY_TIER "Loyalty Tier", SM_TRIAL_STATUS "Sm Trial Status", MILESTONE_NUMBER "Milestone Number", MILESTONE "Milestone", FANCASH_AMOUNT "FC Amount", SEGMENT_NAME "Segment Name", BONUS_SEGMENT "Segment ID", CAST_15 "Segment Added", BONUS_CAMPAIGN_ID "Bonus ID", CAST_16 "Bonus Awarded", BONUS_STATE "Bonus State" from (select distinct ACCO_ID, SM_TRIAL_STATUS, MILESTONE_NUMBER, MILESTONE, SEGMENT_NAME, FANCASH_AMOUNT, BONUS_CAMPAIGN_ID, BONUS_SEGMENT, CURRENT_YEAR_TIER_POINTS, LOYALTY_TIER, BONUS_STATE, SEGMENT_CREATED::timestamp_ltz CAST_15, BONUS_AWARDED_DATE::timestamp_ltz CAST_16 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CSMILESTONESDASHBOARD where ACCO_ID = 6241667) Q1 order by CURRENT_YEAR_TIER_POINTS asc, LOYALTY_TIER asc, SM_TRIAL_STATUS asc, MILESTONE_NUMBER asc, MILESTONE asc, FANCASH_AMOUNT asc, SEGMENT_NAME asc, BONUS_SEGMENT asc, CAST_15 asc, BONUS_CAMPAIGN_ID asc, CAST_16 asc, BONUS_STATE asc limit 71801

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Milestones-CS-Dashboard-jE9SdUSvtDfpHSJnGSv0O?:displayNodeId=szP_AG9SyP","kind":"adhoc","request-id":"g019d7417991d7aa4829f6064bb4d0f6b","user-id":"6useOh6eJqLtUcfgP4w8RGGqFGcIS","email":"derek.dubose@betfanatics.com"}
