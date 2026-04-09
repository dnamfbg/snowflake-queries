-- Query ID: 01c39a39-0212-644a-24dd-07031941d9ff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:17:16.087000+00:00
-- Elapsed: 480ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        order_id, leg_number
    from FMX_ANALYTICS.CUSTOMER.fct_fmx_combo_leg_details
    group by order_id, leg_number
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_unique_combination_o_6c6fb75ffae7be42e6f446871ff0081f.2794e26da9", "profile_name": "user", "target_name": "default"} */
