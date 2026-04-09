-- Query ID: 01c39a3a-0212-6cb9-24dd-070319422aa3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:26.159000+00:00
-- Elapsed: 118ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select count_distinct_markets_grouped_traded
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where count_distinct_markets_grouped_traded is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_52e30bee03080fb76794ea8ba71ade97.fcc86c3b0f", "profile_name": "user", "target_name": "default"} */
