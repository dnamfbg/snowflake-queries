-- Query ID: 01c39a35-0212-6cb9-24dd-070319410677
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:13:22.396000+00:00
-- Elapsed: 6673ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_fmx_wallet_funding_transactions
    
    
    
    as (WITH funding AS (
    SELECT
        transaction_id,
        transaction_type,
        acco_id,
        transaction_ref,
        payment_brand,
        description,
        gateway,
        error_source,
        error_code,
        currency,
        amount_usd,
        fee_usd,
        initiated_at_utc,
        initiated_at_alk,
        completed_at_utc,
        completed_at_alk,
        jurisdictions_id,
        modified,
        product,
        status,
        simplified_status,
        active_refund,
        refundable_amount_usd,
        is_repeat_failure_one_hour,
        row_number_by_transaction_type_brand
    FROM FMX_ANALYTICS.CUSTOMER.wallet_fmx_funding_transactions

    WHERE product = 'EXCHANGE'
),

jurisdictions AS (
    SELECT
        jurisdiction_id,
        jurisdiction_code,
        jurisdiction_name,
        country_code,
        region,
        division,
        supports_prediction_markets
    FROM FMX_ANALYTICS.DIMENSIONS.dim_fmx_jurisdictions
)

SELECT
    f.transaction_id,
    f.transaction_type,
    f.acco_id,
    f.transaction_ref,
    f.payment_brand,
    f.description,
    f.gateway,
    f.error_source,
    f.error_code,
    f.currency,
    f.amount_usd,
    f.fee_usd,
    f.initiated_at_utc,
    f.initiated_at_alk,
    f.completed_at_utc,
    f.completed_at_alk,
    f.modified,
    f.product,
    f.status,
    f.simplified_status,
    f.active_refund,
    f.refundable_amount_usd,
    f.is_repeat_failure_one_hour,
    f.row_number_by_transaction_type_brand,
    -- Jurisdiction enrichment
    COALESCE(j.jurisdiction_id, -1) AS jurisdiction_id,
    COALESCE(j.jurisdiction_code, 'UNKNOWN') AS jurisdiction_code,
    COALESCE(j.jurisdiction_name, 'Unknown') AS jurisdiction_name,
    COALESCE(j.country_code, 'UNKNOWN') AS country_code,
    COALESCE(j.region, 'UNKNOWN') AS region,
    COALESCE(j.division, 'UNKNOWN') AS division,
    COALESCE(j.supports_prediction_markets, FALSE) AS supports_prediction_markets
FROM funding AS f
LEFT JOIN jurisdictions AS j
    ON f.jurisdictions_id = j.jurisdiction_id
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_fmx_wallet_funding_transactions", "profile_name": "user", "target_name": "default"} */
