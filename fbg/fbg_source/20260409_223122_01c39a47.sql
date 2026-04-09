-- Query ID: 01c39a47-0212-6cb9-24dd-07031944af1b
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:31:22.455000+00:00
-- Elapsed: 893192ms
-- Environment: FBG

SELECT "Custom SQL Query"."# of Bets" AS "# of Bets",
  "Custom SQL Query"."# of Bettors" AS "# of Bettors",
  "Custom SQL Query"."# of In-Play Bets" AS "# of In-Play Bets",
  "Custom SQL Query"."# of Parlay Bets" AS "# of Parlay Bets",
  "Custom SQL Query"."# of Pre-Match Bets" AS "# of Pre-Match Bets",
  "Custom SQL Query"."# of Straight Bets" AS "# of Straight Bets",
  "Custom SQL Query"."Adjusted Gaming Revenue" AS "Adjusted Gaming Revenue",
  "Custom SQL Query"."BET_TYPE_CONSOLIDATED" AS "BET_TYPE_CONSOLIDATED",
  "Custom SQL Query"."Bonus Cancel" AS "Bonus Cancel",
  "Custom SQL Query"."Bonus Handle" AS "Bonus Handle",
  "Custom SQL Query"."Bonus Settlement" AS "Bonus Settlement",
  "Custom SQL Query"."Bonus Void" AS "Bonus Void",
  "Custom SQL Query"."Cash Cancel" AS "Cash Cancel",
  "Custom SQL Query"."Cash Handle" AS "Cash Handle",
  "Custom SQL Query"."Cash Settlement" AS "Cash Settlement",
  "Custom SQL Query"."Cash Void" AS "Cash Void",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."Gross Handle" AS "Gross Handle",
  "Custom SQL Query"."MARKET" AS "MARKET",
  "Custom SQL Query"."Net Handle" AS "Net Handle",
  "Custom SQL Query"."Previous Day Total Stake" AS "Previous Day Total Stake",
  "Custom SQL Query"."SELECTION" AS "SELECTION",
  "Custom SQL Query"."Same Day Total Stake" AS "Same Day Total Stake",
  "Custom SQL Query"."State" AS "State",
  "Custom SQL Query"."TOP_HANDLE_FUTURE_BY_STATE" AS "TOP_HANDLE_FUTURE_BY_STATE",
  "Custom SQL Query"."TOP_NUM_BETS_FUTURE_BY_STATE" AS "TOP_NUM_BETS_FUTURE_BY_STATE",
  "Custom SQL Query"."TOURNAMENT_ROUND" AS "TOURNAMENT_ROUND",
  "Custom SQL Query"."Total Win" AS "Total Win"
FROM (
  with TIMEZONE AS (
      select
          *
      from
          FBG_ANALYTICS.REFERENCE_TABLES.STATE_TIMEZONES_MAP
      where
          IS_PRIMARY_TIMEZONE = 'TRUE'
  )
  ------------------------------------------------------------------------------------------------------------------------------
  ,transactions as (
  select
      DATEADD(seconds, -reporting_time_offset_seconds, convert_TIMEZONE('UTC',TIMEZONE, acs.trans_date)) as gaming_trans_date
      , acs.trans_date
      , acs.id
      , acs.trans
      , acs.amount
      , acs.acco_id
      , acs.jurisdictions_id
      , acs.fund_type_id
      , fund.code as fund_type
      , acs.bet_id
      , (CAST(parse_json(acs.additional_info):settlementVersion as smallint)) as acs_settlement_version
  	, acs.additional_info
  	, t.TIMEZONE
      , game_id
  	, j.jurisdiction_name as state
      , reporting_time_offset_seconds
      , m.bonus_origin AS bonus_origin
      , coalesce(b.status,'transaction') as status
      , b.NUM_LINES
      , case when acs.game_id is not null and trans = 'REFUND' then 'VOID'
              when acs.game_id is not null and trans = 'SETTLEMENT' then 'SETTLED'
              when acs.game_id is null and trans = 'REFUND' and (trans_ref like 'P-%' or trans_ref like 'RFT-P%') then 'SETTLED'
              when acs.game_id is null and trans = 'REFUND' and (trans_ref like 'V-%' or trans_ref like 'RFT-V%') then 'VOID'
              when acs.game_id is null and trans = 'SETTLEMENT' and (trans_ref like 'L-%' or trans_ref like 'W%') then 'SETTLED'
              when acs.game_id is null and acs.trans = 'SETTLEMENT' and (acs.trans_ref like 'CO-%') then 'SETTLED'
              when acs.game_id is null and trans in ('STAKE','FREEBET_STAKE') then 'ACCEPTED'
              end as updated_status,
       coalesce(updated_status,lag(updated_status) IGNORE nulls over (
                      PARTITION by acs.bet_id
                      ORDER BY
                          acs.trans_date ASC
                  )) as final_status
  from 
      FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS acs
      left join FBG_SOURCE.OSB_SOURCE.jurisdictions j 
          on j.id = jurisdictions_id
      left join TIMEZONE t
          on j.jurisdiction_code =  t.state_code
      left join FBG_SOURCE.osb_source.bets b
          on acs.bet_id = b.id
      left join FBG_SOURCE.OSB_SOURCE.FUND_TYPE fund
          on fund.id = acs.fund_type_id
      left join FBG_REPORTS.REGULATORY.STG_REGULATORY_MARKETING_CAMPAIGNS m
          on m.id = b.bonus_campaign_id
  where 
      1=1
      and b.test = 'FALSE'
      and b.channel = 'INTERNET'
      and trans <> 'BONUS_EXECUTED'
     -- and j.jurisdiction_name = 'COLORADO'
      and b.status NOT in ('REJECTED','PENDING_WALLET')
      and COALESCE(acs.client_id, '') NOT ILIKE '%FEX%'
    --  and acs.bet_id = '24043076000020311'
  )
  
  
  ,bets AS (
  
  select     
      t.*,
      bp.node_id,
      sport,
      case
          when SPLIT_PART(BP.MRKT_TYPE, ':', -1) = 'ML' then 'Moneyline'
          when SPLIT_PART(BP.MRKT_TYPE, ':', -1) = 'OU' then 'Total'
          when SPLIT_PART(BP.MRKT_TYPE, ':', -1) = 'SPRD' then 'Spread'
           when node_id IN (903827, 725792) then 'Future'
          else 'Prop'
      end as bet_type_consolidated,
        convert_timezone('UTC',TIMEZONE,bp.event_time) as event_date,
        case 
          when node_id IN (903827, 725792) then 'Future'
          when date(event_date) >= '2024-03-19' and date(event_date) <= '2024-03-22' then 'round_1'
          when date(event_date) >= '2024-03-23' and date(event_date) <= '2024-03-24' then 'round_2'
          when date(event_date) >= '2024-03-28' and date(event_date) <= '2024-03-29' then 'round_3_sweet_sixteen'
          when date(event_date) >= '2024-03-30' and date(event_date) <= '2024-03-31' then 'round_4_elite_8'
          when date(event_date) = '2024-04-06'  then 'round_5_final_4'
          when date(event_date) = '2024-04-08'  then 'round_6_final'
          else 'unknown'
      end as tournament_round,
      bet_type,
      market,
      selection,
      live_bet,
      event_time,
      TO_TIMESTAMP(parse_json(er.summmary):EventResult:finishTime::STRING) as event_end_time,
      datediff('minutes',event_time, event_end_time) as event_seconds,
        case 
          when t.trans in ('STAKE','FREEBET_STAKE')
          and fund_type = 'CASH'
          then abs(amount) / b.NUM_LINES
          else 0
      end as cash_stake_per_betleg,
  
        case 
          when t.trans in ('REFUND','SETTLEMENT','UNSETTLEMENT')
              and t.final_status != 'VOID' 
              and t.acs_settlement_version >= 1 
              and fund_type = 'CASH' 
          then amount / b.NUM_LINES
          else 0
      end as cash_settlement_per_betleg,
  
  
        case
            when trans IN ('SETTLEMENT', 'WINNING_BONUS', 'REFUND', 'UNSETTLEMENT')
              and game_id IS NULL 
              and fund_type = 'CASH'  
              and final_status = 'VOID' 
              and (void_reason != 'GOODWILL' OR void_reason IS NULL)
              and acs_settlement_version >= 1 
          then amount / b.NUM_LINES
          else 0
      end as cash_cancel_sports_per_betleg,
  
        case
            when trans IN ('SETTLEMENT', 'WINNING_BONUS', 'REFUND', 'UNSETTLEMENT')
              and game_id IS NULL 
              and fund_type = 'CASH'  
              and final_status = 'VOID' 
              and void_reason = 'GOODWILL'
              and acs_settlement_version >= 1 
          then amount / b.NUM_LINES
          else 0
      end as cash_void_sports_per_betleg,
  
        case
          when t.trans IN ('STAKE','FREEBET_STAKE') 
              and  t.fund_type != 'CASH' 
          then abs(t.amount)/b.NUM_LINES 
          else 0
      end as bonus_stake_per_betleg,
  
        case
           when trans in ('SETTLEMENT','REFUND','UNSETTLEMENT')
              and t.fund_type != 'CASH'
              and final_status != 'VOID'
              and acs_settlement_version >= 1
          then amount/ b.NUM_LINES
          else 0
      end as bonus_settlement_per_betleg,
  
        case
            when trans IN ('SETTLEMENT', 'WINNING_BONUS', 'REFUND', 'UNSETTLEMENT')
              and game_id IS NULL 
              and fund_type != 'CASH'  
              and final_status = 'VOID' 
              and (void_reason != 'GOODWILL' OR void_reason IS NULL)
              and acs_settlement_version >= 1 
          then amount / b.NUM_LINES
          else 0
      end as bonus_cancel_sports_per_betleg,
  
        case
            when trans IN ('SETTLEMENT', 'WINNING_BONUS', 'REFUND', 'UNSETTLEMENT')
              and game_id IS NULL 
              and fund_type != 'CASH'  
              and final_status = 'VOID' 
              and void_reason = 'GOODWILL'
              and acs_settlement_version >= 1 
          then amount / b.NUM_LINES
          else 0
      end as bonus_void_sports_per_betleg
      
  from
      transactions t
      left join FBG_SOURCE.osb_source.bets b
          on t.bet_id=b.id
      left join FBG_SOURCe.osb_source.bet_parts bp 
          on b.id=bp.bet_id
      left join FBG_SOURCE.OSB_SOURCE.event_results er
          on bp.node_id = er.event_id
      where
           (case when node_id IN (903827, 725792) and market ILIKE '%NCAA%' then 1
                    else 0 end ) = 1
  
  
  )
  
  ,super_bowl_agg AS (
  
  select
      state,
      bet_type_consolidated,
      tournament_round,
      bet_id,
      acco_id,
      market,
      selection,
      bet_type,
      live_bet,
      sum(case when gaming_trans_date::date = event_time::date then cash_stake_per_betleg+bonus_stake_per_betleg else 0 end) as same_day_total_stake,
      sum(case when gaming_trans_date::date < event_time::date then cash_stake_per_betleg+bonus_stake_per_betleg else 0 end) as prev_day_total_stake,
      sum(cash_stake_per_betleg) as cash_handle,
      sum(cash_settlement_per_betleg) as cash_settlement,
      sum(cash_cancel_sports_per_betleg) as cash_cancel,
      sum(cash_void_sports_per_betleg) as cash_void,
      sum(bonus_stake_per_betleg) as bonus_handle,
      sum(bonus_settlement_per_betleg) as bonus_settlement,
      sum(bonus_cancel_sports_per_betleg) as bonus_cancel,
      sum(bonus_void_sports_per_betleg) as bonus_void,
      (cash_handle+bonus_handle)-cash_settlement as GGR,
      count(distinct bet_id) as number_of_bets,
      count(distinct acco_id) as number_of_bettors,
      count(distinct case when trans_date >= event_time
                           and trans_date <= event_end_time
                          then bet_id end)/min(event_seconds) as bets_per_minute
      
      
  from bets
  group by all
  )
  
  ,final as (
  select
      state as "State",
      bet_type_consolidated,
      tournament_round,
      market,
      selection,
      round(sum(same_day_total_stake),2) as "Same Day Total Stake",
      round(sum(prev_day_total_stake),2) as "Previous Day Total Stake",
      round(sum(cash_handle),2) as "Cash Handle",
      round(sum(cash_settlement),2) as "Cash Settlement",
      round(sum(cash_cancel),2) as "Cash Cancel",
      round(sum(cash_void),2) as "Cash Void",
      round(sum(bonus_handle),2) as "Bonus Handle",
      round(sum(bonus_settlement),2) as "Bonus Settlement",
      round(sum(bonus_cancel),2) as "Bonus Cancel",
      round(sum(bonus_void),2) as "Bonus Void",
      round(sum(cash_handle+bonus_handle),2) as "Gross Handle",
      round(sum((cash_handle+bonus_handle)-(cash_cancel + cash_void + bonus_cancel + bonus_void)),2) as "Net Handle",
      round(sum(GGR),2) as "GGR",
      round(sum(GGR-cash_cancel-cash_void-bonus_cancel-bonus_void),2) as "Total Win",
      round(sum(GGR-bonus_handle),2) as "Adjusted Gaming Revenue",
      count(distinct bet_id) as "# of Bets",
      count(distinct acco_id) as "# of Bettors",
      count(distinct case when bet_type = 'SINGLE' then bet_id else NULL end) as "# of Straight Bets",
      count(distinct case when bet_type = 'MULTIPLE' then bet_id else NULL end) as "# of Parlay Bets",
      count(distinct case when live_bet = 0 then bet_id else NULL end) as "# of Pre-Match Bets",
      count(distinct case when live_bet = 1 then bet_id else NULL end) as "# of In-Play Bets"
  
  from super_bowl_agg
  --where state = 'KENTUCKY'
  group by all
  )
  
  select *, 
  rank() OVER(partition by "State" order by "Gross Handle" desc) as top_handle_future_by_state,
  rank() OVER(partition by "State" order by "# of Bets" desc) as top_num_bets_future_by_state,
  from final
) "Custom SQL Query"
