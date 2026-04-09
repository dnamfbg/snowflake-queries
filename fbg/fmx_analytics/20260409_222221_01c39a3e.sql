-- Query ID: 01c39a3e-0212-6dbe-24dd-07031942bc8b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:21.070000+00:00
-- Elapsed: 885ms
-- Run Count: 2
-- Environment: FBG

create or replace   view FMX_ANALYTICS.CUSTOMER.vw_fmx_kpi_pivot_new
  
  
  
  
  as (
    WITH orders_all_periods AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', order_report_date_alk)) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', order_report_date_alk)) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', order_report_date_alk)) = 0
                THEN DATE_TRUNC('day', order_report_date_alk)
            WHEN GROUPING(DATE_TRUNC('month', order_report_date_alk)) = 0
                THEN DATE_TRUNC('month', order_report_date_alk)
            ELSE DATE_TRUNC('year', order_report_date_alk)
        END AS report_date,
        COUNT(DISTINCT CASE WHEN order_status = 'COMPLETED' THEN account_id END) AS actives,
        SUM(filled_quantity) AS contracts_ps_qty,
        SUM(filled_contract_amount_usd) AS contracts_ps_amt,
        SUM(CASE WHEN order_status = 'COMPLETED' THEN 1 ELSE 0 END) AS contracts_traded_count,
        SUM(order_pnl_after_fees_usd) AS customer_pnl_amt,
        SUM(CASE WHEN is_first_completed_trade = 1 THEN 1 ELSE 0 END) AS fmx_ftus,
        SUM(filled_handle_usd) AS total_handle_usd
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders
    WHERE COALESCE(is_test_account, FALSE) = FALSE
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', order_report_date_alk)),
        (DATE_TRUNC('month', order_report_date_alk)),
        (DATE_TRUNC('year', order_report_date_alk))
    )
),

wallet_all_periods AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))) = 0
                THEN DATE_TRUNC('day', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))) = 0
                THEN DATE_TRUNC('month', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))
            ELSE DATE_TRUNC('year', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))
        END AS report_date,
        SUM(CASE WHEN transaction_type = 'DEPOSIT' AND status = 'DEPOSIT_SUCCESS' THEN 1 ELSE 0 END) AS deposit_count,
        SUM(CASE WHEN transaction_type = 'DEPOSIT' AND status = 'DEPOSIT_SUCCESS' THEN amount_usd ELSE 0 END)
            AS deposit_amt,
        SUM(CASE WHEN transaction_type = 'WITHDRAWAL' AND status = 'WITHDRAWAL_COMPLETED' THEN 1 ELSE 0 END)
            AS withdrawal_count,
        SUM(CASE WHEN transaction_type = 'WITHDRAWAL' AND status = 'WITHDRAWAL_COMPLETED' THEN amount_usd ELSE 0 END)
            AS withdrawal_amt
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_wallet_funding_transactions
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))),
        (DATE_TRUNC('month', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE))),
        (DATE_TRUNC('year', CAST(DATEADD('day', 1, initiated_at_alk) AS DATE)))
    )
),

new_customers_all_periods AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))) = 0
                THEN DATE_TRUNC('day', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))) = 0
                THEN DATE_TRUNC('month', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))
            ELSE DATE_TRUNC('year', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))
        END AS report_date,
        COUNT(DISTINCT acco_id) AS new_logins
    FROM FMX_ANALYTICS.customer.dim_fmx_core_customer
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))),
        (DATE_TRUNC('month', CAST(DATEADD('day', 1, registration_date_alk) AS DATE))),
        (DATE_TRUNC('year', CAST(DATEADD('day', 1, registration_date_alk) AS DATE)))
    )
),

forecasts_all_periods AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))) = 0
                THEN DATE_TRUNC('day', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))) = 0
                THEN DATE_TRUNC('month', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))
            ELSE DATE_TRUNC('year', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))
        END AS report_date,
        SUM(actives) AS actives_forecast,
        SUM(contracts_placed_sold) AS contracts_ps_qty_forecast,
        SUM(contracts_placed_sold_amt_usd) AS contracts_ps_amt_forecast,
        SUM(deposit_count) AS deposit_count_forecast,
        SUM(deposit_usd) AS deposit_amt_forecast,
        SUM(total_ftus) AS fmx_ftus_forecast,
        SUM(total_trade_fees_usd) AS total_trade_fees_forecast,
        SUM(total_promo_spend_usd) AS total_promo_spend_forecast,
        MAX(mtd_actives) AS forecast_mtd_actives
    FROM FMX_ANALYTICS.STAGING.fmx_forecasts
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))),
        (DATE_TRUNC('month', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE))),
        (DATE_TRUNC('year', CAST(DATEADD('day', 1, CAST(date AS DATE)) AS DATE)))
    )
),

forecasts AS (
    SELECT
        period_type,
        report_date,
        actives_forecast,
        contracts_ps_qty_forecast,
        contracts_ps_amt_forecast,
        NULL AS contracts_traded_count_forecast,
        deposit_count_forecast,
        deposit_amt_forecast,
        fmx_ftus_forecast,
        forecast_mtd_actives,
        contracts_ps_amt_forecast / NULLIF(contracts_ps_qty_forecast, 0) AS avg_contract_price_forecast,
        deposit_amt_forecast / NULLIF(deposit_count_forecast, 0) AS avg_deposit_size_forecast,
        (total_trade_fees_forecast + contracts_ps_amt_forecast) AS handle_forecast,
        contracts_ps_qty_forecast / NULLIF(actives_forecast, 0) AS contracts_traded_per_active_qty_forecast,
        contracts_ps_amt_forecast / NULLIF(actives_forecast, 0) AS contracts_traded_per_active_amt_forecast
    FROM forecasts_all_periods
),

kyc_rollups AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, created_at_alk) AS DATE))) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, created_at_alk) AS DATE))) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, created_at_alk) AS DATE))) = 0
                THEN DATE_TRUNC('day', CAST(DATEADD('day', 1, created_at_alk) AS DATE))
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, created_at_alk) AS DATE))) = 0
                THEN DATE_TRUNC('month', CAST(DATEADD('day', 1, created_at_alk) AS DATE))
            ELSE DATE_TRUNC('year', CAST(DATEADD('day', 1, created_at_alk) AS DATE))
        END AS report_date,
        COUNT(kyc_check_id) AS kyc_checks
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_kyc_results
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', CAST(DATEADD('day', 1, created_at_alk) AS DATE))),
        (DATE_TRUNC('month', CAST(DATEADD('day', 1, created_at_alk) AS DATE))),
        (DATE_TRUNC('year', CAST(DATEADD('day', 1, created_at_alk) AS DATE)))
    )
),

installs AS (
    SELECT
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, install_date) AS DATE))) = 0 THEN 'day'
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, install_date) AS DATE))) = 0 THEN 'month'
            ELSE 'year'
        END AS period_type,
        CASE
            WHEN GROUPING(DATE_TRUNC('day', CAST(DATEADD('day', 1, install_date) AS DATE))) = 0
                THEN DATE_TRUNC('day', CAST(DATEADD('day', 1, install_date) AS DATE))
            WHEN GROUPING(DATE_TRUNC('month', CAST(DATEADD('day', 1, install_date) AS DATE))) = 0
                THEN DATE_TRUNC('month', CAST(DATEADD('day', 1, install_date) AS DATE))
            ELSE DATE_TRUNC('year', CAST(DATEADD('day', 1, install_date) AS DATE))
        END AS report_date,
        COUNT(DISTINCT user_id) AS install_count
    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_user_funnel
    GROUP BY GROUPING SETS (
        (DATE_TRUNC('day', CAST(DATEADD('day', 1, install_date) AS DATE))),
        (DATE_TRUNC('month', CAST(DATEADD('day', 1, install_date) AS DATE))),
        (DATE_TRUNC('year', CAST(DATEADD('day', 1, install_date) AS DATE)))
    )
),

actuals AS (
    SELECT
        o.period_type,
        o.report_date,
        o.actives,
        o.contracts_ps_qty,
        o.contracts_ps_amt,
        o.contracts_traded_count,
        o.customer_pnl_amt,
        o.fmx_ftus,
        o.contracts_ps_qty / NULLIF(o.actives, 0) AS contracts_traded_per_active_qty,
        o.contracts_ps_amt / NULLIF(o.actives, 0) AS contracts_traded_per_active_amt,
        o.contracts_ps_amt / NULLIF(o.contracts_ps_qty, 0) AS avg_contract_price,
        COALESCE(w.deposit_count, 0) AS deposit_count,
        COALESCE(w.deposit_amt, 0) AS deposit_amt,
        w.deposit_amt / NULLIF(w.deposit_count, 0) AS avg_deposit_size,
        COALESCE(w.withdrawal_count, 0) AS withdrawal_count,
        COALESCE(w.withdrawal_amt, 0) AS withdrawal_amt,
        w.withdrawal_amt / NULLIF(w.withdrawal_count, 0) AS avg_withdrawal_size,
        COALESCE(nc.new_logins, 0) AS new_logins,
        o.total_handle_usd / NULLIF(o.actives, 0) AS handle_per_active
    FROM orders_all_periods AS o
    LEFT JOIN wallet_all_periods AS w
        ON o.period_type = w.period_type AND o.report_date = w.report_date
    LEFT JOIN new_customers_all_periods AS nc
        ON o.period_type = nc.period_type AND o.report_date = nc.report_date
),

joined AS (
    SELECT
        d.report_date,
        -- daily actuals
        d.actives,
        d.contracts_ps_qty,
        d.contracts_ps_amt,
        d.contracts_traded_per_active_qty,
        d.contracts_traded_per_active_amt,
        d.contracts_traded_count,
        d.avg_contract_price,
        d.deposit_count,
        d.deposit_amt,
        d.avg_deposit_size,
        d.withdrawal_count,
        d.withdrawal_amt,
        d.avg_withdrawal_size,
        d.customer_pnl_amt,
        d.fmx_ftus,
        d.new_logins,
        d.handle_per_active,
        -- daily forecasts
        df.actives_forecast,
        df.contracts_ps_qty_forecast,
        df.contracts_ps_amt_forecast,
        df.contracts_traded_per_active_qty_forecast,
        df.contracts_traded_per_active_amt_forecast,
        df.avg_contract_price_forecast,
        df.contracts_traded_count_forecast,
        df.deposit_count_forecast,
        df.deposit_amt_forecast,
        df.avg_deposit_size_forecast,
        df.fmx_ftus_forecast,
        df.handle_forecast,
        df.forecast_mtd_actives,
        -- monthly actuals
        m.actives AS actives_mtd,
        m.contracts_ps_qty AS contracts_ps_qty_mtd,
        m.contracts_ps_amt AS contracts_ps_amt_mtd,
        m.contracts_traded_per_active_qty AS contracts_traded_per_active_qty_mtd,
        m.contracts_traded_per_active_amt AS contracts_traded_per_active_amt_mtd,
        m.contracts_traded_count AS contracts_traded_count_mtd,
        m.avg_contract_price AS avg_contract_price_mtd,
        m.deposit_count AS deposit_count_mtd,
        m.deposit_amt AS deposit_amt_mtd,
        m.avg_deposit_size AS avg_deposit_size_mtd,
        m.withdrawal_count AS withdrawal_count_mtd,
        m.withdrawal_amt AS withdrawal_amt_mtd,
        m.avg_withdrawal_size AS avg_withdrawal_size_mtd,
        m.customer_pnl_amt AS customer_pnl_amt_mtd,
        m.fmx_ftus AS fmx_ftus_mtd,
        m.new_logins AS new_logins_mtd,
        m.handle_per_active AS handle_per_active_mtd,
        -- monthly forecasts
        mf.actives_forecast AS actives_forecast_mtd,
        mf.contracts_ps_qty_forecast AS contracts_ps_qty_forecast_mtd,
        mf.contracts_ps_amt_forecast AS contracts_ps_amt_forecast_mtd,
        mf.contracts_traded_per_active_qty_forecast AS contracts_traded_per_active_qty_forecast_mtd,
        mf.contracts_traded_per_active_amt_forecast AS contracts_traded_per_active_amt_forecast_mtd,
        mf.avg_contract_price_forecast AS avg_contract_price_forecast_mtd,
        mf.contracts_traded_count_forecast AS contracts_traded_count_forecast_mtd,
        mf.deposit_count_forecast AS deposit_count_forecast_mtd,
        mf.deposit_amt_forecast AS deposit_amt_forecast_mtd,
        mf.avg_deposit_size_forecast AS avg_deposit_size_forecast_mtd,
        mf.fmx_ftus_forecast AS fmx_ftus_forecast_mtd,
        mf.handle_forecast AS handle_forecast_mtd,
        -- yearly actuals
        y.actives AS actives_ytd,
        y.contracts_ps_qty AS contracts_ps_qty_ytd,
        y.contracts_ps_amt AS contracts_ps_amt_ytd,
        y.contracts_traded_per_active_qty AS contracts_traded_per_active_qty_ytd,
        y.contracts_traded_per_active_amt AS contracts_traded_per_active_amt_ytd,
        y.contracts_traded_count AS contracts_traded_count_ytd,
        y.avg_contract_price AS avg_contract_price_ytd,
        y.deposit_count AS deposit_count_ytd,
        y.deposit_amt AS deposit_amt_ytd,
        y.avg_deposit_size AS avg_deposit_size_ytd,
        y.withdrawal_count AS withdrawal_count_ytd,
        y.withdrawal_amt AS withdrawal_amt_ytd,
        y.avg_withdrawal_size AS avg_withdrawal_size_ytd,
        y.customer_pnl_amt AS customer_pnl_amt_ytd,
        y.fmx_ftus AS fmx_ftus_ytd,
        y.new_logins AS new_logins_ytd,
        y.handle_per_active AS handle_per_active_ytd,
        -- yearly forecasts
        yf.actives_forecast AS actives_forecast_ytd,
        yf.contracts_ps_qty_forecast AS contracts_ps_qty_forecast_ytd,
        yf.contracts_ps_amt_forecast AS contracts_ps_amt_forecast_ytd,
        yf.contracts_traded_per_active_qty_forecast AS contracts_traded_per_active_qty_forecast_ytd,
        yf.contracts_traded_per_active_amt_forecast AS contracts_traded_per_active_amt_forecast_ytd,
        yf.avg_contract_price_forecast AS avg_contract_price_forecast_ytd,
        yf.contracts_traded_count_forecast AS contracts_traded_count_forecast_ytd,
        yf.deposit_count_forecast AS deposit_count_forecast_ytd,
        yf.deposit_amt_forecast AS deposit_amt_forecast_ytd,
        yf.avg_deposit_size_forecast AS avg_deposit_size_forecast_ytd,
        yf.fmx_ftus_forecast AS fmx_ftus_forecast_ytd,
        yf.handle_forecast AS handle_forecast_ytd,
        -- kyc + installs (day/month/year)
        COALESCE(kr.kyc_checks, 0) AS kyc_checks,
        COALESCE(kr_m.kyc_checks, 0) AS kyc_checks_mtd,
        COALESCE(kr_y.kyc_checks, 0) AS kyc_checks_ytd,
        COALESCE(inst.install_count, 0) AS install_count,
        COALESCE(inst_m.install_count, 0) AS install_count_mtd,
        COALESCE(inst_y.install_count, 0) AS install_count_ytd
    FROM actuals AS d
    LEFT JOIN forecasts AS df
        ON df.period_type = 'day' AND d.report_date = df.report_date
    LEFT JOIN actuals AS m
        ON m.period_type = 'month' AND DATE_TRUNC('month', d.report_date) = m.report_date
    LEFT JOIN forecasts AS mf
        ON mf.period_type = 'month' AND DATE_TRUNC('month', d.report_date) = mf.report_date
    LEFT JOIN actuals AS y
        ON y.period_type = 'year' AND DATE_TRUNC('year', d.report_date) = y.report_date
    LEFT JOIN forecasts AS yf
        ON yf.period_type = 'year' AND DATE_TRUNC('year', d.report_date) = yf.report_date
    LEFT JOIN kyc_rollups AS kr ON kr.period_type = 'day' AND d.report_date = kr.report_date
    LEFT JOIN
        kyc_rollups AS kr_m
        ON kr_m.period_type = 'month' AND DATE_TRUNC('month', d.report_date) = kr_m.report_date
    LEFT JOIN kyc_rollups AS kr_y ON kr_y.period_type = 'year' AND DATE_TRUNC('year', d.report_date) = kr_y.report_date
    LEFT JOIN installs AS inst ON inst.period_type = 'day' AND d.report_date = inst.report_date
    LEFT JOIN
        installs AS inst_m
        ON inst_m.period_type = 'month' AND DATE_TRUNC('month', d.report_date) = inst_m.report_date
    LEFT JOIN
        installs AS inst_y
        ON inst_y.period_type = 'year' AND DATE_TRUNC('year', d.report_date) = inst_y.report_date
    WHERE d.period_type = 'day'
),

pivoted AS (
    SELECT
        'Actives' AS metric,
        report_date,
        actives AS report_day_value,
        actives_forecast AS report_day_forecast,
        CASE
            WHEN actives_forecast = 0 OR actives_forecast IS NULL THEN NULL
            ELSE (actives - actives_forecast) / actives_forecast
        END AS report_day_vs_forecast_pct,
        actives_mtd AS mtd_value,
        actives_forecast_mtd AS mtd_forecast,
        CASE
            WHEN actives_forecast_mtd = 0 OR actives_forecast_mtd IS NULL THEN NULL
            ELSE (actives_mtd - actives_forecast_mtd) / actives_forecast_mtd
        END AS mtd_vs_forecast_pct,
        actives_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Contracts Placed/Sold (Qty)' AS metric,
        report_date,
        contracts_ps_qty AS report_day_value,
        contracts_ps_qty_forecast AS report_day_forecast,
        CASE
            WHEN contracts_ps_qty_forecast = 0 OR contracts_ps_qty_forecast IS NULL THEN NULL
            ELSE (contracts_ps_qty - contracts_ps_qty_forecast) / contracts_ps_qty_forecast
        END AS report_day_vs_forecast_pct,
        contracts_ps_qty_mtd AS mtd_value,
        contracts_ps_qty_forecast_mtd AS mtd_forecast,
        CASE
            WHEN contracts_ps_qty_forecast_mtd = 0 OR contracts_ps_qty_forecast_mtd IS NULL THEN NULL
            ELSE (contracts_ps_qty_mtd - contracts_ps_qty_forecast_mtd) / contracts_ps_qty_forecast_mtd
        END AS mtd_vs_forecast_pct,
        contracts_ps_qty_ytd AS ytd_value,
        contracts_ps_qty_forecast_ytd AS ytd_forecast,
        CASE
            WHEN contracts_ps_qty_forecast_ytd = 0 OR contracts_ps_qty_forecast_ytd IS NULL THEN NULL
            ELSE (contracts_ps_qty_ytd - contracts_ps_qty_forecast_ytd) / contracts_ps_qty_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Contracts Placed/Sold Amount' AS metric,
        report_date,
        contracts_ps_amt AS report_day_value,
        contracts_ps_amt_forecast AS report_day_forecast,
        CASE
            WHEN contracts_ps_amt_forecast = 0 OR contracts_ps_amt_forecast IS NULL THEN NULL
            ELSE (contracts_ps_amt - contracts_ps_amt_forecast) / contracts_ps_amt_forecast
        END AS report_day_vs_forecast_pct,
        contracts_ps_amt_mtd AS mtd_value,
        contracts_ps_amt_forecast_mtd AS mtd_forecast,
        CASE
            WHEN contracts_ps_amt_forecast_mtd = 0 OR contracts_ps_amt_forecast_mtd IS NULL THEN NULL
            ELSE (contracts_ps_amt_mtd - contracts_ps_amt_forecast_mtd) / contracts_ps_amt_forecast_mtd
        END AS mtd_vs_forecast_pct,
        contracts_ps_amt_ytd AS ytd_value,
        contracts_ps_amt_forecast_ytd AS ytd_forecast,
        CASE
            WHEN contracts_ps_amt_forecast_ytd = 0 OR contracts_ps_amt_forecast_ytd IS NULL THEN NULL
            ELSE (contracts_ps_amt_ytd - contracts_ps_amt_forecast_ytd) / contracts_ps_amt_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Contracts per Active (Qty)' AS metric,
        report_date,
        contracts_traded_per_active_qty AS report_day_value,
        contracts_traded_per_active_qty_forecast AS report_day_forecast,
        CASE
            WHEN
                contracts_traded_per_active_qty_forecast = 0 OR contracts_traded_per_active_qty_forecast IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_qty - contracts_traded_per_active_qty_forecast)
                / contracts_traded_per_active_qty_forecast
        END AS report_day_vs_forecast_pct,
        contracts_traded_per_active_qty_mtd AS mtd_value,
        contracts_traded_per_active_qty_forecast_mtd AS mtd_forecast,
        CASE
            WHEN
                contracts_traded_per_active_qty_forecast_mtd = 0 OR contracts_traded_per_active_qty_forecast_mtd IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_qty_mtd - contracts_traded_per_active_qty_forecast_mtd)
                / contracts_traded_per_active_qty_forecast_mtd
        END AS mtd_vs_forecast_pct,
        contracts_traded_per_active_qty_ytd AS ytd_value,
        contracts_traded_per_active_qty_forecast_ytd AS ytd_forecast,
        CASE
            WHEN
                contracts_traded_per_active_qty_forecast_ytd = 0 OR contracts_traded_per_active_qty_forecast_ytd IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_qty_ytd - contracts_traded_per_active_qty_forecast_ytd)
                / contracts_traded_per_active_qty_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Contracts per Active (Amount)' AS metric,
        report_date,
        contracts_traded_per_active_amt AS report_day_value,
        contracts_traded_per_active_amt_forecast AS report_day_forecast,
        CASE
            WHEN
                contracts_traded_per_active_amt_forecast = 0 OR contracts_traded_per_active_amt_forecast IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_amt - contracts_traded_per_active_amt_forecast)
                / contracts_traded_per_active_amt_forecast
        END AS report_day_vs_forecast_pct,
        contracts_traded_per_active_amt_mtd AS mtd_value,
        contracts_traded_per_active_amt_forecast_mtd AS mtd_forecast,
        CASE
            WHEN
                contracts_traded_per_active_amt_forecast_mtd = 0 OR contracts_traded_per_active_amt_forecast_mtd IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_amt_mtd - contracts_traded_per_active_amt_forecast_mtd)
                / contracts_traded_per_active_amt_forecast_mtd
        END AS mtd_vs_forecast_pct,
        contracts_traded_per_active_amt_ytd AS ytd_value,
        contracts_traded_per_active_amt_forecast_ytd AS ytd_forecast,
        CASE
            WHEN
                contracts_traded_per_active_amt_forecast_ytd = 0 OR contracts_traded_per_active_amt_forecast_ytd IS NULL
                THEN NULL
            ELSE
                (contracts_traded_per_active_amt_ytd - contracts_traded_per_active_amt_forecast_ytd)
                / contracts_traded_per_active_amt_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        '# Trades' AS metric,
        report_date,
        contracts_traded_count AS report_day_value,
        contracts_traded_count_forecast AS report_day_forecast,
        CASE
            WHEN contracts_traded_count_forecast = 0 OR contracts_traded_count_forecast IS NULL THEN NULL
            ELSE (contracts_traded_count - contracts_traded_count_forecast) / contracts_traded_count_forecast
        END AS report_day_vs_forecast_pct,
        contracts_traded_count_mtd AS mtd_value,
        contracts_traded_count_forecast_mtd AS mtd_forecast,
        CASE
            WHEN contracts_traded_count_forecast_mtd = 0 OR contracts_traded_count_forecast_mtd IS NULL THEN NULL
            ELSE
                (contracts_traded_count_mtd - contracts_traded_count_forecast_mtd) / contracts_traded_count_forecast_mtd
        END AS mtd_vs_forecast_pct,
        contracts_traded_count_ytd AS ytd_value,
        contracts_traded_count_forecast_ytd AS ytd_forecast,
        CASE
            WHEN contracts_traded_count_forecast_ytd = 0 OR contracts_traded_count_forecast_ytd IS NULL THEN NULL
            ELSE
                (contracts_traded_count_ytd - contracts_traded_count_forecast_ytd) / contracts_traded_count_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Avg. Contract Price' AS metric,
        report_date,
        avg_contract_price AS report_day_value,
        avg_contract_price_forecast AS report_day_forecast,
        CASE
            WHEN avg_contract_price_forecast = 0 OR avg_contract_price_forecast IS NULL THEN NULL
            ELSE (avg_contract_price - avg_contract_price_forecast) / avg_contract_price_forecast
        END AS report_day_vs_forecast_pct,
        avg_contract_price_mtd AS mtd_value,
        avg_contract_price_forecast_mtd AS mtd_forecast,
        CASE
            WHEN avg_contract_price_forecast_mtd = 0 OR avg_contract_price_forecast_mtd IS NULL THEN NULL
            ELSE (avg_contract_price_mtd - avg_contract_price_forecast_mtd) / avg_contract_price_forecast_mtd
        END AS mtd_vs_forecast_pct,
        avg_contract_price_ytd AS ytd_value,
        avg_contract_price_forecast_ytd AS ytd_forecast,
        CASE
            WHEN avg_contract_price_forecast_ytd = 0 OR avg_contract_price_forecast_ytd IS NULL THEN NULL
            ELSE (avg_contract_price_ytd - avg_contract_price_forecast_ytd) / avg_contract_price_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Deposit Count' AS metric,
        report_date,
        deposit_count AS report_day_value,
        deposit_count_forecast AS report_day_forecast,
        CASE
            WHEN deposit_count_forecast = 0 OR deposit_count_forecast IS NULL THEN NULL
            ELSE (deposit_count - deposit_count_forecast) / deposit_count_forecast
        END AS report_day_vs_forecast_pct,
        deposit_count_mtd AS mtd_value,
        deposit_count_forecast_mtd AS mtd_forecast,
        CASE
            WHEN deposit_count_forecast_mtd = 0 OR deposit_count_forecast_mtd IS NULL THEN NULL
            ELSE (deposit_count_mtd - deposit_count_forecast_mtd) / deposit_count_forecast_mtd
        END AS mtd_vs_forecast_pct,
        deposit_count_ytd AS ytd_value,
        deposit_count_forecast_ytd AS ytd_forecast,
        CASE
            WHEN deposit_count_forecast_ytd = 0 OR deposit_count_forecast_ytd IS NULL THEN NULL
            ELSE (deposit_count_ytd - deposit_count_forecast_ytd) / deposit_count_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Deposit Amount' AS metric,
        report_date,
        deposit_amt AS report_day_value,
        deposit_amt_forecast AS report_day_forecast,
        CASE
            WHEN deposit_amt_forecast = 0 OR deposit_amt_forecast IS NULL THEN NULL
            ELSE (deposit_amt - deposit_amt_forecast) / deposit_amt_forecast
        END AS report_day_vs_forecast_pct,
        deposit_amt_mtd AS mtd_value,
        deposit_amt_forecast_mtd AS mtd_forecast,
        CASE
            WHEN deposit_amt_forecast_mtd = 0 OR deposit_amt_forecast_mtd IS NULL THEN NULL
            ELSE (deposit_amt_mtd - deposit_amt_forecast_mtd) / deposit_amt_forecast_mtd
        END AS mtd_vs_forecast_pct,
        deposit_amt_ytd AS ytd_value,
        deposit_amt_forecast_ytd AS ytd_forecast,
        CASE
            WHEN deposit_amt_forecast_ytd = 0 OR deposit_amt_forecast_ytd IS NULL THEN NULL
            ELSE (deposit_amt_ytd - deposit_amt_forecast_ytd) / deposit_amt_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Avg. Deposit Size' AS metric,
        report_date,
        avg_deposit_size AS report_day_value,
        avg_deposit_size_forecast AS report_day_forecast,
        CASE
            WHEN avg_deposit_size_forecast = 0 OR avg_deposit_size_forecast IS NULL THEN NULL
            ELSE (avg_deposit_size - avg_deposit_size_forecast) / avg_deposit_size_forecast
        END AS report_day_vs_forecast_pct,
        avg_deposit_size_mtd AS mtd_value,
        avg_deposit_size_forecast_mtd AS mtd_forecast,
        CASE
            WHEN avg_deposit_size_forecast_mtd = 0 OR avg_deposit_size_forecast_mtd IS NULL THEN NULL
            ELSE (avg_deposit_size_mtd - avg_deposit_size_forecast_mtd) / avg_deposit_size_forecast_mtd
        END AS mtd_vs_forecast_pct,
        avg_deposit_size_ytd AS ytd_value,
        avg_deposit_size_forecast_ytd AS ytd_forecast,
        CASE
            WHEN avg_deposit_size_forecast_ytd = 0 OR avg_deposit_size_forecast_ytd IS NULL THEN NULL
            ELSE (avg_deposit_size_ytd - avg_deposit_size_forecast_ytd) / avg_deposit_size_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Withdrawal Count' AS metric,
        report_date,
        withdrawal_count AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        withdrawal_count_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        withdrawal_count_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Withdrawal Amount' AS metric,
        report_date,
        withdrawal_amt AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        withdrawal_amt_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        withdrawal_amt_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Avg. Withdrawal Size' AS metric,
        report_date,
        avg_withdrawal_size AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        avg_withdrawal_size_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        avg_withdrawal_size_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Customer P&L' AS metric,
        report_date,
        customer_pnl_amt AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        customer_pnl_amt_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        customer_pnl_amt_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'FTUs' AS metric,
        report_date,
        fmx_ftus AS report_day_value,
        fmx_ftus_forecast AS report_day_forecast,
        CASE
            WHEN fmx_ftus_forecast = 0 OR fmx_ftus_forecast IS NULL THEN NULL
            ELSE (fmx_ftus - fmx_ftus_forecast) / fmx_ftus_forecast
        END AS report_day_vs_forecast_pct,
        fmx_ftus_mtd AS mtd_value,
        fmx_ftus_forecast_mtd AS mtd_forecast,
        CASE
            WHEN fmx_ftus_forecast_mtd = 0 OR fmx_ftus_forecast_mtd IS NULL THEN NULL
            ELSE (fmx_ftus_mtd - fmx_ftus_forecast_mtd) / fmx_ftus_forecast_mtd
        END AS mtd_vs_forecast_pct,
        fmx_ftus_ytd AS ytd_value,
        fmx_ftus_forecast_ytd AS ytd_forecast,
        CASE
            WHEN fmx_ftus_forecast_ytd = 0 OR fmx_ftus_forecast_ytd IS NULL THEN NULL
            ELSE (fmx_ftus_ytd - fmx_ftus_forecast_ytd) / fmx_ftus_forecast_ytd
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'New Logins' AS metric,
        report_date,
        new_logins AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        new_logins_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        new_logins_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Handle Per Active' AS metric,
        report_date,
        handle_per_active AS report_day_value,
        handle_forecast / NULLIF(actives_forecast, 0) AS report_day_forecast,
        CASE
            WHEN handle_forecast = 0 OR handle_forecast IS NULL THEN NULL
            ELSE
                (handle_per_active - handle_forecast / NULLIF(actives_forecast, 0))
                / (handle_forecast / NULLIF(actives_forecast, 0))
        END AS report_day_vs_forecast_pct,
        handle_per_active_mtd AS mtd_value,
        handle_forecast_mtd / NULLIF(actives_forecast_mtd, 0) AS mtd_forecast,
        CASE
            WHEN handle_forecast_mtd = 0 OR handle_forecast_mtd IS NULL THEN NULL
            ELSE
                (handle_per_active_mtd - handle_forecast_mtd / NULLIF(actives_forecast_mtd, 0))
                / (handle_forecast_mtd / NULLIF(actives_forecast_mtd, 0))
        END AS mtd_vs_forecast_pct,
        handle_per_active_ytd AS ytd_value,
        handle_forecast_ytd / NULLIF(actives_forecast_ytd, 0) AS ytd_forecast,
        CASE
            WHEN handle_forecast_ytd = 0 OR handle_forecast_ytd IS NULL THEN NULL
            ELSE
                (handle_per_active_ytd - handle_forecast_ytd / NULLIF(actives_forecast_ytd, 0))
                / (handle_forecast_ytd / NULLIF(actives_forecast_ytd, 0))
        END AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'KYC Checks' AS metric,
        report_date,
        kyc_checks AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        kyc_checks_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        kyc_checks_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
    UNION ALL
    SELECT
        'Total Installs' AS metric,
        report_date,
        install_count AS report_day_value,
        NULL AS report_day_forecast,
        NULL AS report_day_vs_forecast_pct,
        install_count_mtd AS mtd_value,
        NULL AS mtd_forecast,
        NULL AS mtd_vs_forecast_pct,
        install_count_ytd AS ytd_value,
        NULL AS ytd_forecast,
        NULL AS ytd_vs_forecast_pct
    FROM joined
)

SELECT
    metric,
    report_date,
    report_day_value,
    report_day_forecast,
    report_day_vs_forecast_pct,
    mtd_value,
    mtd_forecast,
    mtd_vs_forecast_pct,
    ytd_value,
    ytd_forecast,
    ytd_vs_forecast_pct,
    DATEADD('day', -1, report_date) AS activity_date
FROM pivoted
ORDER BY report_date, metric
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.vw_fmx_kpi_pivot_new", "profile_name": "user", "target_name": "default"} */
