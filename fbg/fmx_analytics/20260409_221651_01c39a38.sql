-- Query ID: 01c39a38-0212-644a-24dd-07031941d82f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:16:51.307000+00:00
-- Elapsed: 4986ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    
    



select acco_id
from (select * from FMX_ANALYTICS.CUSTOMER.cust_fmx_day_grid_growth_accounting where registration_state IS NOT NULL) dbt_subquery
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_cust_fmx_day_grid_growth_accounting_acco_id.d6f7920277", "profile_name": "user", "target_name": "default"} */
