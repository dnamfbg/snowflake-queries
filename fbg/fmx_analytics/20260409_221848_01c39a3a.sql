-- Query ID: 01c39a3a-0212-67a9-24dd-07031942564b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:48.752000+00:00
-- Elapsed: 173ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.cust_fmx_customer_first_activity
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_customer_first_activity_acco_id.d6a609ca30", "profile_name": "user", "target_name": "default"} */
