-- Query ID: 01c39a2e-0212-6dbe-24dd-0703193f622f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:06:13.206000+00:00
-- Elapsed: 76961ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BACKFILL_STATUS" AS "BACKFILL_STATUS",
  "Custom SQL Query"."BONUS_AWARDED_DATE" AS "BONUS_AWARDED_DATE",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_STATE" AS "BONUS_STATE",
  "Custom SQL Query"."CURRENT_LOYALTY_TIER" AS "CURRENT_LOYALTY_TIER",
  "Custom SQL Query"."CURRENT_YEAR_TIER_POINTS" AS "CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."FANCASH_AMOUNT" AS "FANCASH_AMOUNT",
  "Custom SQL Query"."IS_CONVERTED" AS "IS_CONVERTED",
  "Custom SQL Query"."MILESTONE_GROUP" AS "MILESTONE_GROUP",
  "Custom SQL Query"."MILESTONE_NAME" AS "MILESTONE_NAME",
  "Custom SQL Query"."SEGMENT_CREATED" AS "SEGMENT_CREATED",
  "Custom SQL Query"."SEGMENT_ID" AS "SEGMENT_ID",
  "Custom SQL Query"."SEGMENT_LOYALTY_TIER" AS "SEGMENT_LOYALTY_TIER",
  "Custom SQL Query"."SEGMENT_NAME" AS "SEGMENT_NAME",
  "Custom SQL Query"."SORT_ORDER" AS "SORT_ORDER",
  "Custom SQL Query"."STATUS_MATCH_START_DATE" AS "STATUS_MATCH_START_DATE",
  "Custom SQL Query"."TRIAL_STATUS" AS "TRIAL_STATUS"
FROM (
  WITH segment_mapping AS (
    SELECT column1 AS segment_id, 
           column2::STRING AS bonus_id,
           column3 AS segment_name,
           column4 AS loyalty_tier,
           column5 AS milestone_name,
           column6 AS sort_order
    FROM VALUES
      (73836, '109066', '6.12.25_MPro_FONE_WFC_TierUpgrade', 'ONEmember pro','ONEmember pro Upgrade/100 TP', 1),
      (78360, '114026', '6.23.25_MPro_FONE_20FC', 'ONEmember pro','250 TP', 2),
      (78361, '114028', '6.23.25_MPro_FONE_25FC', 'ONEmember pro','500 TP', 3),
      (78362, '114029', '6.23.25_MPro_FONE_50FC', 'ONEmember pro','1,000 TP', 4),
      (78363, '114031', '6.23.25_MPro_FONE_50FC1', 'ONEmember pro','1,750 TP', 5),
      (73837, '109067', '6.12.25_GLD_FONE_WFC_TierUpgrade', 'ONEgold','ONEgold Upgrade/2,500 TP', 6),
      (78365, '114034', '6.23.25_GLD_FONE_150FC', 'ONEgold', '5,000 TP', 7),
      (78366, '114036', '6.23.25_GLD_FONE_150FC1', 'ONEgold', '7,500 TP', 8),
      (73838, '109068', '6.12.25_PLT_FONE_WFC_TierUpgrade', 'ONEplatinum', 'ONEplatinum Upgrade/10,000 TP', 9),
      (78368, '114039', '6.23.25_PLT_FONE_250FC1', 'ONEplatinum', '15,000 TP', 10),
      (73839, '109069', '6.12.25_BLK_FONE_WFC_TierUpgrade', 'ONEblack','ONEblack Upgrade/20,000 TP + Invite', 11),
      (71663, '109061', '6.11.25_MPro_FONE_WFC', 'ONEmember pro','ONEmember pro BackfillV1', 12),
      (71663, '106674', '6.11.25_MPro_FONE_WFC', 'ONEmember pro','ONEmember pro BackfillV2', 13),
      (71664, '109062', '6.11.25_GLD_FONE_WFC', 'ONEgold','ONEgold BackfillV1', 14),
      (71664, '106675', '6.11.25_GLD_FONE_WFC', 'ONEgold','ONEgold BackfillV2', 15),
      (71665, '109063', '6.11.25_PLT_FONE_WFC', 'ONEplatinum','ONEplatinum BackfillV1', 16),
      (71665, '106676', '6.11.25_PLT_FONE_WFC', 'ONEplatinum','ONEplatinum BackfillV2', 17),
      (71666, '106677', '6.11.25_BLK_FONE_WFC', 'ONEblack','ONEblack Backfill', 18),
      (52677, '82473', '4.15.25_FONE_Gold_FC', 'ONEgold','ONEgold Early Access V1', 19),
      (52678, '82474', '4.15.25_FONE_Plat_FC', 'ONEplatinum','ONEplat Early Access', 20),
      (52679, '82476', '4.15.25_FONE_Black_FC', 'ONEblack','ONEblack Early Access', 21),
      (58665, '90611', '5.8.25_FOne_FCOffer_Gold', 'ONEgold','ONEgold Upgrade Temp', 22),
      (58666, '90612', '5.8.25_FOne_FCOffer_Plat', 'ONEplatinum','ONEplat Upgrade Temp', 23),
      (58667, '90613', '5.8.25_FOne_FCOffer_BLK', 'ONEblack','ONEblack Upgrade Temp', 24),
      (52680, '82478', '4.15.25_FOne_Gold_FC_June', 'ONEgold','ONEgold Early Access V2',25)
      
  ),
  user_tiers AS (
    SELECT 
      f1.acco_id, 
      f1.CURRENT_YEAR_TIER_POINTS,
      f1.loyalty_tier AS current_loyalty_tier
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES f1
    WHERE f1.loyalty_tier IN ('ONEmember pro', 'ONEgold', 'ONEplatinum', 'ONEblack')
  ),
  backfilled AS (
  SELECT 
      b.amelco_id,
      f.acco_id
      FROM "FBG_ANALYTICS_DEV"."ROHAN_GULATI"."BACKFILLS" b
      LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART f
      ON b.amelco_id = f.amelco_id
  
  ),
  
  audits_0812 AS (
    SELECT
      acco_ID,
      current_year_tier_points AS tp_0812
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_AUDITS
    WHERE as_of_date = '2025-08-12'
  ),
  
  account_segments AS (
    SELECT 
      seg.accounts_id AS acco_id, 
      seg.customer_segments_id AS segment_id,
      CONVERT_TIMEZONE('UTC','America/New_York', seg.created) AS segment_created
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS seg
  ),
  account_bonuses AS (
    SELECT 
      ab.acco_id, 
      ab.bonus_campaign_id::STRING AS bonus_campaign_id,
      CONVERT_TIMEZONE('UTC','America/New_York', ab.modified) AS bonus_awarded_date,
      ab.state AS bonus_state
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES ab
  ),
  fancash_amount AS (
    SELECT
      bc.id AS bonus_campaign_id,
      parse_json(data):Bonus:fanCash:bonusStakes[0]:amount as fancash_amount
    FROM FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS bc
    WHERE bc.id IN (SELECT bonus_id FROM segment_mapping)
  ),
  -- new CTE
  status_match AS (
    SELECT
      acco_id,
      status_match_start_date,
      trial_status,
      is_converted
    FROM fbg_analytics.product_and_customer.status_match
    WHERE matched = 1
  ),
  baseline_milestones AS (
    SELECT 
      ut.acco_id,
      ut.CURRENT_YEAR_TIER_POINTS,
      ut.current_loyalty_tier,
      sm.segment_id,
      sm.bonus_id AS bonus_campaign_id,
      sm.segment_name,
      sm.loyalty_tier AS segment_loyalty_tier,
      sm.milestone_name,
      sm.sort_order
    FROM user_tiers ut
    CROSS JOIN (SELECT * FROM segment_mapping WHERE sort_order <= 11) sm
  ),
  extra_milestones AS (
    SELECT DISTINCT
      ut.acco_id,
      ut.CURRENT_YEAR_TIER_POINTS,
      ut.current_loyalty_tier,
      sm.segment_id,
      sm.bonus_id AS bonus_campaign_id,
      sm.segment_name,
      sm.loyalty_tier AS segment_loyalty_tier,
      sm.milestone_name,
      sm.sort_order
    FROM user_tiers ut
    JOIN segment_mapping sm ON sm.sort_order > 11
    LEFT JOIN account_segments seg
      ON ut.acco_id = seg.acco_id AND sm.segment_id = seg.segment_id
    LEFT JOIN account_bonuses bon
      ON ut.acco_id = bon.acco_id AND sm.bonus_id = bon.bonus_campaign_id
    WHERE seg.acco_id IS NOT NULL OR bon.acco_id IS NOT NULL
  ),
  combined_milestones AS (
    SELECT * FROM baseline_milestones
    UNION ALL
    SELECT * FROM extra_milestones
  ),
  combined_with_data AS (
    SELECT 
      cm.*,
      seg.segment_created,
      CASE 
        WHEN bon.bonus_state = 'EXECUTED' THEN bon.bonus_awarded_date
        ELSE NULL
      END AS bonus_awarded_date,
      bon.bonus_state,
      fc.fancash_amount,  
      CASE 
        WHEN cm.sort_order IN (1,12,13) THEN 'G1'
        WHEN cm.sort_order IN (6,14,15,19,22,25) THEN 'G2'
        WHEN cm.sort_order IN (9,16,17,20,23) THEN 'G3'
        WHEN cm.sort_order IN (11,21,24) THEN 'G4'
        ELSE NULL
      END AS milestone_group
    FROM combined_milestones cm
    LEFT JOIN account_segments seg
      ON cm.acco_id = seg.acco_id AND cm.segment_id = seg.segment_id
    LEFT JOIN account_bonuses bon
      ON cm.acco_id = bon.acco_id AND cm.bonus_campaign_id = bon.bonus_campaign_id
    LEFT JOIN fancash_amount fc 
      ON cm.bonus_campaign_id = fc.bonus_campaign_id
  ),
  group_bonus_check AS (
    SELECT 
      acco_id,
      milestone_group,
      MAX(CASE WHEN bonus_awarded_date IS NOT NULL THEN 1 ELSE 0 END) AS has_award,
      MAX(CASE WHEN segment_created IS NOT NULL THEN 1 ELSE 0 END) AS has_segment
    FROM combined_with_data
    WHERE milestone_group IS NOT NULL
    GROUP BY acco_id, milestone_group
  ),
  final_filtered AS (
    SELECT c.*
    FROM combined_with_data c
    LEFT JOIN group_bonus_check g
      ON c.acco_id = g.acco_id AND c.milestone_group = g.milestone_group
    WHERE
      (
        c.milestone_group IS NOT NULL
        AND (
          (g.has_award = 1 AND c.bonus_awarded_date IS NOT NULL)
          OR (g.has_award = 0 AND g.has_segment = 1 
              AND c.sort_order = (
                SELECT MIN(sort_order) 
                FROM combined_with_data 
                WHERE acco_id = c.acco_id AND milestone_group = c.milestone_group AND segment_created IS NOT NULL
              )
             )
          OR (g.has_award = 0 AND g.has_segment = 0 
              AND c.sort_order = (
                SELECT MIN(sort_order) 
                FROM combined_with_data 
                WHERE acco_id = c.acco_id AND milestone_group = c.milestone_group
              )
             )
        )
      )
      OR c.milestone_group IS NULL
  )
  SELECT 
    ff.*,
    sm.status_match_start_date,
    sm.trial_status,
    sm.is_converted,
    CASE
      WHEN b.acco_id IS NOT NULL THEN 'Backfill Received'
      WHEN a12.tp_0812 < 100 THEN 'N/A - less than 100 TP at Time of Backfill'
      ELSE 'Not Eligible - Account Was Limited at Time of Backfill'
    END AS backfill_status
  FROM final_filtered ff
  LEFT JOIN status_match sm
    ON ff.acco_id = sm.acco_id
  LEFT JOIN backfilled b
    ON ff.acco_id = b.acco_id
  LEFT JOIN audits_0812 a12
    ON ff.acco_id = a12.acco_id
  ORDER BY ff.acco_id, ff.sort_order
) "Custom SQL Query"
