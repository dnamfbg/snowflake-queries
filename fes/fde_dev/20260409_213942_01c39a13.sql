-- Query ID: 01c39a13-0112-6bf9-0000-e307218be39e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:39:42.509000+00:00
-- Elapsed: 269027ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.commerce.dim_commerce_browse_disaggregated (
            "FANGRAPH_ID", "VISITOR_ID", "SITE_ID", "SITE_NAME", "LEAGUE", "TEAM_SCD", "BRAND_SCD", "DEPARTMENT_NAME", "CLASS_SCD", "SUBCLASS_SCD", "UTM_CAMPAIGN", "UTM_SOURCE", "UTM_MEDIUM", "UTM_CONTENT", "ACTION", "DEVICE", "PLAYER_SCD", "DT", "PRODUCT_COUNT"
          )
          select
            
              __src."FANGRAPH_ID", 
            
              __src."VISITOR_ID", 
            
              __src."SITE_ID", 
            
              __src."SITE_NAME", 
            
              __src."LEAGUE", 
            
              __src."TEAM_SCD", 
            
              __src."BRAND_SCD", 
            
              __src."DEPARTMENT_NAME", 
            
              __src."CLASS_SCD", 
            
              __src."SUBCLASS_SCD", 
            
              __src."UTM_CAMPAIGN", 
            
              __src."UTM_SOURCE", 
            
              __src."UTM_MEDIUM", 
            
              __src."UTM_CONTENT", 
            
              __src."ACTION", 
            
              __src."DEVICE", 
            
              __src."PLAYER_SCD", 
            
              __src."DT", 
            
              __src."PRODUCT_COUNT"
            
          from ( WITH pdp_views AS (
    SELECT
        visitor_id,
        site_id,
        league,
        team_scd,
        brand_scd,
        department_name,
        class_scd,
        subclass_scd,
        utm_campaign,
        utm_source,
        utm_medium,
        utm_content,
        device,
        player_scd,
        'pdp_view' AS action,
        dt,
        COUNT(DISTINCT product_id) AS product_count
    FROM COMMERCE_DEV.ORDERS.fanapp_daily_products
    WHERE
        has_product_page_view = TRUE
        AND geo_country_code = 'US'
        AND dt >= DATEADD(MONTH, -15, CURRENT_DATE)
    GROUP BY ALL
    HAVING COUNT(DISTINCT product_id) > 0
),

atc_views AS (
    SELECT
        visitor_id,
        site_id,
        league,
        team_scd,
        brand_scd,
        department_name,
        class_scd,
        subclass_scd,
        utm_campaign,
        utm_source,
        utm_medium,
        utm_content,
        device,
        player_scd,
        'cart_view' AS action,
        dt,
        COUNT(DISTINCT product_id) AS product_count
    FROM COMMERCE_DEV.ORDERS.fanapp_daily_products
    WHERE
        has_cart_view = TRUE
        AND geo_country_code = 'US'
        AND dt >= DATEADD(MONTH, -15, CURRENT_DATE)
    GROUP BY ALL
    HAVING COUNT(DISTINCT product_id) > 0
),

unioned AS (
    SELECT * FROM pdp_views
    UNION ALL
    SELECT * FROM atc_views
),

filtered_fk_map AS (
    SELECT
        visitor_id,
        fan_key
    FROM COMMERCE_DEV.FAN_KEY.exp_prod_fankey_map
),

fi_fk AS (
    SELECT DISTINCT
        fangraph_id,
        fan_key
    FROM fangraph_dev.admin.fan_key_account_map
),

site_nm_lkp AS (
    SELECT
        site_id,
        site_nm
    FROM MDE_DEV.MDE_CORE.site_lkp
    QUALIFY ROW_NUMBER() OVER (PARTITION BY site_id ORDER BY load_dts DESC) = 1
)

SELECT DISTINCT
    fg_map.fangraph_id,
    u.visitor_id,
    u.site_id,
    site_lkp.site_nm AS site_name,
    u.league,
    u.team_scd,
    u.brand_scd,
    u.department_name,
    u.class_scd,
    u.subclass_scd,
    u.utm_campaign,
    u.utm_source,
    u.utm_medium,
    u.utm_content,
    u.action,
    u.device,
    u.player_scd,
    u.dt,
    u.product_count
FROM unioned AS u
INNER JOIN filtered_fk_map AS fk_map
    ON u.visitor_id = fk_map.visitor_id
INNER JOIN fi_fk AS fg_map
    ON fk_map.fan_key = fg_map.fan_key
INNER JOIN site_nm_lkp AS site_lkp
    ON u.site_id = site_lkp.site_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "dim_commerce_browse_disaggregated", "node_alias": "dim_commerce_browse_disaggregated", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_commerce_browse_disaggregated.sql", "node_database": "fangraph_dev", "node_schema": "commerce", "node_id": "model.fes_data.dim_commerce_browse_disaggregated", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fanapp_daily_products", "exp_prod_fankey_map", "fangraph_fan_key_account_map", "site_lkp"], "materialized": "table", "raw_code_hash": "1b949264fa91b120bba7ef5a13ea1b7b"} */
