-- Query ID: 01c39a3d-0212-6cb9-24dd-07031942f183
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:21:56.586000+00:00
-- Elapsed: 172ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_crm_campaign_performance
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crm_campaign_performance_acco_id.47d0235cd2", "profile_name": "user", "target_name": "default"} */
