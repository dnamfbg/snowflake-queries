-- Query ID: 01c39a36-0212-67a8-24dd-070319411fa7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:14:46.101000+00:00
-- Elapsed: 1924ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from FMX_ANALYTICS.CUSTOMER.fct_kalshi_daily_metrics
where activity_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_kalshi_daily_metrics_activity_date.217f960f1b", "profile_name": "user", "target_name": "default"} */
