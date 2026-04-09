-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe3a3
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:08:25.423000+00:00
-- Elapsed: 6941ms
-- Environment: FBG

SELECT ( "SUBQUERY_0"."EXPERIMENT_NAME" ) AS "SUBQUERY_1_COL_0" , ( "SUBQUERY_0"."TESTID" ) AS "SUBQUERY_1_COL_1" , ( "SUBQUERY_0"."START_DATE" ) AS "SUBQUERY_1_COL_2" , ( "SUBQUERY_0"."END_DATE" ) AS "SUBQUERY_1_COL_3" , ( "SUBQUERY_0"."ACCO_ID" ) AS "SUBQUERY_1_COL_4" , ( "SUBQUERY_0"."TESTGROUPID" ) AS "SUBQUERY_1_COL_5" , ( "SUBQUERY_0"."TREATMENT_ARM" ) AS "SUBQUERY_1_COL_6" FROM ( SELECT * FROM ( ( WITH experiments_raw AS (
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
)
SELECT DISTINCT
    e.experiment_name,
    e.testid,
    e.start_date,
    e.end_date,
    tga.acco_id,
    tga.testgroupid,
    COALESCE(eal.readable_treatment_arm, tg.testgroupdescription) AS treatment_arm
FROM experiments e
JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.V_MV_TEST_GROUP_ACCOUNTS tga
    ON e.testid = tga.testid
JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.T_MV_TEST_GROUPS tg
    ON tga.testid = tg.testid
   AND tga.testgroupid = tg.testgroupid
LEFT JOIN experiment_arm_labels eal
    ON e.testid = eal.testid
   AND tga.testgroupid = eal.testgroupid ) ) AS "SF_CONNECTOR_QUERY_ALIAS" ) AS "SUBQUERY_0"
