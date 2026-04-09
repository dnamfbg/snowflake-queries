-- Query ID: 01c399fa-0112-6029-0000-e307218aed7a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:14:33.242000+00:00
-- Elapsed: 2862ms
-- Environment: FES

select * from (
        WITH account_base AS (
    SELECT
        private_fan_id,
        fbg_acco_id,
        tlc_tenant_fan_id,
        unscrubbed_email,
        fanapp_tenant_fan_id
    FROM fangraph_dev.private_fan_id.pfi_customer_mart
),

fbg_daily AS (
    SELECT
        b.private_fan_id,
        a.date AS date_alk, -- Already ALK
        SUM(COALESCE(a.osb_finance_ngr, 0)) AS osb_net_revenue,
        SUM(COALESCE(a.oc_finance_ngr, 0)) AS oc_net_revenue,
        SUM(COALESCE(a.osb_finance_ngr, 0)) + SUM(COALESCE(a.oc_finance_ngr, 0)) AS fbg_net_revenue,
        SUM(COALESCE(a.osb_finance_engr, 0)) AS osb_net_expected_revenue,
        SUM(COALESCE(a.osb_finance_engr, 0)) + SUM(COALESCE(a.oc_finance_ngr, 0)) AS fbg_net_expected_revenue,
        SUM(COALESCE(a.customer_variable_profit, 0)) AS fbg_customer_variable_profit,
        SUM(COALESCE(a.ecustomer_variable_profit, 0)) AS fbg_expected_customer_variable_profit,
        SUM(COALESCE(a.osb_total_bets, 0)) AS osb_total_bets,
        SUM(COALESCE(a.osb_cash_bets, 0)) AS osb_cash_bets,
        SUM(COALESCE(a.oc_total_bets, 0)) AS oc_total_bets,
        SUM(COALESCE(a.oc_cash_bets, 0)) AS oc_cash_bets,
        SUM(COALESCE(a.osb_total_bets, 0)) + SUM(COALESCE(a.oc_total_bets, 0)) AS total_bets,
        SUM(COALESCE(a.osb_cash_bets, 0)) + SUM(COALESCE(a.oc_cash_bets, 0)) AS total_cash_bets
    FROM fbg_fde.fbg_transactions.fde_customer_variable_profit AS a
    INNER JOIN account_base AS b
        ON a.acco_id = b.fbg_acco_id
    GROUP BY ALL
),

live_daily AS (
    SELECT
        b.private_fan_id,
        CONVERT_TIMEZONE('America/Anchorage', o.order_date)::date AS date_alk, -- ALK (offset embedded in source)
        SUM(o.gmv_usd) AS live_gmv,
        SUM(o.fanatics_live_platform_fee_usd) AS live_net_revenue, -- Live's net revenue
        SUM(
            CASE
                WHEN o.order_type = 'Instant Credit' THEN o.fanatics_live_platform_fee_usd -- Instant Credit fee for Instant Rips pass through to GP (6% fee)
                WHEN o.order_type = 'Instant Rips' THEN o.gmv_usd * 0.125 -- Instant Rips = ~12.5% GP of GMV
                ELSE o.gmv_usd * 0.0425 -- Traditional Breakers = ~4–4.5% GP of GMV
            END
        ) AS live_gross_profit,
        COUNT(DISTINCT o.order_id) AS live_orders
    FROM live_fde.data_views_fanatics.fct_live_orders_v2_v AS o
    INNER JOIN account_base AS b
        ON o.fan_id = b.tlc_tenant_fan_id
    WHERE
        o.is_giveaway = FALSE
        AND o.is_refunded = FALSE
        AND o.fan_id IS NOT NULL
    GROUP BY ALL
),

collect_daily AS (
    SELECT
        b.private_fan_id,
        CONVERT_TIMEZONE('America/Anchorage', c.sale_created_at)::date AS date_alk, -- ALK (offset embedded in source)
        SUM(c.gmv) AS collect_gmv,
        SUM(c.revenue) AS collect_net_revenue,
        SUM(
            CASE
                WHEN c.marketplace = 'Weekly Auction' THEN c.gmv * 0.065 -- Weekly Auctions are ~6.5% GP of GMV
                WHEN c.marketplace = 'Fixed Price' THEN c.gmv * 0.0575 -- Fixed Price Marketplace are ~5.5-6% GP of GMV
                ELSE c.gmv * 0.035 -- Premier Auctions and Private Sales are ~3.5% GP of GMV
            END
        ) AS collect_gross_profit,
        COUNT(DISTINCT c.order_id) AS collect_orders
    FROM live_fde.data_views_fanatics.fanatics_collect_orders_v AS c
    INNER JOIN account_base AS b
        ON c.tenant_fan_id = b.tlc_tenant_fan_id
    WHERE c.tenant_fan_id IS NOT NULL
    GROUP BY ALL
),

topps_daily AS (
    SELECT
        b.private_fan_id,
        CONVERT_TIMEZONE('America/Anchorage', t.order_dt)::date AS date_alk, -- ALK (offset embedded in source)
        SUM(t.p_gmv_usd) AS topps_gmv,
        SUM(t.p_revenue_usd) AS topps_net_revenue,
        SUM(t.p_gmv_usd) * 0.6 AS topps_gross_profit,  -- ~60% GP of GMV
        COUNT(DISTINCT t.order_id) AS topps_orders
    FROM live_fde.data_views_fanatics.topps_global_reporting AS t
    INNER JOIN account_base AS b
        ON t.customer_fan_id = b.tlc_tenant_fan_id
    WHERE
        (t.order_status <> 'CANCELED' OR t.order_status IS NULL)
        AND (t.fulfillment_status <> 'TOTALLY REFUNDED' OR t.fulfillment_status IS NULL)
        AND t.customer_fan_id IS NOT NULL
        AND t.trx_price_usd > 0
    GROUP BY ALL
),

ticket_daily AS (
    SELECT
        b.private_fan_id,
        CONVERT_TIMEZONE('America/Los_Angeles', 'America/Anchorage', td.transactiondttm_pt::timestamp)::date AS date_alk, -- ALK
        SUM(td.tickets * td.listingpriceperticket) AS tickets_face_value,
        (tickets_face_value * 0.145) + SUM(td.discountamt) AS tickets_gross_profit, -- Backs out discounts, we get 14.5% from TM of face value
        SUM(td.tickets) AS tickets_purchased
    FROM FES_INTEGRATIONS_DEV.TICKETMASTER.ticketmaster AS td
    INNER JOIN account_base AS b
        ON LOWER(td.emailaddress) = LOWER(b.unscrubbed_email)
    GROUP BY ALL
),

commerce_daily AS (
    SELECT
        a.private_fan_id,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.order_ts_utc::timestamp)::date AS date_alk, -- ALK
        COALESCE(SUM(b.gross_demand), 0) AS commerce_gross_demand, -- Need to double check currency
        COALESCE(SUM(b.net_demand), 0) AS commerce_net_demand,
        COALESCE(SUM(b.contribution_margin), 0) AS commerce_contribution_margin,
        COALESCE(SUM(b.shipping_revenue), 0) AS commerce_shipping_revenue,
        COALESCE(SUM(b.net_demand), 0) + COALESCE(SUM(b.shipping_revenue), 0) AS commerce_net_revenue,
        COUNT(DISTINCT b.order_ref_num) AS commerce_orders
    FROM FDE_DEV.FDE_INFO.fanapp_user_account_id_map AS a
    INNER JOIN COMMERCE_DEV.ORDERS.weekly_trading AS b
        ON a.user_account_id = b.account_id
    WHERE a.private_fan_id IS NOT NULL
    GROUP BY ALL
),

fc_daily AS (
    SELECT
        private_fan_id,
        date_alk, -- Already in ALK

        -- FBG
        SUM(CASE WHEN grouped_nm = 'FBG' THEN loyalty_amount ELSE 0 END) AS loyalty_fbg_amount,
        SUM(CASE WHEN grouped_nm = 'FBG' THEN loyalty_txns ELSE 0 END) AS loyalty_fbg_txns,

        -- Commerce - App
        SUM(CASE WHEN grouped_nm = 'Commerce - App' THEN loyalty_amount ELSE 0 END) AS loyalty_commerce_app_amount,
        SUM(CASE WHEN grouped_nm = 'Commerce - App' THEN loyalty_txns ELSE 0 END) AS loyalty_commerce_app_txns,

        -- Fancash Shop
        SUM(CASE WHEN grouped_nm = 'Fancash Shop' THEN loyalty_amount ELSE 0 END) AS loyalty_fancash_shop_amount,
        SUM(CASE WHEN grouped_nm = 'Fancash Shop' THEN loyalty_txns ELSE 0 END) AS loyalty_fancash_shop_txns,

        -- Topps.com
        SUM(CASE WHEN grouped_nm = 'Topps.com' THEN loyalty_amount ELSE 0 END) AS loyalty_topps_amount,
        SUM(CASE WHEN grouped_nm = 'Topps.com' THEN loyalty_txns ELSE 0 END) AS loyalty_topps_txns,

        -- Commerce - Web
        SUM(CASE WHEN grouped_nm = 'Commerce - Web' THEN loyalty_amount ELSE 0 END) AS loyalty_commerce_web_amount,
        SUM(CASE WHEN grouped_nm = 'Commerce - Web' THEN loyalty_txns ELSE 0 END) AS loyalty_commerce_web_txns,

        -- Collect
        SUM(CASE WHEN grouped_nm = 'Collect' THEN loyalty_amount ELSE 0 END) AS loyalty_collect_amount,
        SUM(CASE WHEN grouped_nm = 'Collect' THEN loyalty_txns ELSE 0 END) AS loyalty_collect_txns,

        -- Fanatics Events
        SUM(CASE WHEN grouped_nm = 'Fanatics Events' THEN loyalty_amount ELSE 0 END) AS loyalty_events_amount,
        SUM(CASE WHEN grouped_nm = 'Fanatics Events' THEN loyalty_txns ELSE 0 END) AS loyalty_events_txns,

        -- Ticketmaster
        SUM(CASE WHEN grouped_nm = 'Ticketmaster' THEN loyalty_amount ELSE 0 END) AS loyalty_ticketmaster_amount,
        SUM(CASE WHEN grouped_nm = 'Ticketmaster' THEN loyalty_txns ELSE 0 END) AS loyalty_ticketmaster_txns,

        -- Live
        SUM(CASE WHEN grouped_nm = 'Live' THEN loyalty_amount ELSE 0 END) AS loyalty_live_amount,
        SUM(CASE WHEN grouped_nm = 'Live' THEN loyalty_txns ELSE 0 END) AS loyalty_live_txns,

        -- Lava.ai
        SUM(CASE WHEN grouped_nm = 'Lava.ai' THEN loyalty_amount ELSE 0 END) AS loyalty_lava_amount,
        SUM(CASE WHEN grouped_nm = 'Lava.ai' THEN loyalty_txns ELSE 0 END) AS loyalty_lava_txns,

        -- Lids
        SUM(CASE WHEN grouped_nm = 'Lids' THEN loyalty_amount ELSE 0 END) AS loyalty_lids_amount,
        SUM(CASE WHEN grouped_nm = 'Lids' THEN loyalty_txns ELSE 0 END) AS loyalty_lids_txns,

        -- TOTALS
        SUM(loyalty_amount) AS loyalty_total_amount,
        SUM(loyalty_txns) AS loyalty_total_txns

    FROM fangraph_dev.private_fan_id.pfi_daily_fancash
    GROUP BY ALL
),

ftp_daily AS (
    SELECT
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', a.user_session_start_ts::timestamp)::date AS date_alk, -- ALK
        b.private_fan_id,
        SUM(a.fancash_value) AS ftp_fc_earned,
        COUNT(*) AS ftp_games_played
    FROM MONTEROSA_DEV.MONTEROSA_CORE.fanapp_game_results AS a
    INNER JOIN account_base AS b ON a.external_id = b.fanapp_tenant_fan_id
    GROUP BY ALL
),

fan_date_spine AS (
    SELECT
        private_fan_id,
        date_alk
    FROM fbg_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM live_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM collect_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM topps_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM ticket_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM commerce_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM fc_daily
    UNION DISTINCT
    SELECT
        private_fan_id,
        date_alk
    FROM ftp_daily
)

SELECT
    s.private_fan_id,
    s.date_alk,

    COALESCE(f.fbg_net_revenue, 0) -- FBG Net Gaming Revenue
    + COALESCE(l.live_net_revenue, 0) -- Live Platform Fee
    + COALESCE(c.collect_net_revenue, 0) -- Collect Platform Fee
    + COALESCE(t.topps_net_revenue, 0) -- Topps Revenue
    + COALESCE(td.tickets_gross_profit, 0) -- Tickets Fanatics Share
    + COALESCE(cd.commerce_net_revenue, 0) -- Commerce Net Revenue (ND + Shipping Revenue)
        AS ecosystem_revenue,

    COALESCE(f.fbg_customer_variable_profit, 0) -- FBG CVP
    + COALESCE(l.live_gross_profit, 0) -- Live Gross Profit
    + COALESCE(c.collect_gross_profit, 0) -- Collect Gross Profit
    + COALESCE(t.topps_gross_profit, 0) -- Topps Gross Profit
    + COALESCE(td.tickets_gross_profit, 0) -- Tickets Fanatics Share
    + COALESCE(cd.commerce_contribution_margin, 0) -- Commerce CM (Includes shipping profit)
        AS ecosystem_profit,

    COALESCE(f.fbg_net_expected_revenue, 0) -- FBG expected Net Gaming Revenue
    + COALESCE(l.live_net_revenue, 0) -- Live Platform Fee
    + COALESCE(c.collect_net_revenue, 0) -- Collect Platform Fee
    + COALESCE(t.topps_net_revenue, 0) -- Topps Revenue
    + COALESCE(td.tickets_gross_profit, 0) -- Tickets Fanatics Share
    + COALESCE(cd.commerce_net_demand, 0) -- Commerce Net Demand
        AS expected_ecosystem_revenue,

    COALESCE(f.fbg_expected_customer_variable_profit, 0) -- FBG eCVP
    + COALESCE(l.live_gross_profit, 0) -- Live Gross Profit
    + COALESCE(c.collect_gross_profit, 0) -- Collect Gross Profit
    + COALESCE(t.topps_gross_profit, 0) -- Topps Gross Profit
    + COALESCE(td.tickets_gross_profit, 0) -- Tickets Fanatics Share
    + COALESCE(cd.commerce_contribution_margin, 0) -- Commerce CM
        AS expected_ecosystem_profit,

    COALESCE(f.fbg_net_revenue, 0) AS fbg_net_revenue,
    COALESCE(f.oc_net_revenue, 0) AS oc_net_revenue,
    COALESCE(f.osb_net_revenue, 0) AS osb_net_revenue,
    COALESCE(f.osb_net_expected_revenue, 0) AS osb_net_expected_net_revenue,
    COALESCE(f.fbg_customer_variable_profit, 0) AS fbg_customer_variable_profit,
    COALESCE(f.fbg_expected_customer_variable_profit, 0) AS fbg_expected_customer_variable_profit,
    COALESCE(f.osb_total_bets, 0) AS osb_total_bets,
    COALESCE(f.osb_cash_bets, 0) AS osb_cash_bets,
    COALESCE(f.oc_total_bets, 0) AS oc_total_bets,
    COALESCE(f.oc_cash_bets, 0) AS oc_cash_bets,
    COALESCE(f.osb_total_bets, 0) + COALESCE(f.oc_total_bets, 0) AS total_bets,
    COALESCE(f.osb_cash_bets, 0) + COALESCE(f.oc_cash_bets, 0) AS total_cash_bets,

    COALESCE(l.live_gmv, 0) AS live_gmv,
    COALESCE(l.live_net_revenue, 0) AS live_net_revenue,
    COALESCE(l.live_gross_profit, 0) AS live_gross_profit,
    COALESCE(l.live_orders, 0) AS live_orders,

    COALESCE(c.collect_gmv, 0) AS collect_gmv,
    COALESCE(c.collect_net_revenue, 0) AS collect_net_revenue,
    COALESCE(c.collect_gross_profit, 0) AS collect_gross_profit,
    COALESCE(c.collect_orders, 0) AS collect_orders,

    COALESCE(t.topps_gmv, 0) AS topps_gmv,
    COALESCE(t.topps_net_revenue, 0) AS topps_net_revenue,
    COALESCE(t.topps_gross_profit, 0) AS topps_gross_profit,
    COALESCE(t.topps_orders, 0) AS topps_orders,

    COALESCE(t.topps_gmv, 0) + COALESCE(l.live_gmv, 0) + COALESCE(c.collect_gmv, 0) AS total_tlc_gmv,
    COALESCE(t.topps_net_revenue, 0) + COALESCE(l.live_net_revenue, 0) + COALESCE(c.collect_net_revenue, 0) AS total_tlc_revenue,
    COALESCE(t.topps_gross_profit, 0) + COALESCE(l.live_gross_profit, 0) + COALESCE(c.collect_gross_profit, 0) AS total_tlc_gross_profit,
    COALESCE(t.topps_orders, 0) + COALESCE(l.live_orders, 0) + COALESCE(c.collect_orders, 0) AS total_tlc_orders,

    COALESCE(cd.commerce_net_revenue, 0) AS commerce_net_revenue,
    COALESCE(cd.commerce_net_demand, 0) AS commerce_net_demand,
    COALESCE(cd.commerce_shipping_revenue, 0) AS commerce_shipping_revenue,
    COALESCE(cd.commerce_contribution_margin, 0) AS commerce_contribution_margin,
    COALESCE(cd.commerce_orders, 0) AS commerce_orders,

    COALESCE(td.tickets_face_value, 0) AS tickets_face_value,
    COALESCE(td.tickets_gross_profit, 0) AS tickets_gross_profit,
    COALESCE(td.tickets_purchased, 0) AS tickets_purchased,

    COALESCE(fcd.loyalty_fbg_amount, 0) AS loyalty_fbg_amount,
    COALESCE(fcd.loyalty_fbg_txns, 0) AS loyalty_fbg_txns,

    COALESCE(fcd.loyalty_commerce_app_amount, 0) AS loyalty_commerce_app_amount,
    COALESCE(fcd.loyalty_commerce_app_txns, 0) AS loyalty_commerce_app_txns,

    COALESCE(fcd.loyalty_fancash_shop_amount, 0) AS loyalty_fancash_shop_amount,
    COALESCE(fcd.loyalty_fancash_shop_txns, 0) AS loyalty_fancash_shop_txns,

    COALESCE(fcd.loyalty_topps_amount, 0) AS loyalty_topps_amount,
    COALESCE(fcd.loyalty_topps_txns, 0) AS loyalty_topps_txns,

    COALESCE(fcd.loyalty_commerce_web_amount, 0) AS loyalty_commerce_web_amount,
    COALESCE(fcd.loyalty_commerce_web_txns, 0) AS loyalty_commerce_web_txns,

    COALESCE(fcd.loyalty_collect_amount, 0) AS loyalty_collect_amount,
    COALESCE(fcd.loyalty_collect_txns, 0) AS loyalty_collect_txns,

    COALESCE(fcd.loyalty_events_amount, 0) AS loyalty_events_amount,
    COALESCE(fcd.loyalty_events_txns, 0) AS loyalty_events_txns,

    COALESCE(fcd.loyalty_ticketmaster_amount, 0) AS loyalty_ticketmaster_amount,
    COALESCE(fcd.loyalty_ticketmaster_txns, 0) AS loyalty_ticketmaster_txns,

    COALESCE(fcd.loyalty_live_amount, 0) AS loyalty_live_amount,
    COALESCE(fcd.loyalty_live_txns, 0) AS loyalty_live_txns,

    COALESCE(fcd.loyalty_lava_amount, 0) AS loyalty_lava_amount,
    COALESCE(fcd.loyalty_lava_txns, 0) AS loyalty_lava_txns,

    COALESCE(fcd.loyalty_lids_amount, 0) AS loyalty_lids_amount,
    COALESCE(fcd.loyalty_lids_txns, 0) AS loyalty_lids_txns,

    COALESCE(fcd.loyalty_total_amount, 0) AS loyalty_total_amount,
    COALESCE(fcd.loyalty_total_txns, 0) AS loyalty_total_txns,

    COALESCE(ftp.ftp_fc_earned, 0) AS ftp_fc_earned,
    COALESCE(ftp.ftp_games_played, 0) AS ftp_games_played

FROM fan_date_spine AS s
LEFT JOIN fbg_daily AS f
    ON s.private_fan_id = f.private_fan_id AND s.date_alk = f.date_alk
LEFT JOIN live_daily AS l
    ON s.private_fan_id = l.private_fan_id AND s.date_alk = l.date_alk
LEFT JOIN collect_daily AS c
    ON s.private_fan_id = c.private_fan_id AND s.date_alk = c.date_alk
LEFT JOIN topps_daily AS t
    ON s.private_fan_id = t.private_fan_id AND s.date_alk = t.date_alk
LEFT JOIN ticket_daily AS td
    ON s.private_fan_id = td.private_fan_id AND s.date_alk = td.date_alk
LEFT JOIN commerce_daily AS cd
    ON s.private_fan_id = cd.private_fan_id AND s.date_alk = cd.date_alk
LEFT JOIN fc_daily AS fcd
    ON s.private_fan_id = fcd.private_fan_id AND s.date_alk = fcd.date_alk
LEFT JOIN ftp_daily AS ftp
    ON s.private_fan_id = ftp.private_fan_id AND s.date_alk = ftp.date_alk 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_ecosystem_daily_activity", "node_alias": "pfi_ecosystem_daily_activity", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/pfi_ecosystem_daily_activity.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_ecosystem_daily_activity", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["pfi_customer_mart", "ticketmaster", "fanapp_user_account_id_map", "weekly_trading", "pfi_daily_fancash", "fanapp_game_results"], "materialized": "table", "raw_code_hash": "e6d88be3daaff02bc4849173a16f30d5"} */
