-- Query ID: 01c39a38-0212-6dbe-24dd-07031941b9af
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:52.741000+00:00
-- Elapsed: 178ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.orders_fmx_account_symbol_hourly_metrics
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_fmx_account_sy_6f4a8c46e8443fda79622296a4ec51b2.fe2d2c7605", "profile_name": "user", "target_name": "default"} */
