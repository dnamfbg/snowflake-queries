-- Query ID: 01c399d6-0212-6dbe-24dd-0703192acd1b
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T20:38:27.411000+00:00
-- Elapsed: 4127ms
-- Environment: FBG

SELECT
bp.market_id "MarketID"
,bp.market "Market"
,bp.event "Event"
,n.id "Event ID"
,bp.selection "Selection"
,case when m.state = 'COMPLETED'
then
CONVERT_TIMEZONE('UTC','America/New_York', dateadd('ms',(IFNULL(nullif((SPLIT_PART(SPLIT_PART (m.attributes, 'firstResultedTime=', 2), ';', 1)::varchar), ''),0)),'1970-01-01'))
else Null end as "FirstResultedTime"
,CONVERT_TIMEZONE('UTC','America/New_York',bp.event_time) "Event Time EST",
count(b.id) "Bet Count",
sum(b.total_stake) "Handle",
m.attributes,
-- TABLES & JOINS
FROM FBG_SOURCE.OSB_SOURCE.BETS b
LEFT JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS bp ON b.id = bp.bet_id
LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON a.id = b.acco_id
LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VALUE_BANDS vb1 ON (vb1.acco_id = a.id)
LEFT JOIN FBG_SOURCE.OSB_SOURCE.MARKETS m ON m.id = bp.market_id
LEFT JOIN FBG_SOURCE.OSB_SOURCE.NODES n ON m.node_id = n.id
LEFT JOIN FBG_SOURCE.OSB_SOURCE.EVENT_RESULTS e ON e.event_id = n.id
LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS s ON (s.bet_id = b.id and s.trans = 'SETTLEMENT')
LEFT JOIN users
-- FILTERS
WHERE a.test = 0
--and bp.event_time > '2024-05-26 00:00:00'
--and vb.segment IN ('VIP', 'Superfan', 'Casual', 'Negative', null) -- segment filter
--and m.MRKT_TYPE LIKE '%PROP%' -- Player Prop filter, for Non Player Props use m.MRKT_TYPE NOT --LIKE '%PROP%'
--and bp.market ilike '%1st Half%'
--and bp.SPORT ilike '%Basketball%' AND (bp.COMP ilike '%NCAA%' OR bp.Comp = 'National Invitation Tournament' OR bp.Comp ILIKE '%COLLEGE%') -- NCAA Basketball only
--and bp.setl_time is null
--and bp.node_ID = 3001996
--and bp.market_ID = 171694193
and bp.instrument_ID = 1385696273
GROUP BY ALL
