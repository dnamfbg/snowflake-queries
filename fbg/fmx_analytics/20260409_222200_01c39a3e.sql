-- Query ID: 01c39a3e-0212-67a9-24dd-07031942ca2f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:00.712000+00:00
-- Elapsed: 193ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_send_date
from FMX_ANALYTICS.STAGING.fct_fmx_crm_campaign_daily_summary
where campaign_send_date is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_crm_campaign_daily_summary_campaign_send_date.3ac85a06cc", "profile_name": "user", "target_name": "default"} */
