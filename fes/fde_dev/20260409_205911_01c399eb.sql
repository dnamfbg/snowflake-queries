-- Query ID: 01c399eb-0112-6544-0000-e307218a728e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:59:11.248000+00:00
-- Elapsed: 2248ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_commerce_purchase_summary_fanapp (
            "PRIVATE_FAN_ID", "FANAPP_COMMERCE_ORDER_COUNT", "FANAPP_COMMERCE_ORDER_AMOUNT_TOTAL", "FANAPP_COMMERCE_DISCOUNT_TOTAL", "FANAPP_COMMERCE_FANCASH_TOTAL", "FANAPP_COMMERCE_FIRST_ORDER_TIMESTAMP", "FANAPP_COMMERCE_LAST_ORDER_TIMESTAMP"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FANAPP_COMMERCE_ORDER_COUNT", 
            
              __src."FANAPP_COMMERCE_ORDER_AMOUNT_TOTAL", 
            
              __src."FANAPP_COMMERCE_DISCOUNT_TOTAL", 
            
              __src."FANAPP_COMMERCE_FANCASH_TOTAL", 
            
              __src."FANAPP_COMMERCE_FIRST_ORDER_TIMESTAMP", 
            
              __src."FANAPP_COMMERCE_LAST_ORDER_TIMESTAMP"
            
          from ( SELECT
    fkfim.fan_id AS private_fan_id,
    COUNT(*) AS fanapp_commerce_order_count,
    SUM(purch_sum.net_demand) AS fanapp_commerce_order_amount_total,
    SUM(purch_sum.discount_total) AS fanapp_commerce_discount_total,
    SUM(purch_sum.fancash_total) AS fanapp_commerce_fancash_total,
    MIN(purch_sum.order_ts_utc) AS fanapp_commerce_first_order_timestamp,
    MAX(purch_sum.order_ts_utc) AS fanapp_commerce_last_order_timestamp
FROM COMMERCE_DEV.ORDERS.fct_purchase_hdr_v2 AS purch_sum
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_key_fan_id_map AS fkfim
    ON purch_sum.fan_key = fkfim.fan_key
WHERE
    fkfim.fan_id IS NOT NULL
    AND purch_sum.order_ts >= '2013-07-01'
    AND purch_sum.channel_session_id NOT IN (24, 25)
    AND purch_sum.site_id IN (515620, 515621, 609465, 609659)
GROUP BY fkfim.fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_purchase_summary_fanapp", "node_alias": "pfi_commerce_purchase_summary_fanapp", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_purchase_summary_fanapp.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_purchase_summary_fanapp", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fct_purchase_hdr_v2", "fan_key_fan_id_map"], "materialized": "table", "raw_code_hash": "c5d22d3baf654a139b12668112c9b233"} */
