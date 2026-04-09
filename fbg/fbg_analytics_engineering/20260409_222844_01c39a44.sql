-- Query ID: 01c39a44-0212-6dbe-24dd-070319441973
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:28:44.637000+00:00
-- Elapsed: 68727ms
-- Environment: FBG

SELECT "Custom SQL Query"."MARKET_ID" AS "MARKET_ID"
FROM (
  WITH stage_1 AS (
      SELECT
          instrument_id AS selection_id,
          MAX(selection) AS selection_name,
          MAX(market_id) AS market_id,
          MAX(bet_parts.node_id) AS event_id,
          MAX(bets.dw_last_updated) AS bet_modified_date_stage,
          MAX(market) AS market_name,
          MAX(comp) AS competition,
  
          -- needs updating
          MAX(
              CASE
                  WHEN fp.provider IS NULL THEN 1
                  WHEN fp.provider LIKE '%ATS%' THEN 1
                  ELSE 0
              END
          ) AS manual_market,
  
          MAX(
              CASE
                  WHEN LOWER(current_value_band) LIKE '%vip%' AND result_type = 'NOT_SET' THEN 1
                  ELSE 0
              END
          ) AS vip_active_on_market,
  
          MAX(bet_parts.mrkt_type) AS mrkt_type,
          MAX(tier1_group) AS market_group_1,
          MAX(tier2_group) AS market_group_2,
  
          MAX(
              CASE
                  WHEN bet_parts.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:ML','ICE_HOCKEY:FTOT:ML','BASEBALL:FTOT:ML','BASKETBALL:FTOT:ML')
                      THEN 'Money Line'
                  WHEN bet_parts.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:SPRD','BASKETBALL:FTOT:SPRD','BASEBALL:FTOT:SPRD','ICE_HOCKEY:FTOT:SPRD')
                      THEN 'Spread'
                  WHEN bet_parts.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:OU','BASKETBALL:FTOT:OU','BASEBALL:FTOT:OU','ICE_HOCKEY:FTOT:OU')
                      THEN 'Totals'
                  ELSE 'Other'
              END
          ) AS six_box_market,
  
          MAX(event) AS event_name,
  
          MIN(DATE(CONVERT_TIMEZONE('UTC','America/New_York', bet_parts.event_time))) AS event_date_et,
          MIN(CONVERT_TIMEZONE('UTC','America/New_York', bet_parts.event_time)) AS event_time_et,
          MIN(DATE(CONVERT_TIMEZONE('UTC','America/New_York', bet_parts.event_time))) AS event_end_time_et,
  
          MIN(
              CONVERT_TIMEZONE(
                  'UTC',
                  'America/New_York',
                  DATEADD(
                      'ms',
                      IFNULL(NULLIF(
                          (SPLIT_PART(SPLIT_PART(m.attributes, 'firstResultedTime=', 2), ';', 1))::varchar,
                          ''
                      ), 0),
                      '1970-01-01'
                  )
              )
          ) AS market_settlement_time,
  
          MAX(
              INITCAP(
                  REPLACE(
                      CASE
                          WHEN LOWER(sport) LIKE '%kazakhstan first%' THEN 'Soccer'
                          WHEN LOWER(sport) LIKE '%australia national%' THEN 'Soccer'
                          WHEN LOWER(sport) LIKE '%italy serie%' THEN 'Soccer'
                          WHEN LOWER(sport) LIKE '%synthesized%' THEN 'Soccer'
                          WHEN LOWER(sport) LIKE '%china basketball%' THEN 'Other Basketball'
                          WHEN LOWER(sport) LIKE '%itf mexico f1%' THEN 'Tennis'
                          WHEN comp ILIKE '%boost%' OR market ILIKE '%boost%' OR bet_parts.mrkt_type ILIKE '%boost%' THEN 'Odds Boost'
                          WHEN LOWER(sport) = 'basketball3x3' THEN sport
                          WHEN sport ILIKE '%Baseball%' AND comp ILIKE '%MLB%' THEN 'MLB'
                          WHEN comp ILIKE '%NFL%' THEN 'NFL'
                          WHEN sport ILIKE '%Baseball%' AND comp NOT ILIKE '%MLB%' THEN 'Other Baseball'
                          WHEN sport ILIKE '%American%Football%' AND comp ILIKE '%NCAA%' THEN 'CFB'
                          WHEN sport ILIKE '%Soccer%' THEN 'Soccer'
                          WHEN sport ILIKE '%Basketball%' AND comp ILIKE 'NBA%' THEN 'NBA'
                          WHEN sport ILIKE '%Basketball%' AND comp ILIKE '%WNBA%' THEN 'WNBA'
                          WHEN sport ILIKE '%Basketball%' AND (
                              comp ILIKE '%NCAA%' OR
                              comp = 'National Invitation Tournament' OR
                              comp ILIKE '%COLLEGE%'
                          ) THEN 'NCAA Basketball'
                          WHEN sport ILIKE '%Basketball%' AND comp NOT ILIKE '%NCAA%' AND comp NOT LIKE '%NBA%' THEN 'Other Basketball'
                          WHEN sport ILIKE '%Ice%Hockey%' AND comp ILIKE '%NHL%' THEN 'NHL'
                          WHEN sport ILIKE '%Ice%Hockey%' AND comp NOT ILIKE '%NHL%' THEN 'Other Hockey'
                          WHEN sport ILIKE '%Table%Tennis%' THEN 'Table Tennis'
                          WHEN UPPER(sport) = 'TENNIS' THEN 'Tennis'
                          WHEN comp ILIKE '%UFC%' THEN 'MMA'
                          WHEN sport ILIKE '%MMA%' THEN 'MMA'
                          WHEN sport ILIKE '%NASCAR%' OR comp ILIKE '%NASCAR%' THEN 'Motorsports'
                          WHEN sport = 'MOTOR_SPORTS' THEN 'Motorsports'
                          WHEN sport ILIKE '%Boxing%' THEN 'Boxing'
                          WHEN sport ILIKE '%Golf%' THEN 'Golf'
                          WHEN sport ILIKE '%Ice%Hockey%' OR sport ILIKE '%Basketball%' OR sport ILIKE '%American Football%' OR sport ILIKE '%Baseball%'
                              THEN comp
                          ELSE sport
                      END,
                  '_', ' ')
              )
          ) AS sport_stage,
  
          -- needs updating
          MAX(COALESCE(fp.provider, 'UNKNOWN')) AS provider,
  
          SUM(
              CASE WHEN (
                  CASE
                      WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE THEN TRUE
                      ELSE bets.free_bet
                  END
              ) = FALSE THEN
                  (
                      CASE
                          WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE
                              THEN COALESCE(sfsa.bonus_bet_amount, 0)
                          ELSE bets.total_stake
                      END
                  ) / num_lines
              ELSE 0 END
          ) AS cash_handle,
  
          SUM(
              CASE WHEN LOWER(current_value_band) LIKE '%vip%' AND (
                  CASE
                      WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE THEN TRUE
                      ELSE bets.free_bet
                  END
              ) = FALSE THEN
                  (
                      CASE
                          WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE
                              THEN COALESCE(sfsa.bonus_bet_amount, 0)
                          ELSE bets.total_stake
                      END
                  ) / num_lines
              ELSE 0 END
          ) AS vip_cash_handle,
  
          SUM(
              CASE WHEN result_type = 'NOT_SET' AND (
                  CASE
                      WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE THEN TRUE
                      ELSE bets.free_bet
                  END
              ) = FALSE THEN
                  (
                      CASE
                          WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE
                              THEN COALESCE(sfsa.bonus_bet_amount, 0)
                          ELSE bets.total_stake
                      END
                  ) / num_lines
              ELSE 0 END
          ) AS unsettled_handle,
  
          SUM(
              CASE WHEN result_type = 'NOT_SET'
                AND LOWER(current_value_band) LIKE '%vip%'
                AND (
                      CASE
                          WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE THEN TRUE
                          ELSE bets.free_bet
                      END
                    ) = FALSE
              THEN
                  (
                      CASE
                          WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE
                              THEN COALESCE(sfsa.bonus_bet_amount, 0)
                          ELSE bets.total_stake
                      END
                  ) / num_lines
              ELSE 0 END
          ) AS unsettled_vip_handle
  
      FROM fbg_source.osb_source.bets AS bets
      INNER JOIN fbg_source.osb_source.bet_parts AS bet_parts
          ON bets.id = bet_parts.bet_id
      LEFT JOIN fbg_source.osb_source.markets AS m
          ON bet_parts.market_id = m.id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart AS cm
          ON bets.acco_id = cm.acco_id
      LEFT JOIN fbg_analytics.trading.market_definitions AS md
          ON bet_parts.mrkt_type = md.market_type
      LEFT JOIN fbg_analytics.trading.feedprovider AS fp
          ON bet_parts.instrument_id = fp.instrumentid
      LEFT JOIN fbg_analytics_engineering.staging.stg_fancash_stake_amounts AS sfsa
          ON bets.id = sfsa.bet_id
  
      WHERE bets.status <> 'REJECTED'
        AND result_type = 'NOT_SET'
        AND bets.status = 'ACCEPTED'
        AND CASE
              WHEN bets.fancash_stake_amount > 0
                   AND bets.free_bet = FALSE
                   AND sfsa.bet_id IS NULL THEN 0
              ELSE 1
            END = 1
        AND cm.is_test_account = FALSE
  
      GROUP BY ALL
  ),
  
  stage_2 AS (
      SELECT
          stage_1.*,
          CASE
              WHEN sport_stage IN ('Mlb','Nfl','Nba','Wnba','Nhl','Mma','Cfb')
                  THEN UPPER(sport_stage)
              WHEN sport_stage = 'Ncaa Basketball'
                  THEN 'NCAA Basketball'
              ELSE sport_stage
          END AS sport,
          MAX(bet_modified_date_stage) OVER (PARTITION BY 1) AS max_bet_modified_date,
          SUM(unsettled_handle) OVER (PARTITION BY market_id) AS market_unsettled_handle
      FROM stage_1
  )
  
  SELECT *
  FROM stage_2
) "Custom SQL Query"
GROUP BY 1
