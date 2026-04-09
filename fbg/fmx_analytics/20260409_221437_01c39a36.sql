-- Query ID: 01c39a36-0212-644a-24dd-070319413b97
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:14:37.178000+00:00
-- Elapsed: 193813ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.int_fmx_trading_activity_daily
    
    
    
    as (with date_bounds as (
    select
        min(trans_date_alk) as min_report_date,
        current_date as max_report_date
    from FMX_ANALYTICS.CUSTOMER.int_fmx_order_metrics_daily
    where trans_date_alk is not null
),

calendar as (
    select d.date_id_alk as report_date
    from FMX_ANALYTICS.DIMENSIONS.dim_date as d
    cross join date_bounds as b
    where d.date_id_alk between b.min_report_date and b.max_report_date
),

daily_metrics as (
    select
        trans_date_alk as report_date,
        coalesce(is_test, 0) as is_test,
        sum(coalesce(total_contracts_buy_qty, 0)) as contracts_placed_qty,
        sum(coalesce(total_contracts_sold_qty, 0)) as contracts_sold_qty,
        sum(coalesce(total_contracts_buy_qty, 0) + coalesce(total_contracts_sold_qty, 0)) as contract_traded_qty,
        sum(coalesce(total_order_buys, 0)) as contracts_placed_amt,
        sum(coalesce(total_order_sold, 0)) as contracts_sold_amt,
        sum(coalesce(total_order_buys, 0)) + sum(coalesce(total_order_sold, 0)) as contract_traded_amt,
        sum(coalesce(total_order_buys_user_count, 0)) as contracts_placed_user_count,
        sum(coalesce(total_order_sold_user_count, 0)) as contracts_sold_user_count,
        sum(coalesce(total_order_buys_user_count, 0) + coalesce(total_order_sold_user_count, 0))
            as contract_traded_user_count,
        sum(coalesce(total_promotions, 0)) as promotions_amt,
        sum(coalesce(total_promotions_count, 0)) as promotions_count,
        sum(coalesce(total_order_buy_fees, 0) + coalesce(total_order_sale_fees, 0)) as trade_fee_amt,
        sum(coalesce(
            revenue_amt_excl_promotions, coalesce(total_order_fee_fmx_amt, 0)
            + coalesce(total_deposit_fees, 0)
        )) as revenue_amt_excl_promotions,
        sum(coalesce(
            revenue_amt, coalesce(total_order_fee_fmx_amt, 0) + coalesce(total_deposit_fees, 0)
            - coalesce(total_promotions, 0)
        )) as revenue_amt,
        sum(total_deposits) as deposit_amt,
        sum(total_deposit_count) as deposit_txn_count,
        sum(total_deposit_user_count) as deposit_user_count,
        sum(total_deposit_fees) as deposit_fee_amt,
        sum(total_withdrawals) as withdrawal_amt,
        sum(total_withdrawal_count) as withdrawal_txn_count,
        sum(total_withdrawal_user_count) as withdrawal_user_count,
        sum(coalesce(customer_pnl_amt, 0)) as customer_pnl_amt,
        sum(coalesce(total_order_buy_count, 0)) as contracts_placed_count,
        sum(coalesce(total_order_sold_count, 0)) as contracts_sold_count,
        sum(coalesce(total_order_buy_count, 0) + coalesce(total_order_sold_count, 0)) as contract_traded_count,
        sum(coalesce(total_order_fee_fmx_amt, 0)) as trade_fee_amt_fmx,
        sum(coalesce(total_order_fee_provider_amt, 0)) as trade_fee_amt_provider,
        sum(coalesce(attempted_order_buy_count, 0)) as attempted_order_buy_count,
        sum(coalesce(attempted_order_sold_count, 0)) as attempted_order_sold_count,
        sum(coalesce(attempted_order_buy_count, 0) + coalesce(attempted_order_sold_count, 0))
            as attempted_order_total_count,
        sum(coalesce(total_order_buy_count, 0) + coalesce(total_order_sold_count, 0)) as successful_order_total_count,
        sum(coalesce(total_order_buy_count, 0) + coalesce(total_order_sold_count, 0)) as trade_transaction_count,
        count(
            distinct case
                when coalesce(total_order_buy_count, 0) > 0 or coalesce(total_order_sold_count, 0) > 0 then acco_id
            end
        ) as actives,
        count(distinct case when total_deposits > 0 then acco_id end) as deposit_users
    from FMX_ANALYTICS.CUSTOMER.int_fmx_order_metrics_daily
    group by 1, 2
),

active_accounts as (
    select distinct
        trans_date_alk as report_date,
        acco_id,
        coalesce(is_test, 0) as is_test
    from FMX_ANALYTICS.CUSTOMER.int_fmx_order_metrics_daily
    where
        total_order_buy_count > 0
        or total_order_sold_count > 0
),

balance_snapshots as (
    select
        bal.acco_id,
        bal.cash_balance,
        act.is_test,
        convert_timezone('UTC', 'America/Anchorage', bal.trans_date) as trans_date_alk,
        date(convert_timezone('UTC', 'America/Anchorage', bal.trans_date)) as report_date
    from FMX_ANALYTICS.STAGING.stg_transaction_balance_info as bal
    inner join active_accounts as act
        on
            bal.acco_id = act.acco_id
            and act.report_date = date(convert_timezone('UTC', 'America/Anchorage', bal.trans_date))
    qualify row_number() over (
        partition by bal.acco_id, date(convert_timezone('UTC', 'America/Anchorage', bal.trans_date))
        order by bal.trans_date desc
    ) = 1
),

sum_balance as (
    select
        report_date,
        is_test,
        sum(cash_balance) as customer_balance
    from balance_snapshots
    group by 1, 2
),

test_dim as (
    select 0 as is_test
    union all
    select 1 as is_test
),

trade_fees_daily as (
    select
        trans_date_alk as report_date,
        0 as is_test,
        sum(total_trade_fee_amt) as trade_fee_amt,
        sum(trade_fee_amt_fmx) as trade_fee_amt_fmx,
        sum(trade_fee_amt_provider) as trade_fee_amt_provider
    from FMX_ANALYTICS.CUSTOMER.int_fmx_trade_fees_daily
    group by 1, 2
),

order_collateral as (
    select
        s.link_trans_ref as order_id,
        date(convert_timezone('UTC', 'America/Anchorage', s.trans_date)) as report_date,
        coalesce(a.is_test_account, 0) as is_test,
        abs(s.amount) as collateral_amt
    from FMX_ANALYTICS.STAGING.stg_account_statements_fmx as s
    left join FMX_ANALYTICS.STAGING.stg_fmx_accounts as a
        on s.acco_id::varchar = a.acco_id
    where upper(s.trans) = 'FEX_ORDER_INITIATED'
),

settled_orders as (
    select distinct link_trans_ref as order_id
    from FMX_ANALYTICS.STAGING.stg_account_statements_fmx
    where upper(trans) = 'FEX_ORDER_SETTLED'
),

open_order_liability as (
    select
        oc.report_date,
        oc.is_test,
        sum(oc.collateral_amt) as total_open_order_amt
    from order_collateral as oc
    left join FMX_ANALYTICS.STAGING.stg_fmx_order_status as os
        on oc.order_id = os.fbg_order_id
    where
        coalesce(upper(os.ord_status), 'NEW') not in ('REJECTED', 'CANCELLED')
        and coalesce(upper(os.ord_status), 'NEW') = 'NEW'
    group by 1, 2
),

executed_unsettled_liability as (
    select
        oc.report_date,
        oc.is_test,
        sum(oc.collateral_amt) as total_executed_unsettled_amt
    from order_collateral as oc
    left join FMX_ANALYTICS.STAGING.stg_fmx_order_status as os
        on oc.order_id = os.fbg_order_id
    left join settled_orders as so
        on oc.order_id = so.order_id
    where
        coalesce(upper(os.ord_status), 'NEW') = 'TRADE'
        and so.order_id is null
    group by 1, 2
),

enriched as (
    select
        cal.report_date,
        td.is_test,
        coalesce(dm.contracts_placed_qty, 0) as contracts_placed_qty,
        coalesce(dm.contracts_sold_qty, 0) as contracts_sold_qty,
        coalesce(dm.contract_traded_qty, 0) as contract_traded_qty,
        coalesce(dm.contracts_placed_amt, 0) as contracts_placed_amt,
        coalesce(dm.contracts_sold_amt, 0) as contracts_sold_amt,
        coalesce(dm.contract_traded_amt, 0) as contract_traded_amt,
        coalesce(dm.contracts_placed_user_count, 0) as contracts_placed_user_count,
        coalesce(dm.contracts_sold_user_count, 0) as contracts_sold_user_count,
        coalesce(dm.contract_traded_user_count, 0) as contract_traded_user_count,
        coalesce(dm.promotions_amt, 0) as promotions_amt,
        coalesce(dm.promotions_count, 0) as promotions_count,
        coalesce(tf.trade_fee_amt, dm.trade_fee_amt, 0) as trade_fee_amt,
        coalesce(tf.trade_fee_amt_fmx, dm.trade_fee_amt_fmx, 0) as trade_fee_amt_fmx,
        coalesce(tf.trade_fee_amt_provider, dm.trade_fee_amt_provider, 0) as trade_fee_amt_provider,
        coalesce(dm.deposit_amt, 0) as deposit_amt,
        coalesce(dm.deposit_txn_count, 0) as deposit_txn_count,
        coalesce(dm.deposit_user_count, 0) as deposit_user_count,
        coalesce(dm.deposit_fee_amt, 0) as deposit_fee_amt,
        coalesce(dm.withdrawal_amt, 0) as withdrawal_amt,
        coalesce(dm.withdrawal_txn_count, 0) as withdrawal_txn_count,
        coalesce(dm.withdrawal_user_count, 0) as withdrawal_user_count,
        coalesce(dm.deposit_users, 0) as deposit_users,
        coalesce(dm.actives, 0) as actives,
        coalesce(sb.customer_balance, 0) as customer_balance,
        coalesce(dm.customer_pnl_amt, 0) as customer_pnl_amt,
        coalesce(dm.contracts_placed_count, 0) as contracts_placed_count,
        coalesce(dm.contracts_sold_count, 0) as contracts_sold_count,
        coalesce(dm.contract_traded_count, 0) as contract_traded_count,
        coalesce(dm.trade_transaction_count, 0) as trade_transaction_count,
        coalesce(dm.attempted_order_buy_count, 0) as attempted_order_buy_count,
        coalesce(dm.attempted_order_sold_count, 0) as attempted_order_sold_count,
        coalesce(dm.attempted_order_total_count, 0) as attempted_order_total_count,
        coalesce(dm.successful_order_total_count, 0) as successful_order_total_count,
        coalesce(ol.total_open_order_amt, 0) as total_open_order_amt,
        coalesce(el.total_executed_unsettled_amt, 0) as total_executed_unsettled_amt,
        coalesce(
            coalesce(tf.trade_fee_amt_fmx, dm.trade_fee_amt_fmx, 0) + coalesce(dm.deposit_fee_amt, 0),
            0
        ) as revenue_amt_excl_promotions,
        coalesce(
            coalesce(tf.trade_fee_amt_fmx, dm.trade_fee_amt_fmx, 0) + coalesce(dm.deposit_fee_amt, 0)
            - coalesce(dm.promotions_amt, 0),
            0
        ) as revenue_amt
    from calendar as cal
    cross join test_dim as td
    left join daily_metrics as dm
        on
            cal.report_date = dm.report_date
            and td.is_test = dm.is_test
    left join sum_balance as sb
        on
            cal.report_date = sb.report_date
            and td.is_test = sb.is_test
    left join trade_fees_daily as tf
        on
            cal.report_date = tf.report_date
            and td.is_test = tf.is_test
    left join open_order_liability as ol
        on
            cal.report_date = ol.report_date
            and td.is_test = ol.is_test
    left join executed_unsettled_liability as el
        on
            cal.report_date = el.report_date
            and td.is_test = el.is_test
)

select
    report_date,
    is_test,
    coalesce(contracts_placed_qty, 0) as contracts_placed_qty,
    coalesce(contracts_sold_qty, 0) as contracts_sold_qty,
    coalesce(contract_traded_qty, 0) as contract_traded_qty,
    coalesce(contracts_placed_amt, 0) as contracts_placed_amt,
    coalesce(contracts_sold_amt, 0) as contracts_sold_amt,
    coalesce(contract_traded_amt, 0) as contract_traded_amt,
    coalesce(contracts_placed_user_count, 0) as contracts_placed_user_count,
    coalesce(contracts_sold_user_count, 0) as contracts_sold_user_count,
    coalesce(contract_traded_user_count, 0) as contract_traded_user_count,
    coalesce(promotions_amt, 0) as promotions_amt,
    coalesce(promotions_count, 0) as promotions_count,
    coalesce(trade_fee_amt, 0) as trade_fee_amt,
    coalesce(trade_fee_amt_fmx, 0) as trade_fee_amt_fmx,
    coalesce(trade_fee_amt_provider, 0) as trade_fee_amt_provider,
    coalesce(contract_traded_amt, 0) + coalesce(trade_fee_amt, 0) as total_handle_amt,
    coalesce(revenue_amt_excl_promotions, 0) as revenue_amt_excl_promotions,
    coalesce(revenue_amt, 0) as revenue_amt,
    coalesce(deposit_amt, 0) as deposit_amt,
    coalesce(deposit_txn_count, 0) as deposit_txn_count,
    coalesce(deposit_user_count, 0) as deposit_user_count,
    coalesce(deposit_fee_amt, 0) as deposit_fee_amt,
    coalesce(withdrawal_amt, 0) as withdrawal_amt,
    coalesce(withdrawal_txn_count, 0) as withdrawal_txn_count,
    coalesce(withdrawal_user_count, 0) as withdrawal_user_count,
    coalesce(deposit_users, 0) as deposit_users,
    coalesce(deposit_amt, 0) / nullif(coalesce(deposit_user_count, 0), 0) as avg_deposit_amt,
    coalesce(actives, 0) as actives,
    coalesce(contract_traded_qty, 0) / nullif(coalesce(actives, 0), 0) as contract_traded_per_active,
    coalesce(revenue_amt, 0) / nullif(coalesce(actives, 0), 0) as revenue_per_active,
    coalesce(customer_balance, 0) as customer_balance,
    coalesce(customer_pnl_amt, 0) as customer_pnl_amt,
    coalesce(contracts_placed_count, 0) as contracts_placed_count,
    coalesce(contracts_sold_count, 0) as contracts_sold_count,
    coalesce(contract_traded_count, 0) as contract_traded_count,
    coalesce(trade_transaction_count, 0) as trade_transaction_count,
    coalesce(attempted_order_buy_count, 0) as attempted_order_buy_count,
    coalesce(attempted_order_sold_count, 0) as attempted_order_sold_count,
    coalesce(attempted_order_total_count, 0) as attempted_order_total_count,
    coalesce(successful_order_total_count, 0) as successful_order_total_count,
    coalesce(successful_order_total_count, 0) / nullif(coalesce(attempted_order_total_count, 0), 0)
        as order_conversion_rate,
    coalesce(total_open_order_amt, 0) as total_open_order_amt,
    coalesce(total_executed_unsettled_amt, 0) as total_executed_unsettled_amt
from enriched
where coalesce(is_test, 0) = 0
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.int_fmx_trading_activity_daily", "profile_name": "user", "target_name": "default"} */
