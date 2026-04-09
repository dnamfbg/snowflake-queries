-- Query ID: 01c39a3f-0212-67a8-24dd-070319433067
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:23:13.728000+00:00
-- Elapsed: 204ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_daily_balance_table_id
from FMX_ANALYTICS.customer.cust_fmx_customer_daily_balance
where customer_daily_balance_table_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_customer_dai_2d4909bba9713ace6978c3015b5fe843.1061367c60", "profile_name": "user", "target_name": "default"} */
