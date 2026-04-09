-- Query ID: 01c39a3a-0212-644a-24dd-0703194262a7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:24.025000+00:00
-- Elapsed: 86ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sum_filled_handle_usd_7d
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where sum_filled_handle_usd_7d is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_e1ebae107689a97d6b54a87e2ba30674.334ce5e940", "profile_name": "user", "target_name": "default"} */
