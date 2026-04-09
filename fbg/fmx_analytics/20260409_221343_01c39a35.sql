-- Query ID: 01c39a35-0212-6dbe-24dd-0703194124f3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:43.878000+00:00
-- Elapsed: 374ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  





with validation_errors as (

    select
        trans_date_alk, acco_id, jurisdiction_id
    from FMX_ANALYTICS.CUSTOMER.int_fmx_order_metrics_daily
    group by trans_date_alk, acco_id, jurisdiction_id
    having count(*) > 1

)

select *
from validation_errors



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_unique_combination_o_1008f1306ad6a3359b45694ee92f9db4.8fd55d6506", "profile_name": "user", "target_name": "default"} */
