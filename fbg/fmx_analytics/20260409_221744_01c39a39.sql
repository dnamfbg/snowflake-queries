-- Query ID: 01c39a39-0212-644a-24dd-07031941dc07
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:44.496000+00:00
-- Elapsed: 284ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_metrics
where activity_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_daily_metrics_activity_date.3d6067c1fb", "profile_name": "user", "target_name": "default"} */
