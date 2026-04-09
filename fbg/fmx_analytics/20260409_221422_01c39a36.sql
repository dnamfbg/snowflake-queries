-- Query ID: 01c39a36-0212-67a9-24dd-070319416717
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:14:22.295000+00:00
-- Elapsed: 140ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_daily_cogs_table_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_customer_daily_cogs
where customer_daily_cogs_table_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_customer_dail_9e8bd34dd49bbc25aeea6bd726ba8cda.30a8ecfc58", "profile_name": "user", "target_name": "default"} */
