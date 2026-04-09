-- Query ID: 01c39a3a-0212-67a8-24dd-07031942458b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:18:53.075000+00:00
-- Elapsed: 482ms
-- Environment: FBG

select ACCO_ID "Account ID", CURRENT_YEAR_TIER_POINTS "Current Year Tier Points", LOYALTY_TIER "Loyalty Tier", SM_TRIAL_STATUS "Sm Trial Status", MILESTONE_NUMBER "Milestone Number", MILESTONE "Milestone", FANCASH_AMOUNT "FC Amount", SEGMENT_NAME "Segment Name", BONUS_SEGMENT "Segment ID", CAST_15 "Segment Added", BONUS_CAMPAIGN_ID "Bonus ID", CAST_16 "Bonus Awarded", BONUS_STATE "Bonus State" from (select distinct ACCO_ID, SM_TRIAL_STATUS, MILESTONE_NUMBER, MILESTONE, SEGMENT_NAME, FANCASH_AMOUNT, BONUS_CAMPAIGN_ID, BONUS_SEGMENT, CURRENT_YEAR_TIER_POINTS, LOYALTY_TIER, BONUS_STATE, SEGMENT_CREATED::timestamp_ltz CAST_15, BONUS_AWARDED_DATE::timestamp_ltz CAST_16 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CSMILESTONESDASHBOARD where ACCO_ID = 6241667) Q1 order by CURRENT_YEAR_TIER_POINTS asc, LOYALTY_TIER asc, SM_TRIAL_STATUS asc, MILESTONE_NUMBER asc, MILESTONE asc, FANCASH_AMOUNT asc, SEGMENT_NAME asc, BONUS_SEGMENT asc, CAST_15 asc, BONUS_CAMPAIGN_ID asc, CAST_16 asc, BONUS_STATE asc limit 71801

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Milestones-CS-Dashboard-jE9SdUSvtDfpHSJnGSv0O?:displayNodeId=szP_AG9SyP","kind":"adhoc","request-id":"g019d7453a4dd7cbc914e5b48fb691d56","user-id":"3iAxZuQ3G72Y9oDKqtSqeCAlzlGuU","email":"phurpa.sherpa@betfanatics.com"}
