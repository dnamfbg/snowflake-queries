-- Query ID: 01c39a3a-0212-67a8-24dd-070319424247
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:17.094000+00:00
-- Elapsed: 383ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select successful_deposits_amount_usd_7d
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where successful_deposits_amount_usd_7d is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_ab7d74a157a6e4aade411e156aaecb93.73642932c0", "profile_name": "user", "target_name": "default"} */
