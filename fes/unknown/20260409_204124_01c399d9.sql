-- Query ID: 01c399d9-0112-6be5-0000-e3072189d966
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:41:24.767000+00:00
-- Elapsed: 4851ms
-- Environment: FES

with monterosa_fanapp_ids as (
    select 
        external_id, 
        max(date(user_session_start_ts)) as last_submission,
        min(date(user_session_start_ts)) as first_submission,
    from monterosa.monterosa_core.fanapp_game_results
        group by all
    )

, amplitude_fanapp_ids as (
    select 
        distinct user_id_corrected 
    from FDE.FDE_INFO.amplitude_events_correction
    )

, monterosa_generated_ids as (
select 
    external_id, 
    user_id_corrected,
    first_submission,
    last_submission,
    case when first_submission = last_submission then 1 else 0 end as one_submission
from monterosa_fanapp_ids
left join amplitude_fanapp_ids on external_id = user_id_corrected
    where user_id_corrected is null
    )
select * from monterosa_generated_ids
