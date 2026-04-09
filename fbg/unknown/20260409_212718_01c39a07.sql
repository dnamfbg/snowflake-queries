-- Query ID: 01c39a07-0212-67a9-24dd-0703193606a3
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:27:18.648000+00:00
-- Elapsed: 110963ms
-- Environment: FBG

With SetCustId as (
select id as acco_id
from fbg_source.osb_source.accounts 
where acco_id = '4494079'

),

successfuldeposits as (

select d.*,
row_number() over(partition by d.acco_id order by d.dw_creation_date asc) as DepNo
from SetCustID id 
left join fbg_source.osb_source.deposits d on d.acco_id = id.acco_id
where lower(status) = 'deposit_success'),

firstdeposit as (
select * from successfuldeposits
where depno = 1
),

successfuldepositsgrouped as 
(
select acco_id,
sum(amount) as amount

from successfuldeposits
group by all

),

successfulwithdrawals as (

select w.*
from SetCustId id
left join fbg_source.osb_source.withdrawals w on w.account_id = id.acco_id
where lower(status) = 'withdrawal_completed'),

successfulwithdrawalsgrouped as (
select account_id, sum(amount) as amount
from successfulwithdrawals
group by all
),

Allbets as (
select b.acco_id,
sum(b.total_stake) as stake
from setcustid id
left join fbg_source.osb_source.bets b on b.acco_id = id.acco_id
group by all
),

AllCasbets as (
select c.acco_id,
sum(c.stake) as stake
from setcustid id
left join fbg_analytics_engineering.casino.casino_sessions_mart c on c.acco_id = id.acco_id
where c.fund_type = 'CASH'
group by all
)


select 
a.email,
a.name,
lower(u.amelco_id) as amelco_id,
a.id,
split_part(split_part(a.kyc_info,'dob":"',2),'"',1) as DOB,
split_part(split_part(a.contact_details,'address1":"',2),'"',1) as Address1,
split_part(split_part(a.contact_details,'address2":"',2),'"',1) as Address2,
split_part(split_part(a.contact_details,'address3":"',2),'"',1) as Address3,
split_part(split_part(a.contact_details,'address4":"',2),'"',1) as Address4,
split_part(split_part(a.contact_details,'postCode":"',2),'"',1) as Postcode,
split_part(split_part(a.contact_details,'phone1":"',2),'"',1) as PhoneNo,
to_date(u.registration_date_est) as Registration_Date_Est,
to_date(min(d.created)) as First_Successful_Deposit,
round(fd.amount,2) First_Deposit_Amount,
round(dg.amount,2) as Total_Successful_Deposits,
to_date(min(w.initiated_at)) as First_Successful_Withdrawal,
round(wg.amount,2) as Total_Successful_Withdrawals,
round(b.stake,2) as Total_SB_Wager,
round(cb.stake,2) as Total_Cas_Wager




from SetCustID id 
left join fbg_source.osb_source.accounts a on a.id = id.acco_id
left join fbg_analytics_engineering.customers.customer_mart u on u.acco_id = a.id
left join successfuldeposits d on d.acco_id = a.id
left join firstdeposit fd on fd.acco_id = d.acco_id
left join successfuldepositsgrouped dg on dg.acco_id = id.acco_id
left join successfulwithdrawals w on w.account_id = a.id
left join successfulwithdrawalsgrouped wg on wg.account_id = id.acco_id
left join allbets b on b.acco_id = id.acco_id
left join allcasbets cb on cb.acco_id = id.acco_id
group by all;
