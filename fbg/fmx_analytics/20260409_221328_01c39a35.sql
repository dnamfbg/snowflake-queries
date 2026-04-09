-- Query ID: 01c39a35-0212-67a9-24dd-07031940ef87
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:28.047000+00:00
-- Elapsed: 171ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from FMX_ANALYTICS.CUSTOMER.int_fmx_vip_rebate_model

where not(ROUND(total_fmx_revenue_tier_0 + total_fmx_revenue_tier_1 + total_fmx_revenue_tier_2 + total_fmx_revenue_tier_3 + total_fmx_revenue_tier_4, 2) = ROUND(total_fmx_revenue, 2))


  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_expression_is_true_i_613a2177174dea41d0a72b99e47211bb.0e8f619d9c", "profile_name": "user", "target_name": "default"} */
