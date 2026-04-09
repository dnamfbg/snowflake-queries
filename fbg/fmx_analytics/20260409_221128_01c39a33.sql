-- Query ID: 01c39a33-0212-67a8-24dd-07031940a5eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:28.506000+00:00
-- Elapsed: 240ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select distinct_accounts
from FMX_ANALYTICS.CUSTOMER.int_fmx_kyc_results_daily
where distinct_accounts is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_kyc_results_daily_distinct_accounts.d2b5b106a5", "profile_name": "user", "target_name": "default"} */
