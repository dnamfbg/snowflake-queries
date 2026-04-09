-- Query ID: 01c39a32-0212-6cb9-24dd-070319403777
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:10:11.333000+00:00
-- Elapsed: 1099ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.STAGING.cust_fmx_second_deposit_events
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_second_deposit_events_acco_id.04eddfab4d", "profile_name": "user", "target_name": "default"} */
