-- Query ID: 01c399da-0212-67a9-24dd-0703192c138f
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:42:59.254000+00:00
-- Elapsed: 6064ms
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
        status IN ('ACCEPTED','SETTLED','VOID')
        AND test = 0 -- remove bets from test accounts
        --AND jurisdictions_id = 19
        --AND bet_type = 'SINGLE'
    AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) > '2024-08-29 01:00:00' -- adjust date/time
        --AND CONVERT_TIMEZONE('UTC', 'EST', placed_time) BETWEEN '2024-04-09 08:00:00' AND '2024-04-09 23:59:00' -- adjust date/time
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
        selection,
        instrument_id,
        market_id,
    FROM
    Bet_parts
    --WHERE sport = 'American_football'
        --AND event ILIKE '%1383870%' -- event name
      WHERE node_id in ('4058029')-- event ID
        --WHERE market ILIKE '%CLAYTON KERSHAW%' -- market name
        --WHERE market_id = '159937874' -- market ID
        --OR selection ILIKE '%CLAYTON KERSHAW%' -- selection name
        --WHERE instrument_id = (369853072) -- selection ID
        --AND mrkt_type = 'ICE_HOCKEY:FT:OTW:WIN'  -- market code
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
    bp.market_id,
    bp.selection,
    cashout_status,
    bp.instrument_id,
FROM
    BetsCTE bts
INNER JOIN
    AccountsCTE ac ON bts.acco_id = ac.id
INNER JOIN
    BetPartsCTE bp ON bts.id = bp.bet_id
ORDER BY
    bts.placed_time DESC, bts.id;
