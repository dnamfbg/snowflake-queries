-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e48c3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:01:47.999000+00:00
-- Elapsed: 68795ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_CODE" AS "BONUS_CODE",
  "Custom SQL Query"."BONUS_DEPOSIT_PERCENTAGE" AS "BONUS_DEPOSIT_PERCENTAGE",
  "Custom SQL Query"."BONUS_EXPIRE_ET" AS "BONUS_EXPIRE_ET",
  "Custom SQL Query"."BONUS_NAME" AS "BONUS_NAME",
  "Custom SQL Query"."BONUS_ORIGIN" AS "BONUS_ORIGIN",
  "Custom SQL Query"."BONUS_SOURCE" AS "BONUS_SOURCE",
  "Custom SQL Query"."BONUS_START_ET" AS "BONUS_START_ET",
  "Custom SQL Query"."BONUS_STATUS" AS "BONUS_STATUS",
  "Custom SQL Query"."BOOST_PERCENTAGE" AS "BOOST_PERCENTAGE",
  "Custom SQL Query"."Bonus Category" AS "Bonus Category",
  "Custom SQL Query"."COMMERCE_CURRENT_YEAR_TIER_POINTS" AS "COMMERCE_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."DAYS_TO_OPT_IN" AS "DAYS_TO_OPT_IN",
  "Custom SQL Query"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query"."EXPIRY_STATUS" AS "EXPIRY_STATUS",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FBG_GOODWILL_CURRENT_YEAR_TIER_POINTS" AS "FBG_GOODWILL_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."FT_REP" AS "FT_REP",
  "Custom SQL Query"."LAST_YEAR_TIER_POINTS" AS "LAST_YEAR_TIER_POINTS",
  "Custom SQL Query"."OC_CURRENT_YEAR_TIER_POINTS" AS "OC_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."ODDSBOOST_DESCRIPTION" AS "ODDSBOOST_DESCRIPTION",
  "Custom SQL Query"."OPT_IN_TIME_ET" AS "OPT_IN_TIME_ET",
  "Custom SQL Query"."OSB_CURRENT_YEAR_TIER_POINTS" AS "OSB_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."OTHER_CURRENT_YEAR_TIER_POINTS" AS "OTHER_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."PRODUCT" AS "PRODUCT",
  "Custom SQL Query"."PSEUDONYM" AS "PSEUDONYM",
  "Custom SQL Query"."SEGMENT_CREATED_TIME_ET" AS "SEGMENT_CREATED_TIME_ET",
  "Custom SQL Query"."SEGMENT_ID" AS "SEGMENT_ID",
  "Custom SQL Query"."SEGMENT_NAME" AS "SEGMENT_NAME",
  "Custom SQL Query"."SERIES" AS "SERIES",
  "Custom SQL Query"."SETTLEMENT_TYPE" AS "SETTLEMENT_TYPE",
  "Custom SQL Query"."SUBCATEGORY" AS "SUBCATEGORY",
  "Custom SQL Query"."TIER" AS "TIER",
  "Custom SQL Query"."USER_STATE" AS "USER_STATE",
  "Custom SQL Query"."VIPTIER" AS "VIPTIER",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  -- Mapping of every segment to bonus + Direct Investments
  WITH 
      -- Step 1: Create Mapping for Excluded Segments from Bonus Campaign ID to Every Segment ID that is Excluded
      excluded_mapping AS (
          SELECT
              id AS bonus_campaign_id,
              VALUE::STRING AS excluded_segment_id, -- Extract excluded segment IDs
              CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:starts::NUMBER / 1000)) AS bonus_start_ET,
              CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:expires::NUMBER / 1000)) AS bonus_expire_ET,
              parse_json(data):Bonus:daysToActivate::NUMBER as days_to_opt_in -- Days to Opt Into Bonus field in NATS
          FROM fbg_source.osb_source.bonus_campaigns b,
               TABLE(FLATTEN(INPUT => parse_json(data):Bonus:excludedSegmentIds)) -- Flatten the excluded segments array
          WHERE
              CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET 
      ),
      
      -- Step 2: Create Mapping for Included Segments from Bonus Campaign ID to Every Segment ID that is Included (Including Global Bonuses)
      mapping AS (
          WITH flattened_bonus_campaigns AS (
              -- Handle bonuses with non-empty segmentIds - explicit inclusion
              SELECT
                  id AS bonus_campaign_id,
                  VALUE::STRING AS segment_id,
                  parse_json(data):Bonus:status::VARCHAR AS bonus_status,
                  parse_json(data):Bonus:name::VARCHAR AS bonus_name,
                  parse_json(data):Bonus:bonusCode::VARCHAR AS bonus_code,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:starts::NUMBER / 1000)) AS bonus_start_ET,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:expires::NUMBER / 1000)) AS bonus_expire_ET,
                  parse_json(data):Bonus:daysToActivate::NUMBER as days_to_opt_in -- Days to Opt Into Bonus field in NATS
              FROM fbg_source.osb_source.bonus_campaigns b,
                   TABLE(FLATTEN(INPUT => parse_json(data):Bonus:segmentIds)) -- Flatten non-empty arrays
              WHERE parse_json(data):Bonus:bulkAwardBonus::BOOLEAN = false -- Check for bulkAwardBonus = false
              AND parse_json(data):Bonus:registrationBonus::BOOLEAN = false -- Check for registrationBonus = false
              AND parse_json(data):Bonus:goodwillBonus::BOOLEAN = false -- Check for goodwillBonus = false
              AND parse_json(data):Bonus:purchaseMatch::BOOLEAN = false -- Check for purchaseMatch = false
              AND parse_json(data):Bonus:bonusOrigin::varchar <> 'converted_from_fancash' -- Remove FanCash conversion campaigns
              AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET 
  
              UNION ALL
  
              -- Handle bonuses with empty or missing segmentIds - these are global bonuses
              SELECT
                  id AS bonus_campaign_id,
                  NULL AS segment_id, -- No specific segment for global bonuses
                  parse_json(data):Bonus:status::VARCHAR AS bonus_status,
                  parse_json(data):Bonus:name::VARCHAR AS bonus_name,
                  parse_json(data):Bonus:bonusCode::VARCHAR AS bonus_code,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:starts::NUMBER / 1000)) AS bonus_start_ET,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:expires::NUMBER / 1000)) AS bonus_expire_ET,
                  parse_json(data):Bonus:daysToActivate::NUMBER as days_to_opt_in -- Days to Opt Into Bonus field in NATS
              FROM fbg_source.osb_source.bonus_campaigns
              WHERE (parse_json(data):Bonus:segmentIds IS NULL -- Check for a global bonus campaign with no segments
                 OR ARRAY_SIZE(parse_json(data):Bonus:segmentIds) = 0)
               AND parse_json(data):Bonus:bulkAwardBonus::BOOLEAN = false -- Check for bulkAwardBonus = false
               AND parse_json(data):Bonus:registrationBonus::BOOLEAN = false -- Check for registrationBonus = false
               AND parse_json(data):Bonus:goodwillBonus::BOOLEAN = false -- Check for goodwillBonus = false
               AND parse_json(data):Bonus:purchaseMatch::BOOLEAN = false -- Check for purchaseMatch = false
               AND parse_json(data):Bonus:bonusOrigin::varchar <> 'converted_from_fancash' -- Remove FanCash conversion campaigns
               AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET 
          )
          SELECT 
              bonus_campaign_id,
              segment_id,
              bonus_status,
              bonus_name,
              bonus_code,
              bonus_start_ET,
              bonus_expire_ET,
              days_to_opt_in
          FROM flattened_bonus_campaigns
      ),
  
      /* NEW: Tier points CTE from F1_ATTRIBUTES (joined on acco_id) */
      f1_tier_points AS (
          SELECT
              acco_id,
              last_year_tier_points,
              osb_current_year_tier_points,
              oc_current_year_tier_points,
              commerce_current_year_tier_points,
              fbg_goodwill_current_year_tier_points,
              other_current_year_tier_points
          FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES
      ),
  
     final AS (
      -- Step 3: Combine Account Segments and Global Bonuses
      SELECT 
          a.accounts_id AS acco_id,
          u.vip_host,
          CASE WHEN u.vip_host IS NULL THEN ui.fast_track_rep_name ELSE NULL END AS ft_rep,
          u.daily_rewards_offer_id AS Tier,
          coded_total_tier AS VIPTier,
          b.bonus_campaign_id,
          b.bonus_name,
          b.bonus_status,
          CASE 
              WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) BETWEEN b.bonus_start_ET AND b.bonus_expire_ET THEN 'ACTIVE' 
              WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) < b.bonus_start_ET THEN 'NOT STARTED'
              ELSE 'EXPIRED' 
          END AS expiry_status,
          CASE 
              WHEN f.state IS NULL THEN
                  CASE 
                      WHEN (DATEADD(day, b.days_to_opt_in, CONVERT_TIMEZONE('UTC','America/New_York', a.created)) > CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP)
                            OR b.days_to_opt_in = 0)
                      THEN 'NO LOGIN'
                      ELSE 'NO LOGIN - MISSED'
                  END 
              ELSE f.state 
          END AS user_state,
          CONVERT_TIMEZONE('UTC','America/New_York',TO_TIMESTAMP(SPLIT_PART(REGEXP_SUBSTR(f.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_time_ET,
          b.segment_id,
          PARSE_JSON(c.data):CustomerSegment:name::VARCHAR AS segment_name,
          CONVERT_TIMEZONE('UTC','America/New_York', a.created) AS segment_created_time_ET,
          b.bonus_start_ET,
          b.bonus_expire_ET,
          b.days_to_opt_in,
          d.settlement_type,
          d.bonus_code,
          d.bonus_origin,
          d.description,
          d.oddsboost_description,
          d.boost_percentage,
          d.bonus_deposit_percentage,
          'SEGMENT' AS bonus_source,
          bc."Bonus Category",
          bc.subcategory,
          bc.series,
          bc.product,
          ui.f1_loyalty_tier,
          u.pseudonym,
  
          /* NEW: tier points columns */
          tp.last_year_tier_points,
          tp.osb_current_year_tier_points,
          tp.oc_current_year_tier_points,
          tp.commerce_current_year_tier_points,
          tp.fbg_goodwill_current_year_tier_points,
          tp.other_current_year_tier_points
  
      FROM fbg_source.osb_source.account_segments a
      LEFT JOIN mapping b
          ON a.customer_segments_id = b.segment_id -- Match specific segments
      LEFT JOIN fbg_source.osb_source.customer_segments c
          ON a.customer_segments_id = c.id
      LEFT JOIN fbg_analytics_engineering.product.promotions d
          ON d.id = b.bonus_campaign_id
      LEFT JOIN excluded_mapping e
          ON b.bonus_campaign_id = e.bonus_campaign_id 
          AND a.customer_segments_id = e.excluded_segment_id -- Exclude users in excluded segments
      LEFT JOIN fbg_source.osb_source.account_bonuses f
          ON b.bonus_campaign_id = f.bonus_campaign_id 
          AND a.accounts_id = f.acco_id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart u
          ON u.acco_id = a.accounts_id
      LEFT JOIN fbg_analytics.product_and_customer.t_daily_rewards_record z
          ON z.acco_id = a.accounts_id
          AND DATE(z.insert_timestamp) = CURRENT_DATE() - 1
      LEFT JOIN fbg_analytics.product_and_customer.bonus_categories bc
          ON b.bonus_campaign_id = bc.bonus_campaign_id
      LEFT JOIN fbg_analytics.vip.vip_user_info ui
          ON a.accounts_id = ui.acco_id
      LEFT JOIN f1_tier_points tp
          ON tp.acco_id = a.accounts_id
  
      WHERE e.excluded_segment_id IS NULL -- Exclude users in excluded segments
        AND b.bonus_campaign_id IS NOT NULL   
        AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) BETWEEN b.bonus_start_ET AND b.bonus_expire_ET 
        AND d.description NOT ILIKE '%DO NOT TURN ACTIVE%'
        AND (u.vip_host IS NOT NULL 
             OR (ui.is_currently_fast_track = 1 AND ui.fast_track_routing_decision IN ('Week 1','Week 2','Week 3','Week 4')))
        AND user_state <> 'NO LOGIN - MISSED'
        AND b.bonus_name NOT ILIKE '%seg sync%'
  
      UNION ALL
  
      -- Add global bonuses for the specific user, but deduplicate global IDs
      SELECT DISTINCT
          a.accounts_id AS acco_id,
          u.vip_host,
          CASE WHEN u.vip_host IS NULL THEN ui.fast_track_rep_name ELSE NULL END AS ft_rep,
          u.daily_rewards_offer_id AS Tier,
          coded_total_tier AS VIPTier,
          b.bonus_campaign_id,
          b.bonus_name,
          b.bonus_status,
          CASE 
              WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) BETWEEN b.bonus_start_ET AND b.bonus_expire_ET THEN 'ACTIVE' 
              WHEN CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) < b.bonus_start_ET THEN 'NOT STARTED'
              ELSE 'EXPIRED' 
          END AS expiry_status,
          CASE 
              WHEN f.state IS NULL THEN
                  CASE 
                      WHEN (DATEADD(day, b.days_to_opt_in, b.bonus_start_ET) > CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP)
                            OR b.days_to_opt_in = 0)
                      THEN 'NO LOGIN'
                      ELSE 'NO LOGIN - MISSED'
                  END 
              ELSE f.state 
          END AS user_state,
          CONVERT_TIMEZONE('UTC','America/New_York',TO_TIMESTAMP(SPLIT_PART(REGEXP_SUBSTR(f.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_time_ET,
          'GLOBAL' AS segment_id,
          'GLOBAL' AS segment_name,
          NULL AS segment_created_time_ET,
          b.bonus_start_ET,
          b.bonus_expire_ET,
          b.days_to_opt_in,
          d.settlement_type,
          d.bonus_code,
          d.bonus_origin,
          d.description,
          d.oddsboost_description,
          d.boost_percentage,
          d.bonus_deposit_percentage,
          'GLOBAL' AS bonus_source,
          bc."Bonus Category",
          bc.subcategory,
          bc.series,
          bc.product,
          ui.f1_loyalty_tier,
          u.pseudonym,
  
          /* NEW: tier points columns */
          tp.last_year_tier_points,
          tp.osb_current_year_tier_points,
          tp.oc_current_year_tier_points,
          tp.commerce_current_year_tier_points,
          tp.fbg_goodwill_current_year_tier_points,
          tp.other_current_year_tier_points
  
      FROM fbg_source.osb_source.account_segments a
      LEFT JOIN mapping b
          ON b.segment_id IS NULL
      LEFT JOIN fbg_analytics_engineering.product.promotions d
          ON d.id = b.bonus_campaign_id
      LEFT JOIN excluded_mapping e
          ON b.bonus_campaign_id = e.bonus_campaign_id 
          AND a.customer_segments_id = e.excluded_segment_id
      LEFT JOIN fbg_source.osb_source.account_bonuses f
          ON b.bonus_campaign_id = f.bonus_campaign_id 
          AND a.accounts_id = f.acco_id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart u
          ON u.acco_id = a.accounts_id
      LEFT JOIN fbg_analytics.product_and_customer.t_daily_rewards_record z
          ON z.acco_id = a.accounts_id
          AND DATE(z.insert_timestamp) = CURRENT_DATE() - 1
      LEFT JOIN fbg_analytics.product_and_customer.bonus_categories bc
          ON b.bonus_campaign_id = bc.bonus_campaign_id
      LEFT JOIN fbg_analytics.vip.vip_user_info ui
          ON a.accounts_id = ui.acco_id
      LEFT JOIN f1_tier_points tp
          ON tp.acco_id = a.accounts_id
  
      WHERE b.segment_id IS NULL
        AND b.bonus_campaign_id IS NOT NULL
        AND NOT EXISTS (
              SELECT 1
              FROM excluded_mapping e2
              JOIN fbg_source.osb_source.account_segments a2
                ON e2.excluded_segment_id = a2.customer_segments_id
              WHERE e2.bonus_campaign_id = b.bonus_campaign_id
                AND a2.accounts_id = a.accounts_id
         )
        AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) BETWEEN b.bonus_start_ET AND b.bonus_expire_ET 
        AND d.description NOT ILIKE '%DO NOT TURN ACTIVE%'
        AND b.bonus_name NOT ILIKE '%seg sync%'
        AND (u.vip_host IS NOT NULL 
             OR (ui.is_currently_fast_track = 1 AND ui.fast_track_routing_decision IN ('Week 1','Week 2','Week 3','Week 4')))
        AND user_state <> 'NO LOGIN - MISSED'
      ) 
  
  SELECT *
  FROM final
  WHERE "Bonus Category" NOT IN ('Seg Sync', 'TEST', 'DNU', 'Acquisition')
    AND DATE(bonus_expire_et) >= DATE(CURRENT_TIMESTAMP)
    AND bonus_source <> 'GLOBAL'
    AND subcategory <> 'FanCash Drop'
    AND bonus_status <> 'IN_ACTIVE'
    AND user_state NOT IN ('EXPIRED', 'VOID', 'EXECUTED')
) "Custom SQL Query"
