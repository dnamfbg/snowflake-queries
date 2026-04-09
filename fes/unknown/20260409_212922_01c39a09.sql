-- Query ID: 01c39a09-0112-6f44-0000-e307218b1df2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:29:22.305000+00:00
-- Elapsed: 4330ms
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

, ftus_not_attributed_in_fanapp_users as (
    select 
        *
    from fanapp.reporting.fbg_affiliate_ftus
    where private_fan_id not in (
        select distinct private_fan_id from fanapp_users where fanapp_ftu_attribution is not null
        )
)

select year(ftu_Day), fanapp_ftu_attribution, count(distinct private_fan_id) from ftus_not_attributed_in_fanapp_users group by all order by 2,1 asc;
