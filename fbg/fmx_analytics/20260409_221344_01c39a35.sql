-- Query ID: 01c39a35-0212-6cb9-24dd-07031941094f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:44.073000+00:00
-- Elapsed: 165ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select trans_date_alk
from FMX_ANALYTICS.CUSTOMER.int_fmx_order_metrics_daily
where trans_date_alk is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_order_metrics_daily_trans_date_alk.e3083d6e3b", "profile_name": "user", "target_name": "default"} */
