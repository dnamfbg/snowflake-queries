-- Query ID: 01c39a34-0212-6dbe-24dd-07031940cadb
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:12:18.374000+00:00
-- Elapsed: 54330ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        simplified_status as value_field,
        count(*) as n_records

    from FMX_ANALYTICS.CUSTOMER.wallet_fmx_funding_transactions
    group by simplified_status

)

select *
from all_values
where value_field not in (
    'SUCCESSFUL','PENDING','FAILED'
)



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.accepted_values_wallet_fmx_fun_7a25d9d6ac953eaf827a26654c12872f.808e0833ed", "profile_name": "user", "target_name": "default"} */
