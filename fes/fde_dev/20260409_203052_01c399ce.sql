-- Query ID: 01c399ce-0112-6806-0000-e30721897f5a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:30:52.210000+00:00
-- Elapsed: 648ms
-- Environment: FES

select * from (
        WITH topps_base AS (
    SELECT
        fitm.fan_id AS private_fan_id,
        topps.c_id
    FROM fangraph_dev.topps.topps_dim_customer AS topps
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON topps.c_fan_id = fitm.tenant_fan_id
    WHERE fitm.fan_id IS NOT NULL
),

orders AS (
    SELECT
        customer_id,
        TO_DATE(TO_TIMESTAMP(order_dt_clean, 'MM/DD/YYYY HH12:MI AM')) AS order_date,
        subtotal_usd AS subtotal,
        order_shipping_amt_usd AS shipping_amt,
        p_discount_amt_usd AS discount_amt,
        order_id
    FROM fangraph_dev.topps.topps_global_reporting
    GROUP BY ALL
)

SELECT DISTINCT
    topps_base.private_fan_id,
    orders.order_date,
    orders.subtotal,
    orders.shipping_amt,
    orders.discount_amt,
    orders.order_id
FROM topps_base
LEFT JOIN orders
    ON topps_base.c_id = orders.customer_id
WHERE orders.order_date IS NOT NULL 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_orders_by_date", "node_alias": "pfi_topps_orders_by_date", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_orders_by_date.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_orders_by_date", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_dim_customer", "fan_id_tenant_map", "topps_global_reporting"], "materialized": "table", "raw_code_hash": "3a0569ab1d93a92ced0263594ab2c351"} */
