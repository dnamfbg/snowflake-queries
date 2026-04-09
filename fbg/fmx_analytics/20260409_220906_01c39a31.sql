-- Query ID: 01c39a31-0212-67a8-24dd-07031940206b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:06.069000+00:00
-- Elapsed: 1462ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    order_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.fct_fmx_order_pnl
where order_id is not null
group by order_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_fct_fmx_order_pnl_order_id.0ee087da4f", "profile_name": "user", "target_name": "default"} */
