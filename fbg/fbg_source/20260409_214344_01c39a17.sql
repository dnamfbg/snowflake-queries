-- Query ID: 01c39a17-0212-67a9-24dd-0703193a707b
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:43:44.030000+00:00
-- Elapsed: 6881ms
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
        cashout_status
    FROM
        BETS bts
    WHERE
        status IN ('ACCEPTED','SETTLED', 'VOID')
        AND test = 0 -- remove bets from test accounts
       --AND jurisdictions_id = 15
        --AND bet_type = 'SINGLE'
    AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) > '2023-10-01 00:00:00' -- adjust date/time
        --AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) BETWEEN '2023-12-30 18:00:00' AND '2025-01-01 00:00:00' -- adjust date/time
        --AND cashout_status = 'COMPLETED' -- find cashout bets
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
        market,
        selection
    FROM
        BET_PARTS
   --WHERE sport = 'League of Legends'
        --AND event ILIKE '%Raptors%' -- event name
        --AND comp = 'Ncaa'
    --WHERE node_id = 4058029
        -- event ID
        --AND market ILIKE '%zubac%' -- market name
    WHERE market_id = 559801628 -- market ID
        --WHERE bet_id IN (25045905000019413)
        --AND selection ILIKE '%zubac%' -- selection name
    --WHERE instrument_id = 1331550585 -- selection ID
        --AND mrkt_type = 'BASKETBALL:FTOT:A:OU'  -- market code
        --AND price > 3.5 -- decimal odds
        --AND live_bet = 1 -- 1 = live, 0 = pre-match
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
        --WHERE ID = 3223415
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
