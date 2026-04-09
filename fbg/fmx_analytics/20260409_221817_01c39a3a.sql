-- Query ID: 01c39a3a-0212-644a-24dd-0703194261cb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:17.094000+00:00
-- Elapsed: 263ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select vol_71_to_99_cents
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where vol_71_to_99_cents is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_lifetime_facts_vol_71_to_99_cents.87192b6e83", "profile_name": "user", "target_name": "default"} */
