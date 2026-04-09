-- Query ID: 01c39a1f-0212-6dbe-24dd-0703193baee3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:51:15.584000+00:00
-- Elapsed: 82863ms
-- Environment: FBG

with base as (
select
    v2.account_id, 
    v2.sportsbook_ftu_date_alk, 
    TO_CHAR(v2.SPORTSBOOK_FTU_DATE_ALK, 'YYYY-MM') AS year_month,
    v2.ltv_pred_d90 as v2_d90_pred, 
    v1.d90_ltv_pred as v1_d90_pred,
    v2.cash_bet_amount + v2.d90cash_handle as v2_actual
from fbg_analytics_dev.product_and_customer.SPORTSBOOK_LTV_90DAYS_V2 v2
left join fbg_analytics.product_and_customer.SPORTSBOOK_LTV_90DAYS v1
on v1.account_id = v2.account_id
where 1=1
and v2.sportsbook_ftu_date_alk >= '2024-09-01'
),

cash_handle as (
SELECT
    b.account_id, 
    b.sportsbook_ftu_date_alk,
    b.year_month,
    b.v1_d90_pred,
    b.v2_d90_pred,
    b.v2_actual,
    sum(w.total_cash_stake_by_legs) AS actual
from base b
inner join fbg_analytics_engineering.trading.trading_sportsbook_mart w on b.account_id = w.account_id
where 1=1
and w.wager_placed_time_alk <= dateadd(day,90,date(b.sportsbook_ftu_date_alk))
and w.wager_placed_time_alk >= DATE(b.sportsbook_ftu_date_alk)
and wager_status not in ('REJECTED', 'VOID') 
and wager_channel = 'INTERNET'
group by all
)
select year_month, 
count(account_id) as user_count,
sum(actual) as actual_wager_mart,
sum(v2_actual) as v2_actual_table,
sum(v2_d90_pred) as v2_prediction,
sum(v1_d90_pred) as v1_prediction,
round(sum(v1_d90_pred) / nullif(sum(actual), 0), 3) as v1_pred_to_actual_ratio,
round(sum(v2_d90_pred) / nullif(sum(actual), 0), 3) as v2_pred_to_actual_ratio,
round((sum(v1_d90_pred) - sum(actual)) / nullif(sum(actual), 0) * 100, 1) as v1_pct_error,
round((sum(v2_d90_pred) - sum(actual)) / nullif(sum(actual), 0) * 100, 1) as v2_pct_error,
round(sum(actual) / count(account_id), 2) as actual_per_user,
round(sum(v1_d90_pred) / count(account_id), 2) as v1_pred_per_user,
round(sum(v2_d90_pred) / count(account_id), 2) as v2_pred_per_user
from cash_handle
group by 1
order by 1 asc
