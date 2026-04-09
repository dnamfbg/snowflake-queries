-- Query ID: 01c39a36-0212-6e7d-24dd-070319418317
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:14:23.575000+00:00
-- Elapsed: 108376ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders
    
    
    
    as (-- This model creates a core orders fact table by joining and transforming data from multiple 
-- sources, including orders, markets, settlements, executions, account statements, and P&L calculations. 
-- It provides a comprehensive view of each order with enriched features for analysis.
WITH orders_core AS (

    SELECT
        order_id,
        account_id,
        exchange_user_id,
        jurisdiction_id AS order_state_id,
        quantity AS order_quantity,
        exchange,
        symbol AS market_symbol,
        created_at AS order_created_at,
        order_source,
        fan_id AS order_fan_id,
        new_fee_schedule AS order_new_fee_schedule,
        price_before_allowance AS order_price_before_allowance,
        order_slippage_allowance,
        CAST(DATEADD('day', 1, created_at) AS DATE) AS order_report_date,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', created_at) AS order_created_at_alk,
        DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', DATEADD('day', 1, created_at))) AS order_report_date_alk,
        UPPER(action) AS trade_action,
        UPPER(side) AS trade_side,
        price / 100.0 AS order_price_usd,
        fmx_fees_withheld / 100.0 AS fmx_fees_withheld_usd,
        IFF(order_slippage_allowance > 0, TRUE, FALSE) AS is_price_tolerance_enabled
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_orders

),

combo_leg_selection_count AS (

    SELECT
        symbol,
        COUNT(DISTINCT f.value:symbol::STRING) AS leg_selection_count
    FROM FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets,
    LATERAL FLATTEN(
        input => PARSE_JSON(PARSE_JSON(UNKNOWN_FIELDS_JSON):COMBO_LIST)
    ) f
    WHERE markets_grouping = 'COMBOS'
    GROUP BY 1

),

crypto_markets AS (

    SELECT
        cm.symbol AS market_symbol,
        cm.name AS market_name,
        cm.alpha_strike AS alpha_strike,
        cm.title AS market_title,
        cm.predict_market_type,
        cm.predict_event_type,
        cm.predict_contract_type,
        cm.markets_grouping,
        cm.sport_vs_other,
        cm.event_date,
        cm.market_open_date_time AS market_open_date,
        cm.trading_status AS market_trading_status,
        COALESCE(cls.leg_selection_count, 1) AS leg_selection_count
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets AS cm 
    LEFT JOIN combo_leg_selection_count AS cls
        ON cm.symbol = cls.symbol

),

orders_base AS (

    SELECT
        oc.order_id,
        oc.account_id,
        oc.order_created_at,
        oc.order_source,
        oc.order_fan_id,
        oc.order_new_fee_schedule,
        oc.order_price_before_allowance,
        oc.order_slippage_allowance,
        oc.is_price_tolerance_enabled,
        oc.order_report_date,
        oc.order_created_at_alk,
        oc.order_report_date_alk,
        oc.exchange_user_id,
        oc.order_state_id,
        oc.order_quantity,
        oc.exchange,
        oc.market_symbol,
        cm.market_name,
        cm.alpha_strike,
        cm.market_title,
        cm.predict_market_type,
        cm.predict_event_type,
        cm.predict_contract_type,
        cm.markets_grouping,
        cm.sport_vs_other,
        cm.event_date,
        cm.market_open_date,
        cm.market_trading_status,
        cm.leg_selection_count,
        oc.trade_action,
        oc.trade_side,
        oc.fmx_fees_withheld_usd,
        oc.order_price_usd
    FROM
        orders_core AS oc

    LEFT JOIN crypto_markets AS cm
        ON oc.market_symbol = cm.market_symbol

),

settlement_reports AS (

    SELECT
        symbol,
        exchange_user_id,
        CAST(SUM(payout_change) / 100.0 AS NUMBER(36, 4)) AS total_settlement_payout_usd,
        MAX(settlement_report_id) AS settlement_report_id,
        MAX(market_result) AS market_result,
        MAX(created_at) AS settlement_created_at
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_settlement_reports

    GROUP BY 1, 2

),

execution_reports AS (

    SELECT
        er.order_id,
        CASE
            WHEN MAX(CASE WHEN er.report_type = 'TRADE' THEN 1 ELSE 0 END) = 1
                THEN
                    CASE
                        WHEN
                            SUM(CASE WHEN er.report_type = 'TRADE' THEN er.quantity ELSE 0 END)
                            >= MAX(oc.order_quantity)
                            THEN 'FULLY_FILLED'
                        ELSE 'PARTIALLY_FILLED'
                    END
            WHEN MAX(CASE WHEN er.report_type = 'CANCELLED' THEN 1 ELSE 0 END) = 1 THEN 'CANCELLED'
            WHEN MAX(CASE WHEN er.report_type = 'REJECTED' THEN 1 ELSE 0 END) = 1 THEN 'REJECTED'
            WHEN MAX(CASE WHEN er.report_type = 'EXPIRED' THEN 1 ELSE 0 END) = 1 THEN 'EXPIRED'
            WHEN MAX(CASE WHEN er.report_type = 'REPLACED' THEN 1 ELSE 0 END) = 1 THEN 'REPLACED'
            WHEN MAX(CASE WHEN er.report_type = 'PENDING_NEW' THEN 1 ELSE 0 END) = 1 THEN 'PENDING'
            ELSE 'UNKNOWN'
        END AS execution_status,
        COUNT(DISTINCT er.execution_report_id) AS execution_count,
        MAX(er.created_at) AS latest_execution_at,
        MAX(CASE
            WHEN er.report_type IN ('CANCELLED', 'REJECTED')
                THEN er.reason
        END) AS rejection_reason
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_execution_reports AS er

    LEFT JOIN orders_core AS oc
        ON er.order_id = oc.order_id
    GROUP BY 1

),

account_statements AS (

    SELECT
        link_trans_ref,
        acco_id,
        -- Taking the most recent record per transaction gets the balance after trade, fees and reverts if applicable
        MAX_BY(CAST(balance AS NUMBER(36, 6)), trans_date) AS customer_balance
    FROM
        FMX_ANALYTICS.STAGING.stg_account_statements_fmx
    -- One transaction that causes a duplicate as a bonus spend is attributed to two different customers. These
    -- are test transactions so will exclude for now and raise with engineering if problem persists 25/03/2026. 
    WHERE trans_ref <> '601-de48afa7-0f88-429f-8714-e6fc389052c4-2800793'
    GROUP BY 1, 2

),

accounts_base AS (

    SELECT
        acco_id,
        reg_jurisdictions_id AS registration_state_id,
        registration_state,
        registration_date_utc,
        registration_date_alk,
        COALESCE(is_test_account, 0)::boolean AS is_test_account
    FROM
        FMX_ANALYTICS.STAGING.stg_fmx_accounts

),

jurisdictions AS (

    SELECT
        jurisdiction_id,
        jurisdiction_code AS order_state_code,
        jurisdiction_name AS order_state_name,
        region AS order_state_region,
        division AS order_state_division,
        country_code AS order_country_code
    FROM
        FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions

),

pnl AS (

    SELECT
        is_fmx_vip,
        order_id,
        customer_completed_trade_number,
        -- filled measures (authoritative)
        filled_quantity,
        filled_price_usd,
        filled_fmx_fees_usd,
        fmx_fees_charged_after_refunds_and_clawbacks_usd,
        filled_exchange_fees_usd,
        filled_total_fees_usd,
        filled_contract_amount_usd,
        filled_handle_usd,
        filled_cashflow_usd,
        -- settlement & position state (authoritative)
        total_settlement_payout_usd,
        pos_before_qty,
        pos_after_qty,
        close_qty,
        oversell_qty,
        position_open_qty,
        buy_remaining_qty,
        position_status_type,
        position_closed_pct,
        avg_entry_price_usd_before,
        -- pnl (authoritative)
        realized_price_pnl_usd,
        settlement_pnl_usd,
        fees_pnl_usd,
        order_pnl_before_fees_usd,
        order_pnl_after_fees_usd,
        position_pnl_before_fees_usd,
        position_pnl_after_fees_usd,
        -- recon fields
        reconciliation_pnl_before_fees,
        reconciliation_pnl_after_fees,
        pnl_before_fees_recon_match,
        pnl_after_fees_recon_match,
        -- overalls
        lifetime_order_count,
        lifetime_handle_usd
    FROM
        FMX_ANALYTICS.CUSTOMER.fct_fmx_order_pnl

),

cogs_cumulative AS (

    SELECT
        acco_id,
        SUM(geolocation_costs_usd) AS total_geolocation_costs_usd,
        SUM(kyc_verification_cost_usd) AS total_kyc_verification_cost_usd,
        SUM(deposit_processing_cost_usd) AS total_deposit_processing_cost_usd,
        SUM(withdrawal_processing_cost_usd) AS total_withdrawal_processing_cost_usd,
        SUM(promotions_cost_usd) AS total_promotions_cost_usd
    FROM
         FMX_ANALYTICS.CUSTOMER.fct_fmx_customer_daily_cogs
    GROUP BY 1

),

base AS (

    SELECT
        ob.order_id,
        ob.order_created_at,
        ob.order_report_date,
        ob.order_created_at_alk,
        ob.order_report_date_alk,
        ob.account_id,
        ob.order_fan_id,
        ob.order_new_fee_schedule,
        ob.order_state_id,
        ob.order_source,
        j.order_country_code,
        j.order_state_code,
        j.order_state_name,
        j.order_state_region,
        j.order_state_division,
        ab.registration_state_id,
        ab.registration_state,
        ab.registration_date_utc,
        ab.registration_date_alk,
        ab.is_test_account,
        ob.market_symbol,
        ob.market_name,
        ob.alpha_strike,
        ob.market_title,
        ob.predict_market_type,
        ob.predict_event_type,
        ob.predict_contract_type,
        ob.markets_grouping,
        ob.sport_vs_other,
        ob.market_open_date,
        ob.market_trading_status,
        ob.leg_selection_count,
        ob.trade_action,
        ob.trade_side,
        ob.exchange_user_id,
        ob.order_price_before_allowance,
        ob.order_slippage_allowance,
        ob.is_price_tolerance_enabled,
        er.execution_status,
        er.execution_count,
        er.latest_execution_at,
        sr.settlement_report_id,
        sr.settlement_created_at,
        pnl.customer_completed_trade_number,
        MIN(IFF(pnl.customer_completed_trade_number = 1, ob.order_created_at_alk, NULL))
            OVER (PARTITION BY ob.account_id) AS first_completed_trade_created_at,
        COALESCE(ob.event_date, sr.settlement_created_at) AS event_date,
        COALESCE(pnl.is_fmx_vip, 'No') AS is_vip_account,
        COALESCE(
            a.customer_balance,
            LAG(a.customer_balance) IGNORE NULLS OVER (
                PARTITION BY ob.account_id
                ORDER BY ob.order_created_at, ob.order_id
            )
        ) AS customer_balance,
        CASE
            WHEN pnl.filled_cashflow_usd IS NULL THEN 0
            ELSE
                a.customer_balance
                / NULLIF(
                    COALESCE(a.customer_balance, 0) + COALESCE(-1 * pnl.filled_cashflow_usd, 0),
                    0
                )
                - 1
        END AS pct_change_customer_balance,
        CASE
            WHEN COALESCE(pnl.filled_quantity, 0) = 0 THEN 'FAILURE_NO_CHANGE'
            WHEN ob.trade_action = 'SELL' AND COALESCE(pnl.pos_after_qty, 0) < 0 THEN 'OVERSELL'
            WHEN COALESCE(pnl.pos_before_qty, 0) = 0 AND COALESCE(pnl.pos_after_qty, 0) <> 0 THEN 'OPEN'
            WHEN COALESCE(pnl.pos_before_qty, 0) > 0 AND COALESCE(pnl.pos_after_qty, 0) = 0 THEN 'FULLY_CLOSED'
            WHEN ABS(COALESCE(pnl.pos_after_qty, 0)) > ABS(COALESCE(pnl.pos_before_qty, 0)) THEN 'INCREASE'
            WHEN ABS(COALESCE(pnl.pos_after_qty, 0)) < ABS(COALESCE(pnl.pos_before_qty, 0)) THEN 'DECREASE'
            ELSE 'OTHER'
        END AS order_position_effect,
        IFF(COALESCE(pnl.filled_quantity, 0) = 0, 'FAILED', pnl.position_status_type) AS order_position_status_type,
        ob.order_state_id = ab.registration_state_id AS is_order_in_registration_state,
        ROW_NUMBER() OVER (
            PARTITION BY ob.account_id
            ORDER BY ob.order_created_at ASC, ob.order_id ASC
        ) AS customer_attempted_trade_number,
        ROW_NUMBER() OVER (
            PARTITION BY ob.account_id, ob.market_symbol
            ORDER BY ob.order_created_at ASC, ob.order_id ASC
        ) AS symbol_trade_number,
        DATEDIFF('day', ob.market_open_date, ob.order_created_at) AS days_after_market_open,
        DATEDIFF('day', ob.order_created_at, COALESCE(ob.event_date, sr.settlement_created_at)) AS days_until_event,
        DATEDIFF('hour', ob.order_created_at, COALESCE(ob.event_date, sr.settlement_created_at)) AS hours_until_event,
        ob.order_created_at > ob.event_date AS is_in_play_order,
        COALESCE(sr.market_result, 'PENDING') AS market_result,
        CASE
            WHEN
                (ob.trade_side = 'YES' AND ob.trade_action = 'BUY')
                OR (ob.trade_side = 'NO' AND ob.trade_action = 'SELL') THEN 'YES'
            WHEN
                (ob.trade_side = 'NO' AND ob.trade_action = 'BUY')
                OR (ob.trade_side = 'YES' AND ob.trade_action = 'SELL') THEN 'NO'
        END AS exposure_side,
        CASE
            WHEN COALESCE(pnl.filled_quantity, 0) = 0 THEN 'FAILED'
            WHEN sr.market_result IS NULL THEN 'PENDING'
            WHEN (
                (
                    (ob.trade_side = 'YES' AND ob.trade_action = 'BUY')
                    OR (ob.trade_side = 'NO' AND ob.trade_action = 'SELL')
                )
                AND sr.market_result = 'RESULT_YES'
            ) THEN 'WIN'
            WHEN (
                (
                    (ob.trade_side = 'NO' AND ob.trade_action = 'BUY')
                    OR (ob.trade_side = 'YES' AND ob.trade_action = 'SELL')
                )
                AND sr.market_result = 'RESULT_NO'
            ) THEN 'WIN'
            ELSE 'LOSS'
        END AS market_result_trade_outcome,
        COALESCE(ob.order_quantity, 0) AS attempted_quantity,
        COALESCE(ob.order_price_usd, 0) AS attempted_price_usd,
        COALESCE(NULLIF(ob.fmx_fees_withheld_usd, 0), NULLIF(pnl.filled_fmx_fees_usd, 0), 0) AS attempted_fees_usd,
        COALESCE(ob.order_quantity * ob.order_price_usd, 0) AS attempted_contract_amount_usd,
        CASE
            WHEN ob.trade_action = 'SELL' THEN COALESCE(ob.order_quantity * ob.order_price_usd, 0)
            ELSE
                COALESCE(ob.order_quantity * ob.order_price_usd, 0)
                + COALESCE(NULLIF(ob.fmx_fees_withheld_usd, 0), NULLIF(pnl.filled_fmx_fees_usd, 0), 0)
        END AS attempted_handle_usd,
        COALESCE(pnl.filled_quantity, 0) AS filled_quantity,
        COALESCE(pnl.filled_price_usd, 0) AS filled_price_usd,
        COALESCE(pnl.filled_fmx_fees_usd, 0) AS filled_fmx_fees_usd,
        COALESCE(pnl.fmx_fees_charged_after_refunds_and_clawbacks_usd, 0)
            AS fmx_fees_charged_after_refunds_and_clawbacks_usd,
        COALESCE(pnl.filled_exchange_fees_usd, 0) AS filled_exchange_fees_usd,
        COALESCE(pnl.filled_total_fees_usd, 0) AS filled_total_fees_usd,
        COALESCE(pnl.filled_contract_amount_usd, 0) AS filled_contract_amount_usd,
        COALESCE(pnl.filled_handle_usd, 0) AS filled_handle_usd,
        COALESCE(pnl.filled_cashflow_usd, 0) AS filled_cashflow_usd,
        COALESCE(pnl.pos_before_qty, 0) AS pos_before_qty,
        COALESCE(pnl.pos_after_qty, 0) AS pos_after_qty,
        COALESCE(pnl.close_qty, 0) AS close_qty,
        COALESCE(pnl.oversell_qty, 0) AS oversell_qty,
        COALESCE(pnl.position_open_qty, 0) AS position_open_qty,
        COALESCE(pnl.buy_remaining_qty, 0) AS buy_remaining_qty,
        CASE
            WHEN COALESCE(pnl.filled_quantity, 0) = 0 THEN 0
            WHEN COALESCE(pnl.pos_before_qty, 0) = 0 AND COALESCE(pnl.pos_after_qty, 0) <> 0 THEN 1.0
            WHEN ABS(COALESCE(pnl.pos_before_qty, 0)) > 0 THEN
                (ABS(COALESCE(pnl.pos_after_qty, 0)) - ABS(COALESCE(pnl.pos_before_qty, 0)))
                / NULLIF(ABS(COALESCE(pnl.pos_before_qty, 0)), 0)
        END AS pct_position_change,
        COALESCE(pnl.position_closed_pct, 0) AS position_closed_pct,
        COALESCE(pnl.avg_entry_price_usd_before, 0) AS avg_entry_price_usd_before,
        COALESCE(pnl.realized_price_pnl_usd, 0) AS realized_price_pnl_usd,
        COALESCE(pnl.settlement_pnl_usd, 0) AS settlement_pnl_usd,
        COALESCE(pnl.fees_pnl_usd, 0) AS fees_pnl_usd,
        COALESCE(pnl.order_pnl_before_fees_usd, 0) AS order_pnl_before_fees_usd,
        COALESCE(pnl.order_pnl_after_fees_usd, 0) AS order_pnl_after_fees_usd,
        COALESCE(pnl.order_pnl_after_fees_usd, 0) > 0 AS is_profitable_order_after_fees,
        COALESCE(pnl.position_pnl_before_fees_usd, 0) AS position_pnl_before_fees_usd,
        COALESCE(pnl.position_pnl_after_fees_usd, 0) AS position_pnl_after_fees_usd,
        COALESCE(pnl.position_pnl_after_fees_usd, 0) > 0 AS is_profitable_position_after_fees,
        COALESCE(pnl.reconciliation_pnl_before_fees, 0) AS reconciliation_pnl_before_fees,
        COALESCE(pnl.reconciliation_pnl_after_fees, 0) AS reconciliation_pnl_after_fees,
        COALESCE(pnl.pnl_before_fees_recon_match, TRUE) AS pnl_before_fees_recon_match,
        COALESCE(pnl.pnl_after_fees_recon_match, TRUE) AS pnl_after_fees_recon_match,
        IFF(
            ob.trade_action = 'BUY',
            COALESCE(pnl.filled_quantity, 0),
            -COALESCE(pnl.filled_quantity, 0)
        ) AS signed_qty_on_contract,
        IFF(
            COALESCE(pnl.filled_quantity, 0) = 0 AND er.rejection_reason IS NULL,
            'FAILED_TO_FILL', er.rejection_reason
        ) AS rejection_reason,
        CASE
            WHEN er.execution_status = 'PENDING' THEN 'PENDING'
            WHEN COALESCE(pnl.filled_quantity, 0) = 0 THEN 'FAILED'
            ELSE 'COMPLETED'
        END AS order_status,
        LAG(
            IFF(COALESCE(pnl.filled_quantity, 0) = 0, ob.order_created_at, NULL)
        ) IGNORE NULLS
            OVER (
                PARTITION BY ob.account_id, ob.market_symbol, ob.trade_action, ob.trade_side
                ORDER BY ob.order_created_at, ob.order_id
            )
            AS prev_failed_order_created_at,
        COALESCE(sr.total_settlement_payout_usd, 0) AS total_settlement_payout_usd,
        IFF(
            COALESCE(ob.order_quantity, 0) > 0,
            COALESCE(pnl.filled_quantity, 0) / COALESCE(ob.order_quantity, 0),
            NULL
        ) AS fill_rate_percentage,
         -- Cogs
        CAST(
            COALESCE(
                COALESCE(cc.total_kyc_verification_cost_usd, 0)
                / NULLIF(pnl.lifetime_order_count, 0),
                0
            ) AS NUMBER(36, 6)
        ) AS order_kyc_verification_cost_usd,       
        CAST(
            COALESCE(
                COALESCE(cc.total_geolocation_costs_usd, 0)
                / NULLIF(pnl.lifetime_order_count, 0),
                0
            ) AS NUMBER(36, 6)
        ) AS order_geolocation_cost_usd,        
        CAST(
            COALESCE(pnl.filled_handle_usd, 0) * 0.0008
            AS NUMBER(36, 6)
        ) AS order_server_cost_usd,     
        CAST(
            COALESCE(
                COALESCE(cc.total_deposit_processing_cost_usd, 0)
                * (
                    COALESCE(pnl.filled_handle_usd, 0)
                    / NULLIF(pnl.lifetime_handle_usd, 0)
                ),
                0
            ) AS NUMBER(36, 6)
        ) AS order_deposit_processing_cost_usd,     
        CAST(
            COALESCE(
                COALESCE(cc.total_withdrawal_processing_cost_usd, 0)
                * (
                    COALESCE(pnl.filled_handle_usd, 0)
                    / NULLIF(pnl.lifetime_handle_usd, 0)
                ),
                0
            ) AS NUMBER(36, 6)
        ) AS order_withdrawal_processing_cost_usd,
        CAST(
            COALESCE(
                COALESCE(cc.total_promotions_cost_usd, 0)
                * (
                    COALESCE(pnl.filled_handle_usd, 0)
                    / NULLIF(pnl.lifetime_handle_usd, 0)
                ),
                0
            ) AS NUMBER(36, 6)
        ) AS order_promotions_cost_usd
    FROM
        orders_base AS ob

    LEFT JOIN settlement_reports AS sr
        ON
            ob.market_symbol = sr.symbol
            AND ob.exchange_user_id = sr.exchange_user_id
    LEFT JOIN execution_reports AS er
        ON ob.order_id = er.order_id
    LEFT JOIN account_statements AS a
        ON ob.order_id = a.link_trans_ref
    LEFT JOIN accounts_base AS ab
        ON ob.account_id = ab.acco_id
    LEFT JOIN jurisdictions AS j
        ON ob.order_state_id = j.jurisdiction_id
    LEFT JOIN pnl AS pnl
        ON ob.order_id = pnl.order_id
    LEFT JOIN cogs_cumulative AS cc
        ON ob.account_id = cc.acco_id

    -- filter removed: is_test_account column available for downstream filtering

),

enriched AS (

    SELECT
        *,
        COALESCE(customer_attempted_trade_number = 1, FALSE) AS is_first_attempted_trade,
        COALESCE(customer_completed_trade_number = 1, FALSE) AS is_first_completed_trade,
        IFF(
            prev_failed_order_created_at IS NOT NULL
            AND order_status = 'FAILED'
            AND DATEDIFF('minute', prev_failed_order_created_at, order_created_at) <= 60,
            TRUE,
            FALSE
        ) AS is_repeat_order_failure,
        CASE
            WHEN hours_until_event IS NULL THEN NULL
            WHEN hours_until_event < 0 THEN 'IN_PLAY'
            WHEN hours_until_event < 1 THEN '<1H'
            WHEN hours_until_event < 6 THEN '1-6H'
            WHEN hours_until_event < 24 THEN '6-24H'
            WHEN hours_until_event < 72 THEN '1-3D'
            WHEN hours_until_event < 168 THEN '3-7D'
            ELSE '>7D'
        END AS time_to_event_bucket,
        COALESCE(CAST(
            order_kyc_verification_cost_usd
            + order_geolocation_cost_usd
            + order_server_cost_usd
            + order_deposit_processing_cost_usd
            + order_withdrawal_processing_cost_usd
            + order_promotions_cost_usd
            AS NUMBER(36, 6)
        ), 0) AS order_total_cogs_usd
    FROM
        base

)

SELECT
    order_id,
    md5(cast(coalesce(cast(account_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(market_symbol as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS account_market_reference_id, --noqa
    order_created_at,
    order_report_date,
    order_created_at_alk,
    order_report_date_alk,
    -- Customer specific details
    account_id,
    order_fan_id,
    order_source,
    is_vip_account,
    is_test_account,
    registration_date_utc,
    registration_date_alk,
    registration_state_id,
    registration_state,
    customer_attempted_trade_number,
    customer_completed_trade_number,
    is_first_attempted_trade,
    is_first_completed_trade,
    first_completed_trade_created_at,
    order_country_code,
    order_state_id,
    -- Order location details
    order_state_code,
    order_state_name,
    order_state_region,
    order_state_division,
    is_order_in_registration_state,
    market_symbol,
    symbol_trade_number,
    -- Market
    market_name,
    market_title,
    alpha_strike,
    predict_market_type,
    predict_event_type,
    predict_contract_type,
    markets_grouping,
    sport_vs_other,
    market_open_date,
    days_after_market_open,
    event_date,
    days_until_event,
    hours_until_event,
    time_to_event_bucket,
    is_in_play_order,
    market_result,
    market_trading_status,
    leg_selection_count,
    order_status,
    is_repeat_order_failure,
    -- Trade Specific Details: order details
    rejection_reason,
    order_position_effect,
    order_position_status_type,
    trade_action,
    trade_side,
    exposure_side,
    market_result_trade_outcome,
    attempted_quantity,
    attempted_price_usd,
    order_price_before_allowance,
    order_slippage_allowance,
    is_price_tolerance_enabled,
    -- Trade Specific Details: attempted
    attempted_fees_usd,
    attempted_contract_amount_usd,
    attempted_handle_usd,
    filled_quantity,
    fill_rate_percentage,
    -- Trade Specific Details: filled features
    filled_price_usd,
    avg_entry_price_usd_before,
    order_new_fee_schedule,
    filled_fmx_fees_usd,
    fmx_fees_charged_after_refunds_and_clawbacks_usd,
    filled_exchange_fees_usd,
    filled_contract_amount_usd,
    filled_handle_usd,
    filled_cashflow_usd,
    -- Customer Balance
    customer_balance,
    pct_change_customer_balance,
    -- Execution details
    exchange_user_id,
    execution_status,
    execution_count,
    latest_execution_at,
    -- Settlement details
    settlement_report_id,
    settlement_created_at,
    total_settlement_payout_usd,
    -- Trade position details
    signed_qty_on_contract,
    pos_before_qty,
    pos_after_qty,
    pct_position_change,
    position_closed_pct,
    oversell_qty,
    position_open_qty,
    buy_remaining_qty,
    close_qty,
    -- PNL and reconciliation
    realized_price_pnl_usd,
    settlement_pnl_usd,
    fees_pnl_usd,
    order_pnl_before_fees_usd,
    order_pnl_after_fees_usd,
    is_profitable_order_after_fees,
    position_pnl_before_fees_usd,
    position_pnl_after_fees_usd,
    is_profitable_position_after_fees,
    reconciliation_pnl_before_fees,
    reconciliation_pnl_after_fees,
    pnl_before_fees_recon_match,
    pnl_after_fees_recon_match,
    -- Cogs
    order_kyc_verification_cost_usd,
    order_geolocation_cost_usd,
    order_server_cost_usd,
    order_deposit_processing_cost_usd,
    order_withdrawal_processing_cost_usd,
    order_promotions_cost_usd,
    order_total_cogs_usd
FROM
    enriched
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_core_orders", "profile_name": "user", "target_name": "default"} */
