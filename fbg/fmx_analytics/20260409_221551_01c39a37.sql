-- Query ID: 01c39a37-0212-6e7d-24dd-070319418b67
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:15:51.050000+00:00
-- Elapsed: 407ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour
from FMX_ANALYTICS.CUSTOMER.orders_orchestrator_steps_hourly
where activity_hour is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_orchestrator_steps_hourly_activity_hour.68b34a35e6", "profile_name": "user", "target_name": "default"} */
