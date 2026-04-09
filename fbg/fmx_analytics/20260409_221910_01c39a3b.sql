-- Query ID: 01c39a3b-0212-67a8-24dd-0703194246fb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:19:10.622000+00:00
-- Elapsed: 174ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_first_activity
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_first_activity_acco_id.c18d654c7e", "profile_name": "user", "target_name": "default"} */
