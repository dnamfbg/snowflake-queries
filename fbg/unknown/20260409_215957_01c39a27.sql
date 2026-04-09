-- Query ID: 01c39a27-0212-6cb9-24dd-0703193d9bbf
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:59:57.115000+00:00
-- Elapsed: 1764ms
-- Environment: FBG

SELECT COUNT(*) AS total_rows, COUNT(PINNACLE) AS non_null, COUNT(CASE WHEN PINNACLE != 0 THEN 1 END) AS non_zero FROM FBG_UNITY_CATALOG.QUANTS.price_alignment_history WHERE EVENT_SPORT = 'BASKETBALL' AND MARKET_TYPE = 'PlayerPropsOverUnder' AND INCIDENT_TYPE = 'Points' AND IS_INPLAY = 'TRUE' LIMIT 1
