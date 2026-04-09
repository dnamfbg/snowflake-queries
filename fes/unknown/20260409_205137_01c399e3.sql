-- Query ID: 01c399e3-0112-6be5-0000-e3072189dc7a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:51:37.382000+00:00
-- Elapsed: 7450ms
-- Environment: FES

with fanapp_users as (
    select
        coh.private_fan_id,
        pfi.fbg_tenant_fan_id,
        pfi.fanapp_tenant_fan_id,
        coh.channel_label as fanapp_channel_label,
        coh.source_label as fanapp_source_label,
        coh.placement_label as fanapp_placement_label,
        fbg.acquisition_channel as fbg_acquisition_channel,
        coh.first_install_ts_alk as fanapp_install,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', pfi.fbg_ftu_ts_utc) AS fbg_ftu_ts_alk,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', pfi.fbg_reg_ts_utc) AS fbg_reg_ts_alk,
        coh.fanapp_ftu_attribution,
        coh.first_install_state,
    from fes_users.sandbox.fanapp_cohort_labels coh
        left join fangraph.private_fan_id.pfi_customer_mart pfi
            on coh.private_fan_id = pfi.private_fan_id
        left join fbg_fde.fbg_users.v_fbg_customer_mart fbg
            on pfi.fbg_acco_id = fbg.acco_id
)

, monterosa_fanapp_ids as (
    select 
        external_id as fanapp_tenant_fan_id, 
        max(date(user_session_start_ts)) as last_submission,
        min(date(user_session_start_ts)) as first_submission,
    from monterosa.monterosa_core.fanapp_game_results
        group by all
    )

select 
    m.fanapp_tenant_fan_id as monterosa_fanapp_tenant_fan_id,
    coh.fanapp_tenant_fan_id as cohort_fanapp_tenant_fan_id
    from monterosa_fanapp_ids m
        left join fanapp_users coh
        on m.fanapp_tenant_fan_id = coh.fanapp_tenant_fan_id;
