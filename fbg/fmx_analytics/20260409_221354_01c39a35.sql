-- Query ID: 01c39a35-0212-67a8-24dd-0703194118c7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:54.833000+00:00
-- Elapsed: 158ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select trans_date_alk
from FMX_ANALYTICS.CUSTOMER.int_fmx_symbol_metrics_daily
where trans_date_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_symbol_metrics_daily_trans_date_alk.15c2fbce2c", "profile_name": "user", "target_name": "default"} */
