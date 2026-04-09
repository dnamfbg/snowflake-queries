-- Query ID: 01c39a3c-0212-6dbe-24dd-07031942b333
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:20:52.551000+00:00
-- Elapsed: 34539ms
-- Run Count: 2
-- Environment: FBG

INSERT INTO FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_10k(

select  a.acco_id,
        acc.vip,
        host.name as vip_host,
        convert_timezone('UTC','America/New_York', a.placed_time) as placed_time,
        j.jurisdiction_code as state,
        a.id as bet_id,
        CASE WHEN a.status = 'ACCEPTED' THEN 'Open'
             WHEN a.status = 'SETTLED' AND a.result = 4 THEN 'Cashout'
             WHEN a.status = 'SETTLED' AND a.payout = 0 THEN 'Loss'
             WHEN a.status = 'SETTLED' AND a.payout > 0 THEN 'Win'
        END as bet_status,
        a.total_stake as stake,
        CASE WHEN a.Build_A_Bet = 't' then 'SGP' 
              WHEN a.Teaser_Price IS NOT NULL THEN 'TEASER'
              WHEN a.Bet_Type = 'MULTIPLE' then 'Parlay'
              WHEN a.Bet_Type = 'SINGLE' then 'Single'
              ELSE a.Bet_Type
        END AS bet_type,
        a.Num_Lines AS Legs,
        CASE WHEN total_price >= 2 THEN ROUND(((a.total_price-1)*100),0)
             ELSE ROUND((-100/(a.total_price-1)),0)
        END as odds,
        bp.selection,
        bp.sport,
        round((total_price * total_stake) - total_stake, 2) as possible_win
        
from FBG_SOURCE.OSB_SOURCE.BETS as a

left join (
            select bet_id,
                   RTRIM(LISTAGG(DISTINCT CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ')) WITHIN GROUP (ORDER BY CONCAT(Event, ' / ', Market, ' / ',Selection, ' + ') DESC),' + ') AS selection,
                   RTRIM(LISTAGG(DISTINCT CONCAT(sport,' + ')) WITHIN GROUP (ORDER BY CONCAT(sport, ' + ') DESC),' + ') AS sport
            from FBG_SOURCE.OSB_SOURCE.BET_PARTS
            where stake >= 1000
            group by 1
           ) as bp
on a.id = bp.bet_id

LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS J
on a.Jurisdictions_Id = j.Id

LEFT JOIN FBG_ANALYTICS_DEV.DANIEL_RUSTICO.big_bet_alert_historical_10k as b
on a.id = b.bet_id

INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS as acc
on a.acco_id = acc.id

LEFT JOIN vip_host as host
on a.acco_id = host.acco_id

WHERE acc.test = 0
and a.status IN ('ACCEPTED', 'SETTLED')
and a.channel = 'INTERNET'
and a.total_stake >= 10000
and b.bet_id is null

)
