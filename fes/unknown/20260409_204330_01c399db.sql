-- Query ID: 01c399db-0112-6f44-0000-e307218a21d6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:43:30.284000+00:00
-- Elapsed: 205ms
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

, monterosa_generated_ftus as (
select 
    pfi.private_fan_id, 
    fanapp_tenant_fan_id, 
    ftp_first_game_ts_utc,
    ftu_source,
    fanapp_ftu_attribution
from fangraph.private_fan_id.pfi_customer_mart pfi
    inner join monterosa_generated_ids m
        on fanapp_tenant_fan_id = external_id
    left join fanapp.reporting.fbg_affiliate_ftus ftu
        on pfi.private_fan_id = ftu.private_fan_id
        )

select fanapp_ftu_attribution, count(distinct private_fan_id) from monterosa_generated_ftus group by all;
