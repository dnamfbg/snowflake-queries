-- Query ID: 01c399c8-0212-644a-24dd-07031928171b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:24:21.107000+00:00
-- Elapsed: 4043ms
-- Environment: FBG

SELECT 
    'old' AS tbl,
    SUM(total_bet_count) AS total_bets,
    SUM(cash_bet_count) AS cash_bets,
    SUM(freespin_bet_count) AS freespin_bets,
    SUM(casino_credit_bet_count) AS credit_bets,
    SUM(cash_bet_round_count) AS cash_rounds,
    SUM(freespin_bet_round_count) AS freespin_rounds,
    SUM(casino_credit_bet_round_count) AS credit_rounds
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
UNION ALL
SELECT 
    'new',
    SUM(total_bet_count),
    SUM(cash_bet_count),
    SUM(freespin_bet_count),
    SUM(casino_credit_bet_count),
    SUM(cash_bet_round_count),
    SUM(freespin_bet_round_count),
    SUM(casino_credit_bet_round_count)
FROM fbg_analytics_engineering.casino.gold__casino_daily_settled_agg_usd
WHERE settled_date_alk BETWEEN '2026-01-01' AND '2026-04-04'
