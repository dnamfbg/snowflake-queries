-- Query ID: 01c39a37-0212-67a8-24dd-07031941a3d7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:15:48.940000+00:00
-- Elapsed: 3358ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.wallet_fmx_withdrawal_failures_hourly
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_wallet_fmx_withdrawal_f1ad71ac7dbc41e9ce38415bd8c8fc27.6fe26e50ab", "profile_name": "user", "target_name": "default"} */
