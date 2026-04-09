-- Query ID: 01c39a30-0212-6e7d-24dd-070319401007
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:43.864000+00:00
-- Elapsed: 304ms
-- Run Count: 2
-- Environment: FBG

select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    jurisdiction_code as unique_field,
    count(*) as n_records

from FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions
where jurisdiction_code is not null
group by jurisdiction_code
having count(*) > 1



  
  
      
    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.dbt_fmx.unique_dim_fmx_jurisdictions_jurisdiction_code.45dc538dc0", "profile_name": "user", "target_name": "default"} */
