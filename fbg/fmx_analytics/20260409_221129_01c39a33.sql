-- Query ID: 01c39a33-0212-644a-24dd-07031940d28f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:29.198000+00:00
-- Elapsed: 427ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select kyc_date
from FMX_ANALYTICS.CUSTOMER.int_fmx_kyc_results_daily
where kyc_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_kyc_results_daily_kyc_date.f91ce45ab3", "profile_name": "user", "target_name": "default"} */
