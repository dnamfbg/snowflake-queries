-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fbb17
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:51.644000+00:00
-- Elapsed: 2347ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.ORDERS.fmx_orders_live
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fmx_orders_live_symbol.ca4a121599", "profile_name": "user", "target_name": "default"} */
