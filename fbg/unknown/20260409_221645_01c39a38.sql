-- Query ID: 01c39a38-0212-6cb9-24dd-070319419e3b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:16:45.665000+00:00
-- Elapsed: 880ms
-- Environment: FBG

SELECT * FROM FBG_ANALYTICS.TRADING.LIVE_CM_HOURLY
ORDER BY CASE
        WHEN report = 'Live CM: Courtside' THEN 1 
        WHEN report = 'Live CM: Soccer FF' THEN 2
        WHEN report = 'Live CM: Tennis FF' THEN 3
        WHEN report = 'Live CM: Locations' THEN 4
        WHEN report = 'Live CM: Business Change' THEN 5
        WHEN report = 'Live CM: Max Bets' THEN 6
        WHEN report = 'Live CM: Negative Mix' THEN 7
        WHEN report = 'Live CM: High Stakes' THEN 8
        WHEN report = 'Live CM: High Deposit' THEN 9
        WHEN report = 'Live CM: PM Top X' THEN 10
        WHEN report = 'Live CM: Devices' THEN 11
        WHEN report = 'Live CM: Max Payout' THEN 12
        ELSE 13 END,Recommended_Action, PM_Stake_Factor DESC;
