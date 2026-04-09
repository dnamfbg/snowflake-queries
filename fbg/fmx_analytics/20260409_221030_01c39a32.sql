-- Query ID: 01c39a32-0212-6cb9-24dd-070319403af3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:10:30.184000+00:00
-- Elapsed: 204ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.STAGING.cust_fmx_first_deposit_events
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_first_deposit_events_acco_id.17fbea6ad6", "profile_name": "user", "target_name": "default"} */
