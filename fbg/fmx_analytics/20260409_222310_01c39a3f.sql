-- Query ID: 01c39a3f-0212-67a8-24dd-07031942dfcb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:23:10.128000+00:00
-- Elapsed: 156ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select symbol
from FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_stats_daily
where symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crypto_market_stats_daily_symbol.20ea84699f", "profile_name": "user", "target_name": "default"} */
