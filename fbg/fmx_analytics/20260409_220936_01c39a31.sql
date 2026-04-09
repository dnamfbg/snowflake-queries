-- Query ID: 01c39a31-0212-6cb9-24dd-070319403297
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:36.872000+00:00
-- Elapsed: 258ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_id
from FMX_ANALYTICS.STAGING.stg_xtremepush_campaigns
where campaign_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_stg_xtremepush_campaigns_campaign_id.8e2c3a82cb", "profile_name": "user", "target_name": "default"} */
