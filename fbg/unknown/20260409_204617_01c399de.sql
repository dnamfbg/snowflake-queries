-- Query ID: 01c399de-0212-67a9-24dd-0703192c97af
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:46:17.550000+00:00
-- Elapsed: 1103ms
-- Environment: FBG

SELECT DISTINCT
        acco_id,
       gift_type,
        tracking,
    
    FROM fbg_sheetzu.default.loyalty_gifting_tracker 
    WHERE campaign = 'Masters 2026'
