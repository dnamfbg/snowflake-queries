-- Query ID: 01c39a31-0212-6cb9-24dd-0703194032db
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:38.024000+00:00
-- Elapsed: 1037ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        interaction_type as value_field,
        count(*) as n_records

    from FMX_ANALYTICS.STAGING.stg_xtremepush_campaigns
    group by interaction_type

)

select *
from all_values
where value_field not in (
    'sent','open','click','control'
)



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.accepted_values_stg_xtremepush_ceb46612ffa418c46459dfc7f530e386.a685b2834d", "profile_name": "user", "target_name": "default"} */
