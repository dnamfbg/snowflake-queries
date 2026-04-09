-- Query ID: 01c39a3a-0212-6dbe-24dd-07031942342b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:22.237000+00:00
-- Elapsed: 204ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select vol_0_to_29_cents
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where vol_0_to_29_cents is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_lifetime_facts_vol_0_to_29_cents.21dd7b41ef", "profile_name": "user", "target_name": "default"} */
