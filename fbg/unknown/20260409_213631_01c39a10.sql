-- Query ID: 01c39a10-0212-6cb9-24dd-070319389693
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T21:36:31.079000+00:00
-- Elapsed: 237359ms
-- Environment: FBG

select 
    transaction_account_id,
    'LTD' as period,
    coalesce(sum(case when (transaction_type = 'WITHDRAWAL_COMPLETED' OR (transaction_description ILIKE ANY ('%patron request wire wd via vip am%','%patron request wire withdrawal via vip am%') AND transaction_type = 'FINANCE_CORRECTION_WITHDRAWAL')) then ABS(transaction_amount) end),0) as withdrawals,
    coalesce(sum(case when (transaction_type = 'DEPOSIT' OR (transaction_description ILIKE ANY ('%crediting wire%', '%completing wire%') AND transaction_type = 'FINANCE_CORRECTION_DEPOSIT')) then ABS(transaction_amount) end),0) as deposits,
    withdrawals - deposits as netLoss,
    coalesce(abs(sum(case when transaction_type = 'STAKE'and transaction_casino_game_id is not null then transaction_amount end)),0) as gamesStake,
    coalesce(sum(case when transaction_type = 'SETTLEMENT' and transaction_casino_game_id is not null then transaction_amount end),0) as gamesWinnings,
    coalesce(sum(case when transaction_type = 'FREEBET_STAKE' then transaction_amount end),0) as freebetsStake,
    count(case when transaction_type = 'FREEBET_STAKE' then 1 end) as freebetsCount,
    count(case when transaction_type = 'BONUS_DEPOSIT' then transaction_amount end) as depositBonus
from fbg_analytics_engineering.transactions.transactions_mart
where transaction_account_id in (1395843)
group by all

UNION ALL

select 
    transaction_account_id,
    'YTD' as period,
    coalesce(sum(case when (transaction_type = 'WITHDRAWAL_COMPLETED' OR (transaction_description ILIKE ANY ('%patron request wire wd via vip am%','%patron request wire withdrawal via vip am%') AND transaction_type = 'FINANCE_CORRECTION_WITHDRAWAL')) then ABS(transaction_amount) end),0) as withdrawals,
    coalesce(sum(case when (transaction_type = 'DEPOSIT' OR (transaction_description ILIKE ANY ('%crediting wire%', '%completing wire%') AND transaction_type = 'FINANCE_CORRECTION_DEPOSIT')) then ABS(transaction_amount) end),0) as deposits,
    withdrawals - deposits as netLoss,
    coalesce(abs(sum(case when transaction_type = 'STAKE'and transaction_casino_game_id is not null then transaction_amount end)),0) as gamesStake,
    coalesce(sum(case when transaction_type = 'SETTLEMENT' and transaction_casino_game_id is not null then transaction_amount end),0) as gamesWinnings,
    coalesce(sum(case when transaction_type = 'FREEBET_STAKE' then transaction_amount end),0) as freebetsStake,
    count(case when transaction_type = 'FREEBET_STAKE' then 1 end) as freebetsCount,
    count(case when transaction_type = 'BONUS_DEPOSIT' then transaction_amount end) as depositBonus
from fbg_analytics_engineering.transactions.transactions_mart
where transaction_account_id in (1395843)
    and trans_date_est >= DATE_TRUNC('year', CURRENT_DATE())
group by all
