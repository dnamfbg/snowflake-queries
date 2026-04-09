-- Query ID: 01c39a0a-0212-67a8-24dd-07031936d4af
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T21:30:08.132000+00:00
-- Elapsed: 1077ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__sportsbook_bets_detail
  
  
  
  
  as (
    WITH silver__sportsbook_bets_detail AS (
    SELECT
        /* Primary Keys */
        bet.id,
        bet.acco_id,
        bet.betslip_id,

        /* Foreign Keys */
        bet.brand_id,
        bet.chan_id,
        bet.jurisdictions_id,
        bet.bonus_campaign_id,
        bet.account_bonuses_id,
        bet.fund_type_id,
        bet.wallet_type_id,
        bet.bet_type_id,
        bet.retail_card_id,

        /* Reference Identifiers */
        bet.reference,
        bet.external_bet_id,
        bet.pointsbet_bet_id,

        /* Status and Type */
        bet.status AS bet_status,
        bet.bet_type,
        bet.channel,
        bet.currency,
        bet.country_code,
        bet.void_reason,
        bet.wager_result,
        bet.result,

        /* Stake Amounts */
        bet.total_stake,
        bet.captured_stake,
        bet.requested_stake,
        bet.bonus_stake,
        bet.fancash_stake_amount,
        bet.min_stake,
        bet.max_stake,

        /* Price Fields */
        bet.total_price,
        bet.request_price,
        bet.teaser_price,
        bet.price_at_placement,

        /* Winnings and Payout */
        bet.winnings,
        bet.odds_boost_bonus_winnings,
        bet.payout,
        bet.max_payout,
        bet.refund,
        bet.cashout_amt,

        /* Counts */
        bet.num_bets,
        bet.num_lines,
        bet.settlement_version,
        bet.cashout_count,
        bet.pct_max_stake_used,

        /* Boolean Flags from Bets */
        CASE WHEN fancash.bet_id IS NOT NULL THEN TRUE ELSE bet.is_free_bet END AS is_free_bet,
        bet.is_build_a_bet,
        bet.is_test,
        bet.is_odds_boost_bonus,
        bet.is_insurance_bonus,
        bet.is_cancelled,
        bet.is_overask,

        /* FanCash Wager Flag (same logic as TRADING_SPORTSBOOK_MART) */
        CASE 
            WHEN fancash.bet_id IS NOT NULL THEN TRUE
            WHEN bet.is_free_bet = FALSE AND bet.fancash_stake_amount > 0 THEN TRUE 
            ELSE FALSE 
        END AS is_fancash_wager,

        /* Profit Boost Token Flag (same logic as TRADING_SPORTSBOOK_MART) */
        (CASE
            WHEN fancash.bet_id IS NOT NULL THEN FALSE
            WHEN bet.is_free_bet = FALSE AND bet.fancash_stake_amount > 0 THEN FALSE
            WHEN bet.status = 'SETTLED' THEN bet.is_odds_boost_bonus
            ELSE FALSE
        END)::BOOLEAN AS is_profit_boost_token,


        /* FanCash Bonus Amounts from Account Bonuses */
        COALESCE(bonus.bonus_bet_amount, fancash.bonus_bet_amount) AS fancash_bonus_bet_amount,
        COALESCE(bonus.profit_boost_amount, fancash.profit_boost_amount) AS fancash_profit_boost_amount,
        COALESCE(bonus.bonus_bet_percentage, fancash.bonus_bet_percentage) AS fancash_bonus_bet_percentage,
        bonus.referee_fan_id,
        referee_map.acco_id AS referee_acco_id,

        /* Applied Campaign Details from Bonus Campaigns */
        campaign.bonus_code,
        campaign.description AS campaign_description,
        campaign.bonus_category,
        campaign.subcategory,
        campaign.series,
        campaign.boost_pct,
        campaign.modified_at AS campaign_modified_at,
        campaign.record_created_at AS campaign_record_created_at,
        campaign.record_last_updated AS campaign_record_last_updated,

        /* Timestamps */
        bet.placed_at,
        bet.settlement_at,
        bet.voided_at,
        bet.modified_at,

        /* Warehouse Metadata */
        bet.record_created_at,
        bet.record_last_updated,
        GREATEST(
            COALESCE(bet.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(bonus.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(fancash.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
            COALESCE(campaign.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ)
        ) AS upstream_record_last_updated,
        CURRENT_TIMESTAMP() AS model_run_at

    FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_bets AS bet
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_account_bonuses AS bonus
        ON bet.account_bonuses_id = bonus.id
    LEFT JOIN (
        SELECT *
        FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_account_bonuses
        WHERE bet_id IS NOT NULL
          AND bonus_bet_amount IS NOT NULL
        QUALIFY ROW_NUMBER() OVER (PARTITION BY bet_id ORDER BY modified_at DESC, id DESC) = 1
    ) AS fancash
        ON bet.id = fancash.bet_id
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__promotions_bonus_campaigns AS campaign
        ON bet.bonus_campaign_id = campaign.id
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__customer_tenant_fan_id_to_acco_id AS referee_map
        ON bonus.referee_fan_id = referee_map.tenant_fan_id
)

SELECT * FROM silver__sportsbook_bets_detail
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "259e2e63-1a0f-4abe-b02e-2cd600c29520", "run_started_at": "2026-04-09T21:30:00.364844+00:00", "full_refresh": true, "which": "run", "node_name": "silver__sportsbook_bets_detail", "node_alias": "silver__sportsbook_bets_detail", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/trading/silver/silver__sportsbook_bets_detail.sql", "node_database": "FBG_ANALYTICS_DEV", "node_schema": "KATE_SMOLKO", "node_id": "model.dbt_analytics_engineering.silver__sportsbook_bets_detail", "node_resource_type": "model", "node_meta": {"contains_pii": false, "cost_center": "Analytics Engineering"}, "node_tags": ["view"], "invocation_command": "dbt ", "node_refs": ["bronze__osb_source_bets", "bronze__osb_source_account_bonuses", "silver__promotions_bonus_campaigns", "silver__customer_tenant_fan_id_to_acco_id"], "materialized": "view", "raw_code_hash": "636510144c12b8cccd5a7b088f2e6d85"} */;
