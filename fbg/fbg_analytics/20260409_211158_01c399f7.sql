-- Query ID: 01c399f7-0212-6dbe-24dd-07031932b803
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:11:58.753000+00:00
-- Elapsed: 961ms
-- Environment: FBG

select
    date(date_trunc('month', sportsbook_ftu_date_alk)) as sbk_month,
    date(date_trunc('month', casino_ftu_date_alk)) as cas_month,
    first_bet_state as sbk_state,
    first_casino_state as cas_state,
    first_product,
    acquisition_channel,
    --first_sport,
    count(acco_id),
    sum(pred_gp_18mo_total_final) as GP,
    sum(pred_gp_18mo_sbk_final) as GP_SBK,
    sum(pred_gp_18mo_oc_final) as GP_OC,
    sum(first_bet_amount),
    sum(first_deposit_amount),
    sum(acq_cost) as CAC,
    sum(acq_cost_estimated) as CAC_est,
    case
        when first_product = 'SBK' then sbk_month else cas_month
        end as ftu_month
from fbg_analytics.product_and_customer.acquisition_customer_mart
where
    is_test_account = FALSE AND ftu_month >= '2025-01-01'
group by
    sbk_month, cas_month, sbk_state, cas_state, first_product, acquisition_channel
