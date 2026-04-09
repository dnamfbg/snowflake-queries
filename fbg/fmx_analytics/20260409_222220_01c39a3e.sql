-- Query ID: 01c39a3e-0212-6cb9-24dd-07031942f4a7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:22:20.393000+00:00
-- Elapsed: 379ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  






with validation_errors as (

    select
        user_id
    from FMX_ANALYTICS.CUSTOMER.fct_fmx_user_funnel
    group by user_id
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_unique_combination_o_43bf2043c58f87f10c278691509d8780.14a73274e4", "profile_name": "user", "target_name": "default"} */
