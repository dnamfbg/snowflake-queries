-- Query ID: 01c39a28-0212-6cb9-24dd-0703193d9e97
-- Database: FBG_ANALYTICS_DEV
-- Schema: ALVIN_CHAI
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:00:28.283000+00:00
-- Elapsed: 3153ms
-- Environment: FBG

SELECT query_id, query_text, total_elapsed_time, execution_time, compilation_time, 
       queued_provisioning_time, queued_repair_time, queued_overload_time,
       bytes_scanned, rows_produced, partitions_scanned, partitions_total,
       bytes_spilled_to_local_storage, bytes_spilled_to_remote_storage,
       warehouse_name, warehouse_size, query_type, execution_status
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY 
WHERE query_id = '01c39a11-0212-6dbe-24dd-07031938d133'
