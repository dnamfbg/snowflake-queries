-- Query ID: 01c399f0-0112-65b6-0000-e307218a3936
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:04:54.292000+00:00
-- Elapsed: 15600ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fbg_revenue (
            "PRIVATE_FAN_ID", "FBG_BETS_TOTAL", "FBG_NUMBER_BETS_PLACED", "FBG_FIRST_BET_TS", "FBG_LAST_BET_TS"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FBG_BETS_TOTAL", 
            
              __src."FBG_NUMBER_BETS_PLACED", 
            
              __src."FBG_FIRST_BET_TS", 
            
              __src."FBG_LAST_BET_TS"
            
          from ( WITH fbg_account_to_pfi AS (
    SELECT
        fbg_acc.id AS fbg_account_id,
        fitm.fan_id AS private_fan_id
    FROM fbg_fde.fbg_users.fbg_to_fde_accounts AS fbg_acc
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON REPLACE(fbg_acc.ref1, 'AMELCO-', '') = fitm.tenant_fan_id
    WHERE
        fbg_acc.creation_date IS NOT NULL
        AND UPPER(fbg_acc.status) = 'ACTIVE'
        AND fitm.tenant_id = '100002'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fbg_acc.id
        ORDER BY fitm.last_modified_time ASC
    ) = 1
)

SELECT
    pfi.private_fan_id,
    SUM(fbg_rev.bet_amount) AS fbg_bets_total,
    SUM(fbg_rev.number_bets_placed) AS fbg_number_bets_placed,
    MIN(fbg_rev.first_bet_ts) AS fbg_first_bet_ts,
    MAX(fbg_rev.last_bet_ts) AS fbg_last_bet_ts
FROM fangraph_dev.fbg.app_revenue_base AS fbg_rev
INNER JOIN fbg_account_to_pfi AS pfi
    ON fbg_rev.fbg_account_id = pfi.fbg_account_id
GROUP BY pfi.private_fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_revenue", "node_alias": "pfi_fbg_revenue", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_revenue.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_revenue", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map", "fbg_app_revenue_base"], "materialized": "table", "raw_code_hash": "7b9fa8a1bdb56782e8ec244b6a53f5fb"} */
