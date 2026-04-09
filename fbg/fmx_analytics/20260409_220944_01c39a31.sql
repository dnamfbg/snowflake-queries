-- Query ID: 01c39a31-0212-6e7d-24dd-070319401a8b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:09:44.410000+00:00
-- Elapsed: 2173ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select message_id
from FMX_ANALYTICS.CUSTOMER.fct_vip_contact_history
where message_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_vip_contact_history_message_id.a22cd21725", "profile_name": "user", "target_name": "default"} */
