-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fba5f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:48.105000+00:00
-- Elapsed: 101857ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.cust_fmx_first_deposit_events
    
    
    
    as (WITH deposits AS (
    SELECT
        acco_id::varchar AS acco_id,
        trans_ref AS deposit_id,
        amount AS deposit_amount,
        payment_brand AS deposit_type,
        jurisdictions_id AS deposit_jurisdiction_id,
        trans_date AS deposit_date_utc
    FROM FMX_ANALYTICS.STAGING.stg_account_statements_fmx
    WHERE
        trans = 'DEPOSIT'
        AND COALESCE(payment_brand, '') <> 'TERMINAL'
)

SELECT
    d.acco_id,
    d.deposit_id AS first_fmx_deposit_id,
    d.deposit_amount AS first_fmx_deposit_amount,
    d.deposit_type AS first_fmx_deposit_type,
    d.deposit_jurisdiction_id AS first_fmx_deposit_jurisdiction_id,
    j.jurisdiction_code AS first_fmx_deposit_jurisdiction_code,
    j.jurisdiction_name AS first_fmx_deposit_jurisdiction_name,
    d.deposit_date_utc AS first_fmx_deposit_date_utc,
    CONVERT_TIMEZONE('UTC', 'America/Anchorage', d.deposit_date_utc) AS first_fmx_deposit_date_alk,
    CONVERT_TIMEZONE('UTC', 'America/New_York', d.deposit_date_utc) AS first_fmx_deposit_date_est
FROM deposits AS d
LEFT JOIN FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions AS j
    ON d.deposit_jurisdiction_id = j.jurisdiction_id
QUALIFY ROW_NUMBER() OVER (PARTITION BY d.acco_id ORDER BY d.deposit_date_utc) = 1
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.cust_fmx_first_deposit_events", "profile_name": "user", "target_name": "default"} */
