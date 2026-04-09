-- Query ID: 01c39a29-0212-644a-24dd-0703193e0de7
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_SER_XL_WH_PROD
-- Last Executed: 2026-04-09T22:01:18.905000+00:00
-- Elapsed: 304ms
-- Run Count: 2
-- Environment: FBG

WITH BetsCTE AS (
    SELECT 
        id,
        acco_id,
        jurisdictions_id,
        CASE 
            WHEN jurisdictions_id = 2 THEN 'Ohio'
            WHEN jurisdictions_id = 3 THEN 'Tennessee'
            WHEN jurisdictions_id = 4 THEN 'Massachusetts'
            WHEN jurisdictions_id = 5 THEN 'Maryland'
            WHEN jurisdictions_id = 6 THEN 'Pennsylvania'
            WHEN jurisdictions_id = 7 THEN 'New Jersey'
            WHEN jurisdictions_id = 8 THEN 'Michigan'
            WHEN jurisdictions_id = 9 THEN 'Colorado'
            WHEN jurisdictions_id = 10 THEN 'Kentucky'
            WHEN jurisdictions_id = 11 THEN 'West Virginia'
            WHEN jurisdictions_id = 12 THEN 'Virginia'
            WHEN jurisdictions_id = 13 THEN 'Connecticut'
            WHEN jurisdictions_id = 14 THEN 'North Carolina'
            WHEN jurisdictions_id = 15 THEN 'New York'
            WHEN jurisdictions_id = 16 THEN 'Vermont'
            WHEN jurisdictions_id = 17 THEN 'Iowa'
            WHEN jurisdictions_id = 18 THEN 'Kansas'
            WHEN jurisdictions_id = 19 THEN 'Indiana'
            WHEN jurisdictions_id = 20 THEN 'Illinois'
            WHEN jurisdictions_id = 21 THEN 'Arizona'
            WHEN jurisdictions_id = 22 THEN 'Wyoming'
            WHEN jurisdictions_id = 23 THEN 'Louisiana'
            WHEN jurisdictions_id = 24 THEN 'DC'
            WHEN jurisdictions_id = 25 THEN 'Missouri'
            ELSE NULL
        END AS jurisdiction,
        total_stake,
        winnings,
        payout,
        bet_type,
        status,
        placed_time,
        CONVERT_TIMEZONE('America/New_York', PLACED_TIME) AS PLACED_TIME_EST, -- adjust timezone
        settlement_time,
        cashout_status,
        w2g_id
    FROM 
        BETS bts
    WHERE
        status IN ('ACCEPTED', 'SETTLED', 'VOID')
        --status IN ('SETTLED')
        --AND total_stake > 5
        --AND winnings > 100
        --AND test = 0 -- bets from test accounts
        --AND acco_id IN (1062318, 1440671)
        --AND jurisdictions_id = 25
        --AND bet_type = 'SINGLE'
        AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) > '2024-09-01 00:00:00' -- adjust date/time
        --AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) BETWEEN '2025-11-09 15:00:00' AND '2025-11-09 16:00:00' -- adjust date/time
        --AND cashout_status = 'COMPLETED' -- find cashout bets
        --AND w2g_id = 1
),

-- Table - Bet Parts
BetPartsCTE AS (
    SELECT 
        bet_id,
        part_no,
        event_time,
        price,
        sport,
        comp,
        event,
        node_id,
        market,
        mrkt_type,
        selection,
        selection_type,
        result_type,
    FROM 
        BET_PARTS
      --WHERE sport IN ('ICE_HOCKEY')
      --WHERE event ILIKE %Olympic%' -- event name
      --WHERE node_id IN (4209816) -- event ID 
      --WHERE selection_type = 'A'

      --AND (market ILIKE '%Sudakov%' OR selection ILIKE '%Sudakov%')

      --AND market ILIKE '%first reception%' -- market name
      WHERE market_id IN (559886324) -- market ID
      --and MRKT_TYPE ILIKE '%PROP%'

      --WHERE bet_id IN (26138244000259414) 
      
      --AND result_type = 'Lose'

      --AND selection ILIKE '%Goalscorer%' -- selection name
      --WHERE instrument_id IN (1382589312)  -- selection ID

      --WHERE comp ILIKE '%Ncaa Division I%'

      --WHERE mrkt_type IN ('TENNIS:P:WINNERANDTOTAL', 'TENNIS:P:GROUPCS')  -- market code
      --AND market iLIKE '%1+%'

      --WHERE price > 100 -- decimal odds
      --WHERE live_bet = 1 -- 1 = live, 0 = pre-match
        
),

-- Table - Accounts
AccountsCTE AS (
    SELECT 
        colour_cat, -- trading classification
        id, 
        ref1,
        pre_match_stake_coef
    FROM 
        ACCOUNTS
        --WHERE colour_cat = 'GREEN'
)

-- Join tables
SELECT 
    ac.colour_cat,
    ac.id, 
    ac.ref1,
    ac.pre_match_stake_coef,
    bts.id, 
    bts.jurisdictions_id,
    bts.jurisdiction,
    bts.total_stake,
    bp.price,
    bts.winnings,
    bts.payout,
    bts.bet_type,
    bts.status,
    bts.placed_time,
    bts.PLACED_TIME_EST,
    bts.settlement_time,
    bp.event_time,
    bp.part_no,
    bp.sport,
    bp.comp,
    bp.event,
    --bp.event_node_id,
    bp.market,
    --bp.market_id,
    bp.selection,
    cashout_status
    --bp.instrument_id,
FROM 
    BetsCTE bts
INNER JOIN 
    AccountsCTE ac ON bts.acco_id = ac.id
INNER JOIN 
    BetPartsCTE bp ON bts.id = bp.bet_id
ORDER BY
    bts.placed_time DESC, bts.id;
