-- Query ID: 01c39a33-0212-67a9-24dd-07031940e193
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:33.095000+00:00
-- Elapsed: 331ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from FMX_ANALYTICS.CUSTOMER.fct_fmx_kyc_results_daily
where activity_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_kyc_results_daily_activity_date.385dd904cd", "profile_name": "user", "target_name": "default"} */
