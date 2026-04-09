-- Query ID: 01c39a3b-0212-644a-24dd-07031942664b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:19:17.857000+00:00
-- Elapsed: 703ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    acco_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.int_fmx_acquisition_customer
where acco_id is not null
group by acco_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_int_fmx_acquisition_customer_acco_id.aa1bcc6c4a", "profile_name": "user", "target_name": "default"} */
