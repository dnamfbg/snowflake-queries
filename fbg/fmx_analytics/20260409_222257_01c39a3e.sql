-- Query ID: 01c39a3e-0212-67a8-24dd-07031942ddcb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:57.071000+00:00
-- Elapsed: 16533ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.customer.cust_fmx_customer_daily_balance
    
    
    
    as (WITH date_spine AS (

    SELECT date_id_alk::date AS activity_date
    FROM
        FMX_ANALYTICS.DIMENSIONS.dim_date
    WHERE date_id_alk <= CURRENT_DATE()

),

account_base AS (

    SELECT DISTINCT acco_id
    FROM
        FMX_ANALYTICS.DIMENSIONS.dim_fmx_accounts
    WHERE COALESCE(is_test_account, 0) = 0

),

idle_events_ranked AS (

    SELECT
        st.acco_id AS account_id,
        st.trans_date::date AS event_date,
        st.balance::number(36, 6) AS balance_usd,
        COALESCE(st.fund_type_id, 1) AS normalized_fund_type_id,
        ROW_NUMBER() OVER (
            PARTITION BY
                st.acco_id,
                st.trans_date::date,
                COALESCE(st.fund_type_id, 1)
            ORDER BY st.trans_date DESC
        ) AS rn
    FROM
        FMX_ANALYTICS.STAGING.stg_account_statements_fmx AS st
    INNER JOIN account_base AS ab
        ON st.acco_id = ab.acco_id

),

idle_events AS (

    SELECT
        account_id,
        event_date,
        MAX(CASE WHEN normalized_fund_type_id = 1 THEN balance_usd END) AS idle_funds_usd,
        MAX(CASE WHEN normalized_fund_type_id = 19 THEN balance_usd END) AS promo_funds_usd
    FROM
        idle_events_ranked
    WHERE rn = 1
    GROUP BY 1, 2

),

idle_bounds AS (

    SELECT
        account_id,
        MIN(event_date) AS min_date
    FROM
        idle_events
    GROUP BY 1

),

idle_grid AS (

    SELECT
        b.account_id,
        ds.activity_date
    FROM
        idle_bounds AS b
    INNER JOIN date_spine AS ds
        ON b.min_date <= ds.activity_date
),

idle_daily AS (

    SELECT
        g.account_id,
        g.activity_date,
        ie.idle_funds_usd,
        ie.promo_funds_usd
    FROM
        idle_grid AS g
    LEFT JOIN idle_events AS ie
        ON
            g.account_id = ie.account_id
            AND g.activity_date >= ie.event_date

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY g.account_id, g.activity_date
        ORDER BY ie.event_date DESC
    ) = 1

),

core_orders AS (
    SELECT
        account_id,
        market_symbol,
        order_created_at,
        pos_after_qty,
        settlement_created_at
    FROM
        FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders
    WHERE order_status = 'COMPLETED'
        AND COALESCE(is_test_account, false) = false
),

position_events AS (

    SELECT
        account_id,
        market_symbol,
        DATE_TRUNC('day', order_created_at)::date AS event_date,
        MAX_BY(pos_after_qty, order_created_at) AS pos_after_qty
    FROM
        core_orders
    GROUP BY 1, 2, 3

),

settlement_dates AS (

    SELECT
        account_id,
        market_symbol,
        MIN(DATE_TRUNC('day', settlement_created_at)::date) AS settlement_date
    FROM
        core_orders
    WHERE settlement_created_at IS NOT NULL
    GROUP BY 1, 2
),

pos_bounds AS (

    SELECT
        account_id,
        market_symbol,
        MIN(event_date) AS min_date
    FROM
        position_events
    GROUP BY 1, 2

),

pos_grid AS (

    SELECT
        b.account_id,
        b.market_symbol,
        ds.activity_date
    FROM
        pos_bounds AS b
    INNER JOIN date_spine AS ds
        ON b.min_date <= ds.activity_date

),

pos_daily_raw AS (

    SELECT
        g.account_id,
        g.market_symbol,
        g.activity_date,
        pe.pos_after_qty
    FROM
        pos_grid AS g
    LEFT JOIN position_events AS pe
        ON
            g.account_id = pe.account_id
            AND g.market_symbol = pe.market_symbol
            AND g.activity_date >= pe.event_date

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY g.account_id, g.market_symbol, g.activity_date
        ORDER BY pe.event_date DESC
    ) = 1

),

pos_daily AS (

    SELECT
        p.account_id,
        p.market_symbol,
        p.activity_date,
        CASE
            WHEN
                s.settlement_date IS NOT NULL
                AND p.activity_date >= s.settlement_date
                THEN 0
            ELSE p.pos_after_qty
        END AS pos_after_qty
    FROM
        pos_daily_raw AS p
    LEFT JOIN settlement_dates AS s
        ON
            p.account_id = s.account_id
            AND p.market_symbol = s.market_symbol

),

market_price_daily AS (

    SELECT
        activity_date_alk::date AS activity_date,
        symbol,
        MAX_BY(last_best_bid_price, activity_hour_alk) AS last_best_bid_price
    FROM
        FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_detail_hourly
    WHERE last_best_bid_price IS NOT NULL
    GROUP BY 1, 2
),

active_by_account_date AS (

    SELECT
        p.account_id,
        p.activity_date,
        SUM(ABS(COALESCE(p.pos_after_qty, 0)) * COALESCE(m.last_best_bid_price, 0)) AS active_funds_usd
    FROM
        pos_daily AS p
    LEFT JOIN market_price_daily AS m
        ON
            p.market_symbol = m.symbol
            AND p.activity_date = m.activity_date
    GROUP BY 1, 2

),

final AS (

    SELECT
        COALESCE(i.account_id, a.account_id) AS account_id,
        COALESCE(i.activity_date, a.activity_date) AS activity_date,
        COALESCE(i.idle_funds_usd, 0) AS idle_funds_usd,
        COALESCE(a.active_funds_usd, 0) AS active_funds_usd,
        COALESCE(i.promo_funds_usd, 0) AS promo_funds_usd,
        COALESCE(i.idle_funds_usd, 0)
        + COALESCE(a.active_funds_usd, 0)
        + COALESCE(i.promo_funds_usd, 0) AS total_customer_balance,
        CASE
            WHEN COALESCE(a.active_funds_usd, 0) = 0 THEN 0
            ELSE
                COALESCE(a.active_funds_usd, 0)
                / NULLIF(
                    COALESCE(i.idle_funds_usd, 0)
                    + COALESCE(a.active_funds_usd, 0)
                    + COALESCE(i.promo_funds_usd, 0),
                    0
                )
        END AS active_ratio
    FROM
        idle_daily AS i
    FULL OUTER JOIN active_by_account_date AS a
        ON
            i.account_id = a.account_id
            AND i.activity_date = a.activity_date

)

SELECT
md5(cast(coalesce(cast(account_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(activity_date as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS customer_daily_balance_table_id, --noqa
*
FROM final
WHERE COALESCE(total_customer_balance, 0) > 0
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.cust_fmx_customer_daily_balance", "profile_name": "user", "target_name": "default"} */
