-- Query ID: 01c39a3e-0212-6dbe-24dd-07031942bf33
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:48.233000+00:00
-- Elapsed: 154ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_hourly
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crypto_market_quote_hourly_symbol.85e2b8c564", "profile_name": "user", "target_name": "default"} */
