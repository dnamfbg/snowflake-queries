-- Query ID: 01c399ea-0112-6544-0000-e307218a725e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:58:57.052000+00:00
-- Elapsed: 109ms
-- Environment: FES

select * from (
        SELECT
    fkfim.fan_id AS private_fan_id,
    COUNT(DISTINCT purch_sum.order_ref_num) AS commerce_order_count,
    SUM(purch_sum.net_demand) AS commerce_order_amount_total,
    SUM(purch_sum.discount_total) AS commerce_discount_total,
    SUM(purch_sum.fancash_total) AS commerce_fancash_total,
    MIN(purch_sum.order_ts_utc) AS commerce_first_order_timestamp,
    MAX(purch_sum.order_ts_utc) AS commerce_last_order_timestamp
FROM COMMERCE_DEV.ORDERS.fct_purchase_hdr_v2 AS purch_sum
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_key_fan_id_map AS fkfim
    ON purch_sum.fan_key = fkfim.fan_key
WHERE
    fkfim.fan_id IS NOT NULL
    AND purch_sum.order_ts >= '2013-07-01'
    AND purch_sum.channel_session_id NOT IN (24, 25)
GROUP BY fkfim.fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_purchase_summary", "node_alias": "pfi_commerce_purchase_summary", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_purchase_summary.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_purchase_summary", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fct_purchase_hdr_v2", "fan_key_fan_id_map"], "materialized": "table", "raw_code_hash": "c44b39d2584dcbc6c70f009a6a97d171"} */
