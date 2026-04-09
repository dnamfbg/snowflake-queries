-- Query ID: 01c39a2a-0212-644a-24dd-0703193e6577
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:26.196000+00:00
-- Elapsed: 120ms
-- Environment: FBG

SELECT
    * EXCLUDE (FBG_UAT, FBG_UAT_LAST_UPDATE, BET365, BET365_LAST_UPDATE, BETFAIR, BETFAIR_LAST_UPDATE, BETMGM, BETMGM_LAST_UPDATE, BETONLINE, BETONLINE_LAST_UPDATE, BETRIVERS, BETRIVERS_LAST_UPDATE, BOVADA, BOVADA_LAST_UPDATE, CAESARS, CAESARS_LAST_UPDATE, DRAFTKINGS, DRAFTKINGS_LAST_UPDATE, ESPN, ESPN_LAST_UPDATE, IBCBET, IBCBET_LAST_UPDATE, MARATHON, MARATHON_LAST_UPDATE, PINNACLE, PINNACLE_LAST_UPDATE, WILLHILL, WILLHILL_LAST_UPDATE, period_number, raw_created_timestamp, event_sport),
    DATEDIFF('second', FBG_LAST_UPDATE, PUSH_TIMESTAMP) AS FBG_LATENCY,
    DATEDIFF('second', FANDUEL_LAST_UPDATE, PUSH_TIMESTAMP) AS FANDUEL_LATENCY
FROM FBG_UNITY_CATALOG.QUANTS.price_alignment_history
WHERE
    market_type ILIKE '%Player%'
    AND event_sport = 'BASKETBALL'
    AND is_inplay = TRUE
    and fanduel <> 0
    and FBG <> 0
    --AND fixture_id = 'OF-3062887999'
    --AND incident_type IN ('Points')
    --AND selection = 'Over'
    --AND line = 2.5
    --AND player_name = 'Dean Wade'
    --AND period_type = 'FullTime'
    --and line = 12.5
    --and selection = 'Over'
    --and incident_type = 'Points'
    --and PLAYER_NAME = 'Karl-Anthony Towns'
    --and fixture_id = 'OF-3062924499'
    and abs(fbg-fanduel) > 2
    --AND end_timestamp < '2026-04-01'
    AND DATEDIFF('second', FANDUEL_LAST_UPDATE, PUSH_TIMESTAMP) <= DATEDIFF('second', FBG_LAST_UPDATE, PUSH_TIMESTAMP)
LIMIT 100000;
