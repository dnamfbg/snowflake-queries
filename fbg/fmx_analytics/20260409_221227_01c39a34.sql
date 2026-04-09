-- Query ID: 01c39a34-0212-6cb9-24dd-07031940be0b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:12:27.688000+00:00
-- Elapsed: 252ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.cust_fmx_first_cash_order_events
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_first_cash_order_events_acco_id.ce811f34fc", "profile_name": "user", "target_name": "default"} */
