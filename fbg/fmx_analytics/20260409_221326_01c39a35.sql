-- Query ID: 01c39a35-0212-6e7d-24dd-07031940faff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:26.022000+00:00
-- Elapsed: 225ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_fees_paid
from FMX_ANALYTICS.CUSTOMER.int_fmx_vip_rebate_model
where total_fees_paid is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_vip_rebate_model_total_fees_paid.919306ca3d", "profile_name": "user", "target_name": "default"} */
