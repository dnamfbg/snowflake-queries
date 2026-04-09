-- Query ID: 01c39a09-0112-6bf9-0000-e307218b4d6e
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T21:29:49.939000+00:00
-- Elapsed: 28249ms
-- Environment: FES

create or replace table fes_users.caroline_wylie.fanapp_monthly_actives as (
    with events as (
        select case when user_id_corrected is not null or cast(user_id_corrected as string) <> cast(device_id as string) then user_id_corrected else cast(amplitude_id as string) end as id
            , aec.*
        from fde.fde_info.amplitude_events_correction aec
    )
    select distinct date_trunc(month, event_time) as month
        , apb.bridge_identity_key
        , apb.is_guest_flag
        , f1.loyalty_tier
        , pfs.customer_segment
    from events e
    left join fes_users.caroline_wylie.amplitude_to_pfi_bridge apb
        on e.id = apb.bridge_identity_key
    left join fes_users.sandbox.f1_attributes f1
        on apb.private_fan_id = f1.private_fan_id
    left join fes_users.sandbox.pfi_fanapp_customer_segmentation pfs
        on apb.private_fan_id = pfs.private_fan_id
    where pfs.cohort_view = 'l12m' 
        or pfs.cohort_view is null
)
