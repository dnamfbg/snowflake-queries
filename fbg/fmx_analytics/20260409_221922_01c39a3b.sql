-- Query ID: 01c39a3b-0212-67a8-24dd-0703194247af
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:19:22.390000+00:00
-- Elapsed: 239ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select kyc_check_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_kyc_results
where kyc_check_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_kyc_results_kyc_check_id.9bdee46270", "profile_name": "user", "target_name": "default"} */
