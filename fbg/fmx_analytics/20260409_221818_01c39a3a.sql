-- Query ID: 01c39a3a-0212-67a8-24dd-07031942426b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:18.389000+00:00
-- Elapsed: 102ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select count_customer_active_weeks
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where count_customer_active_weeks is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_62c4fc79c430751d15ee5fb707969356.41a048fb1d", "profile_name": "user", "target_name": "default"} */
