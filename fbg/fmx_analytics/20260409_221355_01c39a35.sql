-- Query ID: 01c39a35-0212-67a9-24dd-07031941631f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:55.067000+00:00
-- Elapsed: 167ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.int_fmx_symbol_metrics_daily
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_symbol_metrics_daily_symbol.073c1db2ae", "profile_name": "user", "target_name": "default"} */
