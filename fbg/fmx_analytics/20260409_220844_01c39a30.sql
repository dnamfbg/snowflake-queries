-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fb9c3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:44.077000+00:00
-- Elapsed: 324ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    
    

with all_values as (

    select
        region as value_field,
        count(*) as n_records

    from FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions
    group by region

)

select *
from all_values
where value_field not in (
    'NORTHEAST','MIDWEST','SOUTH','WEST','TERRITORY','UNKNOWN'
)



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.accepted_values_dim_fmx_jurisd_e760958fce71efdabd093f336d45b685.7aeb252892", "profile_name": "user", "target_name": "default"} */
