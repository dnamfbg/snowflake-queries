-- Query ID: 01c399f3-0212-67a9-24dd-0703193168df
-- Database: FBG_ANALYTICS_DEV
-- Schema: ALVIN_CHAI
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:07:57.966000+00:00
-- Elapsed: 2639ms
-- Environment: FBG

WITH dag_models AS (
    SELECT model_name FROM (VALUES
        ('customer_mart'),('customer_demographics_and_information'),('customer_registration'),
        ('customer_marketing_and_acquisition'),('customer_product_preferences'),('customer_betting_activity'),
        ('customer_vip_and_segmentation'),('customer_acquisition_and_tracking'),('customer_financial_information'),
        ('customer_pointsbet_metrics'),('bronze__fde_fbg_info_fbg_affiliate_ftusf'),('stg_casino_segment'),
        ('stg_trading_accounts'),('stg_trading_promotions'),('stg_pointsbet_segments'),
        ('stg_trading_sporting_event_results_score_summary'),('stg_first_deposit'),('stg_offer_bonus_double_dip_cyoo'),
        ('dim_trading_jurisdictions'),('stg_acquisition_pre1_gatheracq'),('transactions_mart'),
        ('sporting_events'),('vip_customer_info'),('trading_legs'),('stg_acquisition_on_registration'),
        ('stg_acquisition_source'),('stg_casino_game_preference'),('stg_vip_acquisition'),
        ('s_transactions_timestamps'),('stg_casino_first_time_cash_user'),('stg_wager_leg_results'),
        ('trading_wagers'),('casino_game_details'),('stg_casino_segment_tier'),('stg_acquisition_pre4_randomize'),
        ('stg_sportsbook_first_time_user'),('stg_vip_lifecycle_cas'),('stg_trading_displayed_events'),
        ('stg_trading_legs'),('stg_fbg_firsts'),('stg_fanapp_attribution'),('stg_sub_channel_bc'),
        ('itm_boost_market_payout'),('stg_bet_in_casino_state'),('stg_product_preference'),
        ('stg_sportsbook_first_time_cash_user'),('stg_offer_bonus'),('stg_trading_legs_sport_category'),
        ('stg_fanapp_tenant_id'),('h_transactions'),('stg_first_bet_after_deposit'),('casino_transactions_mart'),
        ('stg_casino_daily_player_agg'),('stg_first_use_data'),('promotions'),('stg_illegitimate_intent'),
        ('stg_casino_behavioral_segment'),('stg_trading_sporting_special_event_details'),('stg_casino_days'),
        ('itm_boost_token_payout'),('stg_acquisition_channel'),('stg_last_updated_leg_wager'),
        ('stg_offer_bonus_cyoo'),('stg_salesforce_all'),('stg_trading_sporting_event_details'),
        ('stg_fancash_stake_amounts'),('stg_sbk_segments'),('stg_trading_wagers'),
        ('stg_acquisition_pre2_restricted_hash'),('stg_account_status_inc'),('stg_kyc'),('stg_first_login'),
        ('fancash_transactions_mart'),('stg_acquisition_pre5_webattribution'),('stg_acquisition_sub_channel'),
        ('fanapp_customer_info'),('casino_sessions_mart'),('stg_login_customer_segments'),
        ('stg_trading_sporting_event_results_score_summary_parse'),('itm_non_boosted_selection_price'),
        ('stg_casino_first_time_user'),('itm_restricted_handle'),('stg_trading_sporting_special_level_event_details'),
        ('stg_fanapp_reg_info'),('itm_resettled_wagers'),('retail_transactions_mart'),('stg_duplicate_flag'),
        ('stg_acquisition_pre3_hashed_date'),('trading_sportsbook_mart'),('casino_first_time_users'),
        ('account_statements_transactions_mart'),('stg_casino_cluster'),('stg_vip_lifecycle_osb'),
        ('stg_estimated_expected_margin'),('event_history'),('stg_automatic_kyc'),
        ('stg_trading_sporting_event_results_summary_parse'),('itm_boost_payout'),('stg_sbk_cluster'),
        ('sportsbook_first_time_users'),('s_transactions_location'),('stg_sportsbook_days'),
        ('stg_trading_promotions_oddsboost'),('stg_casino_session_activity'),('stg_manual_kyc'),
        ('stg_double_dip_on_registration'),('stg_acquisition_bonus_name'),('s_transactions_meta'),
        ('stg_trading_sporting_event_results_summary'),('s_transactions_financial'),('s_transactions_references'),
        ('stg_trading_event_event_history'),('dn_media_source_clean'),('pointsbet_migration_status'),
        ('elite_users')
    ) AS t(model_name)
),
-- Get cost per model per day, then average per model using the most common warehouse size (mode)
model_daily_cost AS (
    SELECT
        r.NAME,
        r.MATERIALIZATION,
        r.WAREHOUSE_SIZE,
        SUM(r.TOTAL_DAILY_COST) / NULLIF(SUM(r.TOTAL_RUNS), 0) AS cost_per_run,
        AVG(r.RUNTIME_MINUTES) AS avg_runtime_min,
        SUM(r.TOTAL_RUNS) AS total_runs,
        SUM(r.TOTAL_DAILY_COST) AS total_cost
    FROM FBG_ANALYTICS_ENGINEERING.STAGING.DBT_CLOUD_MODEL_RUNS r
    INNER JOIN dag_models d ON LOWER(r.NAME) = LOWER(d.model_name)
    WHERE r.RUN_DATE_UTC >= DATEADD('day', -30, CURRENT_DATE())
    GROUP BY r.NAME, r.MATERIALIZATION, r.WAREHOUSE_SIZE
),
-- Pick the most frequently used warehouse size per model (highest total_runs)
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY NAME ORDER BY total_runs DESC, total_cost DESC) AS rn
    FROM model_daily_cost
)
SELECT
    NAME,
    MATERIALIZATION,
    WAREHOUSE_SIZE,
    ROUND(avg_runtime_min, 2) AS avg_runtime_min,
    ROUND(cost_per_run, 4) AS cost_per_run,
    total_runs
FROM ranked
WHERE rn = 1
ORDER BY cost_per_run DESC
