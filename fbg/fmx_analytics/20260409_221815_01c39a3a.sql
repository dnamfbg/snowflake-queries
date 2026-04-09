-- Query ID: 01c39a3a-0212-67a8-24dd-0703194241ff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:15.055000+00:00
-- Elapsed: 244ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select report_date
from FMX_ANALYTICS.CUSTOMER.fct_fmx_state_breakdown
where report_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_state_breakdown_report_date.47529664f1", "profile_name": "user", "target_name": "default"} */
