-- Query ID: 01c39a3d-0212-6cb9-24dd-07031942f23f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:21:59.880000+00:00
-- Elapsed: 141ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_id
from FMX_ANALYTICS.STAGING.fct_fmx_crm_campaign_summary
where campaign_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crm_campaign_summary_campaign_id.e86d2dea75", "profile_name": "user", "target_name": "default"} */
