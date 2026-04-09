-- Query ID: 01c39a3d-0212-67a9-24dd-07031942c8cb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:21:53.634000+00:00
-- Elapsed: 284ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_crm_campaign_engagement
where campaign_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_crm_campaign_engagement_campaign_id.9fecfe18f1", "profile_name": "user", "target_name": "default"} */
