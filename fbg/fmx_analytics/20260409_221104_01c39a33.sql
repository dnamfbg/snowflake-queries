-- Query ID: 01c39a33-0212-67a8-24dd-07031940a28f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:04.817000+00:00
-- Elapsed: 141ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_hour
from FMX_ANALYTICS.CUSTOMER.fct_fmx_hourly_dashboard
where activity_hour is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_hourly_dashboard_activity_hour.1d6e9ad501", "profile_name": "user", "target_name": "default"} */
