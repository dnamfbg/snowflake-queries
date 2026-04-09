-- Query ID: 01c39a35-0212-6e7d-24dd-07031940ff2f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:59.598000+00:00
-- Elapsed: 155ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.fct_fmx_market_conversion_rate
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_market_conversion_rate_symbol.5d9604c3f4", "profile_name": "user", "target_name": "default"} */
