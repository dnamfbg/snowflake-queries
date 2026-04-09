-- Query ID: 01c399ed-0112-6bf9-0000-e3072189fd3a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:01:45.421000+00:00
-- Elapsed: 112ms
-- Environment: FES

select * from (
        SELECT
    fitm.fan_id AS private_fan_id,
    TO_TIMESTAMP(MIN(a.event_ts)) AS fbg_first_login_ts,
    TO_TIMESTAMP(MAX(a.event_ts)) AS fbg_last_login_ts
FROM FANFLOW_DEV.ACCOUNT_EVENTS.signin__account AS a
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
    ON a.tenant_fan_id = fitm.tenant_fan_id
WHERE
    a.site_id = 608111
    AND fitm.tenant_id = 100002
GROUP BY ALL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_login", "node_alias": "pfi_fbg_login", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_login.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_login", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["signin__account", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "b68535a33cb372ed129fd07f617fa8de"} */
