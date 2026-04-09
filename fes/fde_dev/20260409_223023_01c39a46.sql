-- Query ID: 01c39a46-0112-6f82-0000-e307218d08ea
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:30:23.628000+00:00
-- Elapsed: 3682ms
-- Environment: FES

merge into fangraph_dev.commerce.dim_commerce_browse_anonymous as DBT_INTERNAL_DEST
        using fangraph_dev.commerce.dim_commerce_browse_anonymous__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.pk = DBT_INTERNAL_DEST.pk
                )

    
    when matched then update set
        "PK" = DBT_INTERNAL_SOURCE."PK","VISITOR_ID" = DBT_INTERNAL_SOURCE."VISITOR_ID","SITE_ID" = DBT_INTERNAL_SOURCE."SITE_ID","SITE_NAME" = DBT_INTERNAL_SOURCE."SITE_NAME","US_DMA" = DBT_INTERNAL_SOURCE."US_DMA","DMA_NAME" = DBT_INTERNAL_SOURCE."DMA_NAME","GEO_COUNTRY_CODE" = DBT_INTERNAL_SOURCE."GEO_COUNTRY_CODE","GEO_REGION" = DBT_INTERNAL_SOURCE."GEO_REGION","LEAGUE" = DBT_INTERNAL_SOURCE."LEAGUE","TEAM_SCD" = DBT_INTERNAL_SOURCE."TEAM_SCD","BRAND_SCD" = DBT_INTERNAL_SOURCE."BRAND_SCD","DEPARTMENT_NAME" = DBT_INTERNAL_SOURCE."DEPARTMENT_NAME","CLASS_SCD" = DBT_INTERNAL_SOURCE."CLASS_SCD","SUBCLASS_SCD" = DBT_INTERNAL_SOURCE."SUBCLASS_SCD","UTM_CAMPAIGN" = DBT_INTERNAL_SOURCE."UTM_CAMPAIGN","UTM_SOURCE" = DBT_INTERNAL_SOURCE."UTM_SOURCE","UTM_MEDIUM" = DBT_INTERNAL_SOURCE."UTM_MEDIUM","UTM_CONTENT" = DBT_INTERNAL_SOURCE."UTM_CONTENT","ACTION" = DBT_INTERNAL_SOURCE."ACTION","PRODUCT_COUNT" = DBT_INTERNAL_SOURCE."PRODUCT_COUNT","_UPDATE_TS" = DBT_INTERNAL_SOURCE."_UPDATE_TS"
    

    when not matched then insert
        ("PK", "VISITOR_ID", "SITE_ID", "SITE_NAME", "US_DMA", "DMA_NAME", "GEO_COUNTRY_CODE", "GEO_REGION", "LEAGUE", "TEAM_SCD", "BRAND_SCD", "DEPARTMENT_NAME", "CLASS_SCD", "SUBCLASS_SCD", "UTM_CAMPAIGN", "UTM_SOURCE", "UTM_MEDIUM", "UTM_CONTENT", "ACTION", "PRODUCT_COUNT", "_INSERT_TS", "_UPDATE_TS")
    values
        ("PK", "VISITOR_ID", "SITE_ID", "SITE_NAME", "US_DMA", "DMA_NAME", "GEO_COUNTRY_CODE", "GEO_REGION", "LEAGUE", "TEAM_SCD", "BRAND_SCD", "DEPARTMENT_NAME", "CLASS_SCD", "SUBCLASS_SCD", "UTM_CAMPAIGN", "UTM_SOURCE", "UTM_MEDIUM", "UTM_CONTENT", "ACTION", "PRODUCT_COUNT", "_INSERT_TS", "_UPDATE_TS")


/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "dim_commerce_browse_anonymous", "node_alias": "dim_commerce_browse_anonymous", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/dim/dim_commerce_browse_anonymous.sql", "node_database": "fangraph_dev", "node_schema": "commerce", "node_id": "model.fes_data.dim_commerce_browse_anonymous", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["exp_prod_fankey_map", "fanapp_daily_products", "site_lkp"], "materialized": "incremental", "raw_code_hash": "343000c95f4ef0bb66134afc07a9f4fd"} */;
