-- Query ID: 01c39a32-0212-6dbe-24dd-07031940478b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:10:19.749000+00:00
-- Elapsed: 918ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    qualifying_order_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.int_fmx_tiered_suo
where qualifying_order_id is not null
group by qualifying_order_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_int_fmx_tiered_suo_qualifying_order_id.efd3d8abcf", "profile_name": "user", "target_name": "default"} */
