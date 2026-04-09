-- Query ID: 01c39a31-0212-67a9-24dd-07031940719f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:41.406000+00:00
-- Elapsed: 899ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    message_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.cust_fmx_vip_contact_history
where message_id is not null
group by message_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_cust_fmx_vip_contact_history_message_id.c3240ba6bf", "profile_name": "user", "target_name": "default"} */
