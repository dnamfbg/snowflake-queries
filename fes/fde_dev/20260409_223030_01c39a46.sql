-- Query ID: 01c39a46-0112-6806-0000-e307218d3626
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:30:30.820000+00:00
-- Elapsed: 1281ms
-- Environment: FES

select * from (
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
    
    ) as __dbt_sbq
    where false
    limit 0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "dim_fbg_purchase", "node_alias": "dim_fbg_purchase", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_fbg_purchase.sql", "node_database": "fangraph_dev", "node_schema": "fbg", "node_id": "model.fes_data.dim_fbg_purchase", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": [], "materialized": "incremental", "raw_code_hash": "cbd581fbe8569f2b46949807da4666a5"} */
