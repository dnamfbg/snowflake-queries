-- Query ID: 01c399c8-0212-67a8-24dd-07031927de97
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:24:59.417000+00:00
-- Elapsed: 4952ms
-- Environment: FBG

SELECT 
    'old' AS tbl,
    SUM(total_stake) AS total_stake,
    SUM(total_payout) AS total_payout,
    SUM(ggr) AS ggr,
    SUM(ngr) AS ngr,
    SUM(cash_bet_stake) AS cash_stake,
    SUM(cash_bet_payout) AS cash_payout,
    SUM(freespin_bet_stake) AS fs_stake,
    SUM(freespin_bet_payout) AS fs_payout,
    SUM(expected_ggr) AS expected_ggr,
    SUM(expected_ngr) AS expected_ngr
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
UNION ALL
SELECT 
    'new',
    SUM(total_stake_usd),
    SUM(total_payout_usd),
    SUM(ggr_usd),
    SUM(ngr_usd),
    SUM(cash_bet_stake_usd),
    SUM(cash_bet_payout_usd),
    SUM(freespin_bet_stake_usd),
    SUM(freespin_bet_payout_usd),
    SUM(expected_ggr_usd),
    SUM(expected_ngr_usd)
FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
