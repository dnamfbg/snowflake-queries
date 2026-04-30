-- Fangraph Account Creation Timestamps (Lightweight)
-- Extracted from fes-airflow/dags/dbt/models/fangraph
-- Only the fields needed: fangraph_id + 8 opco account creation timestamps
--
-- Source tables (all on FES):
--   COMMERCE.SOURCE.UNIFIED_FANID_PII_ICEBERG       (fan_id_tenant_map)
--   COMMERCE.SOURCE.FAN_KEY_MASTER_PII_ICEBERG       (fan_key_master)
--   COMMERCE.SOURCE.FAN_KEY_ACCOUNT_MAP_PII_ICEBERG  (fan_key_account_map)
--   FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS            (fbg accounts)
--   FBG_FDE.FBG_USERS.V_FBG_USERS                    (fbg users)
--   LIVE_FDE.DATA_VIEWS_FANATICS.FANATICS_LIVE_USERS_V
--   LIVE_FDE.DATA_VIEWS_FANATICS.FANATICS_COLLECT_USERS_V
--   COLLECTIBLES_FDE.TOPPS_DIGITAL.USER_PROFILES_DIM__NEXT
--   COLLECTIBLES_FDE.TOPPS_DIGITAL.TTF_USER_PROFILES_DIM__NEXT
--   FES_INTEGRATIONS.LEAP_EVENT_TECH.CUSTOMER_REPORT  (events/leap)
--   FES_INTEGRATIONS.LEAP_EVENT_TECH.ORDER_REPORT
--
-- NOTE: This query depends on the fangraph_id_final mapping table.
--       You'll need to reference it from wherever dbt materializes it,
--       e.g. FDE_DEV.<your_schema>.FANGRAPH_ID_FINAL or the prod equivalent.
--       Update the placeholder below with the correct fully-qualified name.

-- ============================================================
-- CONFIGURE: Set the fangraph_id_final table location
-- ============================================================
-- SET fangraph_id_final_table = 'FDE.FANGRAPH.FANGRAPH_ID_FINAL';  -- adjust as needed

-- ============================================================
-- 1. FANGRAPH ID SPINE (all valid fangraph_ids)
-- ============================================================
WITH fangraph_ids AS (
    SELECT fangraph_id
    FROM FDE.FANGRAPH.FANGRAPH_ID_FINAL  -- adjust schema if needed
    GROUP BY fangraph_id
),

-- ============================================================
-- 2. FAN ID TENANT MAP → commerce, fanapp, fbg, live timestamps
-- ============================================================
fan_id_tenant_map AS (
    SELECT
        fitm.fan_id,
        fitm.tenant_id,
        fitm.tenant_fan_id,
        fitm.creation_time AS tenant_created_date
    FROM COMMERCE.SOURCE.UNIFIED_FANID_PII_ICEBERG AS fitm
),

fangraph_fan_id_tenant_map AS (
    SELECT
        fid.fangraph_id,
        fitm.*
    FROM fan_id_tenant_map AS fitm
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'fi-' || fitm.fan_id
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fitm.tenant_id, fitm.tenant_fan_id
        ORDER BY fitm.tenant_created_date ASC
    ) = 1
),

tenant_map_opco AS (
    SELECT
        fangraph_id,
        TO_TIMESTAMP(MIN(IFF(tenant_id = '1', tenant_created_date, NULL)))  AS commerce_account_creation_timestamp,  -- tenant_id_commerce = '1'
        TO_TIMESTAMP(MIN(IFF(tenant_id = '5', tenant_created_date, NULL)))  AS fanapp_account_creation_timestamp,    -- tenant_id_fanapp = '5'
        TO_TIMESTAMP(MIN(IFF(tenant_id = '3', tenant_created_date, NULL)))  AS fbg_account_creation_timestamp,       -- tenant_id_fbg = '3'
        TO_TIMESTAMP(MIN(IFF(tenant_fan_id IN (SELECT tenant_fan_id FROM live_users), tenant_created_date, NULL)))
            AS live_account_creation_timestamp
    FROM fangraph_fan_id_tenant_map
    GROUP BY fangraph_id
),

-- ============================================================
-- 3. FAN KEY MASTER → commerce creation_time_ts (fallback)
-- ============================================================
first_fan_key_creation AS (
    SELECT
        fan_key,
        MIN(creation_time) AS creation_time_ts
    FROM COMMERCE.SOURCE.FAN_KEY_ACCOUNT_MAP_PII_ICEBERG
    GROUP BY fan_key
),

fan_key_master AS (
    SELECT
        fid.fangraph_id,
        TO_TIMESTAMP(ffkc.creation_time_ts) AS commerce_fkm_creation_ts
    FROM COMMERCE.SOURCE.FAN_KEY_MASTER_PII_ICEBERG AS fkm
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'fk-' || fkm.fan_key
    INNER JOIN first_fan_key_creation AS ffkc
        ON fkm.fan_key = ffkc.fan_key
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fid.fangraph_id
        ORDER BY fkm.last_modified_time DESC
    ) = 1
),

-- ============================================================
-- 4. FBG ACCOUNTS → fbg_account_creation_ts
-- ============================================================
fbg_accounts AS (
    SELECT
        fitm.fangraph_id,
        fbg_acc.creation_date AS fbg_account_creation_ts
    FROM FBG_FDE.FBG_USERS.FBG_TO_FDE_ACCOUNTS AS fbg_acc
    INNER JOIN fangraph_fan_id_tenant_map AS fitm
        ON REPLACE(fbg_acc.ref1, 'AMELCO-', '') = fitm.tenant_fan_id
    INNER JOIN FBG_FDE.FBG_USERS.V_FBG_USERS AS fbg_usr
        ON fbg_acc.id = fbg_usr.acco_id
    WHERE fbg_acc.creation_date IS NOT NULL
      AND fitm.tenant_id = '3'  -- tenant_id_fbg
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fitm.fangraph_id
        ORDER BY
            CASE WHEN UPPER(fbg_acc.status) = 'ACTIVE' THEN 1 ELSE 2 END,
            fbg_acc.modified DESC,
            fbg_acc.creation_date DESC,
            fbg_acc.id DESC
    ) = 1
),

-- ============================================================
-- 5. LIVE USERS + ORDERS → live_account_creation_ts
-- ============================================================
live_users AS (
    SELECT
        tenant_fan_id,
        LOWER(TRIM(email)) AS email
    FROM LIVE_FDE.DATA_VIEWS_FANATICS.FANATICS_LIVE_USERS_V
    WHERE tenant_fan_id IS NOT NULL
),

live_summary AS (
    SELECT
        COALESCE(fitm.fangraph_id, eid.fangraph_id) AS fangraph_id,
        MIN(fitm_ts.tenant_created_date) AS account_creation_ts
    FROM LIVE_FDE.DATA_VIEWS_FANATICS.FCT_LIVE_ORDERS_V2_V AS flo
    LEFT JOIN (
        SELECT tenant_fan_id, fangraph_id, tenant_created_date
        FROM fangraph_fan_id_tenant_map
        WHERE tenant_fan_id IN (SELECT tenant_fan_id FROM live_users)
    ) AS fitm
        ON flo.fan_id = fitm.tenant_fan_id
    LEFT JOIN (
        SELECT tenant_fan_id, fangraph_id, tenant_created_date
        FROM fangraph_fan_id_tenant_map
        WHERE tenant_fan_id IN (SELECT tenant_fan_id FROM live_users)
    ) AS fitm_ts
        ON flo.fan_id = fitm_ts.tenant_fan_id
    LEFT JOIN (
        SELECT lu.user_id, MIN(fid.fangraph_id) AS fangraph_id
        FROM live_users lu
        INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL fid
            ON -- simplified: would need fangraph_opco_identity for full email resolve
               FALSE
        GROUP BY lu.user_id
    ) AS eid
        ON flo.user_id = eid.user_id
    WHERE COALESCE(fitm.fangraph_id, eid.fangraph_id) IS NOT NULL
    GROUP BY 1
),

-- ============================================================
-- 6. TOPPS.COM → topps_com_created_timestamp
-- ============================================================
topps_customers AS (
    SELECT
        fid.fangraph_id,
        MIN(TO_TIMESTAMP(topps.c_created_at)) AS topps_com_created_timestamp
    FROM FDE.FANGRAPH.TOPPS_DIM_CUSTOMER AS topps  -- adjust if source table differs
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'topps-' || topps.c_id
    GROUP BY fid.fangraph_id
),

-- ============================================================
-- 7. TOPPS DIGITAL → topps_digital_account_creation_timestamp
-- ============================================================
topps_digital AS (
    SELECT
        fid.fangraph_id,
        MIN(TO_TIMESTAMP(u.user_activation_dt)) AS topps_digital_account_creation_timestamp
    FROM (
        SELECT topps_digital_user_id, user_activation_dt
        FROM COLLECTIBLES_FDE.TOPPS_DIGITAL.USER_PROFILES_DIM__NEXT
        UNION ALL
        SELECT topps_digital_user_id, user_activation_dt
        FROM COLLECTIBLES_FDE.TOPPS_DIGITAL.TTF_USER_PROFILES_DIM__NEXT
    ) AS u
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'toppsd-' || u.topps_digital_user_id
    GROUP BY fid.fangraph_id
),

-- ============================================================
-- 8. EVENTS (LEAP) → events_account_creation_timestamp
-- ============================================================
events_customers AS (
    SELECT
        fid.fangraph_id,
        MIN(c.registration_time) AS events_account_creation_timestamp
    FROM FDE.FANGRAPH.LEAP_CUSTOMERS_COMBINED AS c  -- adjust if materialized elsewhere
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'events-' || c.customer_id
    GROUP BY fid.fangraph_id
),

-- ============================================================
-- 9. COLLECT → collect_account_creation_timestamp
-- ============================================================
collect_users AS (
    SELECT
        fid.fangraph_id,
        MIN(collect.registered_at::TIMESTAMP_NTZ) AS collect_account_creation_timestamp
    FROM LIVE_FDE.DATA_VIEWS_FANATICS.FANATICS_COLLECT_USERS_V AS collect
    INNER JOIN FDE.FANGRAPH.FANGRAPH_ID_FINAL AS fid
        ON fid.node = 'collect-' || collect.user_id
    GROUP BY fid.fangraph_id
)

-- ============================================================
-- FINAL SELECT
-- ============================================================
SELECT
    fg.fangraph_id,

    -- Commerce: prefer fan_key_master creation_time, fall back to tenant_map
    COALESCE(fkm.commerce_fkm_creation_ts, tmo.commerce_account_creation_timestamp)
        AS commerce_account_creation_timestamp,

    ev.events_account_creation_timestamp,

    -- FBG: prefer direct account table, fall back to tenant_map
    COALESCE(fbg.fbg_account_creation_ts, tmo.fbg_account_creation_timestamp)
        AS fbg_account_creation_timestamp,

    -- Live: prefer order-derived summary, fall back to tenant_map
    COALESCE(ls.account_creation_ts, tmo.live_account_creation_timestamp)
        AS live_account_creation_timestamp,

    tc.topps_com_created_timestamp,
    td.topps_digital_account_creation_timestamp,
    tmo.fanapp_account_creation_timestamp,
    cu.collect_account_creation_timestamp

FROM fangraph_ids AS fg
LEFT JOIN tenant_map_opco AS tmo ON fg.fangraph_id = tmo.fangraph_id
LEFT JOIN fan_key_master AS fkm  ON fg.fangraph_id = fkm.fangraph_id
LEFT JOIN fbg_accounts AS fbg    ON fg.fangraph_id = fbg.fangraph_id
LEFT JOIN live_summary AS ls     ON fg.fangraph_id = ls.fangraph_id
LEFT JOIN topps_customers AS tc  ON fg.fangraph_id = tc.fangraph_id
LEFT JOIN topps_digital AS td    ON fg.fangraph_id = td.fangraph_id
LEFT JOIN events_customers AS ev ON fg.fangraph_id = ev.fangraph_id
LEFT JOIN collect_users AS cu    ON fg.fangraph_id = cu.fangraph_id
