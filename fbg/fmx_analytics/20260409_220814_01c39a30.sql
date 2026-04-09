-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fb357
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:14.009000+00:00
-- Elapsed: 473ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_crypto_stacked_ledger
  
  
  
  
  as (
    select
    POSTING_BUSINESS_DATE,
    LEDGER_ITEM_ID,
    POSTING_TIME,
    LOGIN_NAME,
    ACCOUNT_NAME,
    MEMBER_ID,
    MEMBER_TYPE_ID,
    SETTLEMENT_ACCOUNT_ID,
    SETTLEMENT_ACCOUNT_TYPE_ID,
    LEDGER_ID,
    LEDGER_TYPE_ID,
    AMOUNT,
    LEDGER_ITEM_REASON_ID,
    ORDER_ID,
    EXECUTION_ID,
    POSITION_ID,
    INSTRUMENT_ID,
    INSTRUMENT_TYPE_ID,
    TRADEABLE_SYMBOL_ID,
    SUGGESTED_DISPLAY_NAME,
    RESOURCE_CLASS_ID,
    IS_TEST_INSTRUMENT,
    DW_CREATED,
    DW_LAST_UPDATED
from FBG_SOURCE.CRYPTO.STACKED_LEDGER
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_crypto_stacked_ledger", "profile_name": "user", "target_name": "default"} */
