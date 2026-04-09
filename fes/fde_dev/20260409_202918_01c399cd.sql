-- Query ID: 01c399cd-0112-6f44-0000-e3072188cd72
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:29:18.072000+00:00
-- Elapsed: 16210ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fbg_app_revenue (
            "PRIVATE_FAN_ID", "FBG_CASINO_MIN_BET_AMOUNT", "FBG_CASINO_MAX_BET_AMOUNT", "FBG_CASINO_NUMBER_BETS_PLACED", "FBG_CASINO_FIRST_BET_TS", "FBG_CASINO_LAST_BET_TS", "FBG_ONLINE_SPORTSBOOK_MIN_BET_AMOUNT", "FBG_ONLINE_SPORTSBOOK_MAX_BET_AMOUNT", "FBG_ONLINE_SPORTSBOOK_NUMBER_BETS_PLACED", "FBG_ONLINE_SPORTSBOOK_FIRST_BET_TS", "FBG_ONLINE_SPORTSBOOK_LAST_BET_TS", "FBG_RETAIL_SPORTSBOOK_MIN_BET_AMOUNT", "FBG_RETAIL_SPORTSBOOK_MAX_BET_AMOUNT", "FBG_RETAIL_SPORTSBOOK_NUMBER_BETS_PLACED", "FBG_RETAIL_SPORTSBOOK_FIRST_BET_TS", "FBG_RETAIL_SPORTSBOOK_LAST_BET_TS", "FBG_TOTAL_BETS_PLACED"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FBG_CASINO_MIN_BET_AMOUNT", 
            
              __src."FBG_CASINO_MAX_BET_AMOUNT", 
            
              __src."FBG_CASINO_NUMBER_BETS_PLACED", 
            
              __src."FBG_CASINO_FIRST_BET_TS", 
            
              __src."FBG_CASINO_LAST_BET_TS", 
            
              __src."FBG_ONLINE_SPORTSBOOK_MIN_BET_AMOUNT", 
            
              __src."FBG_ONLINE_SPORTSBOOK_MAX_BET_AMOUNT", 
            
              __src."FBG_ONLINE_SPORTSBOOK_NUMBER_BETS_PLACED", 
            
              __src."FBG_ONLINE_SPORTSBOOK_FIRST_BET_TS", 
            
              __src."FBG_ONLINE_SPORTSBOOK_LAST_BET_TS", 
            
              __src."FBG_RETAIL_SPORTSBOOK_MIN_BET_AMOUNT", 
            
              __src."FBG_RETAIL_SPORTSBOOK_MAX_BET_AMOUNT", 
            
              __src."FBG_RETAIL_SPORTSBOOK_NUMBER_BETS_PLACED", 
            
              __src."FBG_RETAIL_SPORTSBOOK_FIRST_BET_TS", 
            
              __src."FBG_RETAIL_SPORTSBOOK_LAST_BET_TS", 
            
              __src."FBG_TOTAL_BETS_PLACED"
            
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
),

fbg_rev_cas AS (
    SELECT
        pfi.private_fan_id,
        MIN(fbg_rev.min_bet_amount) AS fbg_casino_min_bet_amount,
        MAX(fbg_rev.max_bet_amount) AS fbg_casino_max_bet_amount,
        SUM(fbg_rev.number_bets_placed) AS fbg_casino_number_bets_placed,
        MIN(fbg_rev.first_bet_ts) AS fbg_casino_first_bet_ts,
        MAX(fbg_rev.last_bet_ts) AS fbg_casino_last_bet_ts
    FROM fangraph_dev.fbg.app_revenue_base AS fbg_rev
    INNER JOIN fbg_account_to_pfi AS pfi
        ON fbg_rev.fbg_account_id = pfi.fbg_account_id
    WHERE fbg_rev.subledger_application = 'iCasino'
    GROUP BY pfi.private_fan_id
),

fbg_rev_onlspt AS (
    SELECT
        pfi.private_fan_id,
        MIN(fbg_rev.min_bet_amount) AS fbg_online_sportsbook_min_bet_amount,
        MAX(fbg_rev.max_bet_amount) AS fbg_online_sportsbook_max_bet_amount,
        SUM(fbg_rev.number_bets_placed) AS fbg_online_sportsbook_number_bets_placed,
        MIN(fbg_rev.first_bet_ts) AS fbg_online_sportsbook_first_bet_ts,
        MAX(fbg_rev.last_bet_ts) AS fbg_online_sportsbook_last_bet_ts
    FROM fangraph_dev.fbg.app_revenue_base AS fbg_rev
    INNER JOIN fbg_account_to_pfi AS pfi
        ON fbg_rev.fbg_account_id = pfi.fbg_account_id
    WHERE fbg_rev.subledger_application = 'iGaming'
    GROUP BY pfi.private_fan_id
),

fbg_rev_retspt AS (
    SELECT
        pfi.private_fan_id,
        MIN(fbg_rev.min_bet_amount) AS fbg_retail_sportsbook_min_bet_amount,
        MAX(fbg_rev.max_bet_amount) AS fbg_retail_sportsbook_max_bet_amount,
        SUM(fbg_rev.number_bets_placed) AS fbg_retail_sportsbook_number_bets_placed,
        MIN(fbg_rev.first_bet_ts) AS fbg_retail_sportsbook_first_bet_ts,
        MAX(fbg_rev.last_bet_ts) AS fbg_retail_sportsbook_last_bet_ts
    FROM fangraph_dev.fbg.app_revenue_base AS fbg_rev
    INNER JOIN fbg_account_to_pfi AS pfi
        ON fbg_rev.fbg_account_id = pfi.fbg_account_id
    WHERE fbg_rev.subledger_application = 'Retail Sportsbook'
    GROUP BY pfi.private_fan_id
)

SELECT
    COALESCE(c.private_fan_id, o.private_fan_id, r.private_fan_id) AS private_fan_id,
    c.fbg_casino_min_bet_amount,
    c.fbg_casino_max_bet_amount,
    c.fbg_casino_number_bets_placed,
    c.fbg_casino_first_bet_ts,
    c.fbg_casino_last_bet_ts,
    o.fbg_online_sportsbook_min_bet_amount,
    o.fbg_online_sportsbook_max_bet_amount,
    o.fbg_online_sportsbook_number_bets_placed,
    o.fbg_online_sportsbook_first_bet_ts,
    o.fbg_online_sportsbook_last_bet_ts,
    r.fbg_retail_sportsbook_min_bet_amount,
    r.fbg_retail_sportsbook_max_bet_amount,
    r.fbg_retail_sportsbook_number_bets_placed,
    r.fbg_retail_sportsbook_first_bet_ts,
    r.fbg_retail_sportsbook_last_bet_ts,
    COALESCE(o.fbg_online_sportsbook_number_bets_placed, 0)
    + COALESCE(r.fbg_retail_sportsbook_number_bets_placed, 0)
    + COALESCE(c.fbg_casino_number_bets_placed, 0) AS fbg_total_bets_placed
FROM fbg_rev_cas AS c
FULL OUTER JOIN fbg_rev_onlspt AS o ON c.private_fan_id = o.private_fan_id
FULL OUTER JOIN fbg_rev_retspt AS r ON COALESCE(c.private_fan_id, o.private_fan_id) = r.private_fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_app_revenue", "node_alias": "pfi_fbg_app_revenue", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_app_revenue.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_app_revenue", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map", "fbg_app_revenue_base"], "materialized": "table", "raw_code_hash": "656b164d3c483e85aab623e050631da0"} */
