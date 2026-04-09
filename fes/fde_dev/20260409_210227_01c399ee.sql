-- Query ID: 01c399ee-0112-65b6-0000-e307218a36da
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:02:27.664000+00:00
-- Elapsed: 298ms
-- Environment: FES

select * from (
        WITH base_users AS (
    SELECT DISTINCT private_fan_id
    FROM LOYALTY_DEV.LOYALTY_INFO.tier_points_ledger_v2
),

latest_loyalty_account AS (
    SELECT
        loyalty_account_id,
        private_fan_id,
        hashed_email,
        email,
        fan_id_creation_time,
        last_modified_time
    FROM LOYALTY_DEV.LOYALTY_INFO.loyalty_account_id_fan_id_map
    WHERE loyalty_account_id IS NOT NULL
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY last_modified_time DESC
    ) = 1
),

tlc_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS tlc_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100004'
    GROUP BY tenant_fan_id, fan_id
),

commerce_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS commerce_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100001'
    GROUP BY tenant_fan_id, fan_id
),

fbg_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS fbg_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100002'
    GROUP BY tenant_fan_id, fan_id
),

shop_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS shop_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100024'
    GROUP BY tenant_fan_id, fan_id
),

pointsville_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS pointsville_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100021'
    GROUP BY tenant_fan_id, fan_id
),

fanapp_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS fanapp_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100005'
    GROUP BY tenant_fan_id, fan_id
),

lids_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS lids_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100006'
    GROUP BY tenant_fan_id, fan_id
),

events_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS events_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100015'
    GROUP BY tenant_fan_id, fan_id
),

ticketmaster_tenant_ids AS (
    SELECT
        tenant_fan_id,
        fan_id AS private_fan_id,
        MIN(tenant_created_date) AS ticketmaster_first_login_date_utc
    FROM COMMERCE_DEV.FAN_KEY.fan_id_tenant_map
    WHERE tenant_id = '100026'
    GROUP BY tenant_fan_id, fan_id
),

fan_key_email AS (
    SELECT
        fan_key,
        unscrubbed_email,
        md5_hashed_email
    FROM COMMERCE_DEV.FAN_KEY.fan_key_account_map
    WHERE is_primary_account = 1
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fan_key
        ORDER BY last_modified_time DESC
    ) = 1
)

SELECT
    a.private_fan_id,

    -- Loyalty account
    b.loyalty_account_id,
    b.fan_id_creation_time,
    b.hashed_email AS loyalty_md5_hashed_email,
    b.email AS loyalty_email,

    -- Fan key + email
    m.fan_key,
    m.unscrubbed_email,
    m.md5_hashed_email AS fankey_md5_hashed_email,

    -- Tenant IDs + first login dates
    c.tenant_fan_id AS tlc_tenant_fan_id,
    c.tlc_first_login_date_utc,
    d.tenant_fan_id AS fbg_tenant_fan_id,
    d.fbg_first_login_date_utc,
    f.tenant_fan_id AS shop_tenant_fan_id,
    f.shop_first_login_date_utc,
    g.tenant_fan_id AS pointsville_tenant_fan_id,
    g.pointsville_first_login_date_utc,
    h.tenant_fan_id AS fanapp_tenant_fan_id,
    h.fanapp_first_login_date_utc,
    i.tenant_fan_id AS lids_tenant_fan_id,
    i.lids_first_login_date_utc,
    j.tenant_fan_id AS events_tenant_fan_id,
    j.events_first_login_date_utc,
    l.tenant_fan_id AS ticketmaster_tenant_fan_id,
    l.ticketmaster_first_login_date_utc,
    n.tenant_fan_id AS commerce_tenant_fan_id,
    n.commerce_first_login_date_utc

FROM base_users AS a
LEFT JOIN latest_loyalty_account AS b ON a.private_fan_id = b.private_fan_id
LEFT JOIN tlc_tenant_ids AS c ON a.private_fan_id = c.private_fan_id
LEFT JOIN fbg_tenant_ids AS d ON a.private_fan_id = d.private_fan_id
LEFT JOIN shop_tenant_ids AS f ON a.private_fan_id = f.private_fan_id
LEFT JOIN pointsville_tenant_ids AS g ON a.private_fan_id = g.private_fan_id
LEFT JOIN fanapp_tenant_ids AS h ON a.private_fan_id = h.private_fan_id
LEFT JOIN lids_tenant_ids AS i ON a.private_fan_id = i.private_fan_id
LEFT JOIN events_tenant_ids AS j ON a.private_fan_id = j.private_fan_id
LEFT JOIN ticketmaster_tenant_ids AS l ON a.private_fan_id = l.private_fan_id
LEFT JOIN fan_key_email AS m ON b.hashed_email = m.md5_hashed_email
LEFT JOIN commerce_tenant_ids AS n ON a.private_fan_id = n.private_fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_tenant_id_mapping", "node_alias": "pfi_tenant_id_mapping", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_tenant_id_mapping.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_tenant_id_mapping", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["tier_points_ledger_v2", "loyalty_account_id_fan_id_map", "fan_id_tenant_map", "fan_key_account_map"], "materialized": "table", "raw_code_hash": "6c4aa157781acc01dc277af4d9c4bc19"} */
