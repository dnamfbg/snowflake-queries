-- Query ID: 01c399da-0112-6bf9-0000-e3072189f7de
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:42:56.551000+00:00
-- Elapsed: 2411ms
-- Environment: FES

with monterosa_fanapp_ids as (
    select 
        fanapp_tenant_fan_id,
        max(submission_dt) as last_submission,
        min(submission_dt) as first_submission,
    from fes_users.dylan_tuch.ftp_daily_submissions
        group by all
    )

, amplitude_fanapp_ids as (
    select
        distinct user_id_corrected
    from FDE.FDE_INFO.amplitude_events_correction
    )

, monterosa_generated_ids as (
select 
    m.fanapp_tenant_fan_id, 
    user_id_corrected,
    first_submission,
    last_submission,
    case when first_submission = last_submission then 1 else 0 end as one_submission
from monterosa_fanapp_ids m
left join amplitude_fanapp_ids a on m.fanapp_tenant_fan_id = a.user_id_corrected
    where fanapp_tenant_fan_id is null
    )
select * from monterosa_generated_ids;
