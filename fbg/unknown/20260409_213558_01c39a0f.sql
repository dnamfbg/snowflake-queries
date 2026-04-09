-- Query ID: 01c39a0f-0212-6cb9-24dd-0703193892d7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:35:58.076000+00:00
-- Elapsed: 2926ms
-- Environment: FBG

with wdmarpw as (
select 
date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as date,  
w.user_id, 
w.decision_source,
w.decision_category,
case 
when route_name in ('First Time Withdrawals' ,'Paypal / Venmo FTWs','First Time Withdrawals Casino States No Sports') then 'First Time Withdrawals'
ELSE route_name
END AS "actualRoute"
FROM FBG_SOURCE.SIFT.WORKFLOW_METRICS w
where w.decision_source = 'manual'),


false as (
select 
date_trunc('day', date) as day, "actualRoute",
count(user_ID) as Totalpends, 
count_if(( decision_category = 'accept')) as totalpendaccept,
totalpendaccept/totalpends as acceptrate, count(distinct user_id) as users,
count_if(( decision_category = 'block')) as totalpendblock,
totalpendblock/totalpends as blockrate
from wdmarpw
where (day >= ('2025-04-09 21:35:57')::timestamp AND day < ('2026-04-09 21:35:57')::timestamp) 
group by all 
ORDER BY day DESC),


total as (
select 
date_trunc('day', date) as day, 
count(user_ID) as totalwds
from wdmarpw
where (day >= ('2025-04-09 21:35:57')::timestamp AND day < ('2026-04-09 21:35:57')::timestamp) 
group by all 
ORDER BY day DESC),

final as(
SELECT f.day as "Week", f."actualRoute" as "Route", f.totalpends as "WDs per Route", f.users as "Users Impacted", totalpends/totalwds as "Pend Rate" ,f.acceptrate "Accept Rate", blockrate as "Block Rate", totalpendblock, totalpendaccept
FROM false f
LEFT JOIN total t
ON f.day = t.day
GROUP BY ALL ORDER BY "Week" DESC, "Pend Rate" DESC)



SELECT "Week" as "Date", 
"Route",
"WDs per Route", "Users Impacted", totalpendaccept as "Total Accepts", totalpendblock as "Total Blocks", "Pend Rate", "Accept Rate", "Block Rate"
FROM final f
WHERE ("Date" >= ('2025-04-09 21:35:57')::timestamp AND "Date" < ('2026-04-09 21:35:57')::timestamp)  and "Route" = 'First Time Withdrawals'
ORDER BY "Date" ASC;
