-- Query ID: 01c39a35-0212-67a8-24dd-0703194114ff
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:29.017000+00:00
-- Elapsed: 311ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from FMX_ANALYTICS.CUSTOMER.int_fmx_vip_rebate_model

where not(ROUND(total_fees_paid_tier_0 + total_fees_paid_tier_1 + total_fees_paid_tier_2 + total_fees_paid_tier_3 + total_fees_paid_tier_4, 2) = ROUND(total_fees_paid, 2))


  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_expression_is_true_i_e03c8651f1598987943337ef6ff2671e.5771c0ab47", "profile_name": "user", "target_name": "default"} */
