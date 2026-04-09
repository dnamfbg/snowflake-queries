-- Query ID: 01c39a3a-0212-6dbe-24dd-07031942350b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:35.151000+00:00
-- Elapsed: 190ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select acco_id
from FMX_ANALYTICS.CUSTOMER.fct_fmx_vip_overview
where acco_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_vip_overview_acco_id.a6dab7cc75", "profile_name": "user", "target_name": "default"} */
