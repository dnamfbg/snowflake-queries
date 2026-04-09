-- Query ID: 01c39a3a-0212-67a8-24dd-0703194244ff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:46.830000+00:00
-- Elapsed: 157ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour
from FMX_ANALYTICS.CUSTOMER.orders_product_symbol_activity_hourly
where activity_hour is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_product_symbol_activity_hourly_activity_hour.1342881916", "profile_name": "user", "target_name": "default"} */
