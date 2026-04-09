-- Query ID: 01c399f6-0212-6b00-24dd-07031931aef3
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:10:09.048000+00:00
-- Elapsed: 763ms
-- Environment: FBG

select ACCO_ID "Acco Id", CURRENT_YEAR_TIER_POINTS "Current Year Tier Points", CURRENT_LOYALTY_TIER "Current Loyalty Tier", SEGMENT_ID "Segment Id", BONUS_CAMPAIGN_ID "Bonus Campaign Id", SEGMENT_NAME "Segment Name", SEGMENT_LOYALTY_TIER "Segment Loyalty Tier", MILESTONE_NAME "Milestone Name", SORT_ORDER "Sort Order", CAST_19 "Segment Created", CAST_18 "Bonus Awarded Date", BONUS_STATE "Bonus State", FANCASH_AMOUNT "Fancash Amount", MILESTONE_GROUP "Milestone Group", STATUS_MATCH_START_DATE "Status Match Start Date", TRIAL_STATUS "Trial Status", IS_CONVERTED "Is Converted", BACKFILL_STATUS "Backfill Status" from (select ACCO_ID, CURRENT_YEAR_TIER_POINTS, CURRENT_LOYALTY_TIER, SEGMENT_ID, BONUS_CAMPAIGN_ID, SEGMENT_NAME, SEGMENT_LOYALTY_TIER, MILESTONE_NAME, SORT_ORDER, BONUS_STATE, FANCASH_AMOUNT, MILESTONE_GROUP, STATUS_MATCH_START_DATE, TRIAL_STATUS, IS_CONVERTED, BACKFILL_STATUS, BONUS_AWARDED_DATE::timestamp_ltz CAST_18, SEGMENT_CREATED::timestamp_ltz CAST_19 from FBG_ANALYTICS.OPERATIONS.MILESTONE_ACCOUNT_LEVEL_TIERS) Q1 limit 1001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/Milestone-Dash-CS-Data-Model-2TRZbJCM146bD400H3FV13?:displayNodeId=g1BBii4l3e","kind":"adhoc","request-id":"g019d7414ba9c7780b75b0b5047f4260b","user-id":"U74a05QYBc3SLGuMZGLkhCc73eHJm","email":"alex.frank@betfanatics.com"}
