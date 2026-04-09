-- Query ID: 01c399c5-0112-6db7-0000-e307218966c2
-- Database: FES_USERS
-- Schema: MITCHELL_MANN
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:21:38.101000+00:00
-- Elapsed: 5765ms
-- Environment: FES

select * from (
        WITH push_base AS (
    SELECT * FROM FES_USERS.MITCHELL_MANN.dbfork_____FES_USERS__MITCHELL_MANN__fanapp_crm_sfmc_push_fct_dev
),

comm_id_map AS (
    SELECT
        user_account_id,
        private_fan_id
    FROM FDE.FDE_INFO.fanapp_user_account_id_map
),

orders AS (
    SELECT
        im.private_fan_id,
        coalesce(a.order_ref_num, a.sales_order_id)::string AS order_id,
        a.order_ts_utc,
        round(sum(a.net_demand), 2) AS order_net
    FROM COMMERCE.ORDERS.weekly_trading AS a
    INNER JOIN comm_id_map AS im ON a.account_id = im.user_account_id
    WHERE
        a.order_ts_utc IS NOT NULL
        AND a.selling_site_id IN (515620, 515621, 514647, 514648)
        AND im.private_fan_id IS NOT NULL
    GROUP BY im.private_fan_id, order_id, a.order_ts_utc
),

ftp_fan_id_map AS (
    SELECT DISTINCT
        tenant_fan_id,
        fanid_private_fan_id AS private_fan_id
    FROM fangraph_dev.admin.fan_id_tenant_map
),

ftp AS (
    SELECT
        m.private_fan_id,
        a.event_id,
        a.user_session_start_ts AS session_start_ts_utc,
        CASE WHEN lower(coalesce(a.game_result, '')) IN ('win', 'winner', 'won') THEN 1 ELSE 0 END AS is_win,
        coalesce(a.fancash_value, 0) AS fancash_won
    FROM MONTEROSA.MONTEROSA_CORE.fanapp_game_results AS a
    INNER JOIN ftp_fan_id_map AS m ON a.external_id = m.tenant_fan_id
    WHERE
        a.user_session_start_ts IS NOT NULL
        AND a.event_id IS NOT NULL
        AND m.private_fan_id IS NOT NULL
),

xsell AS (
    SELECT
        p.private_fan_id,
        p.fbg_acco_id AS fbg_id,
        a.install_date_utc AS sbk_install_date_utc,
        a.registration_date_utc,
        a.first_deposit_date_utc,
        a.first_deposit_amount,
        a.fbg_ftu_date_utc
    FROM fangraph.private_fan_id.pfi_customer_mart AS p
    INNER JOIN fbg_fde.fbg_users.v_fbg_customer_mart AS a
        ON p.fbg_tenant_fan_id = a.tenant_fan_id
    WHERE
        a.is_test_account = FALSE
        AND a.is_kiosk = FALSE
        AND p.private_fan_id IS NOT NULL
),

pl_ftus AS (
    SELECT
        private_fan_id,
        ftu_day,
        most_recent_action_ts
    FROM FANAPP.REPORTING.fbg_affiliate_ftus
    WHERE ftu_source = 'Push'
),

commerce_attrib_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        o.order_id,
        o.order_ts_utc,
        o.order_net,
        CASE WHEN o.order_ts_utc >= pb.send_ts_utc AND o.order_ts_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN o.order_ts_utc >= pb.send_ts_utc AND o.order_ts_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN o.order_ts_utc >= pb.send_ts_utc AND o.order_ts_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN o.order_ts_utc >= pb.send_ts_utc AND o.order_ts_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND o.order_ts_utc >= pb.open_ts_utc AND o.order_ts_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND o.order_ts_utc >= pb.open_ts_utc AND o.order_ts_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND o.order_ts_utc >= pb.open_ts_utc AND o.order_ts_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND o.order_ts_utc >= pb.open_ts_utc AND o.order_ts_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, o.order_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, o.order_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN orders AS o
        ON
            pb.private_fan_id = o.private_fan_id
            AND pb.send_ts_utc <= o.order_ts_utc
            AND o.order_ts_utc < dateadd('day', 7, pb.send_ts_utc)
),

commerce_attrib AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN order_net ELSE 0 END) AS nd_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN order_net ELSE 0 END) AS nd_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN order_net ELSE 0 END) AS nd_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN order_net ELSE 0 END) AS nd_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN order_net ELSE 0 END) AS nd_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN order_net ELSE 0 END) AS nd_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN order_net ELSE 0 END) AS nd_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN order_net ELSE 0 END) AS nd_24h_post_open,
        count(DISTINCT CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN order_id END) AS orders_1h_post_send,
        count(DISTINCT CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN order_id END) AS orders_4h_post_send,
        count(DISTINCT CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN order_id END) AS orders_12h_post_send,
        count(DISTINCT CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN order_id END) AS orders_24h_post_send,
        count(DISTINCT CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN order_id END) AS orders_1h_post_open,
        count(DISTINCT CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN order_id END) AS orders_4h_post_open,
        count(DISTINCT CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN order_id END) AS orders_12h_post_open,
        count(DISTINCT CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN order_id END) AS orders_24h_post_open
    FROM commerce_attrib_raw
    GROUP BY private_fan_id, instance_key_str, request_id
),

ftp_attrib_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        f.event_id,
        f.session_start_ts_utc,
        f.is_win,
        f.fancash_won,
        CASE WHEN f.session_start_ts_utc >= pb.send_ts_utc AND f.session_start_ts_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN f.session_start_ts_utc >= pb.send_ts_utc AND f.session_start_ts_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN f.session_start_ts_utc >= pb.send_ts_utc AND f.session_start_ts_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN f.session_start_ts_utc >= pb.send_ts_utc AND f.session_start_ts_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND f.session_start_ts_utc >= pb.open_ts_utc AND f.session_start_ts_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND f.session_start_ts_utc >= pb.open_ts_utc AND f.session_start_ts_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND f.session_start_ts_utc >= pb.open_ts_utc AND f.session_start_ts_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND f.session_start_ts_utc >= pb.open_ts_utc AND f.session_start_ts_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, f.event_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, f.event_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN ftp AS f
        ON
            pb.private_fan_id = f.private_fan_id
            AND pb.send_ts_utc <= f.session_start_ts_utc
            AND f.session_start_ts_utc < dateadd('day', 7, pb.send_ts_utc)
),

ftp_attrib AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN 1 ELSE 0 END) AS games_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN 1 ELSE 0 END) AS games_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN 1 ELSE 0 END) AS games_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN 1 ELSE 0 END) AS games_24h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN is_win ELSE 0 END) AS wins_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN is_win ELSE 0 END) AS wins_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN is_win ELSE 0 END) AS wins_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN is_win ELSE 0 END) AS wins_24h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN fancash_won ELSE 0 END) AS fancash_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS games_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS games_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS games_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS games_24h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN is_win ELSE 0 END) AS wins_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN is_win ELSE 0 END) AS wins_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN is_win ELSE 0 END) AS wins_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN is_win ELSE 0 END) AS wins_24h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN fancash_won ELSE 0 END) AS fancash_24h_post_open
    FROM ftp_attrib_raw
    GROUP BY private_fan_id, instance_key_str, request_id
),

xsell_install_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        x.fbg_id,
        CASE WHEN x.sbk_install_date_utc >= pb.send_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN x.sbk_install_date_utc >= pb.send_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN x.sbk_install_date_utc >= pb.send_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN x.sbk_install_date_utc >= pb.send_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND x.sbk_install_date_utc >= pb.open_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND x.sbk_install_date_utc >= pb.open_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND x.sbk_install_date_utc >= pb.open_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND x.sbk_install_date_utc >= pb.open_ts_utc AND x.sbk_install_date_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN xsell AS x
        ON
            pb.private_fan_id = x.private_fan_id
            AND pb.send_ts_utc <= x.sbk_install_date_utc
            AND x.sbk_install_date_utc < dateadd('day', 7, pb.send_ts_utc)
),

xsell_reg_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        x.fbg_id,
        CASE WHEN x.registration_date_utc >= pb.send_ts_utc AND x.registration_date_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN x.registration_date_utc >= pb.send_ts_utc AND x.registration_date_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN x.registration_date_utc >= pb.send_ts_utc AND x.registration_date_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN x.registration_date_utc >= pb.send_ts_utc AND x.registration_date_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND x.registration_date_utc >= pb.open_ts_utc AND x.registration_date_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND x.registration_date_utc >= pb.open_ts_utc AND x.registration_date_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND x.registration_date_utc >= pb.open_ts_utc AND x.registration_date_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND x.registration_date_utc >= pb.open_ts_utc AND x.registration_date_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN xsell AS x
        ON
            pb.private_fan_id = x.private_fan_id
            AND pb.send_ts_utc <= x.registration_date_utc
            AND x.registration_date_utc < dateadd('day', 7, pb.send_ts_utc)
),

xsell_dep_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        x.fbg_id,
        x.first_deposit_amount,
        CASE WHEN x.first_deposit_date_utc >= pb.send_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN x.first_deposit_date_utc >= pb.send_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN x.first_deposit_date_utc >= pb.send_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN x.first_deposit_date_utc >= pb.send_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND x.first_deposit_date_utc >= pb.open_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND x.first_deposit_date_utc >= pb.open_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND x.first_deposit_date_utc >= pb.open_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND x.first_deposit_date_utc >= pb.open_ts_utc AND x.first_deposit_date_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN xsell AS x
        ON
            pb.private_fan_id = x.private_fan_id
            AND pb.send_ts_utc <= x.first_deposit_date_utc
            AND x.first_deposit_date_utc < dateadd('day', 7, pb.send_ts_utc)
),

xsell_ftu_raw AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        x.fbg_id,
        CASE WHEN x.fbg_ftu_date_utc >= pb.send_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 1, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_1h_send,
        CASE WHEN x.fbg_ftu_date_utc >= pb.send_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 4, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_4h_send,
        CASE WHEN x.fbg_ftu_date_utc >= pb.send_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 12, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_12h_send,
        CASE WHEN x.fbg_ftu_date_utc >= pb.send_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 24, pb.send_ts_utc) THEN 1 ELSE 0 END AS in_24h_send,
        CASE WHEN pb.message_opened AND x.fbg_ftu_date_utc >= pb.open_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pb.message_opened AND x.fbg_ftu_date_utc >= pb.open_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pb.message_opened AND x.fbg_ftu_date_utc >= pb.open_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pb.message_opened AND x.fbg_ftu_date_utc >= pb.open_ts_utc AND x.fbg_ftu_date_utc < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id ORDER BY pb.send_ts_utc DESC, pb.instance_key_str DESC) AS rn_last_send,
        CASE WHEN pb.message_opened THEN row_number() OVER (PARTITION BY pb.private_fan_id, x.fbg_id, pb.message_opened ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC) END AS rn_last_open
    FROM push_base AS pb
    INNER JOIN xsell AS x
        ON
            pb.private_fan_id = x.private_fan_id
            AND pb.send_ts_utc <= x.fbg_ftu_date_utc
            AND x.fbg_ftu_date_utc < dateadd('day', 7, pb.send_ts_utc)
),

pl_ftu_attrib AS (
    SELECT
        pb.private_fan_id,
        pb.instance_key_str,
        pb.request_id,
        pf.ftu_day,
        CASE WHEN pf.most_recent_action_ts >= pb.open_ts_utc AND pf.most_recent_action_ts < dateadd('hour', 1, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_1h_open,
        CASE WHEN pf.most_recent_action_ts >= pb.open_ts_utc AND pf.most_recent_action_ts < dateadd('hour', 4, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_4h_open,
        CASE WHEN pf.most_recent_action_ts >= pb.open_ts_utc AND pf.most_recent_action_ts < dateadd('hour', 12, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_12h_open,
        CASE WHEN pf.most_recent_action_ts >= pb.open_ts_utc AND pf.most_recent_action_ts < dateadd('hour', 24, pb.open_ts_utc) THEN 1 ELSE 0 END AS in_24h_open,
        row_number() OVER (
            PARTITION BY pb.private_fan_id, pf.ftu_day
            ORDER BY pb.open_ts_utc DESC, pb.instance_key_str DESC
        ) AS rn_last_open
    FROM push_base AS pb
    INNER JOIN pl_ftus AS pf
        ON
            pb.private_fan_id = pf.private_fan_id
            AND pb.message_opened
            AND pb.open_ts_utc <= pf.most_recent_action_ts
            AND pb.open_ts_utc > dateadd('day', -7, pf.most_recent_action_ts)
),

pl_ftu_agg AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS pl_ftus_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS pl_ftus_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS pl_ftus_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS pl_ftus_24h_post_open
    FROM pl_ftu_attrib
    GROUP BY private_fan_id, instance_key_str, request_id
),

xsell_install_agg AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN 1 ELSE 0 END) AS installs_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN 1 ELSE 0 END) AS installs_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN 1 ELSE 0 END) AS installs_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN 1 ELSE 0 END) AS installs_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS installs_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS installs_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS installs_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS installs_24h_post_open
    FROM xsell_install_raw
    GROUP BY private_fan_id, instance_key_str, request_id
),

xsell_reg_agg AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN 1 ELSE 0 END) AS registrations_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN 1 ELSE 0 END) AS registrations_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN 1 ELSE 0 END) AS registrations_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN 1 ELSE 0 END) AS registrations_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS registrations_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS registrations_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS registrations_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS registrations_24h_post_open
    FROM xsell_reg_raw
    GROUP BY private_fan_id, instance_key_str, request_id
),

xsell_dep_agg AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN 1 ELSE 0 END) AS deposits_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN 1 ELSE 0 END) AS deposits_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN 1 ELSE 0 END) AS deposits_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN 1 ELSE 0 END) AS deposits_24h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS deposits_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS deposits_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS deposits_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS deposits_24h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN first_deposit_amount ELSE 0 END) AS deposit_amount_24h_post_open
    FROM xsell_dep_raw
    GROUP BY private_fan_id, instance_key_str, request_id
),

xsell_ftu_agg AS (
    SELECT
        private_fan_id,
        instance_key_str,
        request_id,
        sum(CASE WHEN rn_last_send = 1 AND in_1h_send = 1 THEN 1 ELSE 0 END) AS ftus_1h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_4h_send = 1 THEN 1 ELSE 0 END) AS ftus_4h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_12h_send = 1 THEN 1 ELSE 0 END) AS ftus_12h_post_send,
        sum(CASE WHEN rn_last_send = 1 AND in_24h_send = 1 THEN 1 ELSE 0 END) AS ftus_24h_post_send,
        sum(CASE WHEN rn_last_open = 1 AND in_1h_open = 1 THEN 1 ELSE 0 END) AS ftus_1h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_4h_open = 1 THEN 1 ELSE 0 END) AS ftus_4h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_12h_open = 1 THEN 1 ELSE 0 END) AS ftus_12h_post_open,
        sum(CASE WHEN rn_last_open = 1 AND in_24h_open = 1 THEN 1 ELSE 0 END) AS ftus_24h_post_open
    FROM xsell_ftu_raw
    GROUP BY private_fan_id, instance_key_str, request_id
)

SELECT
    pb.private_fan_id,
    pb.send_date_utc,
    pb.message_name,
    pb.campaign,
    pb.message_send_type,
    pb.is_triggered_flag,
    pb.instance_key_str,
    pb.request_id,
    pb.message_opened,
    pb.delivered_flag,
    coalesce(c.nd_1h_post_send, 0) AS nd_1h_post_send,
    coalesce(c.nd_4h_post_send, 0) AS nd_4h_post_send,
    coalesce(c.nd_12h_post_send, 0) AS nd_12h_post_send,
    coalesce(c.nd_24h_post_send, 0) AS nd_24h_post_send,
    coalesce(c.nd_1h_post_open, 0) AS nd_1h_post_open,
    coalesce(c.nd_4h_post_open, 0) AS nd_4h_post_open,
    coalesce(c.nd_12h_post_open, 0) AS nd_12h_post_open,
    coalesce(c.nd_24h_post_open, 0) AS nd_24h_post_open,
    coalesce(c.orders_1h_post_send, 0) AS orders_1h_post_send,
    coalesce(c.orders_4h_post_send, 0) AS orders_4h_post_send,
    coalesce(c.orders_12h_post_send, 0) AS orders_12h_post_send,
    coalesce(c.orders_24h_post_send, 0) AS orders_24h_post_send,
    coalesce(c.orders_1h_post_open, 0) AS orders_1h_post_open,
    coalesce(c.orders_4h_post_open, 0) AS orders_4h_post_open,
    coalesce(c.orders_12h_post_open, 0) AS orders_12h_post_open,
    coalesce(c.orders_24h_post_open, 0) AS orders_24h_post_open,
    coalesce(f.games_1h_post_send, 0) AS games_1h_post_send,
    coalesce(f.games_4h_post_send, 0) AS games_4h_post_send,
    coalesce(f.games_12h_post_send, 0) AS games_12h_post_send,
    coalesce(f.games_24h_post_send, 0) AS games_24h_post_send,
    coalesce(f.wins_1h_post_send, 0) AS wins_1h_post_send,
    coalesce(f.wins_4h_post_send, 0) AS wins_4h_post_send,
    coalesce(f.wins_12h_post_send, 0) AS wins_12h_post_send,
    coalesce(f.wins_24h_post_send, 0) AS wins_24h_post_send,
    coalesce(f.fancash_24h_post_send, 0) AS fancash_24h_post_send,
    coalesce(f.games_1h_post_open, 0) AS games_1h_post_open,
    coalesce(f.games_4h_post_open, 0) AS games_4h_post_open,
    coalesce(f.games_12h_post_open, 0) AS games_12h_post_open,
    coalesce(f.games_24h_post_open, 0) AS games_24h_post_open,
    coalesce(f.wins_1h_post_open, 0) AS wins_1h_post_open,
    coalesce(f.wins_4h_post_open, 0) AS wins_4h_post_open,
    coalesce(f.wins_12h_post_open, 0) AS wins_12h_post_open,
    coalesce(f.wins_24h_post_open, 0) AS wins_24h_post_open,
    coalesce(f.fancash_24h_post_open, 0) AS fancash_24h_post_open,
    -- Installs post-send
    coalesce(xi.installs_1h_post_send, 0) AS installs_1h_post_send,
    coalesce(xi.installs_4h_post_send, 0) AS installs_4h_post_send,
    coalesce(xi.installs_12h_post_send, 0) AS installs_12h_post_send,
    coalesce(xi.installs_24h_post_send, 0) AS installs_24h_post_send,
    -- Registrations post-send
    coalesce(xr.registrations_1h_post_send, 0) AS registrations_1h_post_send,
    coalesce(xr.registrations_4h_post_send, 0) AS registrations_4h_post_send,
    coalesce(xr.registrations_12h_post_send, 0) AS registrations_12h_post_send,
    coalesce(xr.registrations_24h_post_send, 0) AS registrations_24h_post_send,
    -- Deposits post-send
    coalesce(xd.deposits_1h_post_send, 0) AS deposits_1h_post_send,
    coalesce(xd.deposits_4h_post_send, 0) AS deposits_4h_post_send,
    coalesce(xd.deposits_12h_post_send, 0) AS deposits_12h_post_send,
    coalesce(xd.deposits_24h_post_send, 0) AS deposits_24h_post_send,
    coalesce(xd.deposit_amount_1h_post_send, 0) AS deposit_amount_1h_post_send,
    coalesce(xd.deposit_amount_4h_post_send, 0) AS deposit_amount_4h_post_send,
    coalesce(xd.deposit_amount_12h_post_send, 0) AS deposit_amount_12h_post_send,
    coalesce(xd.deposit_amount_24h_post_send, 0) AS deposit_amount_24h_post_send,
    -- FTUs post-send
    coalesce(xf.ftus_1h_post_send, 0) AS ftus_1h_post_send,
    coalesce(xf.ftus_4h_post_send, 0) AS ftus_4h_post_send,
    coalesce(xf.ftus_12h_post_send, 0) AS ftus_12h_post_send,
    coalesce(xf.ftus_24h_post_send, 0) AS ftus_24h_post_send,
    -- Installs post-open
    coalesce(xi.installs_1h_post_open, 0) AS installs_1h_post_open,
    coalesce(xi.installs_4h_post_open, 0) AS installs_4h_post_open,
    coalesce(xi.installs_12h_post_open, 0) AS installs_12h_post_open,
    coalesce(xi.installs_24h_post_open, 0) AS installs_24h_post_open,
    -- Registrations post-open
    coalesce(xr.registrations_1h_post_open, 0) AS registrations_1h_post_open,
    coalesce(xr.registrations_4h_post_open, 0) AS registrations_4h_post_open,
    coalesce(xr.registrations_12h_post_open, 0) AS registrations_12h_post_open,
    coalesce(xr.registrations_24h_post_open, 0) AS registrations_24h_post_open,
    -- Deposits post-open
    coalesce(xd.deposits_1h_post_open, 0) AS deposits_1h_post_open,
    coalesce(xd.deposits_4h_post_open, 0) AS deposits_4h_post_open,
    coalesce(xd.deposits_12h_post_open, 0) AS deposits_12h_post_open,
    coalesce(xd.deposits_24h_post_open, 0) AS deposits_24h_post_open,
    coalesce(xd.deposit_amount_1h_post_open, 0) AS deposit_amount_1h_post_open,
    coalesce(xd.deposit_amount_4h_post_open, 0) AS deposit_amount_4h_post_open,
    coalesce(xd.deposit_amount_12h_post_open, 0) AS deposit_amount_12h_post_open,
    coalesce(xd.deposit_amount_24h_post_open, 0) AS deposit_amount_24h_post_open,
    -- FTUs post-open
    coalesce(xf.ftus_1h_post_open, 0) AS ftus_1h_post_open,
    coalesce(xf.ftus_4h_post_open, 0) AS ftus_4h_post_open,
    coalesce(xf.ftus_12h_post_open, 0) AS ftus_12h_post_open,
    coalesce(xf.ftus_24h_post_open, 0) AS ftus_24h_post_open,
    -- P&L FTUs (official affiliate attribution where push gets credit)
    coalesce(pl.pl_ftus_1h_post_open, 0) AS pl_ftus_1h_post_open,
    coalesce(pl.pl_ftus_4h_post_open, 0) AS pl_ftus_4h_post_open,
    coalesce(pl.pl_ftus_12h_post_open, 0) AS pl_ftus_12h_post_open,
    coalesce(pl.pl_ftus_24h_post_open, 0) AS pl_ftus_24h_post_open
FROM push_base AS pb
LEFT JOIN commerce_attrib AS c
    ON
        pb.private_fan_id = c.private_fan_id
        AND pb.request_id = c.request_id
        AND pb.instance_key_str = c.instance_key_str
LEFT JOIN ftp_attrib AS f
    ON
        pb.private_fan_id = f.private_fan_id
        AND pb.request_id = f.request_id
        AND pb.instance_key_str = f.instance_key_str
LEFT JOIN xsell_install_agg AS xi
    ON
        pb.private_fan_id = xi.private_fan_id
        AND pb.request_id = xi.request_id
        AND pb.instance_key_str = xi.instance_key_str
LEFT JOIN xsell_reg_agg AS xr
    ON
        pb.private_fan_id = xr.private_fan_id
        AND pb.request_id = xr.request_id
        AND pb.instance_key_str = xr.instance_key_str
LEFT JOIN xsell_dep_agg AS xd
    ON
        pb.private_fan_id = xd.private_fan_id
        AND pb.request_id = xd.request_id
        AND pb.instance_key_str = xd.instance_key_str
LEFT JOIN xsell_ftu_agg AS xf
    ON
        pb.private_fan_id = xf.private_fan_id
        AND pb.request_id = xf.request_id
        AND pb.instance_key_str = xf.instance_key_str
LEFT JOIN pl_ftu_agg AS pl
    ON
        pb.private_fan_id = pl.private_fan_id
        AND pb.request_id = pl.request_id
        AND pb.instance_key_str = pl.instance_key_str 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "test", "target_database": "FES_USERS", "target_schema": "MITCHELL_MANN", "invocation_id": "5772944f-6f8b-4da0-a0e9-77adbef467c2", "run_started_at": "2026-04-09T20:21:30.155976+00:00", "full_refresh": false, "which": "run", "node_name": "fanapp_crm_sfmc_push_reporting", "node_alias": "dbfork_____FES_USERS__MITCHELL_MANN__fanapp_crm_sfmc_push_reporting_dev", "node_package_name": "fes_data", "node_original_file_path": "models/fes_users/mitchell_mann/fanapp_crm_sfmc_push_reporting.sql", "node_database": "FES_USERS", "node_schema": "MITCHELL_MANN", "node_id": "model.fes_data.fanapp_crm_sfmc_push_reporting", "node_resource_type": "model", "node_meta": {}, "node_tags": ["users"], "invocation_command": "dbt ", "node_refs": ["fanapp_crm_sfmc_push_fct", "fanapp_user_account_id_map", "weekly_trading", "fanapp_game_results", "pfi_customer_mart", "fbg_affiliate_ftus"], "materialized": "table", "raw_code_hash": "858196e5803a436839d5fc36cf6c916b"} */
