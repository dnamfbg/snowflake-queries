-- Query ID: 01c39a32-0212-6dbe-24dd-0703194047a7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:10:20.001000+00:00
-- Elapsed: 155ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_id
from FMX_ANALYTICS.CUSTOMER.int_fmx_tiered_suo
where account_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_tiered_suo_account_id.cd8cd29681", "profile_name": "user", "target_name": "default"} */
