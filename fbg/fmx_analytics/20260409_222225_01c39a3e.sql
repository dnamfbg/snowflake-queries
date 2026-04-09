-- Query ID: 01c39a3e-0212-6cb9-24dd-07031942f53f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:25.747000+00:00
-- Elapsed: 173ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select report_date
from FMX_ANALYTICS.CUSTOMER.int_fmx_daily_customer_activity
where report_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_daily_customer_activity_report_date.c517bce733", "profile_name": "user", "target_name": "default"} */
