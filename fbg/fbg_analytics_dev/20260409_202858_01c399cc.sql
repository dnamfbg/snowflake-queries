-- Query ID: 01c399cc-0212-6dbe-24dd-07031928f6cb
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:28:58.276000+00:00
-- Elapsed: 964ms
-- Environment: FBG

create or replace   view FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__promotions_account_bonus_to_bet_id
  
  
  
  
  as (
    WITH direct_bets AS (
    SELECT
        base.id,
        base.authorize_transaction_id,
        base.referee_fan_id,
        bets.bet_id,
        bets.jurisdictions_id,
        SUM(bets.total_stake) AS stake,
        SUM(bets.payout) AS payout,
        SUM(CASE WHEN bets.bonus_campaign_id = 22 then bets.total_stake ELSE 0 END) AS bonus_bet_stake,
        SUM(CASE WHEN bets.bonus_campaign_id = 22 then bets.payout ELSE 0 END) AS bonus_bet_payout,
        SUM(bets.total_cash_stake) AS cash_stake,
        SUM(bets.trading_win) AS trading_win,
        SUM(bets.total_cash_ggr) AS cash_ggr,
        SUM(bets.total_non_cash_stake) AS non_cash_stake,
        SUM(bets.fancash_stake_profit_boost) AS fancash_stake_profit_boost,
        bets.record_last_updated AS bets_record_last_updated,
        base.record_created_at,
        base.record_last_updated
    FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_account_bonuses AS base
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__sportsbook_bet_parts_to_bet_id AS bets
        ON base.bet_id = bets.bet_id::VARCHAR
        AND bets.bet_status = 'SETTLED'
    GROUP BY ALL
),

overwrite_bets AS (
    SELECT
        base.id,
        overwrite.bet_id AS overwrite_bet_id,
        ow_bets.jurisdictions_id,
        SUM(ow_bets.total_stake) AS stake,
        SUM(ow_bets.payout) AS payout,
        SUM(CASE WHEN ow_bets.bonus_campaign_id = 22 then ow_bets.total_stake ELSE 0 END) AS bonus_bet_stake,
        SUM(CASE WHEN ow_bets.bonus_campaign_id = 22 then ow_bets.payout ELSE 0 END) AS bonus_bet_payout,
        ow_bets.record_last_updated AS bets_record_last_updated
    FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_account_bonuses AS base
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.bronze__osb_source_account_bonuses AS overwrite
        ON base.authorize_transaction_id = overwrite.authorize_transaction_id
    LEFT JOIN FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__sportsbook_bet_parts_to_bet_id AS ow_bets
        ON overwrite.bet_id = ow_bets.bet_id::VARCHAR
        AND ow_bets.bet_status = 'SETTLED'
    WHERE overwrite.bet_id != base.bet_id
       OR (base.bet_id IS NULL AND overwrite.bet_id IS NOT NULL)
    GROUP BY ALL
),

casino_bets AS (
    SELECT
        account_bonus_id,
        LISTAGG(DISTINCT bet_id, ', ') AS bet_id,
        SUM(stake) AS stake,
        SUM(payout) AS payout,
        MAX(record_last_updated) AS record_last_updated
    FROM FBG_ANALYTICS_DEV.KATE_SMOLKO.silver__casino_bet_and_campaign_agg
    WHERE settled_at IS NOT NULL
    GROUP BY account_bonus_id
)

SELECT
    d.id,
    d.referee_fan_id,
    d.authorize_transaction_id,
    COALESCE(LISTAGG(DISTINCT o.jurisdictions_id, ', '), MAX(c.bet_id)) AS bet_id,
    CASE
        WHEN d.bet_id IS NOT NULL THEN 'SPORTSBOOK'
        WHEN MAX(c.account_bonus_id) IS NOT NULL THEN 'CASINO'
    END AS product,
    LISTAGG(DISTINCT COALESCE(d.jurisdictions_id, o.jurisdictions_id), ', ') AS jurisdictions_id,
    COUNT(DISTINCT o.overwrite_bet_id) AS overwrite_bet_count,
    COALESCE(SUM(d.stake), SUM(o.stake)) AS total_stake,
    COALESCE(SUM(d.payout), SUM(o.payout)) AS total_payout,
    COALESCE(SUM(d.bonus_bet_stake), SUM(o.bonus_bet_stake)) AS bonus_bet_stake,
    COALESCE(SUM(d.bonus_bet_payout), SUM(o.bonus_bet_payout)) AS bonus_bet_payout,
    SUM(d.cash_stake) AS profit_boost_stake,
    SUM(d.trading_win) - SUM(d.cash_ggr) AS profit_boost_payout,
    SUM(d.non_cash_stake) AS fortuna_bb_amount,
    SUM(d.fancash_stake_profit_boost) AS fortuna_pbt_amount,
    SUM(d.non_cash_stake) + SUM(d.fancash_stake_profit_boost) AS fortuna_stake,
    SUM(d.payout) AS fortuna_payout,
    SUM(c.stake) AS casino_stake,
    SUM(c.payout) AS casino_payout,
    LEAST(MIN(d.bets_record_last_updated), MIN(o.bets_record_last_updated)) AS bets_record_last_updated,
    MAX(c.record_last_updated) AS casino_record_last_updated,
    d.record_created_at,
    d.record_last_updated,
    GREATEST(
        COALESCE(d.record_last_updated, '1900-01-01'::TIMESTAMP_NTZ),
        COALESCE(MIN(d.bets_record_last_updated), '1900-01-01'::TIMESTAMP_NTZ),
        COALESCE(MIN(o.bets_record_last_updated), '1900-01-01'::TIMESTAMP_NTZ),
        COALESCE(MAX(c.record_last_updated), '1900-01-01'::TIMESTAMP_NTZ)
    ) AS upstream_record_last_updated,
    CURRENT_TIMESTAMP() AS model_run_at
FROM direct_bets AS d
LEFT JOIN overwrite_bets AS o
    ON d.id = o.id
LEFT JOIN casino_bets AS c
    ON d.id = c.account_bonus_id
GROUP BY
    d.id,
    d.referee_fan_id,
    d.authorize_transaction_id,
    d.bet_id,
    d.record_created_at,
    d.record_last_updated
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "fe539f03-296f-4d16-93de-9aa2fece3bbf", "run_started_at": "2026-04-09T20:28:50.708645+00:00", "full_refresh": true, "which": "run", "node_name": "silver__promotions_account_bonus_to_bet_id", "node_alias": "silver__promotions_account_bonus_to_bet_id", "node_package_name": "dbt_analytics_engineering", "node_original_file_path": "models/promotions/silver/silver__promotions_account_bonus_to_bet_id.sql", "node_database": "FBG_ANALYTICS_DEV", "node_schema": "KATE_SMOLKO", "node_id": "model.dbt_analytics_engineering.silver__promotions_account_bonus_to_bet_id", "node_resource_type": "model", "node_meta": {"contains_pii": false}, "node_tags": ["view"], "invocation_command": "dbt ", "node_refs": ["bronze__osb_source_account_bonuses", "silver__sportsbook_bet_parts_to_bet_id", "silver__casino_bet_and_campaign_agg"], "materialized": "view", "raw_code_hash": "e80649b9dc87b64f462e876b3bc291e8"} */;
