-- Query ID: 01c399fa-0212-6b00-24dd-07031932eacb
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:14:06.477000+00:00
-- Elapsed: 2075ms
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
WHERE TO_VARCHAR(cs.data) ILIKE ANY ('%100dm%','%50dm%')
GROUP BY 1
ORDER BY 1;
