-- Query ID: 01c399df-0212-644a-24dd-0703192cd703
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:47:17.150000+00:00
-- Elapsed: 21749ms
-- Environment: FBG

WITH base AS (
        SELECT SPLIT_PART(bp.mrkt_type, ':', -1) AS prop_type,     CASE
                WHEN SPLIT_PART(bp.mrkt_type, ':', -1) IN ('ML','12', 'NCAABCHAMPEALL') THEN 'Moneyline'
                WHEN SPLIT_PART(bp.mrkt_type, ':', -1) IN ('OU','BTTS', 'DNB') THEN 'Total'
                WHEN SPLIT_PART(bp.mrkt_type, ':', -1) IN ('AH','HC', 'SPRD') THEN 'Spread'
                WHEN SPLIT_PART(bp.mrkt_type, ':', -1) = 'OT' THEN 'Future'
                WHEN SPLIT_PART(bp.mrkt_type, ':', -1) LIKE 'P:%' THEN 'PlayerProps'
                ELSE 'Prop'
            END AS bet_type_consolidated, rt.TRANSACTION_WAGER_ID
        FROM FBG_ANALYTICS_ENGINEERING.REGULATORY.REGULATORY_TRANSACTIONS_MART rt
        JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON bp.bet_id = rt.TRANSACTION_WAGER_ID::NUMBER AND bp.part_no = 1
        WHERE rt.TRANSACTION_LOCATION_INITIALS = 'MA'
          AND rt.TRANSACTION_TYPE IN ('STAKE','FREEBET_STAKE')
          AND (bp.COMP_ID = 417222 OR bp.NODE_ID = 2232743)
          AND bp.event_time::DATE BETWEEN '2026-03-17' AND '2026-04-07'
          AND COALESCE(bp.mrkt_type, '') NOT LIKE '%NCAAW%'
          AND SPLIT_PART(bp.mrkt_type, ':', -1) NOT IN ('ML','12','OU','BTTS','AH','HC','OT')
    )
    SELECT prop_type, bet_type_consolidated,COUNT(DISTINCT TRANSACTION_WAGER_ID) AS bet_count FROM base 
    GROUP BY all ORDER BY 2 DESC ;
