-- Query ID: 01c39a0f-0212-6b00-24dd-07031938a04b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:35:57.733000+00:00
-- Elapsed: 2420ms
-- Environment: FBG

with wdmarpw as (
select 
date(convert_timezone('UTC','America/New_York',workflow_run_start_time)) as starttime,
date(convert_timezone('UTC','America/New_York', decision_time)) as decisiontime,
datediff('minute',WORKFLOW_RUN_START_TIME,DECISION_TIME) as pendtime,
w.user_id, 
w.decision_source,
w.decision_category,
case 
when route_name in ('First Time Withdrawals') then 'First Time Withdrawals'
ELSE route_name
END AS "actualRoute"
FROM FBG_SOURCE.SIFT.WORKFLOW_METRICS w
where w.decision_source = 'manual')

select
starttime as "Date",
avg(pendtime)/60,
max(pendtime)/60,
median(pendtime)/60
from wdmarpw
where "actualRoute" = 'First Time Withdrawals'
group by all
order by "Date" desc;
