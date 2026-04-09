-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fb3b7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:16.240000+00:00
-- Elapsed: 380ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_fmx_mm_fix_messages
  
  
  
  
  as (
    with source as (
    select
        beginstring,
        sendercompid,
        sendersubid,
        senderlocid,
        targetcompid,
        targetsubid,
        targetlocid,
        session_qualifier,
        msgseqnum,
        message,
        dw_creation_date,
        dw_last_updated,
        dw_source_timestamp,
        metadata_kafka_offset,
        metadata_kafka_partition,
        is_deleted,
        record_lsn
    from FBG_UNITY_CATALOG.FMX_MARKET_MAKERS_POSTGRES_SOURCE.FIX_MESSAGES
)

select
    beginstring,
    sendercompid,
    sendersubid,
    senderlocid,
    targetcompid,
    targetsubid,
    targetlocid,
    session_qualifier,
    msgseqnum,
    message,
    dw_creation_date,
    dw_last_updated,
    dw_source_timestamp,
    metadata_kafka_offset,
    metadata_kafka_partition,
    is_deleted,
    record_lsn
from source
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_fmx_mm_fix_messages", "profile_name": "user", "target_name": "default"} */
