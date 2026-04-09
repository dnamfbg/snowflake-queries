-- Query ID: 01c399f9-0212-67a8-24dd-07031932dd73
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T21:13:32.484000+00:00
-- Elapsed: 1636ms
-- Environment: FBG

SELECT * FROM ( ( SELECT 
    loyalty_tier,
    COUNT(DISTINCT acco_id) as n_clients,
    COUNT(DISTINCT CASE WHEN share_4w > 0 THEN acco_id END) as n_positive_sow,
    ROUND(MEDIAN(CASE WHEN share_4w > 0 THEN share_4w END), 4) as med_sow_4w,
    ROUND(AVG(CASE WHEN share_4w > 0 THEN share_4w END), 4) as avg_sow_4w,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CASE WHEN share_4w > 0 THEN share_4w END), 4) as p25_sow_4w,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CASE WHEN share_4w > 0 THEN share_4w END), 4) as p75_sow_4w,
    ROUND(MEDIAN(CASE WHEN total_4w > 0 THEN total_4w END), 2) as med_total_4w
FROM (
    SELECT DISTINCT acco_id, loyalty_tier, share_4w, total_4w
    FROM FBG_ANALYTICS_DEV.DAN_ZHAO.MECHANICS_TEST_202602_OR_SOW_TOTAL_TRUSTLY_ONLY
)
GROUP BY loyalty_tier
ORDER BY n_clients DESC ) ) AS "SF_CONNECTOR_QUERY_ALIAS"
