-- Query ID: 01c399d5-0112-6bf9-0000-e3072189f6b2
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:37:23.584000+00:00
-- Elapsed: 202ms
-- Environment: FES

select * from (
        SELECT
    private_fan_id,
    MIN(order_date) AS topps_com_order_first_date,
    MAX(order_date) AS topps_com_order_last_date,
    SUM(COALESCE(subtotal, 0)) AS topps_com_gmv_total,
    SUM(COALESCE(shipping_amt, 0)) AS topps_com_shipping_total,
    SUM(
        COALESCE(subtotal, 0)
        + COALESCE(shipping_amt, 0)
    ) AS topps_com_gross_total,
    SUM(
        COALESCE(subtotal, 0)
        + COALESCE(shipping_amt, 0)
        - COALESCE(discount_amt, 0)
    ) AS topps_com_net_total
FROM fangraph_dev.private_fan_id.pfi_topps_orders_by_date
GROUP BY private_fan_id
HAVING topps_com_order_first_date IS NOT NULL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_orders", "node_alias": "pfi_topps_orders", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_orders.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_orders", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_topps_orders_by_date"], "materialized": "table", "raw_code_hash": "3b60519df67528528957ea6e93b4deb8"} */
