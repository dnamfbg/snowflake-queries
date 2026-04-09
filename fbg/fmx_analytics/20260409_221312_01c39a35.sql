-- Query ID: 01c39a35-0212-6e7d-24dd-07031940f983
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:12.205000+00:00
-- Elapsed: 974ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    acco_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.cust_fmx_first_order_events
where acco_id is not null
group by acco_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_cust_fmx_first_order_events_acco_id.f5d69d3fee", "profile_name": "user", "target_name": "default"} */
