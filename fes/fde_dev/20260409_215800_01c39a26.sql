-- Query ID: 01c39a26-0112-6029-0000-e307218b8fda
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:58:00.418000+00:00
-- Elapsed: 663ms
-- Environment: FES

select * from (
        WITH first_fan_key_creation_time AS (
    SELECT
        fan_key,
        MIN(creation_time) AS creation_time_ts
    FROM COMMERCE_DEV.FAN_KEY.fan_key_account_map
    GROUP BY ALL
)

SELECT
    fangraph_ids.fangraph_id,
    fkm.fan_key,
    fkm.account_email,
    fkm.scrubbed_email,
    fkm.mobile_number,
    INITCAP(TRIM(fkm.first_name)) AS first_name,
    INITCAP(TRIM(fkm.last_name)) AS last_name,
    fkm.billing_address_id,
    bill_addr.street_address1 AS billing_street_address1,
    bill_addr.street_address2 AS billing_street_address2,
    bill_addr.city AS billing_city,
    bill_addr.state AS billing_state,
    bill_addr.country AS billing_country,
    bill_addr.zip_code AS billing_zip_code,
    bill_addr.zip_code_extension AS billing_zip_code_extension,
    fkm.shipping_address_id,
    ship_addr.street_address1 AS shipping_street_address1,
    ship_addr.street_address2 AS shipping_street_address2,
    ship_addr.city AS shipping_city,
    ship_addr.state AS shipping_state,
    ship_addr.country AS shipping_country,
    ship_addr.zip_code AS shipping_zip_code,
    ship_addr.zip_code_extension AS shipping_zip_code_extension,
    fkm.hashed_email,
    fkm.internal_surrogate_key,
    fkm.account_directory_id,
    fkm.account_id,
    fkm.account_type,
    TO_TIMESTAMP(fkm.last_modified_time) AS last_modified_ts,
    TO_TIMESTAMP(first_fan_key_creation_time.creation_time_ts) AS creation_time_ts,
    fkm.change_date,
    ROW_NUMBER() OVER (PARTITION BY fangraph_ids.fangraph_id ORDER BY fkm.last_modified_time DESC) = 1 AS best_fangraph_record
FROM COMMERCE_DEV.FAN_KEY.fan_key_master_pii AS fkm
LEFT JOIN commerce_cde.cde_cust_info.fan_addresses_v AS bill_addr ON fkm.billing_address_id = bill_addr.address_id
LEFT JOIN commerce_cde.cde_cust_info.fan_addresses_v AS ship_addr ON fkm.shipping_address_id = ship_addr.address_id
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids ON fangraph_ids.node = 'fk-' || fkm.fan_key
INNER JOIN first_fan_key_creation_time AS first_fan_key_creation_time ON fkm.fan_key = first_fan_key_creation_time.fan_key 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_fan_key_master", "node_alias": "fan_key_master", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph/fangraph_fan_key_master.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_fan_key_master", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_key_account_map", "fan_key_master_pii", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "76a033b5002b8695b7b9799d79388e3f"} */
