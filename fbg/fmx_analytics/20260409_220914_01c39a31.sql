-- Query ID: 01c39a31-0212-6cb9-24dd-0703193fbee7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:09:14.935000+00:00
-- Elapsed: 253ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from FMX_ANALYTICS.CUSTOMER.fct_nadex_daily_metrics
where activity_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_nadex_daily_metrics_activity_date.89141c81e0", "profile_name": "user", "target_name": "default"} */
