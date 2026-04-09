-- Query ID: 01c39a31-0212-6dbe-24dd-0703193fcc03
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:09:05.495000+00:00
-- Elapsed: 155ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_order_pnl
where account_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_order_pnl_account_id.6872ce7f7f", "profile_name": "user", "target_name": "default"} */
