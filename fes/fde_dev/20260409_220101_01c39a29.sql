-- Query ID: 01c39a29-0112-6029-0000-e307218c10f2
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:01:01.491000+00:00
-- Elapsed: 623ms
-- Environment: FES

select * from (
        SELECT
    fangraph_ids.fangraph_id,
    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.usd_purchase_amount, 0)) AS topps_digital_starwars_purchases_usd,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.usd_purchase_amount, 0)) AS topps_digital_marvel_purchases_usd,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.usd_purchase_amount, 0)) AS topps_digital_disney_purchases_usd,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.usd_purchase_amount, 0)) AS topps_digital_wwe_purchases_usd,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.usd_purchase_amount, 0)) AS topps_digital_baseball_purchases_usd,

    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.usd_purchases, 0)) AS topps_digital_starwars_purchases_usd_count,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.usd_purchases, 0)) AS topps_digital_marvel_purchases_usd_count,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.usd_purchases, 0)) AS topps_digital_disney_purchases_usd_count,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.usd_purchases, 0)) AS topps_digital_wwe_purchases_usd_count,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.usd_purchases, 0)) AS topps_digital_baseball_purchases_usd_count,

    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.gem_purchase_amount, 0)) AS topps_digital_starwars_purchases_premium_gem,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.gem_purchase_amount, 0)) AS topps_digital_marvel_purchases_premium_gem,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.gem_purchase_amount, 0)) AS topps_digital_disney_purchases_premium_gem,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.gem_purchase_amount, 0)) AS topps_digital_wwe_purchases_premium_gem,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.gem_purchase_amount, 0)) AS topps_digital_baseball_purchases_premium_gem,

    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.gem_purchases, 0)) AS topps_digital_starwars_purchases_premium_gem_count,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.gem_purchases, 0)) AS topps_digital_marvel_purchases_premium_gem_count,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.gem_purchases, 0)) AS topps_digital_disney_purchases_premium_gem_count,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.gem_purchases, 0)) AS topps_digital_wwe_purchases_premium_gem_count,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.gem_purchases, 0)) AS topps_digital_baseball_purchases_premium_gem_count,

    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.coin_purchase_amount, 0)) AS topps_digital_starwars_freemium_soft_coin,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.coin_purchase_amount, 0)) AS topps_digital_marvel_freemium_soft_coin,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.coin_purchase_amount, 0)) AS topps_digital_disney_freemium_soft_coin,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.coin_purchase_amount, 0)) AS topps_digital_wwe_freemium_soft_coin,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.coin_purchase_amount, 0)) AS topps_digital_baseball_freemium_soft_coin,

    SUM(IFF(topps_digital_purchases.app_name = 'starwars', topps_digital_purchases.coin_purchases, 0)) AS topps_digital_starwars_freemium_soft_coin_count,
    SUM(IFF(topps_digital_purchases.app_name = 'marvel', topps_digital_purchases.coin_purchases, 0)) AS topps_digital_marvel_freemium_soft_coin_count,
    SUM(IFF(topps_digital_purchases.app_name = 'disney', topps_digital_purchases.coin_purchases, 0)) AS topps_digital_disney_freemium_soft_coin_count,
    SUM(IFF(topps_digital_purchases.app_name = 'wwe', topps_digital_purchases.coin_purchases, 0)) AS topps_digital_wwe_freemium_soft_coin_count,
    SUM(IFF(topps_digital_purchases.app_name = 'baseball', topps_digital_purchases.coin_purchases, 0)) AS topps_digital_baseball_freemium_soft_coin_count

FROM collectibles_fde.topps_digital.store_item_user_purchases_vw AS topps_digital_purchases
LEFT JOIN fangraph_dev.topps_digital.topps_digital_id_mapping AS id_mapping
    ON topps_digital_purchases.user_profile_key = id_mapping.user_profile_key
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids
    ON fangraph_ids.node = 'toppsd-' || id_mapping.topps_digital_user_id
GROUP BY fangraph_ids.fangraph_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "topps_digital_purchases", "node_alias": "topps_digital_purchases", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/opco_topps_digital/topps_digital_purchases.sql", "node_database": "fangraph_dev", "node_schema": "topps_digital", "node_id": "model.fes_data.topps_digital_purchases", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_digital_id_mapping", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "f91c9fa4090aee9dedb0f673372b5709"} */
