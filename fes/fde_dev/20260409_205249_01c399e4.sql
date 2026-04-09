-- Query ID: 01c399e4-0112-6ccc-0000-e3072189edf6
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:52:49.249000+00:00
-- Elapsed: 362ms
-- Environment: FES

select * from (
        WITH collect_fangraph_id_from_fan_id AS (

    SELECT
        fitm.fangraph_id,
        c.fan_id AS tenant_fan_id,
        c.user_id,
        LOWER(TRIM(c.email)) AS email,
        CONCAT('collect-', c.user_id) AS node
    FROM live_fde.data_views_fanatics.fanatics_collect_users_v AS c
    LEFT JOIN fangraph_dev.admin.fan_id_tenant_map AS fitm
        ON c.fan_id = fitm.tenant_fan_id

),

fangraph_email_lookup AS (

    SELECT
        email,
        fangraph_id
    FROM fangraph_dev.admin.fangraph_opco_identity
    GROUP BY ALL

)

SELECT
    c.node,
    MIN(COALESCE(
        c.fangraph_id,
        f.fangraph_id,
        UUID_STRING('40960c24-9bf5-5ee9-aa9b-f1125fe7959c', c.user_id)
    )) AS fangraph_id
FROM collect_fangraph_id_from_fan_id AS c
LEFT JOIN fangraph_email_lookup AS f
    ON c.email = f.email
GROUP BY ALL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step16_collect", "node_alias": "fangraph_id_step16_collect", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step16_collect.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step16_collect", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": [], "materialized": "table", "raw_code_hash": "29568d61236e3c128f1f3fbacec688e7"} */
