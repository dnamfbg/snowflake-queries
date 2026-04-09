-- Query ID: 01c39a29-0112-6544-0000-e307218bae9a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:01:40.307000+00:00
-- Elapsed: 719ms
-- Environment: FES

select * from (
        WITH tenant_to_pfi AS (
    SELECT DISTINCT
        tenant_fan_id,
        fan_id AS private_fan_id
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE fan_id IS NOT NULL
)

SELECT
    pfi.private_fan_id,
    cu.first_name AS collect_first_name,
    cu.last_name AS collect_last_name,
    cu.email AS collect_email,
    cu.phone AS collect_phone,
    cu.state AS collect_state,
    cu.country AS collect_country,
    cu.is_frozen AS collect_is_frozen,
    cu.account_creation_timestamp AS collect_account_creation_timestamp,
    cu.last_active_timestamp AS collect_last_active_timestamp,
    cu.email_opt_in AS collect_email_opt_in,
    cu.sms_opt_in AS collect_sms_opt_in,
    cu.push_opt_in AS collect_push_opt_in,
    cu.first_bid_timestamp AS collect_first_bid_timestamp,
    cu.first_purchased_timestamp AS collect_first_purchased_timestamp,
    cu.first_listed_at_timestamp AS collect_first_listed_at_timestamp,
    cu.last_listed_at_timestamp AS collect_last_listed_at_timestamp,
    cu.first_sold_at_timestamp AS collect_first_sold_at_timestamp,
    cu.last_sold_at_timestamp AS collect_last_sold_at_timestamp,
    cu.total_listings AS collect_total_listings,
    cu.total_sales AS collect_total_sales,
    cu.total_paid AS collect_total_paid,
    cu.total_gmv_sold AS collect_total_gmv_sold,
    cu.total_revenue_sold AS collect_total_revenue_sold,
    cu.revenue_lifetime AS collect_revenue_lifetime,
    cu.gmv_lifetime AS collect_gmv_lifetime,
    cu.orders_lifetime AS collect_orders_lifetime,
    cu.items_purchased_lifetime AS collect_items_purchased_lifetime,
    cu.vault_total_submissions AS collect_vault_total_submissions,
    cu.total_number_of_items_in_vault AS collect_total_number_of_items_in_vault,
    cu.total_value_of_items_in_vault AS collect_total_value_of_items_in_vault
FROM fangraph_dev.collect.collect_users AS cu
INNER JOIN tenant_to_pfi AS pfi
    ON cu.tenant_fan_id = pfi.tenant_fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_collect", "node_alias": "pfi_collect", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_collect.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_collect", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["fan_id_tenant_map", "collect_users"], "materialized": "table", "raw_code_hash": "1e28e903691a578df2204c323c675f1b"} */
