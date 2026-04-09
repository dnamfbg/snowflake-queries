-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fb583
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:26.218000+00:00
-- Elapsed: 1322ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_leapxpert_messages
  
  
  
  
  as (
    

WITH source AS (

    SELECT * FROM FBG_SOURCE.LEAPXPERT.LEAPXPERT_MESSAGES

),

deduped AS (

    SELECT DISTINCT *
    FROM source
    WHERE
        content_type = 'text'
        AND (
            (
                participant_email LIKE '%@paragonglobalmarkets.com%'
                OR REGEXP_REPLACE(
                    ARRAY_TO_STRING(recipient_emails, ''), '[\[\]"]', ''
                ) LIKE '%@paragonglobalmarkets.com%'
            )
            OR (
                participant_email = 'rob@betfanatics.com'
                OR REGEXP_REPLACE(ARRAY_TO_STRING(recipient_emails, ''), '[\[\]"]', '') LIKE 'rob@betfanatics.com'
            )
            OR (
                participant_email LIKE '%vip.fanaticsmarkets.com%'
                OR REGEXP_REPLACE(ARRAY_TO_STRING(recipient_emails, ''), '[\[\]"]', '') LIKE '%vip.fanaticsmarkets.com%'
            )
        )

),

final AS (

    SELECT
        room_id,
        participant_id,
        participant_email,
        participant_phone,
        recipient_emails,
        recipient_phones,
        msg_time,
        msg_body,
        content_type,
        conversation_filename,
        dw_created_timestamp,

        participant_email AS clean_participant_email,
        RIGHT(participant_phone, 10) AS clean_participant_phone,
        RIGHT(REGEXP_REPLACE(ARRAY_TO_STRING(recipient_phones, ''), '[\[\]"]', ''), 10) AS clean_recipient_phone,
        REGEXP_REPLACE(ARRAY_TO_STRING(recipient_emails, ''), '[\[\]"]', '') AS clean_recipient_email

    FROM deduped
    WHERE msg_body != 'Joined'

)

SELECT * FROM final
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_leapxpert_messages", "profile_name": "user", "target_name": "default"} */
