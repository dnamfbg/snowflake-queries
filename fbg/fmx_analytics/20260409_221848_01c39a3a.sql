-- Query ID: 01c39a3a-0212-67a9-24dd-070319425647
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:18:48.752000+00:00
-- Elapsed: 8058ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    acco_id as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.CUSTOMER.cust_fmx_customer_first_activity
where acco_id is not null
group by acco_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_cust_fmx_customer_first_activity_acco_id.c4c1112b7a", "profile_name": "user", "target_name": "default"} */
