-- Query ID: 01c39a34-0212-6cb9-24dd-07031940bcdb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:12:19.078000+00:00
-- Elapsed: 799ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select simplified_status
from FMX_ANALYTICS.CUSTOMER.wallet_fmx_funding_transactions
where simplified_status is null



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.not_null_wallet_fmx_funding_transactions_simplified_status.a962b582cf", "profile_name": "user", "target_name": "default"} */
