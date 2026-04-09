-- Query ID: 01c39a1e-0212-67a9-24dd-0703193b98af
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:50:31.078000+00:00
-- Elapsed: 191ms
-- Environment: FBG

select account_id,
generic_bonus_entitlement_json:minStakes[0].amount::NUMBER AS min_stake_amount,
sum(case when is_profit_boost_token = TRUE then total_cash_stake_by_legs else 0 end) as BoostHandle,
sum(case when is_profit_boost_token = FALSE then total_cash_stake_by_legs else 0 end) as QualiHandle,
sum(case when is_profit_boost_token = FALSE and leg_result_type in ('VOID', 'PUSH') then total_cash_stake_by_legs else 0 end) as VoidedPushedQualiHandle,
GREATEST(Min_Stake_Amount - QualiHandle, 0) as StakeLeft
from
fbg_analytics_engineering.trading.trading_sportsbook_mart a
left join fbg_analytics_engineering.product.promotions b
on b.id = a.promotion_id
and b.id = 3713900
where
a.promotion_id  = 3713900
and wager_status = 'SETTLED'
and wager_channel = 'INTERNET'
group by all
;
