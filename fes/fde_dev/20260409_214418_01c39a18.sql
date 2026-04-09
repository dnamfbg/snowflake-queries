-- Query ID: 01c39a18-0112-6ccc-0000-e307218bd522
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:44:18.195000+00:00
-- Elapsed: 23304ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.admin.fangraph_id_step14_topps (
            "NODE", "FANGRAPH_ID"
          )
          select
            
              __src."NODE", 
            
              __src."FANGRAPH_ID"
            
          from ( -- step 1: get fangraph_id where it exists for topps customers by matching tenant_fan_id
WITH topps AS (

    SELECT DISTINCT
        c_email AS email,
        c_id AS id,
        c_fan_id AS fan_id
    FROM fangraph_dev.topps.topps_dim_customer
    WHERE c_id IS NOT NULL
),

topps_fangraph_id_from_fan_id AS (

    SELECT
        fitm.fangraph_id,
        t.email,
        t.id,
        t.fan_id,
        CONCAT('topps-', t.id) AS node
    FROM topps AS t
    LEFT JOIN fangraph_dev.admin.fan_id_tenant_map AS fitm
        ON t.fan_id = fitm.tenant_fan_id

),

-- step 2: get fangraph_id for topps customers by matching email, where node is not in step 1
fan_key_account_map AS (

    SELECT
        account_email,
        MAX_BY(fangraph_id, last_modified_time) AS fangraph_id
    FROM fangraph_dev.admin.fan_key_account_map
    GROUP BY ALL

),

topps_fangraph_id_from_email AS (

    SELECT
        COALESCE(
            fkam.fangraph_id,
            UUID_STRING('fe971b24-9572-4005-b22f-351e9c09274d', t.id)
        ) AS fangraph_id,
        t.node,
        t.email
    FROM topps_fangraph_id_from_fan_id AS t
    LEFT JOIN fan_key_account_map AS fkam
        ON t.email = fkam.account_email
    WHERE t.fangraph_id IS NULL -- already found a fangraph_id in this node from mapping tenant_id

),

-- step 3: get fangraph_id for toppsd customers by matching email, first by looking at step 1, then step 2, then fangraph_fan_key_account_map
topps_d AS (

    SELECT DISTINCT
        topps_digital_email,
        fan_id_email,
        topps_digital_user_id AS id,
        tenant_fan_id
    FROM collectibles_fde.topps_digital.user_profiles_dim__next
    UNION ALL
    SELECT DISTINCT -- TTF Data is separate from vanilla Topps Digital Data and will not join together
        topps_digital_email,
        fanid_email AS fan_id_email,
        topps_digital_user_id AS id,
        tenant_fan_id
    FROM collectibles_fde.topps_digital.ttf_user_profiles_dim__next
),

toppsd_fangraph_id_from_fan_id AS (

    SELECT
        fitm.fangraph_id,
        t.topps_digital_email,
        t.fan_id_email,
        t.id,
        t.tenant_fan_id,
        CONCAT('toppsd-', t.id) AS node
    FROM topps_d AS t
    LEFT JOIN fangraph_dev.admin.fan_id_tenant_map AS fitm
        ON t.tenant_fan_id = fitm.tenant_fan_id

),

fangraph_email_lookup AS (
    SELECT DISTINCT
        email,
        fangraph_id
    FROM fangraph_dev.admin.fangraph_opco_identity
),

toppsd_fangraph_id_from_email AS (

    SELECT
        COALESCE(
            fel.fangraph_id,
            UUID_STRING('fe971b24-9572-4005-b22f-351e9c09274d', t.id)
        ) AS fangraph_id,
        t.node,
        t.topps_digital_email,
        t.fan_id_email
    FROM toppsd_fangraph_id_from_fan_id AS t
    LEFT JOIN fangraph_email_lookup AS fel
        ON t.topps_digital_email = fel.email
    WHERE t.fangraph_id IS NULL -- already found a fangraph_id in this node from mapping tenant_id
)

-- result from step 1
SELECT
    node,
    fangraph_id
FROM topps_fangraph_id_from_fan_id
WHERE
    fangraph_id IS NOT NULL
    AND fan_id IS NOT NULL

UNION ALL

-- result from step 2
SELECT
    node,
    MIN(fangraph_id) AS fangraph_id
FROM topps_fangraph_id_from_email
GROUP BY ALL

UNION ALL

-- result from step 3
SELECT
    node,
    fangraph_id
FROM toppsd_fangraph_id_from_fan_id
WHERE
    fangraph_id IS NOT NULL
    AND tenant_fan_id IS NOT NULL

UNION ALL

-- result from step 4
SELECT
    node,
    MIN(fangraph_id) AS fangraph_id
FROM toppsd_fangraph_id_from_email
GROUP BY ALL 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "fangraph_id_step14_topps", "node_alias": "fangraph_id_step14_topps", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/fangraph_id/fangraph_id_step14_topps.sql", "node_database": "fangraph_dev", "node_schema": "admin", "node_id": "model.fes_data.fangraph_id_step14_topps", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["topps_dim_customer", "fangraph_fan_key_account_map"], "materialized": "table", "raw_code_hash": "f0b9c5a0654136038973d9b1a331ffa3"} */
