-- Query ID: 01c399eb-0112-6ccc-0000-e3072189ef3a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T20:59:21.942000+00:00
-- Elapsed: 288ms
-- Environment: FES

WITH results AS (
    -- paste just the fan_count for Q1 26 TTM
    SELECT 'FBG Only' AS opco, 1845098 AS fan_count
    UNION ALL SELECT 'SBK Only', 1160780
    UNION ALL SELECT 'Casino Only', 310567
    UNION ALL SELECT 'SBK + Casino', 357946
)
SELECT
    SUM(CASE WHEN opco != 'FBG Only' THEN fan_count END) AS split_total,
    MAX(CASE WHEN opco = 'FBG Only' THEN fan_count END) AS fbg_only,
    SUM(CASE WHEN opco != 'FBG Only' THEN fan_count END) -
    MAX(CASE WHEN opco = 'FBG Only' THEN fan_count END) AS diff
FROM results
