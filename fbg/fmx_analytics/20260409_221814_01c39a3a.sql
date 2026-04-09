-- Query ID: 01c39a3a-0212-67a9-24dd-07031942526f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:14.595000+00:00
-- Elapsed: 172ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select state_code
from FMX_ANALYTICS.CUSTOMER.fct_fmx_state_breakdown
where state_code is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_state_breakdown_state_code.cc51db6974", "profile_name": "user", "target_name": "default"} */
