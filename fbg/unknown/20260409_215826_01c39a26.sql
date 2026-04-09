-- Query ID: 01c39a26-0212-67a8-24dd-0703193d2ae7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:58:26.155000+00:00
-- Elapsed: 39497ms
-- Environment: FBG

With SetCustId as (
select id as acco_id
from fbg_source.osb_source.accounts 
where id = '331653'
),


DateRange as (
select *
from fbg_source.osb_source.account_statements s
where s.trans_date >= '2025-06-001'
and   s.trans_date <= '2026-06-001'
)

,
Amount as 
(
select
id.acco_id,
s.id ,
s.trans_date ,
s.trans ,
s.description ,
s.trans_ref,
Case when s.trans in ('STAKE','SETTLEMENT') then split_part(split_part(s.trans_ref,'-',2),'-',1) when s.trans like 'FREE%' then split_part(split_part(s.trans_ref,'-P-',2),'-',1) else s.trans_ref end as TransactionId,
s.amount,
s.balance,
cs.session_id,
s.jurisdictions_id,
cs.stake as CasinoCashStake,
cs.payout as CasinoPayout,
cs.bet_count as number_of_bets,
cs.session_start_time_alk as session_start_time,
g.game_name as Casino_Game,
Case when cs.session_id is not null then row_number() over (partition by cs.session_id order by s.trans_date desc) else 1 end as RowN

from setCustId id
left join DateRange s on id.acco_id = s.acco_id
left join fbg_analytics_engineering.casino.casino_transactions_mart cb on cb.bet_id =  s.bet_id
left join fbg_analytics_engineering.casino.casino_sessions_mart cs on cs.session_id = cb.session_id
left join fbg_analytics_engineering.casino.casino_game_details g on g.game_id = cs.game_id
where --cs.session_id is not null AND 
upper(s.trans) not like '%FREE%' and upper(s.trans) not like '%FAILED%' 
),

CasinoStake as (
select session_id,
sum(abs(amount)) as Total_Stake
from amount
where session_id is not null and trans <> 'SETTLEMENT'
group by all),

finalamount as(
select a.*, c.Total_stake
from amount a
left join casinostake c on a.session_id = c.session_id
where rowN = 1

)
--select * from finalamount

select 
id.acco_id,
--fa.trans_ref,
fa.TransactionID,
--case when fa.session_id is null then fa.id else fa.session_id end as ID,
case when fa.session_id is null then fa.trans_date else fa.session_start_time end as Trans_Date,
case when fa.session_id is null then fa.trans else 'Casino Session' end as TypeOfTrans,
case when fa.session_id is null then fa.description else fa.casino_game end as description,
j.jurisdiction_name,
round(fa.CasinoCashStake,2) as CasinoLosses,
round(fa.CasinoPayout,2) as CasinoWins,
fa.number_of_bets as CasBets,
round(case when fa.session_id is null then abs(fa.amount) else fa.total_stake end,2) as TotalStake,
round(case when fa.session_id is null then fa.amount else fa.CasinoPayout - fa.CasinoCashStake end,2) as NetProfit,
round(case when fa.session_id is null then fa.balance else fa.balance end,2) as balance

--cs.session_id,
--cs.total_cash_stake,
--cs.name as Casino_Game

from setcustid id 
--left join DateRange s on id.acco_id = s.acco_id
left join FinalAmount Fa on (fa.acco_id = id.acco_id )
--left join fbg_reports.casino.casino_bet_activity cb on cb.bet_id =  fa.bet_id
--left join fbg_reports.casino.casino_session_activity cs on cs.session_id = cb.session_id

Left Join fbg_source.osb_source.jurisdictions j on j.id = fa.jurisdictions_id
where Upper(TypeOfTrans) not like '%FREE%' and typeoftrans not like '%PENDING%' and typeoftrans not in ('DEPOSIT_ABANDONED','DEPOSIT_FAILED')
group by all
order by trans_date asc
