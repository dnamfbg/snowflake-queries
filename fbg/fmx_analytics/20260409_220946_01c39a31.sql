-- Query ID: 01c39a31-0212-644a-24dd-07031940630f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:09:46.688000+00:00
-- Elapsed: 1737ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_vip_contact_conversations
    
    
    
    as (WITH dedup_messages AS (

    SELECT
        message_date_est AS message_time,
        description AS message_text,
        acco_id,
        room_id,
        fbg_name AS host_name,
        CASE WHEN outbound = 1 THEN 'Host' ELSE 'VIP' END AS message_sender,
        TRY_TO_TIMESTAMP(RIGHT(message_id, 25)) AS dw_created_date,
        MAX(SHA2(message_id, 256)) AS msg_id
    FROM FMX_ANALYTICS.CUSTOMER.fct_vip_contact_history
    WHERE
        message_type = 'Text'
        AND message_text IS NOT NULL
        AND TRIM(message_text) != ''
        AND NOT message_text LIKE ANY (
            'Added % reaction to:%',
            'Message edited: %',
            'Message deleted for everyone: %'
        )
        AND room_id IS NOT NULL
    GROUP BY ALL

),

final_messages AS (

    SELECT
        *,
        LAG(message_time) OVER (PARTITION BY (room_id || acco_id) ORDER BY message_time) AS prev_message_time
    FROM dedup_messages

)

SELECT
    * EXCLUDE (prev_message_time),
    (
        room_id || ';' || acco_id || ';'
        || SUM(
            CASE
                WHEN prev_message_time IS NULL THEN 1
                WHEN DATEDIFF('second', prev_message_time, message_time) > (60 * 60 * 6) THEN 1
                ELSE 0
            END
        ) OVER (
            PARTITION BY (room_id || acco_id)
            ORDER BY message_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    ) AS conversation_id
FROM final_messages
ORDER BY acco_id, message_time
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_vip_contact_conversations", "profile_name": "user", "target_name": "default"} */
