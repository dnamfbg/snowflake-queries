-- Query ID: 01c39a38-0212-6e7d-24dd-070319421273
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:16:58.835000+00:00
-- Elapsed: 512ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select entity_type
from FMX_ANALYTICS.customer.fct_fmx_top_performers
where entity_type is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_fmx_top_performers_entity_type.5d7c71ae03", "profile_name": "user", "target_name": "default"} */
