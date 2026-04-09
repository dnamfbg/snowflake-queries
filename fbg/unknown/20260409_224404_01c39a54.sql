-- Query ID: 01c39a54-0212-6dbe-24dd-07031947a26f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T22:44:04.691000+00:00
-- Elapsed: 31075ms
-- Environment: FBG

WITH bonus_campaigns AS (

SELECT
    -- Core details
    PARSE_JSON(data):Bonus:id::INT                          AS bonus_id,
    PARSE_JSON(data):Bonus:name::STRING                      AS bonus_name


FROM fbg_source.osb_source.bonus_campaigns
WHERE
    (bonus_name like '%MLB Longball Jackpot%' or bonus_name like '%MLB Long Ball Jackpot%')

),

bets_stage AS (

SELECT
    bets.id,
    bets.acco_id,
    bet_parts.instrument_id,
    bets.result,
    bets.bet_type,
    bets.parlay_type,
    bet_parts.mrkt_type,
    REGEXP_REPLACE(bet_parts.selection, '\\s\\d\\+$', '') AS player_stage,
    to_date(convert_timezone('UTC', 'America/Anchorage', bet_parts.event_time)) AS event_date
    
FROM
    fbg_source.osb_source.bets
INNER JOIN
    bonus_campaigns
    ON bets.bonus_campaign_id = bonus_campaigns.bonus_id
INNER JOIN
    fbg_source.osb_source.bet_parts
    ON bets.id = bet_parts.bet_id
INNER JOIN
    fbg_source.osb_source.accounts
    ON bets.acco_id = accounts.id
WHERE
    1=1
    AND
    bets.status NOT IN ('REJECTED' , 'VOID')
    AND
    result <> 4
    AND
    to_date(convert_timezone('UTC', 'America/Anchorage', bet_parts.event_time)) >= '2026-03-26'
    AND
    accounts.test = 0
)


, player_name AS (
    SELECT
        ps.instrument_id,
        MAX(COALESCE(se.name, entity_name)) AS player
    FROM
        bets_stage ps
    INNER JOIN 
        fbg_source.osb_source.instrument_participants AS ip
        ON ps.instrument_id = ip.instrument_id
    LEFT OUTER JOIN
        fbg_source.osb_source.SDP_EXTERNAL_ID_MAPPINGS AS sim
        ON ip.sdp_external_id_mapping_canonical_id = sim.canonical_id
    LEFT OUTER JOIN
        fbg_source.osb_source.SDP_ENTITIES AS se
        ON sim.entity_id = se.canonical_id
    WHERE
        se.entity_type = 'player'
    GROUP BY
        ALL
)

SELECT
    bets_stage.event_date as selection_date,
    COALESCE(player, player_stage) AS player_name,
    COUNT(DISTINCT bets_stage.acco_id) AS entries,
    50000 / NULLIF(entries, 0) expected_payout_per_winner
FROM
    bets_stage
LEFT OUTER JOIN
    player_name AS pn
    ON bets_stage.instrument_id = pn.instrument_id
WHERE 1=1
  AND bets_stage.event_date = '2026-04-09'
GROUP BY ALL
order by 1 desc, 4 desc
;
