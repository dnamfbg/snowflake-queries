-- Query ID: 01c39a39-0212-67a9-24dd-070319420773
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:18.005000+00:00
-- Elapsed: 131ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select leg_market_names_combo
from FMX_ANALYTICS.CUSTOMER.fct_fmx_combo_leg_details
where leg_market_names_combo is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_combo_leg_details_leg_market_names_combo.574b2a6e02", "profile_name": "user", "target_name": "default"} */
