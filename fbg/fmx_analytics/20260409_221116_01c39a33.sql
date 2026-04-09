-- Query ID: 01c39a33-0212-6cb9-24dd-07031940b34b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:16.795000+00:00
-- Elapsed: 146ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select status
from FMX_ANALYTICS.CUSTOMER.fct_fmx_withdrawal_failures_daily
where status is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_withdrawal_failures_daily_status.dd34225dd5", "profile_name": "user", "target_name": "default"} */
