-- Query ID: 01c39a3d-0212-67a8-24dd-07031942d44b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:21:30.398000+00:00
-- Elapsed: 454ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.orders_fmx_trading_activity_hourly
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_fmx_trading_activity_hourly_activity_hour_alk.715893c72b", "profile_name": "user", "target_name": "default"} */
