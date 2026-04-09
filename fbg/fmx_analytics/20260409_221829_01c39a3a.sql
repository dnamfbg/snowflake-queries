-- Query ID: 01c39a3a-0212-644a-24dd-070319426327
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:18:29.343000+00:00
-- Elapsed: 152ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select successful_withdrawals_amount_usd
from FMX_ANALYTICS.CUSTOMER.int_fmx_customer_lifetime_facts
where successful_withdrawals_amount_usd is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_int_fmx_customer_life_af02b5b6194e11b9ebd45d7558e871b9.e9fe8c0c34", "profile_name": "user", "target_name": "default"} */
