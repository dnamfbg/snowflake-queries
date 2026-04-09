-- Query ID: 01c39a36-0212-67a8-24dd-070319411e4f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:14:33.168000+00:00
-- Elapsed: 431ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_trade_fees_daily
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_trade_fees_daily_acco_id.ae529ead45", "profile_name": "user", "target_name": "default"} */
