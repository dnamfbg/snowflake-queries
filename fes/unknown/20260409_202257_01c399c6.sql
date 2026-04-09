-- Query ID: 01c399c6-0112-6ccc-0000-e3072189e302
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:22:57.492000+00:00
-- Elapsed: 1488ms
-- Environment: FES

with fanapp_users as (
    select
        coh.private_fan_id,
        pfi.fbg_tenant_fan_id,
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


, ftus_not_attributed_in_fanapp_users_properties as (
select 
    p.private_fan_id,
    p.fbg_acco_id,
    p.fbg_tenant_fan_id,
    p.is_fbg_deleted,
    p.fanapp_tenant_fan_id,
    p.commerce_tenant_fan_id,
    p.fbg_ftu_ts_utc as pfi_ftu_ts,
    f.ftu_day as fanapp_ftu_day,
    f.most_recent_action_ts,
    f.ftu_source,
    f.fanapp_ftu_attribution
from fangraph.private_fan_id.pfi_customer_mart p
    left join fanapp.reporting.fbg_affiliate_ftus f
        on p.private_fan_id = f.private_fan_id
    inner join ftus_not_attributed_in_fanapp_users f2
        on p.private_fan_id = f2.private_fan_id),

nonexist AS (

        SELECT *  FROM ftus_not_attributed_in_fanapp_users_properties where fanapp_tenant_fan_id is not null)
        SELECT * FROM nonexist;
