-- Query ID: 01c39a35-0212-67a9-24dd-07031940ef6f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:13:27.106000+00:00
-- Elapsed: 722ms
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  




select
    1
from (select * from FMX_ANALYTICS.CUSTOMER.int_fmx_vip_rebate_model where state_test_group_based_on_order IS NULL OR state_test_group_based_on_order = 'CONTROL') dbt_subquery

where not(rebate_capped_and_rounded_adj_for_test_group = 0)


  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.dbt_utils_expression_is_true_i_423e5e0dbc15bcf0ab96d0af84d88a5a.c505976f72", "profile_name": "user", "target_name": "default"} */
