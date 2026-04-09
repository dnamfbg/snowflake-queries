-- Query ID: 01c39a38-0212-67a8-24dd-07031941a48b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:00.817000+00:00
-- Elapsed: 370ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour_alk
from FMX_ANALYTICS.CUSTOMER.ops_fmx_kyc_results_hourly
where activity_hour_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_ops_fmx_kyc_results_hourly_activity_hour_alk.aa7156f63c", "profile_name": "user", "target_name": "default"} */
