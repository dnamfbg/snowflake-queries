-- Query ID: 01c39a3a-0212-6cb9-24dd-070319422c4f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:46.830000+00:00
-- Elapsed: 117ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.orders_product_symbol_activity_hourly
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_product_symbol_activity_hourly_symbol.c0113f976e", "profile_name": "user", "target_name": "default"} */
