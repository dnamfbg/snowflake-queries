-- Query ID: 01c39a36-0212-6dbe-24dd-070319412da3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:14:34.021000+00:00
-- Elapsed: 2777ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        trans_date_alk, acco_id
    from FMX_ANALYTICS.CUSTOMER.int_fmx_trade_fees_daily
    group by trans_date_alk, acco_id
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_unique_combination_o_1f0e330fb53698a08f7020cdf9555798.d9464cd550", "profile_name": "user", "target_name": "default"} */
