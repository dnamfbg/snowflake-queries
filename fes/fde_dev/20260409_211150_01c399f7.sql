-- Query ID: 01c399f7-0112-65b6-0000-e307218ade5a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:11:50.721000+00:00
-- Elapsed: 693ms
-- Environment: FES

select * from (
        SELECT
    b.private_fan_id,
    DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', l.creation_time)) AS date_alk,
    stm.grouped_nm,
    SUM(l.txn_amount) AS loyalty_amount,
    COUNT(DISTINCT l.external_reference_id) AS loyalty_txns
FROM LOYALTY_DEV.LOYALTY_CORE.loyalty_earn_burn_mapper AS l
INNER JOIN fangraph_dev.private_fan_id.pfi_customer_mart AS b
    ON l.loyalty_account_id = b.loyalty_account_id
INNER JOIN fes_users.rohan_gulati.site_tenant_mapping AS stm
    ON l.tenant_id = stm.tenant_id AND l.site_id = stm.site_id
WHERE l.is_test_txn = 0
GROUP BY ALL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_daily_fancash", "node_alias": "pfi_daily_fancash", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_daily_fancash.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_daily_fancash", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["loyalty_earn_burn_mapper", "pfi_customer_mart"], "materialized": "table", "raw_code_hash": "e4f042925148cc0f8fd666650d4f7b62"} */
