-- Query ID: 01c39a32-0212-67a9-24dd-07031940752b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:10:10.778000+00:00
-- Elapsed: 662ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    acco_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.STAGING.cust_fmx_second_deposit_events
where acco_id is not null
group by acco_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_cust_fmx_second_deposit_events_acco_id.a95f38ad37", "profile_name": "user", "target_name": "default"} */
