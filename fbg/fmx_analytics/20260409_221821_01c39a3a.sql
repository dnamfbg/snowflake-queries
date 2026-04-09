-- Query ID: 01c39a3a-0212-6dbe-24dd-07031942340f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:21.146000+00:00
-- Elapsed: 206ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sum_filled_handle_usd
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where sum_filled_handle_usd is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_lifetime_facts_sum_filled_handle_usd.86c6cc41f0", "profile_name": "user", "target_name": "default"} */
