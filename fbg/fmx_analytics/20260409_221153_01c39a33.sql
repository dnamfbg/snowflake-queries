-- Query ID: 01c39a33-0212-6cb9-24dd-07031940b9b7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:11:53.167000+00:00
-- Elapsed: 306ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select activity_date
from FMX_ANALYTICS.FINANCE.fct_fmx_promotions_daily
where activity_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_promotions_daily_activity_date.9481b93f45", "profile_name": "user", "target_name": "default"} */
