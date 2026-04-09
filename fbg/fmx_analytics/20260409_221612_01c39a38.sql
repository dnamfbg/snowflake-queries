-- Query ID: 01c39a38-0212-6cb9-24dd-07031941996f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:12.133000+00:00
-- Elapsed: 335ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders
where order_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_core_orders_order_id.9f681722be", "profile_name": "user", "target_name": "default"} */
