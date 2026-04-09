-- Query ID: 01c39a33-0212-67a8-24dd-07031940a45b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:11:17+00:00
-- Elapsed: 357ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select payment_brand
from FMX_ANALYTICS.CUSTOMER.fct_fmx_withdrawal_failures_daily
where payment_brand is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_withdrawal_failures_daily_payment_brand.77fded355b", "profile_name": "user", "target_name": "default"} */
