-- Query ID: 01c39a3e-0212-6e7d-24dd-07031942e8eb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:22:32.173000+00:00
-- Elapsed: 430ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        report_date, activity_date
    from FMX_ANALYTICS.CUSTOMER.fct_fmx_monthly_forecasts
    group by report_date, activity_date
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_unique_combination_o_12e7f4f947c875747735b8724b4338ee.ef707aad6c", "profile_name": "user", "target_name": "default"} */
