-- Query ID: 01c39a3e-0212-67a9-24dd-0703194310f3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:56.514000+00:00
-- Elapsed: 157ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_detail_hourly
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crypto_market_quote_detail_hourly_symbol.c47f2e3cbc", "profile_name": "user", "target_name": "default"} */
