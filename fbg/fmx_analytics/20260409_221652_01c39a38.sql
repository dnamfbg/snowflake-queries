-- Query ID: 01c39a38-0212-6e7d-24dd-0703194211d3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:16:52.741000+00:00
-- Elapsed: 293ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.orders_fmx_account_symbol_hourly_metrics
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_orders_fmx_account_symbol_hourly_metrics_acco_id.40a77d2484", "profile_name": "user", "target_name": "default"} */
