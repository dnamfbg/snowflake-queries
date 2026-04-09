-- Query ID: 01c399ea-0212-6dbe-24dd-0703192f501b
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:58:50.695000+00:00
-- Elapsed: 2729ms
-- Environment: FBG

SELECT DISTINCT
    a.accounts_id AS acco_id,
    NULL AS id,
FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
JOIN FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
    ON a.customer_segments_id = cs.id
LEFT JOIN (
        SELECT
            acm.acco_id,
            sportsbook_ftu_date_alk
        FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQUISITION_CUSTOMER_MART acm
    ) vt
    ON vt.acco_id = a.accounts_id
WHERE TO_VARCHAR(cs.data) ILIKE '%award_dm%'
