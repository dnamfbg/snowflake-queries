-- Query ID: 01c39a28-0212-67a9-24dd-0703193de64b
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:00:39.660000+00:00
-- Elapsed: 13928ms
-- Environment: FBG

with accepted_vip_bets as (
  select
b.id ,
    b.bet_type,
    b.acco_id,
    b.total_stake,
    CASE WHEN jurisdictions_id = 2 THEN 'Ohio'
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
    jurisdictions_id
  from FBG_SOURCE.OSB_SOURCE.BETS b
  join FBG_ANALYTICS.TRADING.FCT_VIP_TIERS vb1 on b.acco_id = vb1.acco_id
  where b.status = 'ACCEPTED'
  and coded_total_tier = 'Tier 5'
  --or coded_total_tier = 'Tier 4'
),
the_parts as (
  select
    b.acco_id as acco_id,
    b.jurisdiction as jurisdiction,
    b.jurisdictions_id,
    bp.bet_id as bet_id,
bp.id as part_id,
    bp.stake as stake,
    bp.sport,
    bp.comp,
    bp.event,
    bp.node_id as event_id,
    CONVERT_TIMEZONE('UTC', 'Asia/Manila', bp.event_time) AS event_time_phst,
    bp.mrkt_type,
    bp.market,
    bp.selection,
    bp.instrument_id,
    bp.market_id,
    bp.result_type
  from FBG_SOURCE.OSB_SOURCE.BET_PARTS bp
  join accepted_vip_bets b on bp.bet_id = b.id
 WHERE
    event_time_phst >= DATEADD(DAY, -40, CONVERT_TIMEZONE('UTC', 'Asia/Manila', CURRENT_DATE)) -- event_time one day in the past, today, or within the next four days
    AND event_time_phst < DATEADD(DAY, 1, CONVERT_TIMEZONE('UTC', 'Asia/Manila', CURRENT_DATE))
  ),
filtered_bets as (
select
  tp.jurisdiction,
  tp.acco_id,
  tp.bet_id,
  tp.stake as handle,
  tp.sport,
  tp.comp,
  tp.event,
  tp.event_id,
  tp.event_time_phst,
  tp.market,
  tp.market_id,
  tp.selection,
  tp.instrument_id,
  tp.part_id
from the_parts tp
WHERE tp.result_type = 'NOT_SET'
AND NOT (
    (
    tp.comp ilike '%MLB%'
    AND (tp.mrkt_type IN ('BASEBALL:FTOT:ML','BASEBALL:FT:AXB', 'BASEBALL:FTOT:OU', 'BASEBALL:FTOT:SPRD', 'BASEBALL:P:OU', 'BASEBALL:FT:I1T5W','BASEBALL:P:OU5','BASEBALL:P:RUNYN', 'BASEBALL:P:RUNYN', 'BASEBALL:FT:ML')
      --AND handle <1000
    )
    OR
    (
    tp.comp ilike '%NBA%'
    AND (tp.mrkt_type IN ('BASKETBALL:FTOT:ML','BASKETBALL:FTOT:SPRD','BASKETBALL:FTOT:OU','BASKETBALL:P:SPRD','BASKETBALL:P:OU','BASKETBALL:P:ML','BASKETBALL:LTG:M3FG','BASKETBALL:P:B:OU','BASKETBALL:FTOT:B:OU','BASKETBALL:FTOT:A:OU','BASKETBALL:LTG:MBTTS','BASKETBALL:P:A:OU','BASKETBALL:FT:2M3PTSF3M','BASKETBALL:P:AXB','BASKETBALL:LTG:N4TP','BASKETBALL:P:WM','BASKETBALL:LTG:N4R','BASKETBALL:POT:OU','BASKETBALL:POT:ML','BASKETBALL:FT:OTYN','BASKETBALL:POT:SPRD','BASKETBALL:FTOT:WM5PT','BASKETBALL:FTOT:WM4W','BASKETBALL:FTOT:OE','BASKETBALL:FT:TWBH','BASKETBALL:FTOT:WM10PT','BASKETBALL:P:BTTS25','BASKETBALL:P:BTTS55','BASKETBALL:FT:BTTS23Q','BASKETBALL:FT:B:W4Q','BASKETBALL:FTOT:BTTS110','BASKETBALL:FT:AXB','BASKETBALL:FT:A:W4Q','BASKETBALL:FTOT:RTC','BASKETBALL:FT:PROPPPA','BASKETBALL:FT:PROPTD', 'BASKETBALL:FT:PROPPPAPR', 'BASKETBALL:FT:PROPREC1', 'BASKETBALL:FT:PROPAST', 'BASKETBALL:FT:PROPTDW', 'BASKETBALL:FT:PROP3PM', 'BASKETBALL:FT:PROPREB', 'BASKETBALL:FT:PROPAPR', 'BASKETBALL:FT:PROPPPR', 'BASKETBALL:FT:PROPPTS', 'BASKETBALL:FT:PROPDDW', 'BASKETBALL:FT:PROPBLKTG', 'BASKETBALL:FT:PROPDD', 'BASKETBALL:FT:PROPSTLTG', 'BASKETBALL:FT:PROP3PMTG', 'BASKETBALL:FT:PROPASTTG', 'BASKETBALL:FT:PROPREBTG', 'BASKETBALL:FT:PROPPTSTG','BASKETBALL:P:RX3W','BASKETBALL:LTG:TSNP','BASKETBALL:FTOT:WM','BASKETBALL:FTOT:DBLC','BASKETBALL:FT:B:PROPTFBS','BASKETBALL:FT:PROPTOV','BASKETBALL:LTG:TNFG4W','BASKETBALL:NBAGPROP:FBGMFB','BASKETBALL:FT:PROPTPS','BASKETBALL:FT:PROPBLK','BASKETBALL:FT:PROPSTL','BASKETBALL:FT:B:PROPTTPS','BASKETBALL:FT:PROPPTSTG','BASKETBALL:FT:PROPASTTG')
      --AND handle <1000
     ))
    OR
    (
    tp.comp ilike '%NFL%'
    AND (tp.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:ML','AMERICAN_FOOTBALL:FT:PROPRCYDS','AMERICAN_FOOTBALL:P:SPRD','AMERICAN_FOOTBALL:FTOT:CDR','AMERICAN_FOOTBALL:FT:PROPRSYDS','AMERICAN_FOOTBALL:P:OU','AMERICAN_FOOTBALL:FT:PROPPSYDS','AMERICAN_FOOTBALL:FTOT:NPR','AMERICAN_FOOTBALL:FT:PROPRSYDS','AMERICAN_FOOTBALL:FTOT:CDR','AMERICAN_FOOTBALL:P:B:OU','AMERICAN_FOOTBALL:P:A:OU','AMERICAN_FOOTBALL:FTOT:RECCD','AMERICAN_FOOTBALL:FTOT:A:OU','AMERICAN_FOOTBALL:FTOT:B:OU','AMERICAN_FOOTBALL:FTOT:RSYDSCD','AMERICAN_FOOTBALL:FTOT:PSYDSCD','AMERICAN_FOOTBALL:FT:PROPREC','AMERICAN_FOOTBALL:FTOT:1DCD','AMERICAN_FOOTBALL:FT:PROPRCTDSW','AMERICAN_FOOTBALL:FT:PROPLNGREC','AMERICAN_FOOTBALL:FT:PROPRSATT','AMERICAN_FOOTBALL:FTOT:RX','AMERICAN_FOOTBALL:P:ML')
    --AND handle < 249
    )
    OR
    (
    tp.comp ilike '%NCAAF%'
    AND (tp.mrkt_type IN ('AMERICAN_FOOTBALL:FTOT:ML'))
    --AND handle < 1999
    )
    OR
    (
    tp.sport ilike '%Golf%'
    AND (tp.mrkt_type IN ('GOLF:FT:WIN','GOLF:FT:STOTW:WIN'))
    --AND handle < 100
    )
    OR
    (
    tp.comp ilike '%OddsFactory Premier League%'
    AND (tp.mrkt_type IN ('SOCCER:FT:AXB','SOCCER:FT:OU','SOCCER:FT:DNB','SOCCER:FT:DBLC','SOCCER:FT:BTS','SOCCER:FT:A:OU','SOCCER:FT:B:OU','SOCCER:FT:AHCP','SOCCER:FT:AGSC','SOCCER:FT:COU','SOCCER:P:A:OU','SOCCER:P:AXB','SOCCER:P:B:OU','SOCCER:P:COU','SOCCER:FT:B:COU','SOCCER:FT:A:COU','SOCCER:P:AHCP','SOCCER:FT:FGSC','SOCCER:FT:PS2G','SOCCER:FT:15MR','SOCCER:P:BTS','SOCCER:P:B:COU','SOCCER:FT:60MR','SOCCER:FT:HATR','SOCCER:P:A:COU','SOCCER:P:DBLC1','SOCCER:FT:30MR','SOCCER:FT:CLS','SOCCER:FT:PROPPLTAC','SOCCER:FT:CAXB'))
    --AND handle < 1999
    )
    OR
    (
    tp.comp ilike '%NCAA%'
    AND (tp.mrkt_type IN ('BASKETBALL:P:SPRD' , 'BASKETBALL:P:OU' , 'BASKETBALL:P:DNB' , 'BASKETBALL:FTOT:A:OU' , 'BASKETBALL:FTOT:B:OU' , 'BASKETBALL:POT:OU' , 'BASKETBALL:P:A:OU' , 'BASKETBALL:POT:SPRD' , 'BASKETBALL:FTOT:WM10PT' , 'BASKETBALL:POT:ML' , 'BASKETBALL:FT:TWBH' , 'BASKETBALL:P:B:OU' , 'BASKETBALL:FTOT:WM5PT' , 'BASKETBALL:P:AXB' , 'BASKETBALL:P:WM' , 'BASKETBALL:FTOT:OE' , 'BASKETBALL:FTOT:ML' , 'BASKETBALL:FTOT:SPRD' , 'BASKETBALL:FTOT:OU', 'BASKETBALL:FT:PROPREB', 'BASKETBALL:FT:PROPPTS', 'BASKETBALL:FT:PROPREBTG', 'BASKETBALL:FT:PROPPTSTG', 'BASKETBALL:FT:PROPASTTG', 'BASKETBALL:FT:PROPAST','BASKETBALL:LTG:N4R','BASKETBALL:LTG:M3FG','BASKETBALL:LTG:MBTTS','BASKETBALL:LTG:N4TP','BASKETBALL:LTG:TSNP','BASKETBALL:FT:TWBH','BASKETBALL:FT:PROP3PM'))
    --AND handle < 1999
    )
    OR
    (
    tp.sport ilike '%Tennis%'
    AND (tp.mrkt_type IN ('TENNIS:P:PW','TENNIS:G:PW', 'TENNIS:P:GCSL','TENNIS:P:GW' ))
    --AND handle < 1999
    )
    OR
    (
    tp.comp ilike '%NHL%'
    AND (tp.mrkt_type IN ('ICE_HOCKEY:P:DBLC','ICE_HOCKEY:P:OU','ICE_HOCKEY:FT:NG','ICE_HOCKEY:P:AXB','ICE_HOCKEY:P:SPRD','ICE_HOCKEY:P:OE','ICE_HOCKEY:P:BTS','ICE_HOCKEY:FT:PROP1STSCO','ICE_HOCKEY:P:DNB','ICE_HOCKEY:FT:APUN','ICE_HOCKEY:FTOT:ML','ICE_HOCKEY:FTOT:OU','ICE_HOCKEY:FTOT:SPRD'))
    --AND handle < 999
    )
))))
select
  --count(fb.bet_id) "Bet Count",
  --sum(fb.handle) "Handle",
  fb.sport,
  fb.comp,
  fb.event,
  fb.event_id,
  fb.event_time_phst,
  fb.market,
  fb.instrument_id,
  fb.selection,
from filtered_bets fb
group by all
order by event_time_phst asc
