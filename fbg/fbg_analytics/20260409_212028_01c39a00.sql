-- Query ID: 01c39a00-0212-644a-24dd-07031934b15b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:20:28.023000+00:00
-- Elapsed: 103208ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AMOUNT_MAX" AS "AMOUNT_MAX",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_CODE" AS "BONUS_CODE",
  "Custom SQL Query"."BONUS_DEPOSIT_PERCENTAGE" AS "BONUS_DEPOSIT_PERCENTAGE",
  "Custom SQL Query"."BONUS_EXPIRE_ET" AS "BONUS_EXPIRE_ET",
  "Custom SQL Query"."BONUS_NAME" AS "BONUS_NAME",
  "Custom SQL Query"."BONUS_ORIGIN" AS "BONUS_ORIGIN",
  "Custom SQL Query"."BONUS_START_ET" AS "BONUS_START_ET",
  "Custom SQL Query"."BONUS_STATUS" AS "BONUS_STATUS",
  "Custom SQL Query"."BOOST_PERCENTAGE" AS "BOOST_PERCENTAGE",
  "Custom SQL Query"."DAYS_TO_OPT_IN" AS "DAYS_TO_OPT_IN",
  "Custom SQL Query"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query"."EXPIRY_STATUS" AS "EXPIRY_STATUS",
  "Custom SQL Query"."ODDSBOOST_DESCRIPTION" AS "ODDSBOOST_DESCRIPTION",
  "Custom SQL Query"."OPT_IN_TIME_ET" AS "OPT_IN_TIME_ET",
  "Custom SQL Query"."SEGMENT_CREATED_TIME_ET" AS "SEGMENT_CREATED_TIME_ET",
  "Custom SQL Query"."SEGMENT_ID" AS "SEGMENT_ID",
  "Custom SQL Query"."SEGMENT_NAME" AS "SEGMENT_NAME",
  "Custom SQL Query"."SETTLEMENT_TYPE" AS "SETTLEMENT_TYPE",
  "Custom SQL Query"."TIER" AS "TIER",
  "Custom SQL Query"."USER_STATE" AS "USER_STATE",
  "Custom SQL Query"."VIPTIER" AS "VIPTIER",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  -- Mapping of every segment to bonus
      -- Step 1: Create Mapping for Excluded Segments from Bonus Campaign ID to Every Segment ID that is Excluded
      WITH excluded_mapping AS (
          SELECT
              id AS bonus_campaign_id,
              VALUE::STRING AS excluded_segment_id, -- Extract excluded segment IDs
              CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:starts::NUMBER / 1000)) AS bonus_start_ET,
              CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:expires::NUMBER / 1000)) AS bonus_expire_ET,
              parse_json(data):Bonus:daysToActivate::NUMBER as days_to_opt_in -- Days to Opt Into Bonus field in NATS
          FROM fbg_source.osb_source.bonus_campaigns b,
               TABLE(FLATTEN(INPUT => parse_json(data):Bonus:excludedSegmentIds)) -- Flatten the excluded segments array
               where
              CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET 
      ),
      
      -- Step 2: Create Mapping for Included Sgements from Bonus Campaign ID to Every Segment ID that is Included (Including Global Bonuses)
      mapping AS (
          WITH flattened_bonus_campaigns AS (
              -- Handle bonuses with non-empty segmentIds - explicit inclusion
              SELECT
                  id AS bonus_campaign_id,
                  VALUE::STRING AS segment_id,
                  (TRY_PARSE_JSON(data):Bonus:losingMultipleInsurance:maxAmounts[0]:amount)::NUMBER AS amount_max,
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
              --AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET
              AND (bonus_start_ET >= '2025-08-23' OR bonus_expire_ET >= '2025-08-23')
  
              UNION ALL
              -- Handle bonuses with empty or missing segmentIds - these are global bonuses
              SELECT
                  id AS bonus_campaign_id,
                  NULL AS segment_id, -- No specific segment for global bonuses
                  (TRY_PARSE_JSON(data):Bonus:losingMultipleInsurance:maxAmounts[0]:amount)::NUMBER AS amount_max,
                  parse_json(data):Bonus:status::VARCHAR AS bonus_status,
                  parse_json(data):Bonus:name::VARCHAR AS bonus_name,
                  parse_json(data):Bonus:bonusCode::VARCHAR AS bonus_code,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:starts::NUMBER / 1000)) AS bonus_start_ET,
                  CONVERT_TIMEZONE('UTC', 'America/New_York', TO_TIMESTAMP(parse_json(data):Bonus:expires::NUMBER / 1000)) AS bonus_expire_ET,
                  parse_json(data):Bonus:daysToActivate::NUMBER as days_to_opt_in -- Days to Opt Into Bonus field in NATS
              FROM fbg_source.osb_source.bonus_campaigns
              WHERE parse_json(data):Bonus:segmentIds IS NULL -- Check for a global bonus campaign with no segments
                 OR ARRAY_SIZE(parse_json(data):Bonus:segmentIds) = 0
               AND parse_json(data):Bonus:bulkAwardBonus::BOOLEAN = false -- Check for bulkAwardBonus = false
               AND parse_json(data):Bonus:registrationBonus::BOOLEAN = false -- Check for registrationBonus = false
               AND parse_json(data):Bonus:goodwillBonus::BOOLEAN = false -- Check for goodwillBonus = false
               AND parse_json(data):Bonus:purchaseMatch::BOOLEAN = false -- Check for purchaseMatch = false
               AND parse_json(data):Bonus:bonusOrigin::varchar <> 'converted_from_fancash' -- Remove FanCash conversion campaigns
               --AND CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between bonus_start_ET and bonus_expire_ET 
               AND (bonus_start_ET >= '2025-08-23' OR bonus_expire_ET >= '2025-08-23')
          )
          SELECT 
              bonus_campaign_id,
              amount_max,
              segment_id,
              bonus_status,
              bonus_name,
              bonus_code,
              bonus_start_ET,
              bonus_expire_ET,
              days_to_opt_in
          FROM flattened_bonus_campaigns
      )
  
  , final AS (
  SELECT m.*
  FROM mapping AS m 
  WHERE m.bonus_code ILIKE '%GDG%'
  )
      
      -- Step 3: Combine Account Segments and Global Bonuses
      SELECT 
          a.accounts_id AS acco_id,
          vip_host,
          u.daily_rewards_offer_id as Tier,
          coded_total_tier as VIPTier,
          b.bonus_campaign_id,
          b.bonus_name,
    -- TRY_TO_NUMBER(
    --   REPLACE(
    --     REPLACE(
    --       REGEXP_SUBSTR(b.bonus_name, '\\$[0-9][0-9,]*(\\.[0-9]+)?')
    --     , '$', ''
    --     )
    --   , ',', ''
    --   )
    -- ) AS amount,
          b.amount_max,
          b.bonus_status,
          case when CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between b.bonus_start_ET and b.bonus_expire_ET then 'ACTIVE' 
          when CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) < b.bonus_start_ET then 'NOT STARTED'
          else 'EXPIRED' end as expiry_status,
          case when f.state is null then
           CASE WHEN (DATEADD(day, b.days_to_opt_in, convert_timezone('UTC','America/New_York', a.created)) > CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) OR b.days_to_opt_in = 0)
              THEN 'NO LOGIN'
              ELSE 'NO LOGIN - MISSED'
          END else f.state end as user_state,
          convert_timezone('UTC','America/New_York',TO_TIMESTAMP(split_part(regexp_substr(f.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_time_ET,
          b.segment_id,
          parse_json(c.data):CustomerSegment:name::VARCHAR AS segment_name,
          convert_timezone('UTC','America/New_York', a.created) as segment_created_time_ET,
          b.bonus_start_ET,
          b.bonus_expire_ET,
          b.days_to_opt_in,
          d.settlement_type,
          d.bonus_code,
          d.bonus_origin,
          d.description,
          d.oddsboost_description,
          d.boost_percentage,
          d.bonus_deposit_percentage
      FROM fbg_source.osb_source.account_segments a
      LEFT JOIN final b
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
      on u.acco_id = a.accounts_id
      LEFT JOIN fbg_analytics.product_and_customer.t_daily_rewards_record z
      on z.acco_id = a.accounts_id
      and date(z.insert_timestamp) = current_date() - 1
      WHERE e.excluded_segment_id IS NULL -- Exclude users in excluded segments
       AND b.bonus_campaign_id IS NOT NULL   
        --and CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between b.bonus_start_ET and b.bonus_expire_ET 
        and (b.bonus_start_ET >= '2025-08-23' OR b.bonus_expire_ET >= '2025-08-23')
        and description not ilike '%DO NOT TURN ACTIVE%'
        and vip_host is not null
        --and user_state <> 'NO LOGIN - MISSED'
        and b.bonus_name not ilike '%seg sync%'
  
      -- Add global bonuses for the specific user, but deduplicate global IDs
      UNION ALL
      SELECT DISTINCT -- Remove duplicates only for global bonuses
          a.accounts_id AS acco_id,
          vip_host,
          u.daily_rewards_offer_id as Tier,
          coded_total_tier as VIPTier,
          b.bonus_campaign_id,
          b.bonus_name,
    -- TRY_TO_NUMBER(
    --   REPLACE(
    --     REPLACE(
    --       REGEXP_SUBSTR(b.bonus_name, '\\$[0-9][0-9,]*(\\.[0-9]+)?')
    --     , '$', ''
    --     )
    --   , ',', ''
    --   )
    -- ) AS amount,
          b.amount_max,
          b.bonus_status,
          case when CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between b.bonus_start_ET and b.bonus_expire_ET then 'ACTIVE' 
          when CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) < b.bonus_start_ET then 'NOT STARTED'
          else 'EXPIRED' end as expiry_status,
          case when f.state is null then
           CASE WHEN  (DATEADD(day, b.days_to_opt_in, b.bonus_start_ET) > CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) OR b.days_to_opt_in = 0)
              THEN 'NO LOGIN'
              ELSE 'NO LOGIN - MISSED'
          END else f.state end as user_state,
          convert_timezone('UTC','America/New_York',TO_TIMESTAMP(split_part(regexp_substr(f.overrides, 'optInTime\\W+\\w+'), '=', 2))) AS opt_in_time_ET,
          'GLOBAL' AS segment_id,
          'GLOBAL' AS segment_name,
          null AS segment_created_time_ET,
          b.bonus_start_ET,
          b.bonus_expire_ET,
          b.days_to_opt_in,
          d.settlement_type,
          d.bonus_code,
          d.bonus_origin,
          d.description,
          d.oddsboost_description,
          d.boost_percentage,
          d.bonus_deposit_percentage
      FROM fbg_source.osb_source.account_segments a
      LEFT JOIN final b -- Include all global bonuses (segment_id IS NULL)
       on b.segment_id is null
      LEFT JOIN fbg_analytics_engineering.product.promotions d
          ON d.id = b.bonus_campaign_id
      LEFT JOIN excluded_mapping e
          ON b.bonus_campaign_id = e.bonus_campaign_id 
          AND a.customer_segments_id = e.excluded_segment_id -- Exclude users in excluded segments
      LEFT JOIN fbg_source.osb_source.account_bonuses f
          ON b.bonus_campaign_id = f.bonus_campaign_id 
          AND a.accounts_id = f.acco_id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart u
      on u.acco_id = a.accounts_id
      LEFT JOIN fbg_analytics.product_and_customer.t_daily_rewards_record z
      on z.acco_id = a.accounts_id
      and date(z.insert_timestamp) = current_date() - 1
      WHERE b.segment_id IS NULL -- Only include global bonuses
         AND b.bonus_campaign_id IS NOT NULL
         AND NOT EXISTS (
              SELECT 1
              FROM excluded_mapping e
              JOIN fbg_source.osb_source.account_segments a2
                ON e.excluded_segment_id = a2.customer_segments_id
              WHERE e.bonus_campaign_id = b.bonus_campaign_id
                AND a2.accounts_id = a.accounts_id
         ) -- Exclude users in excluded segments
        --and CONVERT_TIMEZONE('UTC', 'America/New_York', CURRENT_TIMESTAMP) between b.bonus_start_ET and b.bonus_expire_ET
        and (b.bonus_start_ET >= '2025-08-23' OR b.bonus_expire_ET >= '2025-08-23')
        and description not ilike '%DO NOT TURN ACTIVE%'
        and b.bonus_name not ilike '%seg sync%'
        and vip_host is not null
        --and user_state <> 'NO LOGIN - MISSED'
) "Custom SQL Query"
