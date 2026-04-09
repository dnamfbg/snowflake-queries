-- Query ID: 01c39a0b-0212-6b00-24dd-07031936f86f
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:31:05.132000+00:00
-- Elapsed: 2031ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__sportsbook_bet_parts_detail
  
  
  
  
  as (
    



WITH base_cte AS (
    SELECT
        betparts.id,
        betparts.bet_parts_id,
        betparts.bet_id,
        betparts.node_id,
        betparts.market_id,
        betparts.instrument_id,
        betparts.sprt_id,

        /* Part Information */
        betparts.part_no,
        betparts.selection_type,
        betparts.selection,
        betparts.result_type,
        betparts.result_reason,

        /* Pricing */
        betparts.price,
        betparts.original_price,
        betparts.prob,
        betparts.stake_coef,
        betparts.liability_limit,

        /* Event Information */
        betparts.sport,
        betparts.event,
        betparts.market,
        COALESCE(betparts.market_type, 'PB Bet') AS market_type,
        betparts.market_sub_type,
        betparts.limit_tier,

        /* Derived Columns from bet_parts */
        betparts.market_group,
        betparts.hours_from_placed_to_event_start,
        betparts.hours_to_event_bucket,
        betparts.selection_described,

        /* Boolean Flags from bet_parts */
        betparts.is_live_bet,
        betparts.is_outright,
        betparts.is_boost_market,

        /* Timestamps from bet_parts */
        betparts.placed_at,
        betparts.event_at,

        /* Columns from silver__sportsbook_bets_detail */
        bet.acco_id,
        bet.bonus_campaign_id,
        bet.account_bonuses_id,
        bet.wager_result,
        bet.is_free_bet,
        bet.bet_status,
        bet.void_reason,
        bet.channel,
        bet.is_test,
        bet.jurisdictions_id,
        bet.country_code,
        bet.campaign_modified_at,
        bet.is_build_a_bet,
        bet.teaser_price,
        bet.bet_type,
        bet.payout,
        bet.total_stake,
        bet.total_price,
        bet.settlement_at AS bet_settlement_at,
        bet.placed_at AS bet_placed_at,
        bet.modified_at AS bet_modified_at,
        bet.fancash_stake_amount,
        bet.is_odds_boost_bonus,
        bet.is_fancash_wager,
        bet.is_profit_boost_token,
        bet.fancash_bonus_bet_amount,
        bet.fancash_profit_boost_amount,
        bet.fancash_bonus_bet_percentage,
        bet.bonus_code,
        bet.campaign_description,
        bet.bonus_category,
        bet.subcategory,
        bet.series,
        bet.boost_pct,
        bet.referee_acco_id,

        /* Columns from nodes - single join with parent lookup */
        event_node.name AS event_name,
        league_node.name AS event_league,

        /* Pre-compute boost eligibility flag once */
        CASE 
            WHEN bet.channel = 'INTERNET'
             AND bet.is_fancash_wager = FALSE
             AND bet.is_odds_boost_bonus = FALSE
             AND betparts.is_boost_market = TRUE
            THEN TRUE
            ELSE FALSE
        END AS is_boost_eligible,

        /* Pre-compute settled boost eligibility (for fallback price) */
        CASE 
            WHEN bet.channel = 'INTERNET'
             AND bet.is_fancash_wager = FALSE
             AND bet.is_odds_boost_bonus = FALSE
             AND betparts.is_boost_market = TRUE
             AND bet.settlement_at IS NOT NULL
            THEN TRUE
            ELSE FALSE
        END AS is_boost_settled,

        /* Warehouse Metadata */
        bet.campaign_record_created_at,
        bet.campaign_record_last_updated,
        bet.record_created_at AS bet_record_created_at,
        bet.record_last_updated AS bet_record_last_updated,
        betparts.record_created_at,
        betparts.record_last_updated,
        GREATEST(
            COALESCE(bet.upstream_record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(betparts.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(event_node.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(league_node.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ)
        ) AS upstream_record_last_updated

    FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_bet_parts AS betparts
    INNER JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__sportsbook_bets_detail AS bet
        ON betparts.bet_id = bet.id
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_nodes AS event_node
        ON betparts.node_id = event_node.id
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_nodes AS league_node
        ON event_node.parent_node_id = league_node.id
    WHERE betparts.bet_parts_id > 45
)



, boost_instrument_agg AS (
    SELECT
        instrument_id,
        /* Selection for parsing - only from eligible boost bets */
        MAX(CASE WHEN is_boost_eligible THEN selection END) AS _boost_selection,
        /* Fallback price - only from settled eligible boost bets */
        MIN(CASE WHEN is_boost_settled THEN COALESCE(original_price, price) END) AS _boost_fallback_price
    FROM base_cte
    WHERE is_boost_market = TRUE
    GROUP BY instrument_id
),

boost_parsed AS (
    SELECT
        instrument_id,
        _boost_selection,
        _boost_fallback_price,
        REGEXP_SUBSTR(_boost_selection, '\\(was\\s*([+-])\\s*(\\d+)', 1, 1, 'i', 1) AS _parsed_sign,
        REGEXP_SUBSTR(_boost_selection, '\\(was\\s*([+-])\\s*(\\d+)', 1, 1, 'i', 2) AS _parsed_odds,
        REGEXP_INSTR(_boost_selection, '\\(was\\s*[+-]?\\s*[^)]*x', 1, 1, 0, 'i') > 0 AS _has_invalid_x
    FROM boost_instrument_agg
),

boosted_markets__step1_non_boosted_price AS (
    SELECT
        instrument_id,
        _boost_selection AS boost_selection,
        CASE
            WHEN _has_invalid_x THEN _boost_fallback_price
            WHEN _parsed_odds IS NOT NULL
                 AND _parsed_odds != ''
                 AND _parsed_odds != '0'
            THEN CASE
                WHEN _parsed_sign = '+'
                    THEN (TO_DOUBLE(_parsed_odds) / 100) + 1
                WHEN _parsed_sign = '-'
                    THEN 1 + (100 / TO_DOUBLE(_parsed_odds))
                ELSE _boost_fallback_price
            END
            ELSE _boost_fallback_price
        END AS non_boosted_price
    FROM boost_parsed
)



, final AS (
    SELECT
        base.* EXCLUDE (is_boost_eligible, is_boost_settled, record_created_at, record_last_updated, bet_record_created_at, bet_record_last_updated),

        CASE WHEN base.is_boost_market THEN boost.non_boosted_price END AS non_boosted_price,

        boost.boost_selection,

        CASE
            WHEN base.is_boost_market AND boost.non_boosted_price > 0 AND base.price > 0
            THEN ROUND((base.price - boost.non_boosted_price) / boost.non_boosted_price * 100, 2)
        END AS boost_margin_pct,

        /* Warehouse Metadata */
        base.bet_record_created_at,
        base.bet_record_last_updated,
        base.record_created_at,
        base.record_last_updated,
        CURRENT_TIMESTAMP() AS model_run_at

    FROM base_cte AS base
    LEFT JOIN boosted_markets__step1_non_boosted_price boost
      ON base.instrument_id = boost.instrument_id
)

SELECT * FROM final
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "181f48aa-19fc-4bf0-b2ae-e91ec6cc6daf", "run_started_at": "2026-04-09T21:30:57.798057+00:00", "full_refresh": true, "which": "run", "node_name": "silver__sportsbook_bet_parts_detail", "node_alias": "silver__sportsbook_bet_parts_detail", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/trading/silver/silver__sportsbook_bet_parts_detail.sql", "node_database": "FBG_ANALYTICS_DEV", "node_schema": "KATE_SMOLKO", "node_id": "model.dbt_analytics_engineering.silver__sportsbook_bet_parts_detail", "node_resource_type": "model", "node_meta": {"contains_pii": false, "cost_center": "Analytics Engineering"}, "node_tags": ["view"], "invocation_command": "dbt ", "node_refs": ["bronze__osb_source_bet_parts", "silver__sportsbook_bets_detail", "bronze__osb_source_nodes"], "materialized": "view", "raw_code_hash": "acdd2fe0819c8d555431b0b5d9ed3d5f"} */;
