-- Query ID: 01c399d8-0212-6dbe-24dd-0703192b58c7
-- Database: FBG_CUSTOMER_SERVICE
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:40:13.235000+00:00
-- Elapsed: 44264ms
-- Environment: FBG

select transaction_account_id,
coalesce(sum(case when (transaction_type = 'WITHDRAWAL_COMPLETED' OR (transaction_description ILIKE ANY ('%patron request wire wd via vip am%','%patron request wire withdrawal via vip am%') AND transaction_type = 'FINANCE_CORRECTION_WITHDRAWAL')) then ABS(transaction_amount) end),0) as withdrawals,
coalesce(sum(case when (transaction_type = 'DEPOSIT' OR (transaction_description ILIKE ANY ('%crediting wire%', '%completing wire%') AND transaction_type = 'FINANCE_CORRECTION_DEPOSIT')) then ABS(transaction_amount) end),0) as deposits,
coalesce(abs(sum(case when transaction_type = 'STAKE'and transaction_casino_game_id is not null then transaction_amount end)),0) as gamesStake,
coalesce(sum(case when transaction_type = 'SETTLEMENT' and transaction_casino_game_id is not null then transaction_amount end),0) as gamesWinnings,
coalesce(sum(case when transaction_type = 'FREEBET_STAKE' then transaction_amount end),0) as freebetsStake,
count(case when transaction_type = 'FREEBET_STAKE' then 1 end) as freebetsCount,
count(case when transaction_type = 'BONUS_DEPOSIT' then transaction_amount end) as depositBonus
from fbg_analytics_engineering.transactions.transactions_mart
where transaction_account_id in (2355485)
group by transaction_account_id
