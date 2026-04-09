-- Query ID: 01c39a38-0212-67a9-24dd-0703194203eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:16:33.028000+00:00
-- Elapsed: 267ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.wallet_fmx_cash_activity_hourly
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_wallet_fmx_cash_activity_hourly_activity_hour_alk.7415901215", "profile_name": "user", "target_name": "default"} */
