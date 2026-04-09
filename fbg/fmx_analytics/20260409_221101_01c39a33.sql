-- Query ID: 01c39a33-0212-6cb9-24dd-07031940b0cb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:11:01.506000+00:00
-- Elapsed: 356ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour
from FMX_ANALYTICS.CUSTOMER.int_fmx_trading_activity_hourly
where activity_hour is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_trading_activity_hourly_activity_hour.03220cc50a", "profile_name": "user", "target_name": "default"} */
