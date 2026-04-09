-- Query ID: 01c39a36-0212-644a-24dd-070319413b3b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:14:33.168000+00:00
-- Elapsed: 248ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select trans_date_alk
from FMX_ANALYTICS.CUSTOMER.int_fmx_trade_fees_daily
where trans_date_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_trade_fees_daily_trans_date_alk.d763825f7f", "profile_name": "user", "target_name": "default"} */
