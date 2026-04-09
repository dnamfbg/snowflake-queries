-- Query ID: 01c399e4-0112-6029-0000-e307218a532e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:52:28.763000+00:00
-- Elapsed: 715ms
-- Environment: FES

create or replace  temporary view fangraph_dev.fbg.dim_fbg_purchase__dbt_tmp
  
    
    
(
  
    "ACCOUNT_ID" COMMENT $$$$, 
  
    "WAGER_ID" COMMENT $$$$, 
  
    "LEG_ID" COMMENT $$$$, 
  
    "WAGER_PLACED_TIME_UTC" COMMENT $$$$, 
  
    "WAGER_SETTLEMENT_TIME_UTC" COMMENT $$$$, 
  
    "WAGER_MODIFIED_TIME_UTC" COMMENT $$$$, 
  
    "EVENT_TIME_UTC" COMMENT $$$$, 
  
    "LEG_EVENT_TIME_UTC" COMMENT $$$$, 
  
    "TOTAL_EXPECTED_HOLD_PCT_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_STAKE_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_GGR_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_PAYOUT_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_WINNINGS_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_PRICE_BY_WAGER" COMMENT $$$$, 
  
    "TOTAL_STAKE_BY_LEGS" COMMENT $$$$, 
  
    "TOTAL_GGR_BY_LEGS" COMMENT $$$$, 
  
    "TOTAL_PAYOUT_BY_LEGS" COMMENT $$$$, 
  
    "TOTAL_WINNINGS_BY_LEGS" COMMENT $$$$, 
  
    "WAGER_BOOST_PAYOUT" COMMENT $$$$, 
  
    "TRADING_WIN" COMMENT $$$$, 
  
    "NUMBER_OF_LINES_BY_WAGER" COMMENT $$$$, 
  
    "LEG_ODDS" COMMENT $$$$, 
  
    "LEG_PROBABILITY" COMMENT $$$$, 
  
    "LEG_HOURS_FROM_PLACED_TO_EVENT_START_BUCKETS" COMMENT $$$$, 
  
    "PROMOTION_BOOST_PERCENTAGE" COMMENT $$$$, 
  
    "PROMOTION_BONUS_CODE" COMMENT $$$$, 
  
    "PROMOTION_SETTLEMENT_TYPE" COMMENT $$$$, 
  
    "PROMOTION_STATUS" COMMENT $$$$, 
  
    "BONUS_CATEGORY" COMMENT $$$$, 
  
    "MARKET_GROUPING" COMMENT $$$$, 
  
    "WAGER_BET_TYPE" COMMENT $$$$, 
  
    "WAGER_CHANNEL" COMMENT $$$$, 
  
    "EVENT_COUNTRY" COMMENT $$$$, 
  
    "EVENT_LEAGUE" COMMENT $$$$, 
  
    "EVENT_SPORT_NAME" COMMENT $$$$, 
  
    "EVENT_VENUE_NAME" COMMENT $$$$, 
  
    "EVENT_NAME" COMMENT $$$$, 
  
    "EVENT_STATE" COMMENT $$$$, 
  
    "COMPETITOR_A_NAME" COMMENT $$$$, 
  
    "COMPETITOR_B_NAME" COMMENT $$$$, 
  
    "LEG_SELECTION" COMMENT $$$$, 
  
    "LEG_RESULT_TYPE" COMMENT $$$$, 
  
    "LEG_MARKET" COMMENT $$$$, 
  
    "LEG_MARKET_GROUP" COMMENT $$$$, 
  
    "LEG_SPORT_CATEGORY" COMMENT $$$$, 
  
    "IS_WAGER_SINGLE_OR_PARLAY" COMMENT $$$$, 
  
    "WAGER_RESULT" COMMENT $$$$, 
  
    "WAGER_STATUS" COMMENT $$$$, 
  
    "WAGER_STATE" COMMENT $$$$, 
  
    "ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT" COMMENT $$$$, 
  
    "_INSERT_TS" COMMENT $$$$, 
  
    "_UPDATE_TS" COMMENT $$$$
  
)

   as (
    SELECT
    account_id,
    wager_id,
    leg_id,
    wager_placed_time_utc,
    wager_settlement_time_utc,
    wager_modified_time_utc,
    event_time_utc,
    leg_event_time_utc,
    total_expected_hold_pct_by_wager,
    total_stake_by_wager,
    total_ggr_by_wager,
    total_payout_by_wager,
    total_winnings_by_wager,
    total_price_by_wager,
    total_stake_by_legs,
    total_ggr_by_legs,
    total_payout_by_legs,
    total_winnings_by_legs,
    wager_boost_payout,
    trading_win,
    number_of_lines_by_wager,
    leg_odds,
    leg_probability,
    leg_hours_from_placed_to_event_start_buckets,
    promotion_boost_percentage,
    promotion_bonus_code,
    promotion_settlement_type,
    promotion_status,
    bonus_category,
    market_grouping,
    wager_bet_type,
    wager_channel,
    event_country,
    event_league,
    event_sport_name,
    event_venue_name,
    event_name,
    event_state,
    competitor_a_name,
    competitor_b_name,
    leg_selection,
    leg_result_type,
    leg_market,
    leg_market_group,
    leg_sport_category,
    is_wager_single_or_parlay,
    wager_result,
    wager_status,
    wager_state,
    account_value_band_as_of_placement,
    CURRENT_TIMESTAMP() AS _insert_ts,
    CURRENT_TIMESTAMP() AS _update_ts
FROM fbg_fde.fbg_bets.v_fbg_trading_sportsbook_mart
WHERE
    is_test_wager = 0
    
        AND wager_modified_time_utc > (
            SELECT MAX(wager_modified_time_utc) FROM fangraph_dev.fbg.dim_fbg_purchase
        )
    
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "dim_fbg_purchase", "node_alias": "dim_fbg_purchase", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_fbg_purchase.sql", "node_database": "fangraph_dev", "node_schema": "fbg", "node_id": "model.fes_data.dim_fbg_purchase", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": [], "materialized": "incremental", "raw_code_hash": "cbd581fbe8569f2b46949807da4666a5"} */;
