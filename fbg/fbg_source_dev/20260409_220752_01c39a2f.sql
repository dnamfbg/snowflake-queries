-- Query ID: 01c39a2f-0212-6dbe-24dd-0703193f6fd3
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:07:52.374000+00:00
-- Elapsed: 30156ms
-- Environment: FBG

SELECT ( "SUBQUERY_0"."EXPERIMENT_NAME" ) AS "SUBQUERY_1_COL_0" , ( "SUBQUERY_0"."TESTID" ) AS "SUBQUERY_1_COL_1" , ( "SUBQUERY_0"."TESTGROUPID" ) AS "SUBQUERY_1_COL_2" , ( "SUBQUERY_0"."TREATMENT_ARM" ) AS "SUBQUERY_1_COL_3" , ( "SUBQUERY_0"."NUM_SENDS" ) AS "SUBQUERY_1_COL_4" , ( "SUBQUERY_0"."NUM_RESPONSES" ) AS "SUBQUERY_1_COL_5" FROM ( SELECT * FROM ( ( WITH experiments_raw AS (
    SELECT 48 AS testid, 'Cash Out' AS experiment_name, TO_DATE('2025-08-06') AS configured_start_date, TO_DATE('2025-11-18') AS configured_end_date
    UNION ALL
    SELECT 39 AS testid, 'DR v1' AS experiment_name, TO_DATE('2025-07-14') AS configured_start_date, TO_DATE('2025-08-28') AS configured_end_date
    UNION ALL
    SELECT 151 AS testid, 'SGP' AS experiment_name, TO_DATE('2026-03-03') AS configured_start_date, CAST(CURRENT_DATE() AS DATE) AS configured_end_date
    UNION ALL
    SELECT 152 AS testid, 'DR v2' AS experiment_name, TO_DATE('2026-03-03') AS configured_start_date, CAST(CURRENT_DATE() AS DATE) AS configured_end_date
),
experiments AS (
    SELECT
        testid,
        experiment_name,
        GREATEST(configured_start_date, TO_DATE('2025-05-01')) AS start_date,
        LEAST(configured_end_date, TO_DATE('2026-04-06')) AS end_date
    FROM experiments_raw
    WHERE GREATEST(configured_start_date, TO_DATE('2025-05-01')) <= LEAST(configured_end_date, TO_DATE('2026-04-06'))
),
experiment_arm_labels AS (
    SELECT 48 AS testid, 0 AS testgroupid, 'Control' AS readable_treatment_arm
    UNION ALL
    SELECT 48 AS testid, 1 AS testgroupid, 'Rounding Up' AS readable_treatment_arm
    UNION ALL
    SELECT 48 AS testid, 2 AS testgroupid, 'Rounding Down' AS readable_treatment_arm
    UNION ALL
    SELECT 48 AS testid, 3 AS testgroupid, 'Shifting Down' AS readable_treatment_arm
),

survey_sends_exp AS (
    SELECT DISTINCT
        p.customer_id AS acco_id,
        DATE(TO_TIMESTAMP(c.timestamp)) AS send_date,
        CASE c.campaign_name
            WHEN '10.18.24-SURV1-REC-SBK-EMA' THEN 'New'
            WHEN '10.18.24-SURV2-REC-SBK-EMA' THEN 'Active'
            WHEN '10.18.24-SURV3-REC-SBK-EMA' THEN 'Lapsed'
        END AS survey_segment
    FROM FBG_SOURCE.XTREMEPUSH.CAMPAIGNS c
    JOIN FBG_SOURCE.XTREMEPUSH.PROFILES p
        ON c.user_id = p.user_id
    WHERE p.customer_id IS NOT NULL
      AND c.interaction_type = 'sent'
      AND c.campaign_name IN (
          '10.18.24-SURV1-REC-SBK-EMA',
          '10.18.24-SURV2-REC-SBK-EMA',
          '10.18.24-SURV3-REC-SBK-EMA'
      )
      AND DATE(TO_TIMESTAMP(c.timestamp)) BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
),

survey_responses_exp AS (
    SELECT TRY_CAST(ID AS NUMBER) AS acco_id,
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE AS response_date,
        'New' AS response_segment
    FROM FBG_ANALYTICS.JLG.SURVEY_NEW_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
    UNION ALL
    SELECT TRY_CAST(ID AS NUMBER),
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE AS DATE_SUBMITTED,
        'Active'
    FROM FBG_ANALYTICS.JLG.SURVEY_ACTIVE_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
    UNION ALL
    SELECT TRY_CAST(ID AS NUMBER),
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE AS DATE_SUBMITTED,
        'Lapsed'
    FROM FBG_ANALYTICS.JLG.SURVEY_LAPSED_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
),

responses_matched_exp AS (
    SELECT
        r.acco_id,
        r.response_date,
        r.response_segment,
        s.send_date AS matched_send_date,
        ROW_NUMBER() OVER (
            PARTITION BY r.acco_id, r.response_date, r.response_segment
            ORDER BY s.send_date DESC
        ) AS rn
    FROM survey_responses_exp r
    LEFT JOIN survey_sends_exp s
        ON r.acco_id = s.acco_id
       AND r.response_segment = s.survey_segment
       AND s.send_date <= r.response_date
),

responses_final_exp AS (
    SELECT acco_id, response_date, response_segment, matched_send_date
    FROM responses_matched_exp
    WHERE rn = 1
)

SELECT
    e.experiment_name,
    e.testid,
    tga.testgroupid,
    COALESCE(eal.readable_treatment_arm, tg.testgroupdescription) AS treatment_arm,
    COUNT(DISTINCT ss.acco_id || '|' || ss.send_date) AS num_sends,
    COUNT(DISTINCT CASE WHEN rf.acco_id IS NOT NULL THEN rf.acco_id || '|' || rf.matched_send_date END) AS num_responses
FROM experiments e
JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.V_MV_TEST_GROUP_ACCOUNTS tga
    ON e.testid = tga.testid
JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.T_MV_TEST_GROUPS tg
    ON tga.testid = tg.testid
   AND tga.testgroupid = tg.testgroupid
LEFT JOIN experiment_arm_labels eal
    ON e.testid = eal.testid
   AND tga.testgroupid = eal.testgroupid
INNER JOIN survey_sends_exp ss
    ON tga.acco_id = ss.acco_id
   AND ss.send_date BETWEEN e.start_date AND e.end_date
LEFT JOIN responses_final_exp rf
    ON ss.acco_id = rf.acco_id
   AND ss.send_date = rf.matched_send_date
   AND ss.survey_segment = rf.response_segment
GROUP BY e.experiment_name, e.testid, tga.testgroupid, COALESCE(eal.readable_treatment_arm, tg.testgroupdescription)
ORDER BY e.testid, tga.testgroupid ) ) AS "SF_CONNECTOR_QUERY_ALIAS" ) AS "SUBQUERY_0"
