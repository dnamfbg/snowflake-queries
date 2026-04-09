-- Query ID: 01c399d0-0212-6b00-24dd-07031929b64b
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_SER_M_WH_PROD
-- Executed: 2026-04-09T20:32:33.737000+00:00
-- Elapsed: 4883ms
-- Environment: FBG

WITH BetsCTE AS (
    SELECT
        id,
        acco_id,
        total_stake,
        winnings,
        payout,
        bet_type,
        status,
        placed_time,
        CONVERT_TIMEZONE('America/New_York', placed_time) AS placed_time_est,
        settlement_time,
        cashout_status
    FROM BETS
    WHERE status IN ('ACCEPTED','SETTLED','VOID')
),
BetPartsCTE AS (
    SELECT
        bet_id,
        part_no,
        node_id,          -- Event ID
        event_time,       -- timestamp (date + time)
        price,
        sport,
        comp,
        event,
        market,
        market_id,        -- Market ID
        selection
    FROM BET_PARTS
    -- Optional: filter a specific event
    WHERE node_id = 4208050
    
),
AccountsCTE AS (
    SELECT
        id,
        colour_cat
    FROM ACCOUNTS
),

-- De-duplicate at the (bet, selection, market, event) grain
Grain AS (
    SELECT DISTINCT
        bp.node_id                               AS event_id,
        bts.id                                   AS bet_id,
        bts.total_stake                          AS bet_stake,
        CASE WHEN UPPER(ac.colour_cat) = 'GREEN' THEN 1 ELSE 0 END AS is_green,
        bp.sport,
        bp.event_time                            AS event_ts,  -- keep full timestamp; convert if needed
        bp.comp,
        bp.event,
        bp.market,
        bp.market_id,
        bp.selection
    FROM BetsCTE bts
    JOIN AccountsCTE ac ON bts.acco_id = ac.id
    JOIN BetPartsCTE bp ON bts.id = bp.bet_id
)

SELECT
    event_id                                       AS "Event ID",
    sport                                          AS "Sport",
    event_ts                                       AS "Event Date",
    comp                                           AS "Comp",
    event                                          AS "Event",
    market                                         AS "Market",
    market_id                                      AS "Market ID",
    selection                                      AS "Selection",
    COUNT(DISTINCT bet_id)                         AS "Wagers",
    CAST(SUM(bet_stake) AS DECIMAL(18,2))          AS "Stakes",
    COUNT(DISTINCT CASE WHEN is_green = 1 THEN bet_id END) AS "VIP Wagers"
FROM Grain
GROUP BY
    event_id, sport, event_ts, comp, event, market, market_id, selection
ORDER BY
    UPPER(market) ASC,
    market_id ASC;
