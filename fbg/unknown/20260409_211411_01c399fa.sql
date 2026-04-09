-- Query ID: 01c399fa-0212-6b00-24dd-07031932eba7
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_XL_WH
-- Executed: 2026-04-09T21:14:11.828000+00:00
-- Elapsed: 3437ms
-- Environment: FBG

WITH parlay_legs AS (
    SELECT
        SOURCE,
        ACCOUNT_ID,
        PLACED_DATE_EST,
        DATE_TRUNC('MONTH', PLACED_DATE_EST) AS placed_month,
        LEG_SPORT_CATEGORY,
        SUM(BET_CT) AS bet_count,
        SUM(LEG_CT) AS leg_count,
        SUM(HANDLE) AS handle
    FROM FBG_GOVERNANCE.GOVERNANCE.BET_BY_PAGE
    WHERE BET_TYPE IN ('MULTIPLE', 'SGP_STACK')
      AND SOURCE = 'discover'
    GROUP BY SOURCE, ACCOUNT_ID, PLACED_DATE_EST, DATE_TRUNC('MONTH', PLACED_DATE_EST), LEG_SPORT_CATEGORY
),
account_source_date_sports AS (
    SELECT
        SOURCE,
        ACCOUNT_ID,
        PLACED_DATE_EST,
        placed_month,
        COUNT(DISTINCT LEG_SPORT_CATEGORY) AS distinct_sports,
        SUM(bet_count) AS total_bets,
        SUM(leg_count) AS total_legs,
        SUM(handle) AS total_handle
    FROM parlay_legs
    GROUP BY SOURCE, ACCOUNT_ID, PLACED_DATE_EST, placed_month
)
SELECT
    placed_month,
    SUM(total_bets) AS total_parlay_bets,
    SUM(CASE WHEN distinct_sports > 1 THEN total_bets ELSE 0 END) AS cross_sport_parlay_bets,
    ROUND(100.0 * SUM(CASE WHEN distinct_sports > 1 THEN total_bets ELSE 0 END) / NULLIF(SUM(total_bets), 0), 2) AS cross_sport_pct,
    SUM(total_handle) AS total_handle,
    SUM(CASE WHEN distinct_sports > 1 THEN total_handle ELSE 0 END) AS cross_sport_handle,
    ROUND(100.0 * SUM(CASE WHEN distinct_sports > 1 THEN total_handle ELSE 0 END) / NULLIF(SUM(total_handle), 0), 2) AS cross_sport_handle_pct,
    COUNT(DISTINCT ACCOUNT_ID) AS total_accounts,
    COUNT(DISTINCT CASE WHEN distinct_sports > 1 THEN ACCOUNT_ID END) AS cross_sport_accounts,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN distinct_sports > 1 THEN ACCOUNT_ID END) / NULLIF(COUNT(DISTINCT ACCOUNT_ID), 0), 2) AS cross_sport_account_pct
FROM account_source_date_sports
GROUP BY placed_month
ORDER BY placed_month
