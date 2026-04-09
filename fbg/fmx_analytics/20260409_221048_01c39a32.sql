-- Query ID: 01c39a32-0212-6cb9-24dd-070319403eb7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:10:48.134000+00:00
-- Elapsed: 170ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour
from FMX_ANALYTICS.CUSTOMER.int_fmx_wallet_activity_hourly
where activity_hour is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_wallet_activity_hourly_activity_hour.2bd5040a7d", "profile_name": "user", "target_name": "default"} */
