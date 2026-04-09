-- Query ID: 01c39a31-0212-6cb9-24dd-07031940348b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:48.510000+00:00
-- Elapsed: 207ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select msg_id
from FMX_ANALYTICS.CUSTOMER.fct_vip_contact_conversations
where msg_id is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_fct_vip_contact_conversations_msg_id.76b25c6676", "profile_name": "user", "target_name": "default"} */
