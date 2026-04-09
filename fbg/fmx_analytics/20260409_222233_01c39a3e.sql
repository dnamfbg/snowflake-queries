-- Query ID: 01c39a3e-0212-6cb9-24dd-07031942f5eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:33.174000+00:00
-- Elapsed: 538ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select metric
from FMX_ANALYTICS.CUSTOMER.vw_fmx_revenue_pivot
where metric is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_vw_fmx_revenue_pivot_metric.169d28a140", "profile_name": "user", "target_name": "default"} */
