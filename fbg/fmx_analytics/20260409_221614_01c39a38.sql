-- Query ID: 01c39a38-0212-67a8-24dd-07031941a593
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:14.019000+00:00
-- Elapsed: 44669ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.customer.fct_fmx_top_performers
    
    
    
    as (

WITH core_orders AS ( --noqa: disable=AM06,RF04
    SELECT
        market_name,
        account_id::VARCHAR AS account_id,
        trade_action,
        order_id,
        filled_quantity,
        filled_contract_amount_usd,
        fmx_fees_charged_after_refunds_and_clawbacks_usd,
        order_pnl_after_fees_usd,
        is_first_completed_trade,
        UPPER(order_state_code) AS state_code,
        DATE(order_report_date_alk) AS report_date,
        DATE(order_created_at_alk) AS activity_date
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders
    WHERE
        COALESCE(is_test_account, FALSE) = FALSE
        AND order_status = 'COMPLETED'
        AND market_name IS NOT NULL
        AND account_id IS NOT NULL
),

customer_daily AS (
    SELECT
        report_date,
        activity_date,
        account_id AS entity_name,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_quantity ELSE 0 END) AS contracts_placed_qty,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_quantity ELSE 0 END) AS contracts_sold_qty,
        SUM(filled_quantity) AS contracts_traded_qty,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_placed_amt,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_sold_amt,
        SUM(filled_contract_amount_usd) AS contract_traded_amt,
        SUM(fmx_fees_charged_after_refunds_and_clawbacks_usd) AS revenue_amt,
        1 AS actives,
        COUNT(CASE WHEN trade_action = 'BUY' THEN order_id END) AS contracts_placed_count,
        COUNT(CASE WHEN trade_action = 'SELL' THEN order_id END) AS contracts_sold_count,
        COUNT(order_id) AS contract_traded_count,
        SUM(order_pnl_after_fees_usd) AS customer_pnl_amt
    FROM core_orders
    GROUP BY 1, 2, 3
),

customer_lifetime AS (
    SELECT
        entity_name,
        SUM(contracts_placed_qty) AS lifetime_contracts_placed_qty,
        SUM(contracts_sold_qty) AS lifetime_contracts_sold_qty,
        SUM(contracts_traded_qty) AS lifetime_contracts_traded_qty,
        SUM(contracts_placed_amt) AS lifetime_contracts_placed_amt,
        SUM(contracts_sold_amt) AS lifetime_contracts_sold_amt,
        SUM(contract_traded_amt) AS lifetime_contract_traded_amt,
        SUM(revenue_amt) AS lifetime_revenue_amt,
        SUM(contracts_placed_count) AS lifetime_contracts_placed_count,
        SUM(contracts_sold_count) AS lifetime_contracts_sold_count,
        SUM(contract_traded_count) AS lifetime_contract_traded_count,
        SUM(customer_pnl_amt) AS lifetime_customer_pnl_amt,
        1 AS lifetime_actives
    FROM customer_daily
    GROUP BY 1
),

market_daily AS (
    SELECT
        report_date,
        activity_date,
        market_name AS entity_name,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_quantity ELSE 0 END) AS contracts_placed_qty,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_quantity ELSE 0 END) AS contracts_sold_qty,
        SUM(filled_quantity) AS contracts_traded_qty,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_placed_amt,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_sold_amt,
        SUM(filled_contract_amount_usd) AS contract_traded_amt,
        SUM(fmx_fees_charged_after_refunds_and_clawbacks_usd) AS revenue_amt,
        COUNT(DISTINCT account_id) AS actives,
        COUNT(CASE WHEN trade_action = 'BUY' THEN order_id END) AS contracts_placed_count,
        COUNT(CASE WHEN trade_action = 'SELL' THEN order_id END) AS contracts_sold_count,
        COUNT(order_id) AS contract_traded_count,
        SUM(order_pnl_after_fees_usd) AS customer_pnl_amt
    FROM core_orders
    GROUP BY 1, 2, 3
),

market_lifetime_actives AS (
    SELECT
        market_name AS entity_name,
        COUNT(DISTINCT account_id) AS lifetime_actives
    FROM core_orders
    GROUP BY 1
),

ftu_lifetime AS (
    SELECT
        state_code,
        SUM(CASE WHEN is_first_completed_trade = 1 THEN 1 ELSE 0 END) AS lifetime_ftus
    FROM core_orders
    WHERE state_code IS NOT NULL
    GROUP BY 1
),

state_daily AS (
    SELECT
        report_date,
        activity_date,
        state_code AS entity_name,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_quantity ELSE 0 END) AS contracts_placed_qty,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_quantity ELSE 0 END) AS contracts_sold_qty,
        SUM(filled_quantity) AS contracts_traded_qty,
        SUM(CASE WHEN trade_action = 'BUY' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_placed_amt,
        SUM(CASE WHEN trade_action = 'SELL' THEN filled_contract_amount_usd ELSE 0 END) AS contracts_sold_amt,
        SUM(filled_contract_amount_usd) AS contract_traded_amt,
        SUM(fmx_fees_charged_after_refunds_and_clawbacks_usd) AS revenue_amt,
        COUNT(DISTINCT account_id) AS actives,
        COUNT(CASE WHEN trade_action = 'BUY' THEN order_id END) AS contracts_placed_count,
        COUNT(CASE WHEN trade_action = 'SELL' THEN order_id END) AS contracts_sold_count,
        COUNT(order_id) AS contract_traded_count,
        SUM(order_pnl_after_fees_usd) AS customer_pnl_amt,
        SUM(CASE WHEN is_first_completed_trade = 1 THEN 1 ELSE 0 END) AS ftus
    FROM core_orders
    WHERE state_code IS NOT NULL
    GROUP BY 1, 2, 3
),

state_lifetime_actives AS (
    SELECT
        state_code AS entity_name,
        COUNT(DISTINCT account_id) AS lifetime_actives
    FROM core_orders
    WHERE state_code IS NOT NULL
    GROUP BY 1
),

state_lifetime AS (
    SELECT
        entity_name,
        SUM(contracts_placed_qty) AS lifetime_contracts_placed_qty,
        SUM(contracts_sold_qty) AS lifetime_contracts_sold_qty,
        SUM(contracts_traded_qty) AS lifetime_contracts_traded_qty,
        SUM(contracts_placed_amt) AS lifetime_contracts_placed_amt,
        SUM(contracts_sold_amt) AS lifetime_contracts_sold_amt,
        SUM(contract_traded_amt) AS lifetime_contract_traded_amt,
        SUM(revenue_amt) AS lifetime_revenue_amt,
        SUM(contracts_placed_count) AS lifetime_contracts_placed_count,
        SUM(contracts_sold_count) AS lifetime_contracts_sold_count,
        SUM(contract_traded_count) AS lifetime_contract_traded_count,
        SUM(customer_pnl_amt) AS lifetime_customer_pnl_amt
    FROM state_daily
    GROUP BY 1
),

market_lifetime AS (
    SELECT
        entity_name,
        SUM(contracts_placed_qty) AS lifetime_contracts_placed_qty,
        SUM(contracts_sold_qty) AS lifetime_contracts_sold_qty,
        SUM(contracts_traded_qty) AS lifetime_contracts_traded_qty,
        SUM(contracts_placed_amt) AS lifetime_contracts_placed_amt,
        SUM(contracts_sold_amt) AS lifetime_contracts_sold_amt,
        SUM(contract_traded_amt) AS lifetime_contract_traded_amt,
        SUM(revenue_amt) AS lifetime_revenue_amt,
        SUM(contracts_placed_count) AS lifetime_contracts_placed_count,
        SUM(contracts_sold_count) AS lifetime_contracts_sold_count,
        SUM(contract_traded_count) AS lifetime_contract_traded_count,
        SUM(customer_pnl_amt) AS lifetime_customer_pnl_amt
    FROM market_daily
    GROUP BY 1
),

customer_ranked AS (
    SELECT
        'CUSTOMER' AS entity_type,
        cd.entity_name,
        cd.report_date,
        cd.activity_date,
        cd.contracts_placed_qty,
        cd.contracts_sold_qty,
        cd.contracts_traded_qty,
        cd.contracts_placed_amt,
        cd.contracts_sold_amt,
        cd.contract_traded_amt,
        cd.revenue_amt,
        cd.actives,
        cd.contracts_placed_count,
        cd.contracts_sold_count,
        cd.contract_traded_count,
        cd.customer_pnl_amt,
        cl.lifetime_contracts_placed_qty,
        cl.lifetime_contracts_sold_qty,
        cl.lifetime_contracts_traded_qty,
        cl.lifetime_contracts_placed_amt,
        cl.lifetime_contracts_sold_amt,
        cl.lifetime_contract_traded_amt,
        cl.lifetime_revenue_amt,
        cl.lifetime_contracts_placed_count,
        cl.lifetime_contracts_sold_count,
        cl.lifetime_contract_traded_count,
        cl.lifetime_customer_pnl_amt,
        cl.lifetime_actives,
        NULL AS ftus,
        NULL AS lifetime_ftus,
        DENSE_RANK() OVER (
            PARTITION BY cd.activity_date
            ORDER BY cd.revenue_amt DESC
        ) AS revenue_rank
    FROM customer_daily AS cd
    LEFT JOIN customer_lifetime AS cl
        ON cd.entity_name = cl.entity_name
),

market_ranked AS (
    SELECT
        'MARKET' AS entity_type,
        md.entity_name,
        md.report_date,
        md.activity_date,
        md.contracts_placed_qty,
        md.contracts_sold_qty,
        md.contracts_traded_qty,
        md.contracts_placed_amt,
        md.contracts_sold_amt,
        md.contract_traded_amt,
        md.revenue_amt,
        md.actives,
        md.contracts_placed_count,
        md.contracts_sold_count,
        md.contract_traded_count,
        md.customer_pnl_amt,
        ml.lifetime_contracts_placed_qty,
        ml.lifetime_contracts_sold_qty,
        ml.lifetime_contracts_traded_qty,
        ml.lifetime_contracts_placed_amt,
        ml.lifetime_contracts_sold_amt,
        ml.lifetime_contract_traded_amt,
        ml.lifetime_revenue_amt,
        ml.lifetime_contracts_placed_count,
        ml.lifetime_contracts_sold_count,
        ml.lifetime_contract_traded_count,
        ml.lifetime_customer_pnl_amt,
        mla.lifetime_actives,
        NULL AS ftus,
        NULL AS lifetime_ftus,
        DENSE_RANK() OVER (
            PARTITION BY md.activity_date
            ORDER BY md.revenue_amt DESC
        ) AS revenue_rank
    FROM market_daily AS md
    LEFT JOIN market_lifetime AS ml ON md.entity_name = ml.entity_name
    LEFT JOIN market_lifetime_actives AS mla ON md.entity_name = mla.entity_name
),

state_ranked AS (
    SELECT
        'STATE' AS entity_type,
        sd.entity_name,
        sd.report_date,
        sd.activity_date,
        sd.contracts_placed_qty,
        sd.contracts_sold_qty,
        sd.contracts_traded_qty,
        sd.contracts_placed_amt,
        sd.contracts_sold_amt,
        sd.contract_traded_amt,
        sd.revenue_amt,
        sd.actives,
        sd.contracts_placed_count,
        sd.contracts_sold_count,
        sd.contract_traded_count,
        sd.customer_pnl_amt,
        sl.lifetime_contracts_placed_qty,
        sl.lifetime_contracts_sold_qty,
        sl.lifetime_contracts_traded_qty,
        sl.lifetime_contracts_placed_amt,
        sl.lifetime_contracts_sold_amt,
        sl.lifetime_contract_traded_amt,
        sl.lifetime_revenue_amt,
        sl.lifetime_contracts_placed_count,
        sl.lifetime_contracts_sold_count,
        sl.lifetime_contract_traded_count,
        sl.lifetime_customer_pnl_amt,
        sla.lifetime_actives,
        sd.ftus,
        fl.lifetime_ftus,
        DENSE_RANK() OVER (
            PARTITION BY sd.activity_date
            ORDER BY sd.revenue_amt DESC
        ) AS revenue_rank
    FROM state_daily AS sd
    LEFT JOIN state_lifetime AS sl ON sd.entity_name = sl.entity_name
    LEFT JOIN state_lifetime_actives AS sla ON sd.entity_name = sla.entity_name
    LEFT JOIN ftu_lifetime AS fl ON sd.entity_name = fl.state_code
)

SELECT *
FROM customer_ranked
WHERE revenue_rank <= 10

UNION ALL

SELECT *
FROM market_ranked
WHERE revenue_rank <= 10

UNION ALL

SELECT *
FROM state_ranked
WHERE revenue_rank <= 10
ORDER BY activity_date DESC, entity_type ASC, revenue_rank ASC
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_top_performers", "profile_name": "user", "target_name": "default"} */
