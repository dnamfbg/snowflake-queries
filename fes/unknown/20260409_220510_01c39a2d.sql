-- Query ID: 01c39a2d-0112-6be5-0000-e307218c40b6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T22:05:10.841000+00:00
-- Elapsed: 3906ms
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
        coh.first_install_ts_alk as fanapp_install_ts_alk,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', pfi.fbg_ftu_ts_utc) AS fbg_ftu_ts_alk,
        CONVERT_TIMEZONE('UTC', 'America/Anchorage', pfi.fbg_reg_ts_utc) AS fbg_reg_ts_alk,
        coh.fanapp_ftu_attribution,
        coh.first_install_state,
        coh.first_osb_state_flag,
        coh.activated_fbg_post_install,
    from fes_users.sandbox.fanapp_cohort_labels coh
        left join fangraph.private_fan_id.pfi_customer_mart pfi
            on coh.private_fan_id = pfi.private_fan_id
        left join fbg_fde.fbg_users.v_fbg_customer_mart fbg
            on pfi.fbg_acco_id = fbg.acco_id
)

, fbg_flags as (
    select 
        f.*,
        case 
            when (first_osb_state_flag = 1 and (fbg_reg_ts_alk is null or fanapp_install_ts_alk < fbg_reg_ts_alk)) or (first_osb_state_flag = 1 and (fbg_ftu_ts_alk is null or fbg_ftu_ts_alk > fanapp_install_ts_alk)) then 1 else 0 end as FTU_Eligible_install_flag,
        case 
            when first_osb_state_flag = 1 and (fbg_reg_ts_alk is null or fanapp_install_ts_alk < fbg_reg_ts_alk) and (fbg_ftu_ts_alk is null or fbg_ftu_ts_alk > fanapp_install_ts_alk) then 1 else 0 end as ENR_install_flag,
        case when first_osb_state_flag = 1 and fanapp_install_ts_alk > fbg_reg_ts_alk and (fbg_ftu_ts_alk is null or fbg_ftu_ts_alk > fanapp_install_ts_alk) then 1 else 0 end as ENFTU_install_flag,
    from fanapp_users f
)

select 
    * 
from fbg_flags
    where 
        fbg_ftu_ts_alk is null 
        and first_osb_state_flag = 1
        and FTU_Eligible_install_flag = 0;
