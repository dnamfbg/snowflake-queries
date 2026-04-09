-- Query ID: 01c39a39-0212-6dbe-24dd-07031941be9b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:50.263000+00:00
-- Elapsed: 193ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sport_category
from FMX_ANALYTICS.CUSTOMER.fct_competitive_exchange_mapping
where sport_category is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_competitive_exchange_mapping_sport_category.45dd9275eb", "profile_name": "user", "target_name": "default"} */
