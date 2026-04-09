-- Query ID: 01c399ca-0212-6cb9-24dd-070319284cbb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:26:54.125000+00:00
-- Elapsed: 2873ms
-- Environment: FBG

select LEG_SPORT_CATEGORY, sum(total_cash_stake_by_wager), sum(trading_win), sum(trading_win)/sum(total_cash_stake_by_wager)*100 as TWpct, count(distinct account_id)  from fbg_analytics_engineering.trading.trading_sportsbook_mart
where wager_bet_type = 'SQUAD_BET'
and is_test_wager = false
group by LEG_SPORT_CATEGORY
