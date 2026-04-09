-- Query ID: 01c39a31-0212-6cb9-24dd-0703194033b3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:09:42.457000+00:00
-- Elapsed: 1751ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_vip_contact_history
    
    
    
    as (WITH contact_history AS (

    SELECT * FROM FMX_ANALYTICS.CUSTOMER.cust_fmx_vip_contact_history
    

),

final AS (

    SELECT
        message_id,
        message_date_utc,
        message_date_est,
        message_type,
        outbound,
        inbound,
        description,
        acco_id,
        salesforce_id,
        lead_id,
        lead_email,
        user_phone,
        user_email,
        fbg_owner_id,
        fbg_name,
        fbg_phone,
        fbg_email,
        room_id,
        DATE(message_date_est) AS message_date
    FROM contact_history

)

SELECT * FROM final
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_vip_contact_history", "profile_name": "user", "target_name": "default"} */
