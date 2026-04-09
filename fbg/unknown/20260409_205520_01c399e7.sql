-- Query ID: 01c399e7-0212-67a9-24dd-0703192e83fb
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:55:20.004000+00:00
-- Elapsed: 3223ms
-- Environment: FBG

select LEG_SPORT_CATEGORY, count(account_id) as Number_Of_Bets, sum(total_cash_stake_by_wager), sum(trading_win), sum(trading_win)/sum(total_cash_stake_by_wager)*100 as TWpct, count(distinct account_id)  from fbg_analytics_engineering.trading.trading_sportsbook_mart
where wager_bet_type = 'SQUAD_BET'
and is_test_wager = false
group by LEG_SPORT_CATEGORY
