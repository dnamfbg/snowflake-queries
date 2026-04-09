-- Query ID: 01c39a35-0212-67a8-24dd-07031941146f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:25.088000+00:00
-- Elapsed: 1089ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_vip_rebate_model
where account_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_vip_rebate_model_account_id.af6abdff87", "profile_name": "user", "target_name": "default"} */
