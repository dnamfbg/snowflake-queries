-- Query ID: 01c39a3a-0212-6e7d-24dd-070319421d7f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:25.151000+00:00
-- Elapsed: 389ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sum_filled_handle_usd_sport
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where sum_filled_handle_usd_sport is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_0ad14b54df40d5b39c9e66e9da3ea186.b3ad3023dd", "profile_name": "user", "target_name": "default"} */
