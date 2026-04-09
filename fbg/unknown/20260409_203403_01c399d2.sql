-- Query ID: 01c399d2-0212-6dbe-24dd-0703192a2427
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:34:03.692000+00:00
-- Elapsed: 1982ms
-- Environment: FBG

select * from FBG_SOURCE.OSB_SOURCE.BET_PARTS  where mrkt_type like '%NCAABCHAMPEALL%' limit 1000
