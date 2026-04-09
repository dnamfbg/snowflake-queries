-- Query ID: 01c39a30-0212-6e7d-24dd-07031940118b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:52.044000+00:00
-- Elapsed: 1366ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_id
from FMX_ANALYTICS.ORDERS.fmx_orders_live
where account_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fmx_orders_live_account_id.973f1b7129", "profile_name": "user", "target_name": "default"} */
