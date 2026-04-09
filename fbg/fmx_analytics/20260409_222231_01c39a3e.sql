-- Query ID: 01c39a3e-0212-6cb9-24dd-07031942f5c3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:31.718000+00:00
-- Elapsed: 166ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select report_date
from FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_dashboard_ytd
where report_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_daily_dashboard_ytd_report_date.5ed55ada89", "profile_name": "user", "target_name": "default"} */
