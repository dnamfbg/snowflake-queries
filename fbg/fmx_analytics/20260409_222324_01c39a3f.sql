-- Query ID: 01c39a3f-0212-6e7d-24dd-07031942ef13
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:23:24.569000+00:00
-- Elapsed: 187ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select growth_accounting_daily_id
from FMX_ANALYTICS.CUSTOMER.fct_customer_growth_accounting_daily
where growth_accounting_daily_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_customer_growth_a_a3dc54eeca170acc43bb93e91a0cc45e.a8c43f99b9", "profile_name": "user", "target_name": "default"} */
