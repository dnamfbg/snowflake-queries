-- Query ID: 01c399e6-0212-6b00-24dd-0703192e5333
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T20:54:12.485000+00:00
-- Elapsed: 37554ms
-- Environment: FBG

WITH parlay_sports AS (
    SELECT
        WAGER_ID,
        ACCOUNT_ID,
        COUNT(DISTINCT LEG_SPORT_CATEGORY) AS distinct_sports
    FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART
    WHERE IS_WAGER_SINGLE_OR_PARLAY = 'Parlay'
      AND IS_TEST_WAGER = FALSE
    GROUP BY WAGER_ID, ACCOUNT_ID
)
SELECT
    COUNT(*) AS total_parlays,
    SUM(CASE WHEN distinct_sports > 1 THEN 1 ELSE 0 END) AS cross_sport_parlays,
    ROUND(100.0 * SUM(CASE WHEN distinct_sports > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS cross_sport_parlay_pct,
    COUNT(DISTINCT CASE WHEN distinct_sports > 1 THEN ACCOUNT_ID END) AS customers_with_cross_sport,
    COUNT(DISTINCT ACCOUNT_ID) AS total_parlay_customers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN distinct_sports > 1 THEN ACCOUNT_ID END) / COUNT(DISTINCT ACCOUNT_ID), 2) AS pct_customers_with_cross_sport
FROM parlay_sports
