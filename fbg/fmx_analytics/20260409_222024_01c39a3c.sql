-- Query ID: 01c39a3c-0212-67a9-24dd-070319425e5b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:20:24.530000+00:00
-- Elapsed: 255ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acquisition_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_acquisition_summary_daily
where acquisition_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_acquisition_summary_daily_acquisition_id.98fc995403", "profile_name": "user", "target_name": "default"} */
