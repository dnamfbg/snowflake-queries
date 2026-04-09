-- Query ID: 01c39a28-0112-6ccc-0000-e307218bd9ee
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:00:08.583000+00:00
-- Elapsed: 355ms
-- Environment: FES

select * from (
        SELECT
    fangraph_ids.fangraph_id,
    sfm.fan_id,
    sfm.sf_contact_key AS salesforce_contact_id_vip,
    IFF(sfm.sf_contact_key IS NOT NULL, 'SALESFORCE_CONTACT_ID', NULL) AS salesforce_contact_id_vip_type,
    sfm.sf_member_id AS salesforce_member_id_vip,
    ROW_NUMBER() OVER (PARTITION BY fangraph_ids.fangraph_id ORDER BY sfm.fan_id) = 1 AS best_fangraph_record
FROM CDE_DEV.CDE_CORE.salesforce_fanid_mapping AS sfm
INNER JOIN fangraph_dev.admin.fangraph_id_final AS fangraph_ids
    ON fangraph_ids.node = 'fi-' || sfm.fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "salesforce_fangraph_id_mapping", "node_alias": "salesforce_fangraph_id_mapping", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/3rd_party/salesforce_fangraph_id_mapping.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.salesforce_fangraph_id_mapping", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["salesforce_fanid_mapping", "fangraph_id_final"], "materialized": "table", "raw_code_hash": "bb51bdea47928dbc9e829ad0ddfba2fc"} */
