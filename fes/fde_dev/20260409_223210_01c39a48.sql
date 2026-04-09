-- Query ID: 01c39a48-0112-6806-0000-e307218d370a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:32:10.035000+00:00
-- Elapsed: 259ms
-- Environment: FES

select * from (
        WITH events_customers AS (
    SELECT DISTINCT
        lower(trim(customer_email)) AS email,
        customer_id
    FROM FES_INTEGRATIONS_DEV.LEAP_EVENT_TECH.leap_customers_combined
),

fangraph_email_lookup AS (
    SELECT DISTINCT
        email,
        fangraph_id
    FROM fangraph_dev.admin.fangraph_opco_identity
),

email_matching AS (
    SELECT
        coalesce(
            fangraph.fangraph_id,
            uuid_string('3b2bb200-71b5-46c5-b1ed-9b784a6de76e', event.customer_id)
        ) AS fangraph_id,
        concat('events-', event.customer_id) AS node
    FROM events_customers AS event
    LEFT JOIN fangraph_email_lookup AS fangraph
        ON event.email = fangraph.email
)

SELECT
    node,
    min(fangraph_id) AS fangraph_id
FROM email_matching
GROUP BY node 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step15_events", "node_alias": "fangraph_id_step15_events", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step15_events.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step15_events", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["leap_customers_combined"], "materialized": "table", "raw_code_hash": "639bdc1077efe2de18d69343dcd8b6ed"} */
