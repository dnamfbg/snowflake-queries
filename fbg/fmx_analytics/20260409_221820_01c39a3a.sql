-- Query ID: 01c39a3a-0212-6e7d-24dd-070319421cef
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:20.079000+00:00
-- Elapsed: 76ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select count_distinct_markets_traded
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where count_distinct_markets_traded is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_01c7dce44fb90e50139e6eeb3fe927b0.ade6f675a4", "profile_name": "user", "target_name": "default"} */
