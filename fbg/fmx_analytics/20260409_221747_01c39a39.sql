-- Query ID: 01c39a39-0212-67a9-24dd-070319420b57
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:47.200000+00:00
-- Elapsed: 448ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select state_code
from FMX_ANALYTICS.CUSTOMER.fct_fmx_state_breakdown_hourly
where state_code is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_state_breakdown_hourly_state_code.e73b1d9132", "profile_name": "user", "target_name": "default"} */
