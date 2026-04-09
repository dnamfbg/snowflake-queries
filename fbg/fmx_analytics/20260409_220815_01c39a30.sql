-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe1b7
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:15.381000+00:00
-- Elapsed: 438ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_crypto_open_positions
  
  
  
  
  as (
    select
    BUSINESS_DATE,
    LEGAL_NAME,
    MEMBER_TYPE_ID,
    SETTLEMENT_ACCOUNT_ID,
    SETTLEMENT_ACCOUNT_TYPE_ID,
    INSTRUMENT_TYPE_ID,
    PERIODICITY_ID,
    RESOURCE_CLASS,
    RESOURCE_DESCRIPTION,
    TRADEABLE_SYMBOL_ID,
    SUGGESTED_DISPLAY_NAME,
    CLIENT_IDENTIFIER,
    POSITION_SIZE,
    POSITION_COST,
    INSTRUMENT_ID,
    M2M_PRICE,
    M2M_POSITION_VALUE,
    DW_LAST_UPDATED
from FBG_SOURCE.CRYPTO.OPEN_POSITIONS
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_crypto_open_positions", "profile_name": "user", "target_name": "default"} */
