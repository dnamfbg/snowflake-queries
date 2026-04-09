-- Query ID: 01c39a3a-0212-644a-24dd-070319426283
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:23.015000+00:00
-- Elapsed: 71ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select successful_withdrawals_amount_usd_365d
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where successful_withdrawals_amount_usd_365d is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_53e2f5c75e10125de55f6b78732adb3a.66aa2c7005", "profile_name": "user", "target_name": "default"} */
