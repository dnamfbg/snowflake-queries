-- Query ID: 01c39a31-0212-644a-24dd-07031940637b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:09:49.943000+00:00
-- Elapsed: 126ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select kyc_check_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_kyc_results
where kyc_check_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_kyc_results_kyc_check_id.9cd4ef3340", "profile_name": "user", "target_name": "default"} */
