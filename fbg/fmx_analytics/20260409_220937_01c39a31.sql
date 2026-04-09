-- Query ID: 01c39a31-0212-644a-24dd-07031940613f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:37.116000+00:00
-- Elapsed: 288ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select message_type
from FMX_ANALYTICS.STAGING.stg_xtremepush_campaigns
where message_type is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_stg_xtremepush_campaigns_message_type.298da94668", "profile_name": "user", "target_name": "default"} */
