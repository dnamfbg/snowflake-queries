-- Query ID: 01c399d7-0112-6b51-0000-e3072189bece
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:39:36.779000+00:00
-- Elapsed: 195ms
-- Environment: FES

select * from (
        SELECT
    private_fan_id,
    topps_com_order_first_date,
    topps_com_order_last_date,
    topps_com_gmv_total,
    topps_com_shipping_total,
    topps_com_gross_total,
    topps_com_net_total
FROM fangraph_dev.private_fan_id.pfi_topps_orders 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_com_orders", "node_alias": "pfi_topps_com_orders", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_com_orders.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_com_orders", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_topps_orders"], "materialized": "table", "raw_code_hash": "97435136692d0c590818cc25ef728d12"} */
