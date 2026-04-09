-- Query ID: 01c39a46-0112-6f82-0000-e307218d08da
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:30:21.707000+00:00
-- Elapsed: 711ms
-- Environment: FES

create or replace  temporary view fangraph_dev.commerce.dim_commerce_browse_anonymous__dbt_tmp
  
    
    
(
  
    "PK" COMMENT $$$$, 
  
    "VISITOR_ID" COMMENT $$$$, 
  
    "SITE_ID" COMMENT $$$$, 
  
    "SITE_NAME" COMMENT $$$$, 
  
    "US_DMA" COMMENT $$$$, 
  
    "DMA_NAME" COMMENT $$$$, 
  
    "GEO_COUNTRY_CODE" COMMENT $$$$, 
  
    "GEO_REGION" COMMENT $$$$, 
  
    "LEAGUE" COMMENT $$$$, 
  
    "TEAM_SCD" COMMENT $$$$, 
  
    "BRAND_SCD" COMMENT $$$$, 
  
    "DEPARTMENT_NAME" COMMENT $$$$, 
  
    "CLASS_SCD" COMMENT $$$$, 
  
    "SUBCLASS_SCD" COMMENT $$$$, 
  
    "UTM_CAMPAIGN" COMMENT $$$$, 
  
    "UTM_SOURCE" COMMENT $$$$, 
  
    "UTM_MEDIUM" COMMENT $$$$, 
  
    "UTM_CONTENT" COMMENT $$$$, 
  
    "ACTION" COMMENT $$$$, 
  
    "PRODUCT_COUNT" COMMENT $$$$, 
  
    "_INSERT_TS" COMMENT $$$$, 
  
    "_UPDATE_TS" COMMENT $$$$
  
)

   as (
    WITH known_visitors AS (
    SELECT DISTINCT visitor_id
    FROM COMMERCE_DEV.FAN_KEY.exp_prod_fankey_map
),


    changed_visitors AS (
        SELECT DISTINCT visitor_id
        FROM COMMERCE_DEV.ORDERS.fanapp_daily_products
        WHERE _update_ts >= (SELECT MAX(_update_ts) FROM fangraph_dev.commerce.dim_commerce_browse_anonymous)
    ),


anonymous_base AS (
    SELECT
        fdp.visitor_id,
        fdp.site_id,
        fdp.us_dma,
        fdp.dma_name,
        fdp.geo_country_code,
        fdp.geo_region,
        fdp.league,
        fdp.team_scd,
        fdp.brand_scd,
        fdp.department_name,
        fdp.class_scd,
        fdp.subclass_scd,
        fdp.utm_campaign,
        fdp.utm_source,
        fdp.utm_medium,
        fdp.utm_content,
        fdp.has_product_page_view,
        fdp.has_cart_view,
        fdp.product_id
    FROM COMMERCE_DEV.ORDERS.fanapp_daily_products AS fdp
    
        INNER JOIN changed_visitors AS cv
            ON fdp.visitor_id = cv.visitor_id
    
    LEFT JOIN known_visitors AS kv
        ON fdp.visitor_id = kv.visitor_id
    WHERE
        kv.visitor_id IS NULL
        AND fdp.geo_country_code = 'US'
        AND (fdp.has_product_page_view = TRUE OR fdp.has_cart_view = TRUE)
        AND fdp.product_id IS NOT NULL
),

browse_activity AS (
    SELECT
        visitor_id,
        site_id,
        us_dma,
        dma_name,
        geo_country_code,
        geo_region,
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
        'pdp_view' AS action,
        product_id
    FROM anonymous_base
    WHERE has_product_page_view = TRUE

    UNION ALL

    SELECT
        visitor_id,
        site_id,
        us_dma,
        dma_name,
        geo_country_code,
        geo_region,
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
        'cart_view' AS action,
        product_id
    FROM anonymous_base
    WHERE has_cart_view = TRUE
),

site_nm_lkp AS (
    SELECT
        site_id,
        site_nm
    FROM MDE_DEV.MDE_CORE.site_lkp
    QUALIFY ROW_NUMBER() OVER (PARTITION BY site_id ORDER BY load_dts DESC) = 1
)

SELECT
    HASH(CONCAT_WS('|', COALESCE(u.visitor_id::VARCHAR, ''), COALESCE(u.site_id::VARCHAR, ''), COALESCE(site_lkp.site_nm::VARCHAR, ''), COALESCE(u.us_dma::VARCHAR, ''), COALESCE(u.dma_name::VARCHAR, ''), COALESCE(u.geo_country_code::VARCHAR, ''), COALESCE(u.geo_region::VARCHAR, ''), COALESCE(u.league::VARCHAR, ''), COALESCE(u.team_scd::VARCHAR, ''), COALESCE(u.brand_scd::VARCHAR, ''), COALESCE(u.department_name::VARCHAR, ''), COALESCE(u.class_scd::VARCHAR, ''), COALESCE(u.subclass_scd::VARCHAR, ''), COALESCE(u.utm_campaign::VARCHAR, ''), COALESCE(u.utm_source::VARCHAR, ''), COALESCE(u.utm_medium::VARCHAR, ''), COALESCE(u.utm_content::VARCHAR, ''), COALESCE(u.action::VARCHAR, '')
    )) AS pk,
    u.visitor_id,
    u.site_id,
    site_lkp.site_nm AS site_name,
    u.us_dma,
    u.dma_name,
    u.geo_country_code,
    u.geo_region,
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
    COUNT(DISTINCT u.product_id) AS product_count,
    CURRENT_TIMESTAMP() AS _insert_ts,
    CURRENT_TIMESTAMP() AS _update_ts
FROM browse_activity AS u
INNER JOIN site_nm_lkp AS site_lkp
    ON u.site_id = site_lkp.site_id
GROUP BY ALL
  )
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "dim_commerce_browse_anonymous", "node_alias": "dim_commerce_browse_anonymous", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_commerce_browse_anonymous.sql", "node_database": "fangraph_dev", "node_schema": "commerce", "node_id": "model.fes_data.dim_commerce_browse_anonymous", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["exp_prod_fankey_map", "fanapp_daily_products", "site_lkp"], "materialized": "incremental", "raw_code_hash": "343000c95f4ef0bb66134afc07a9f4fd"} */;
