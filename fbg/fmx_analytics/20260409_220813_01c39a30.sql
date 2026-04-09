-- Query ID: 01c39a30-0212-67a8-24dd-0703193fa687
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:13.332000+00:00
-- Elapsed: 414ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_fmx_mm_markets
  
  
  
  
  as (
    with source as (
    select
        fixture_id,
        market_id,
        name,
        is_open,
        is_displayed,
        metadata,
        created_at,
        updated_at,
        dw_creation_date,
        dw_last_updated,
        dw_source_timestamp,
        metadata_kafka_offset,
        metadata_kafka_partition,
        is_deleted,
        record_lsn
    from FBG_UNITY_CATALOG.FMX_MARKET_MAKERS_POSTGRES_SOURCE.MARKETS
)

select
    fixture_id,
    market_id,
    name,
    is_open,
    is_displayed,
    metadata,
    created_at,
    updated_at,
    dw_creation_date,
    dw_last_updated,
    dw_source_timestamp,
    metadata_kafka_offset,
    metadata_kafka_partition,
    is_deleted,
    record_lsn
from source
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_fmx_mm_markets", "profile_name": "user", "target_name": "default"} */
