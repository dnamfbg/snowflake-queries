-- Query ID: 01c399db-0212-644a-24dd-0703192c30cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T20:43:28.502000+00:00
-- Elapsed: 75357ms
-- Environment: FBG

With SetCustId as (

select c.acco_id as acco_id
from fbg_analytics_engineering.customers.customer_mart c 
where acco_id = '4315885'

),

paymentmethods as (
select p.acco_id, p.type, min(p.dw_creation_date) as reg_date
from fbg_source.osb_source.payment_options p
group by all
),

depositstemp as (

select 


  id.acco_id,
case when d.payment_brand = 'CARD'  then split_part(split_part(split_part(split_part(split_part(d.response_json,'lastDigits',2),',',1),':',2),'"',2),'\\',1) when d.payment_brand = 'VENMO' then split_part(split_part(d.response_json,'username\\\\\\":\\\\\\"',2),'\\',1) when d.payment_brand = 'TERMINAL' then split_part(split_part(lower(d.response_json),'terminalid\\":',2),'}',1) when d.payment_brand = 'PAYPAL' then split_part(split_part(regexp_replace(D.response_json,'\\\\"','"'),'username\\\\":\\\\"',2),'\\',1) when 
d.payment_brand = 'APPLEPAY' then split_part(split_part(split_part(split_part(split_part(d.response_json,'lastDigits',2),',',1),':',2),'"',2),'\\',1) when
d.payment_brand = 'MAZOOMA' then parse_json (db.mazooma: ach: lastDigits::varchar) when 
d.payment_brand = 'TRUSTLY' then split_part(split_part(regexp_replace(d.response_json,'\\\\',''),'accountNumber":"',2),'"',1) when 
d.payment_brand = 'PAYSAFECASH' then split_part(split_part(db.paysafecash,'Id":"',2),'"',1)
end as LastDigitst,

--d.response_json,
--split_part(regexp_replace(d.response_json,'\\\\',''),'paymentProviderId',2) as test,
--regexp_replace(d.response_json,'\\\\\\\\\\\\\\\\\\\\\\\\\\\\"','"') as test,
case when d.payment_brand = 'CARD' then concat(d.payment_brand,' - ', split_part(split_part(d.response_json,'cardCategory\\":\\"',2),'\\',1))  
when d.payment_brand = 'MAZOOMA' then split_part(split_part(split_part(db.mazooma,'bankName":',2),'"',2),'"',1)
when d.payment_brand = 'TRUSTLY' then split_part(split_part(split_part(regexp_replace(d.response_json,'\\\\',''),'paymentProviderId',2),'name":"',2),'"',1)
else d.payment_brand
end as MethodType,
  split_part(split_part(d.response_json,'cardCategory\\":\\"',2),'\\',1) as CardCategory,
  concat(split_part(split_part(split_part(d.response_json,'cardExpiry',2),'month\\":\\"',2),'\\',1),'-', split_part(split_part(split_part(d.response_json,'cardExpiry',2),'year\\":\\"',2),'\\',1)) as CardExpiry,
  split_part(split_part(split_part(d.response_json,'cardExpiry',2),'year\\":\\"',2),'\\',1) as CardExpiryYear,
sum(case when d.status like '%SUCCESS%' then d.amount else 0 end)  as Amount_Deposits,
to_date(p.reg_date) as Date_Registered,
count(distinct d.id) as NoOfDeposits,
case when lastdigitst = '' then MethodType else lastdigitst end as lastdigits,
--d.id,
 -- d.response_json,
  




from setcustid id
left join  fbg_source.osb_source.deposits d on d.acco_id = id.acco_id
left join fbg_source.osb_source.deposits_breakdown_system_responses db on db.id = d.id
left join paymentmethods p on (p.acco_id = id.acco_id and p.type = d.payment_brand )

where d.status like '%SUCCESS%'
 
group by all
)
,

withdrawalstemp as (
select 
id.acco_id,
case when w.payment_brand = 'CARD' then concat(w.payment_brand,' - ', split_part(split_part(w.response_json,'cardCategory\\":\\"',2),'\\',1))
when w.payment_brand = 'MAZOOMA' then split_part(split_part(regexp_replace(w.response_json,'\\\\',''),'bankName":"',2),'"',1) 
when w.payment_brand = 'TRUSTLY' then split_part(split_part(split_part(regexp_replace(w.response_json,'\\\\',''),'paymentProviderId',2),'"name":"',2),'"',1)
else w.payment_brand end as payment_brand_test,

case when w.payment_brand = 'CARD'  then split_part(split_part(split_part(split_part(split_part(w.response_json,'lastDigits',2),',',1),':',2),'"',2),'\\',1) when w.payment_brand = 'VENMO' then split_part(split_part(regexp_replace(w.response_json,'\\\\"','"'),'username":"',2),'\\',1) when w.payment_brand = 'TERMINAL' then split_part(split_part(lower(w.response_json),'terminalid\\":',2),'}',1) when w.payment_brand = 'PAYPAL' then split_part(split_part(regexp_replace(w.response_json,'\\\\"','"'),'username\\\\":\\\\"',2),'\\',1) when 
w.payment_brand = 'APPLEPAY' then split_part(split_part(split_part(split_part(split_part(w.response_json,'lastDigits',2),',',1),':',2),'"',2),'\\',1) when
w.payment_brand = 'MAZOOMA' then split_part(split_part(regexp_replace(w.response_json,'\\\\',''),'lastDigits":"',2),'"',1)  when
w.payment_brand = 'TRUSTLY' then split_part(split_part(regexp_replace(w.response_json,'\\\\',''),'accountNumber":"',2),'"',1)
end as LastDigitst,
case when lastdigitst = '' then payment_brand_test else lastdigitst end as lastdigits,


sum( case when w.status like '%COMPLETED%' then w.amount else 0 end ) as Successful_Withdrawals,
count(distinct w.id) as NoOfWithdrawals

from setcustid id
left join fbg_source.osb_source.withdrawals w on w.account_id = id.acco_id
--left join fbg_source.osb_source.withdrawals_breakdown_system_responses wb on wb.id = w.id
where w.status like '%COMPLETED%'
group by all
)

select 
d.acco_id,d.methodtype, d.lastdigits,
--d.test,d.response_json, 
d.cardexpiry,
round(d.amount_deposits,2) as amount_deposits
,round(w.successful_withdrawals,2) as successful_withdrawals
,d.Date_Registered
,d.NoOfDeposits
,w.NoOfWithdrawals
from depositstemp d 
Left Join withdrawalstemp w on (w.lastdigits = d.lastdigits and w.Payment_Brand_test = d.methodtype)
group by all
