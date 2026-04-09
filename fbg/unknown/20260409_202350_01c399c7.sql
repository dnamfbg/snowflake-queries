-- Query ID: 01c399c7-0212-67a9-24dd-07031927f8bf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:23:50.856000+00:00
-- Elapsed: 1892ms
-- Environment: FBG

SELECT settled_date_alk, acco_id, game_id, platform_id, state, is_test_account, 
       total_bet_count, total_stake, ggr, ngr, record_last_updated
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg
WHERE settled_date_alk IN ('2026-04-05', '2026-04-06')
  AND (acco_id, game_id, platform_id, state) IN (
    (3882983, '17056', '608111', 'NJ'),
    (1830771, '19454', '608111', 'PA'),
    (1830771, '19453', '608111', 'NJ'),
    (1830771, '19412', '610887', 'NJ'),
    (1830771, '19423', '610887', 'PA'),
    (1830771, '19421', '610887', 'MI'),
    (1830771, '19402', '610887', 'MI'),
    (1830771, '19422', '610887', 'NJ'),
    (1830771, '19424', '610887', 'NJ'),
    (1830771, '19435', '610887', 'PA'),
    (4286540, '18819', '610887', 'PA')
  )
ORDER BY settled_date_alk, acco_id
