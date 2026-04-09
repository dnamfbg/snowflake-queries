-- Query ID: 01c399f6-0212-6b00-24dd-070319325607
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:10:58.088000+00:00
-- Elapsed: 2763ms
-- Environment: FBG

SELECT
    DATE_TRUNC('WEEK', DATE(a.created)) AS week_start_monday,
    COUNT(DISTINCT a.accounts_id) AS eligible_accounts
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
GROUP BY 1
ORDER BY 1;
