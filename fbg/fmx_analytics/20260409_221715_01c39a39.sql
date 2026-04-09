-- Query ID: 01c39a39-0212-67a9-24dd-07031942072f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:17:15.037000+00:00
-- Elapsed: 239ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select combo_symbol
from FMX_ANALYTICS.CUSTOMER.fct_fmx_combo_leg_details
where combo_symbol is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_combo_leg_details_combo_symbol.1f35292503", "profile_name": "user", "target_name": "default"} */
