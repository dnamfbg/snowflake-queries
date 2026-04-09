-- Query ID: 01c39a3e-0212-67a8-24dd-07031942dc67
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:47.993000+00:00
-- Elapsed: 190ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.fct_fmx_crypto_market_quote_hourly
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crypto_market_quote_hourly_activity_hour_alk.4c3195e5e5", "profile_name": "user", "target_name": "default"} */
