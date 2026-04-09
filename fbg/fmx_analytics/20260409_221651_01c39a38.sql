-- Query ID: 01c39a38-0212-6dbe-24dd-07031941b993
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:51.307000+00:00
-- Elapsed: 15288ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select growth_accounting_account_day_id
from FMX_ANALYTICS.CUSTOMER.cust_fmx_day_grid_growth_accounting
where growth_accounting_account_day_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_day_grid_gro_f57ebff237725d75bdf83d2a95795f6a.fa03026656", "profile_name": "user", "target_name": "default"} */
