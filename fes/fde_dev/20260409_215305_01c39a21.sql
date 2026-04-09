-- Query ID: 01c39a21-0112-6029-0000-e307218b8e66
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:53:05.265000+00:00
-- Elapsed: 594ms
-- Environment: FES

create or replace  temporary view fangraph_dev.topps_digital.dim_topps_digital_purchase__dbt_tmp
  
    
    
(
  
    "FANGRAPH_ID" COMMENT $$$$, 
  
    "TOPPS_DIGITAL_USER_ID" COMMENT $$$$, 
  
    "USER_NAME" COMMENT $$$$, 
  
    "APP_NAME" COMMENT $$$$, 
  
    "USER_PROFILE_KEY" COMMENT $$$$, 
  
    "PURCHASE_KEY" COMMENT $$$$, 
  
    "STORE_PRODUCT_KEY" COMMENT $$$$, 
  
    "STORE_ITEM_KEY" COMMENT $$$$, 
  
    "PURCHASE_TS" COMMENT $$$$, 
  
    "PRODUCT_RELEASE_DT" COMMENT $$$$, 
  
    "PRODUCT_EXPIRES_DT" COMMENT $$$$, 
  
    "PRODUCT_INTERNAL_NAME" COMMENT $$$$, 
  
    "STORE_ITEM_NAME" COMMENT $$$$, 
  
    "STORE_ITEM_REDEEMABLE_CATEGORY" COMMENT $$$$, 
  
    "IS_SINGLE_DAY_RELEASE_PRODUCT" COMMENT $$$$, 
  
    "OS" COMMENT $$$$, 
  
    "USD_PURCHASES" COMMENT $$$$, 
  
    "USD_PURCHASE_AMOUNT" COMMENT $$$$, 
  
    "GEM_PURCHASES" COMMENT $$$$, 
  
    "GEM_PURCHASE_AMOUNT" COMMENT $$$$, 
  
    "COIN_PURCHASES" COMMENT $$$$, 
  
    "COIN_PURCHASE_AMOUNT" COMMENT $$$$, 
  
    "REDEEMABLE_GEMS" COMMENT $$$$, 
  
    "REDEEMABLE_COINS" COMMENT $$$$, 
  
    "REDEEMABLE_PACKS" COMMENT $$$$, 
  
    "REDEEMABLE_COLLECTIBLES" COMMENT $$$$, 
  
    "STORE_ITEM_PACK_NON_BASE_COLLECTIBLES_AVAILABLE" COMMENT $$$$, 
  
    "_INSERT_TS" COMMENT $$$$, 
  
    "_UPDATE_TS" COMMENT $$$$
  
)

   as (
    SELECT
    fangraph_ids.fangraph_id,
    purchases.topps_digital_user_id,
    purchases.user_name,
    purchases.app_name,
    purchases.user_profile_key,
    purchases.store_item_user_purchases_daily_key AS purchase_key,
    purchases.store_product_key,
    purchases.store_item_key,
    purchases.purchase_dt AS purchase_ts,
    purchases.product_release_dt,
    purchases.product_expires_dt,
    purchases.product_internal_name,
    purchases.store_item_name,
    purchases.store_item_redeemable_category,
    purchases.is_single_day_release_product,
    purchases.os,
    purchases.usd_purchases,
    purchases.usd_purchase_amount,
    purchases.gem_purchases,
    purchases.gem_purchase_amount,
    purchases.coin_purchases,
    purchases.coin_purchase_amount,
    purchases.redeemable_gems,
    purchases.redeemable_coins,
    purchases.redeemable_packs,
    purchases.redeemable_collectibles,
    purchases.store_item_pack_non_base_collectibles_available,
    CURRENT_TIMESTAMP() AS _insert_ts,
    CURRENT_TIMESTAMP() AS _update_ts
FROM collectibles_fde.topps_digital.store_item_user_purchases_daily_vw AS purchases
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids
    ON fangraph_ids.node = 'toppsd-' || purchases.topps_digital_user_id

    WHERE purchases.audit_last_update_ts > (
        SELECT MAX(_update_ts)
        FROM fangraph_dev.topps_digital.dim_topps_digital_purchase
    )

  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "dim_topps_digital_purchase", "node_alias": "dim_topps_digital_purchase", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_topps_digital_purchase.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.dim_topps_digital_purchase", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fangraph_id_final"], "materialized": "incremental", "raw_code_hash": "aa0e2708d9c3d90bf4960b5c961ab5a9"} */;
