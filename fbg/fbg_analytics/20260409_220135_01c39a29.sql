-- Query ID: 01c39a29-0212-6dbe-24dd-0703193e283b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:01:35.683000+00:00
-- Elapsed: 23292ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_BONUS_STATE" AS "ACCOUNT_BONUS_STATE",
  "Custom SQL Query"."ACCOUNT_STATUS" AS "ACCOUNT_STATUS",
  "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."BONUS_CAMPAIGN_ID" AS "BONUS_CAMPAIGN_ID",
  "Custom SQL Query"."BONUS_CAMPAIGN_NAME" AS "BONUS_CAMPAIGN_NAME",
  "Custom SQL Query"."BONUS_STAKES_AMOUNT" AS "BONUS_STAKES_AMOUNT",
  "Custom SQL Query"."BONUS_STATUS" AS "BONUS_STATUS",
  "Custom SQL Query"."CASH_STAKE" AS "CASH_STAKE",
  "Custom SQL Query"."CURRENT_BALANCE" AS "CURRENT_BALANCE",
  "Custom SQL Query"."CURRENT_VALUE_BAND" AS "CURRENT_VALUE_BAND",
  "Custom SQL Query"."DAYS_TO_NEW_OFFER" AS "DAYS_TO_NEW_OFFER",
  "Custom SQL Query"."DEPOSITS" AS "DEPOSITS",
  "Custom SQL Query"."DEPOSIT_TIME" AS "DEPOSIT_TIME",
  "Custom SQL Query"."DI_OFFER_NAME" AS "DI_OFFER_NAME",
  "Custom SQL Query"."DI_REQUALIFIED" AS "DI_REQUALIFIED",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FANCASH_AMOUNT" AS "FANCASH_AMOUNT",
  "Custom SQL Query"."LAST_LOGIN_TIME_EST" AS "LAST_LOGIN_TIME_EST",
  "Custom SQL Query"."LAST_MODIFIED_TIME" AS "LAST_MODIFIED_TIME",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."MAXED_OUT" AS "MAXED_OUT",
  "Custom SQL Query"."MAX_QUAL_DEPOSIT_AMOUNT" AS "MAX_QUAL_DEPOSIT_AMOUNT",
  "Custom SQL Query"."NEXT_DI_OFFER" AS "NEXT_DI_OFFER",
  "Custom SQL Query"."NEXT_DI_OFFER_DATE" AS "NEXT_DI_OFFER_DATE",
  "Custom SQL Query"."NEXT_TRIGGER" AS "NEXT_TRIGGER",
  "Custom SQL Query"."NEXT_WITHDRAWAL" AS "NEXT_WITHDRAWAL",
  "Custom SQL Query"."NUM_DI_OFFERS" AS "NUM_DI_OFFERS",
  "Custom SQL Query"."OFFER" AS "OFFER",
  "Custom SQL Query"."OFFER_DATE" AS "OFFER_DATE",
  "Custom SQL Query"."OFFER_SELECTED" AS "OFFER_SELECTED",
  "Custom SQL Query"."OPT_IN_TIME" AS "OPT_IN_TIME",
  "Custom SQL Query"."PERC_MAX_DEPOSIT" AS "PERC_MAX_DEPOSIT",
  "Custom SQL Query"."PSEUDONYM" AS "PSEUDONYM",
  "Custom SQL Query"."QUAL_BONUS_PCT" AS "QUAL_BONUS_PCT",
  "Custom SQL Query"."TIME_TO_WITHDRAWAL" AS "TIME_TO_WITHDRAWAL",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."WITHDRAWALS" AS "WITHDRAWALS"
FROM (
  with deposit_offers as (
      select 
          account_id as acco_id,
          offer,
          offer_date
      from fbg_analytics_dev.luke_harmon.march_madness_dm_2026 
  )
  
  , log_ins as (
      select
          id as acco_id,
          last_login_time,
          case when last_login_time > '2026-03-09 14:00:00.000 +0000' then 1 else 0 end has_logged_on
      
      from fbg_source.osb_source.accounts
      where test = 0
  )
  
  , account_bonus_extracts as (
      select
          a.acco_id,
          bc.bonus_campaign_id,
          bc.bonus_campaign_name,
          bc.qual_bonus_pct,
          concat(round(bc.qual_bonus_pct),'% Offer')::string as offer_selected,
          bc.bonus_stakes_amount,
          bc.bonus_stakes_amount / bc.qual_bonus_pct * 100 as max_qual_deposit_amount,   
  
          CASE 
            WHEN regexp_substr(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              TO_NUMBER(CAST(REGEXP_SUBSTR(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) AS NUMBER(12,2)))
            ELSE NULL
          END as fancash_amount, 
          fancash_amount / bonus_stakes_amount as perc_max_deposit,
          fancash_amount / bc.qual_bonus_pct * 100 as perc_max_deposit_1,
      
          a.state as account_bonus_state,
          a.modified as last_modified_time,
          
          CASE 
            WHEN regexp_substr(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              -- convert_timezone(
              TO_TIMESTAMP_NTZ(CAST(REGEXP_SUBSTR(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) AS NUMBER) / 1000)
            ELSE NULL
          END as opt_in_time,
          
          case when trim(bonus_campaign_name) = '50% Deposit match up to $10K FanCash' then '$10000 50% DM'
               when trim(bonus_campaign_name) = '50% Deposit match up to $5K FanCash' then '$5000 50% DM'
          
               when trim(bonus_campaign_name) = '50% Deposit match up to $2.5K FanCash' then '$2500 50% DM'
               when trim(bonus_campaign_name) = '50% Deposit match up to $1K FanCash' then '$1000 50% DM'
          
               when trim(bonus_campaign_name) = '50% Deposit match up to $500 FanCash' then '$500 50% DM'  
          else null end di_offer_name,
  
          -- row_number() over (partition by acco_id order by record_last_modified desc) N,
          
      from fbg_source.osb_source.account_bonuses a
      left join fbg_p13n.promo_bronze_table.bonus_campaign_extracts bc
      on a.bonus_campaign_id = bc.bonus_campaign_id
      where a.bonus_campaign_id in (
      1081297, 1081298, 1081299, 1081300, 1081301
      )
      -- qualify N = 1
  ),
  
  deposits as (
          SELECT a.acco_id, SUM(amount) AS deposits, min(a.completed_at) as deposit_time
          FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
          INNER JOIN account_bonus_extracts b
              on a.acco_id = b.acco_id
              and a.completed_at >= b.opt_in_time
          WHERE a.status = 'DEPOSIT_SUCCESS'
          GROUP BY all
      ),
  
  
  withdrawals as (
          SELECT a.account_id AS acco_id, SUM(amount) AS withdrawals, min(a.completed_at) as next_withdrawal
          FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
          INNER JOIN account_bonus_extracts b
              on a.account_id = b.acco_id
              and a.completed_at >= b.opt_in_time
          WHERE a.status = 'WITHDRAWAL_COMPLETED'
          GROUP BY all
      ),
  
  
  cash_stake as (
          SELECT acco_id, SUM(cash_stake) AS cash_stake
          FROM (
              SELECT a.acco_id, sum(stake) AS cash_stake
              FROM fbg_analytics_engineering.casino.casino_transactions_mart a
              INNER JOIN account_bonus_extracts b
                  on a.acco_id = b.acco_id
                  and a.placed_time_utc >= b.opt_in_time
              WHERE fund_type_id = 1
              GROUP BY ALL
              
              UNION ALL
              
              SELECT account_id as acco_id, sum(total_cash_stake_by_legs) AS cash_stake
              FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
              INNER JOIN account_bonus_extracts b
                  on a.account_id = b.acco_id
                  and a.wager_placed_time_utc >= b.opt_in_time
              WHERE is_test_wager = FALSE AND wager_status = 'SETTLED'
              GROUP BY ALL
          )
          GROUP BY ALL
      ),
  
  current_balance as (
          SELECT a.acco_id, balance as current_balance
          FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES a
          INNER JOIN deposit_offers b
              on a.acco_id = b.acco_id
          WHERE a.fund_type_id = 1
      )
  
  , next_direct_investment as (
      select 
          d.acco_id,
          di.groups as next_trigger,
          di.offer_date as next_di_offer_date,
          di.offer as next_di_offer,
          count(*) over (partition by di.acco_id) num_di_offers
      
      from deposit_offers d 
      left join fbg_analytics.product_and_customer.direct_investments_history di
      on di.acco_id = d.acco_id
      where 1=1
          and di.gets_offer = 'Y'
          and di.offer_date > '2026-03-09'
          -- and offer_date < '2025-08-25'
      qualify row_number() over (partition by di.acco_id order by di.offer_date) = 1
  )
  
  select
      d.*,
      convert_timezone('UTC', 'America/New_York', l.last_login_time) as last_login_time_est,
      
      cm.vip_host,
      cm.lead_owner,
      cm.current_value_band,
      cm.f1_loyalty_tier,
      cm.pseudonym,
      
      a.bonus_campaign_id,
      a.bonus_campaign_name,
      a.qual_bonus_pct,
      a.bonus_stakes_amount,
      a.max_qual_deposit_amount,
  
      a.fancash_amount,
      a.perc_max_deposit,
      a.opt_in_time,
      a.last_modified_time,        
      a.account_bonus_state,
      a.offer_selected,
      a.di_offer_name,
      -- case when account_bonus_state is null and has_logged_on = 0 then 'Not Logged In - Not Used' 
      --      when account_bonus_state is null and has_logged_on = 1 then 'Logged In - Not Used' 
      --      when account_bonus_state = 'OPT_IN' then 'Offer Selected'
      --      when account_bonus_state = 'EXECUTED' then 'DM Executed'
      -- else null end bonus_status,
      case when account_bonus_state is null then 'Not Logged In - Not Used' 
           when account_bonus_state = 'AVAILABLE' then 'Logged In - Not Used' 
           when account_bonus_state = 'OPT_IN' then 'Offer Selected'
           when account_bonus_state = 'EXECUTED' then 'DM Executed'
      else null end bonus_status,
      case when fancash_amount = bonus_stakes_amount then 1 else 0 end maxed_out,
  
  
      dep.deposits,
      dep.deposit_time,
      wit.withdrawals,
      wit.next_withdrawal,
      CASE WHEN datediff('day',dep.deposit_time, wit.next_withdrawal) < 0 THEN 0 ELSE datediff('day',dep.deposit_time, wit.next_withdrawal) END as time_to_withdrawal,
      cs.cash_stake,
      cb.current_balance,
      
      case when ndi.acco_id is not null then 1 else 0 end di_requalified,
      ndi.next_trigger,
      datediff(day, '2026-03-09', ndi.next_di_offer_date) days_to_new_offer,
      ndi.next_di_offer_date,
      ndi.next_di_offer,
      ndi.num_di_offers,
      initcap(cm.status) as account_status
      
  
  from deposit_offers d
  left join account_bonus_extracts a 
  on d.acco_id = a.acco_id
  and d.offer = a.di_offer_name
  left join fbg_analytics_engineering.customers.customer_mart cm
  on cm.acco_id = d.acco_id 
  left join log_ins l 
  on l.acco_id = d.acco_id
  left join deposits dep
  on a.acco_id = dep.acco_id
  left join withdrawals wit
  on a.acco_id = wit.acco_id
  left join cash_stake cs
  on a.acco_id = cs.acco_id
  left join current_balance cb
  on d.acco_id = cb.acco_id
  left join next_direct_investment ndi 
  on ndi.acco_id = d.acco_id
) "Custom SQL Query"
