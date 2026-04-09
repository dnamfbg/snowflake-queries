-- Query ID: 01c39a39-0212-644a-24dd-07031941db67
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:17:38.012000+00:00
-- Elapsed: 788ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.fct_orders_symbol_hourly_metrics
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_orders_symbol_hourly_metrics_symbol.a88cd320ff", "profile_name": "user", "target_name": "default"} */
