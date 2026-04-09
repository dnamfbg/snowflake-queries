-- Query ID: 01c399f1-0112-65b6-0000-e307218a3a5e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:05:14.936000+00:00
-- Elapsed: 723ms
-- Environment: FES

create or replace  temporary view fangraph_dev.private_fan_id.pfi_fanatics_one_attributes__dbt_tmp
  
    
    
(
  
    "PRIVATE_FAN_ID" COMMENT $$$$, 
  
    "USER_LAST_TXN_TS_UTC" COMMENT $$$$, 
  
    "LOYALTY_TIER" COMMENT $$$$, 
  
    "POINTS_TIER" COMMENT $$$$, 
  
    "POINTS_TIER_RANK" COMMENT $$$$, 
  
    "AMOUNTS_TO_NEXT_POINTS_TIER" COMMENT $$$$, 
  
    "STATUS_MATCH_ACTIVE" COMMENT $$$$, 
  
    "CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "POINTS_TIER_NUMBER" COMMENT $$$$, 
  
    "PRIOR_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "ROLLOVER_TP" COMMENT $$$$, 
  
    "OSB_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "OC_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "COMMERCE_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "FBG_GOODWILL_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "TLC_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "FBG_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "OTHER_CURRENT_YEAR_TIER_POINTS" COMMENT $$$$, 
  
    "VOIDED_TP" COMMENT $$$$, 
  
    "CURRENT_FC_BALANCE" COMMENT $$$$, 
  
    "BASE_FC_EXPIRATION" COMMENT $$$$, 
  
    "UNCLAIMED_BONUS_FC" COMMENT $$$$, 
  
    "TOTAL_OUSTANDING_FC_BALANCE" COMMENT $$$$, 
  
    "FANCASH_UPDATED_TIMESTAMP" COMMENT $$$$, 
  
    "_INSERT_TS" COMMENT $$$$, 
  
    "_UPDATE_TS" COMMENT $$$$
  
)

   as (
    ---using this hard coded time stamp as we don't know what data will be like for 2027 yet


WITH incremental_pfis AS (
    SELECT DISTINCT private_fan_id
    FROM LOYALTY_DEV.LOYALTY_INFO.tier_points_ledger_v2
    
        WHERE transaction_timestamp > (
            SELECT MAX(_update_ts) FROM fangraph_dev.private_fan_id.pfi_fanatics_one_attributes
        )
    
),

base_data AS (
    SELECT
        l.private_fan_id,
        l.transaction_timestamp,
        l.tier_points_amount,
        l.public_facing_tier AS loyalty_tier,
        l.earn_tier AS points_tier,
        l.earn_tier_rank AS points_tier_rank,
        l.current_balance,
        l.external_id_type,
        l.tenant_id,
        l.next_earn_tier,
        l.amount_to_next_earn_tier,
        l.status_match_active,
        l.is_test_transaction
    FROM LOYALTY_DEV.LOYALTY_INFO.tier_points_ledger_v2 AS l
    INNER JOIN incremental_pfis AS i
        ON l.private_fan_id = i.private_fan_id
),

latest_tier_info AS (
    SELECT
        private_fan_id,
        transaction_timestamp AS user_last_txn_ts_utc,
        current_balance AS current_year_tier_points,
        loyalty_tier,
        points_tier,
        points_tier_rank,
        amount_to_next_earn_tier,
        status_match_active
    FROM base_data
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY transaction_timestamp DESC
    ) = 1
),

tenant_map AS (
    SELECT
        private_fan_id,
        loyalty_account_id
    FROM fangraph_dev.private_fan_id.pfi_tenant_id_mapping
),

fc_balance AS (
    SELECT
        loyalty_account_id,
        fancash_balance AS current_fc_balance,
        fancash_expiration AS base_fc_expiration,
        bonus_fancash AS unclaimed_bonus_fc,
        total_balance AS total_oustanding_fc_balance,
        fancash_updated_timestamp
    FROM LOYALTY_DEV.LOYALTY_CORE.loyalty_balance
    
        WHERE fancash_updated_timestamp > (
            SELECT MAX(fancash_updated_timestamp) FROM fangraph_dev.private_fan_id.pfi_fanatics_one_attributes
        )
    
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY loyalty_account_id
        ORDER BY fancash_updated_timestamp DESC
    ) = 1
),

prior_year_points AS (
    SELECT
        private_fan_id,
        ROUND(SUM(IFF(transaction_timestamp < '2026-01-01 08:00:00', tier_points_amount, NULL)), 2) AS prior_year_tier_points,
        ROUND(SUM(IFF(transaction_timestamp <= '2026-01-01 08:00:00', tier_points_amount, NULL)), 2) AS rollover_tp
    FROM base_data
    WHERE transaction_timestamp <= '2026-01-01 08:00:00'
    GROUP BY ALL
),

current_year_points AS (
    SELECT
        private_fan_id,
        ROUND(SUM(IFF(
            tenant_id = '100002' AND external_id_type = 'SPORTS_BOOK_BETTING',
            tier_points_amount, NULL
        )), 2) AS osb_current_year_tier_points,
        ROUND(SUM(IFF(
            tenant_id = '100002' AND external_id_type = 'CASINO_BETTING',
            tier_points_amount, NULL
        )), 2) AS oc_current_year_tier_points,
        ROUND(SUM(IFF(
            tenant_id IN ('100001', '100020', '100013', '100007', '100003'),
            tier_points_amount, NULL
        )), 2) AS commerce_current_year_tier_points,
        ROUND(SUM(IFF(
            tenant_id = '100002' AND external_id_type IS NULL,
            tier_points_amount, NULL
        )), 2) AS fbg_goodwill_current_year_tier_points,
        ROUND(SUM(IFF(
            tenant_id = '100004',
            tier_points_amount, NULL
        )), 2) AS tlc_current_year_tier_points,
        ROUND(SUM(IFF(
            tenant_id = '100002',
            tier_points_amount, NULL
        )), 2) AS fbg_current_year_tier_points,
        ROUND(SUM(IFF(
            NULLIF(TRIM(tenant_id), '') IS NULL,
            tier_points_amount, NULL
        )), 2) AS voided_tp,
        ROUND(SUM(IFF(
            NOT (
                (tenant_id = '100002' AND external_id_type = 'SPORTS_BOOK_BETTING')
                OR (tenant_id = '100002' AND external_id_type = 'CASINO_BETTING')
                OR (tenant_id IN ('100001', '100020', '100013', '100007', '100003'))
                OR (tenant_id = '100002' AND external_id_type IS NULL)
                OR (tenant_id = '100004')
                OR (NULLIF(TRIM(tenant_id), '') IS NULL)
            ),
            tier_points_amount, NULL
        )), 2) AS other_current_year_tier_points
    FROM base_data
    WHERE transaction_timestamp > '2026-01-01 08:00:00'
    GROUP BY ALL
)

SELECT
    lt.private_fan_id,
    lt.user_last_txn_ts_utc,
    lt.loyalty_tier,
    lt.points_tier,
    lt.points_tier_rank,
    lt.amount_to_next_earn_tier AS amounts_to_next_points_tier,
    lt.status_match_active,
    COALESCE(lt.current_year_tier_points, 0) AS current_year_tier_points,
    COALESCE(lt.points_tier_rank, 0) AS points_tier_number,
    COALESCE(pyp.prior_year_tier_points, 0) AS prior_year_tier_points,
    COALESCE(pyp.rollover_tp, 0) AS rollover_tp,
    COALESCE(cy.osb_current_year_tier_points, 0) AS osb_current_year_tier_points,
    COALESCE(cy.oc_current_year_tier_points, 0) AS oc_current_year_tier_points,
    COALESCE(cy.commerce_current_year_tier_points, 0) AS commerce_current_year_tier_points,
    COALESCE(cy.fbg_goodwill_current_year_tier_points, 0) AS fbg_goodwill_current_year_tier_points,
    COALESCE(cy.tlc_current_year_tier_points, 0) AS tlc_current_year_tier_points,
    COALESCE(cy.fbg_current_year_tier_points, 0) AS fbg_current_year_tier_points,
    COALESCE(cy.other_current_year_tier_points, 0) AS other_current_year_tier_points,
    COALESCE(cy.voided_tp, 0) AS voided_tp,
    fcb.current_fc_balance,
    fcb.base_fc_expiration,
    fcb.unclaimed_bonus_fc,
    fcb.total_oustanding_fc_balance,
    fcb.fancash_updated_timestamp,
    CURRENT_TIMESTAMP() AS _insert_ts,
    CURRENT_TIMESTAMP() AS _update_ts
FROM latest_tier_info AS lt
LEFT JOIN tenant_map AS tm ON lt.private_fan_id = tm.private_fan_id
LEFT JOIN prior_year_points AS pyp ON lt.private_fan_id = pyp.private_fan_id
LEFT JOIN current_year_points AS cy ON lt.private_fan_id = cy.private_fan_id
LEFT JOIN fc_balance AS fcb ON tm.loyalty_account_id = fcb.loyalty_account_id
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fanatics_one_attributes", "node_alias": "pfi_fanatics_one_attributes", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_fanatics_one_attributes.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fanatics_one_attributes", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["tier_points_ledger_v2", "pfi_tenant_id_mapping", "loyalty_balance"], "materialized": "incremental", "raw_code_hash": "9b8b3d2e8a7922f6d69f71c99b53fd41"} */;
