-- Query ID: 01c39a39-0212-644a-24dd-07031941dd3f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:51.166000+00:00
-- Elapsed: 223ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select report_date
from FMX_ANALYTICS.CUSTOMER.int_fmx_trading_activity_daily
where report_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_trading_activity_daily_report_date.5321f3ce27", "profile_name": "user", "target_name": "default"} */
