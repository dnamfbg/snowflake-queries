-- Query ID: 01c399ce-0112-6b51-0000-e3072189bbbe
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:30:15.738000+00:00
-- Elapsed: 2310ms
-- Environment: FES

select * from (
        WITH base AS (
    SELECT
        private_fan_id,
        fbg_tenant_fan_id,
        tlc_tenant_fan_id,
        commerce_tenant_fan_id,
        fanapp_tenant_fan_id,
        unscrubbed_email
    FROM fangraph_dev.private_fan_id.pfi_tenant_id_mapping
),

fbg_ftu AS (
    SELECT
        b.private_fan_id,
        e.fbg_ftu_date_utc AS fbg_ftu_ts_utc,
        e.registration_date_utc AS fbg_reg_ts_utc,
        ROW_NUMBER() OVER (
            PARTITION BY b.private_fan_id
            ORDER BY e.registration_date_utc DESC
        ) AS rn --- added to remove customers with multiple FBG accounts tied to 1 tenant fan id
    FROM base AS b
    INNER JOIN fbg_fde.fbg_users.v_fbg_customer_mart AS e
        ON b.fbg_tenant_fan_id = e.tenant_fan_id
    QUALIFY rn = 1
),

live_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(CONVERT_TIMEZONE('UTC', o.order_date)::TIMESTAMP_NTZ) AS live_first_order_ts_utc
    FROM live_fde.data_views_fanatics.fct_live_orders_v2_v AS o
    INNER JOIN base AS b ON o.fan_id = b.tlc_tenant_fan_id
    WHERE
        o.is_giveaway = FALSE
        AND o.is_refunded = FALSE
        AND o.fan_id IS NOT NULL
    GROUP BY ALL
),

collect_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(CONVERT_TIMEZONE('UTC', c.sale_created_at)::TIMESTAMP_NTZ) AS collect_first_order_ts_utc
    FROM live_fde.data_views_fanatics.fanatics_collect_orders_v AS c
    INNER JOIN base AS b ON c.tenant_fan_id = b.tlc_tenant_fan_id
    WHERE c.tenant_fan_id IS NOT NULL
    GROUP BY ALL
),

topps_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(CONVERT_TIMEZONE('UTC', t.order_dt)::TIMESTAMP_NTZ) AS topps_first_order_ts_utc
    FROM live_fde.data_views_fanatics.topps_global_reporting AS t
    INNER JOIN base AS b ON t.customer_fan_id = b.tlc_tenant_fan_id
    WHERE
        (t.order_status <> 'CANCELED' OR t.order_status IS NULL)
        AND (t.fulfillment_status <> 'TOTALLY REFUNDED' OR t.fulfillment_status IS NULL)
        AND t.customer_fan_id IS NOT NULL
        AND t.trx_price_usd > 0
    GROUP BY ALL
),

commerce_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(o.order_ts_utc)::TIMESTAMP_NTZ AS commerce_first_order_ts_utc
    FROM base AS b
    INNER JOIN FDE_DEV.FDE_INFO.fanapp_user_account_id_map AS a
        ON b.private_fan_id = a.private_fan_id
    INNER JOIN COMMERCE_DEV.ORDERS.weekly_trading AS o
        ON a.user_account_id = o.account_id
    WHERE b.private_fan_id IS NOT NULL
    GROUP BY ALL
),

ticket_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(CONVERT_TIMEZONE('America/Los_Angeles', 'UTC', td.transactiondttm_pt)::TIMESTAMP_NTZ) AS ticket_first_order_ts_utc
    FROM FES_INTEGRATIONS_DEV.TICKETMASTER.ticketmaster AS td
    INNER JOIN base AS b ON LOWER(td.emailaddress) = LOWER(b.unscrubbed_email)
    GROUP BY ALL
),

ftp_ftu AS (
    SELECT
        b.private_fan_id,
        MIN(a.user_session_start_ts) AS ftp_first_game_ts_utc
    FROM MONTEROSA_DEV.MONTEROSA_CORE.fanapp_game_results AS a
    INNER JOIN base AS b ON a.external_id = b.fanapp_tenant_fan_id
    GROUP BY ALL
)

SELECT
    b.private_fan_id,

    -- FBG
    fbg.fbg_ftu_ts_utc,
    fbg.fbg_reg_ts_utc,

    -- Live
    lv.live_first_order_ts_utc,

    -- Collect
    co.collect_first_order_ts_utc,

    -- Topps
    tp.topps_first_order_ts_utc,

    -- TLC Combined
    NULLIF(
        LEAST(
            COALESCE(lv.live_first_order_ts_utc, '9999-12-31'::TIMESTAMP_NTZ),
            COALESCE(co.collect_first_order_ts_utc, '9999-12-31'::TIMESTAMP_NTZ),
            COALESCE(tp.topps_first_order_ts_utc, '9999-12-31'::TIMESTAMP_NTZ)
        ),
        '9999-12-31'::TIMESTAMP_NTZ
    ) AS tlc_first_order_ts_utc,

    -- Commerce
    cd.commerce_first_order_ts_utc,

    -- Ticketmaster
    tk.ticket_first_order_ts_utc,

    -- FTP
    ftp.ftp_first_game_ts_utc

FROM base AS b
LEFT JOIN fbg_ftu AS fbg ON b.private_fan_id = fbg.private_fan_id
LEFT JOIN live_ftu AS lv ON b.private_fan_id = lv.private_fan_id
LEFT JOIN collect_ftu AS co ON b.private_fan_id = co.private_fan_id
LEFT JOIN topps_ftu AS tp ON b.private_fan_id = tp.private_fan_id
LEFT JOIN commerce_ftu AS cd ON b.private_fan_id = cd.private_fan_id
LEFT JOIN ticket_ftu AS tk ON b.private_fan_id = tk.private_fan_id
LEFT JOIN ftp_ftu AS ftp ON b.private_fan_id = ftp.private_fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_ftu_dates", "node_alias": "pfi_ftu_dates", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_ftu_dates.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_ftu_dates", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_tenant_id_mapping", "fanapp_user_account_id_map", "weekly_trading", "ticketmaster", "fanapp_game_results"], "materialized": "table", "raw_code_hash": "13710089335f1de8370143d715b55227"} */
