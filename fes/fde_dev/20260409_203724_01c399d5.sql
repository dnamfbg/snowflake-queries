-- Query ID: 01c399d5-0112-6b51-0000-e3072189be1e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:37:24.575000+00:00
-- Elapsed: 1945ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_topps_orders (
            "PRIVATE_FAN_ID", "TOPPS_COM_ORDER_FIRST_DATE", "TOPPS_COM_ORDER_LAST_DATE", "TOPPS_COM_GMV_TOTAL", "TOPPS_COM_SHIPPING_TOTAL", "TOPPS_COM_GROSS_TOTAL", "TOPPS_COM_NET_TOTAL"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."TOPPS_COM_ORDER_FIRST_DATE", 
            
              __src."TOPPS_COM_ORDER_LAST_DATE", 
            
              __src."TOPPS_COM_GMV_TOTAL", 
            
              __src."TOPPS_COM_SHIPPING_TOTAL", 
            
              __src."TOPPS_COM_GROSS_TOTAL", 
            
              __src."TOPPS_COM_NET_TOTAL"
            
          from ( SELECT
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
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_topps_orders", "node_alias": "pfi_topps_orders", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_topps_orders.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_topps_orders", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_topps_orders_by_date"], "materialized": "table", "raw_code_hash": "3b60519df67528528957ea6e93b4deb8"} */
