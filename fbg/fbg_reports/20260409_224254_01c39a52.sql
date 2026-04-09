-- Query ID: 01c39a52-0212-6e7d-24dd-07031947432b
-- Database: FBG_REPORTS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T22:42:54.891000+00:00
-- Elapsed: 40332ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query1"."ACCOUNT_ID" AS "ACCOUNT_ID (Custom SQL Query1)",
  "Custom SQL Query1"."CASH_CASINO_APD_FLAG" AS "CASH_CASINO_APD_FLAG",
  "Custom SQL Query1"."CASINO_FTCU_DATE_AFTER_DEPOSIT" AS "CASINO_FTCU_DATE_AFTER_DEPOSIT",
  "Custom SQL Query1"."CASINO_FTU_DATE" AS "CASINO_FTU_DATE (Custom SQL Query1)",
  "Custom SQL Query1"."CURRENT_CASINO_VIP_FLAG" AS "CURRENT_CASINO_VIP_FLAG",
  "Custom SQL Query1"."FIRST_DEPOSIT_DATE" AS "FIRST_DEPOSIT_DATE",
  "Custom SQL Query1"."GAMING_DATE_ALK" AS "GAMING_DATE_ALK",
  "Custom SQL Query1"."LIFETIME_DEPOSIT_AMOUNT" AS "LIFETIME_DEPOSIT_AMOUNT",
  "Custom SQL Query1"."LIFETIME_TOTAL_DEPOSIT_COUNT" AS "LIFETIME_TOTAL_DEPOSIT_COUNT",
  "Custom SQL Query1"."LIFETIME_TOTAL_WITHDRAW_COUNT" AS "LIFETIME_TOTAL_WITHDRAW_COUNT",
  "Custom SQL Query1"."LIFETIME_WITHDRAW_AMOUNT" AS "LIFETIME_WITHDRAW_AMOUNT",
  "Custom SQL Query1"."VIP_HOST" AS "VIP_HOST"
FROM (
  with acs_actives as (
      select 
          dis.account_id,
          dis.gaming_date_alk,
          dis.current_casino_vip_flag,
          dis.first_deposit_date,
          dis.casino_ftu_date,
          dis.casino_ftcu_date_after_deposit,
          dis.lifetime_deposit_amount,
          dis.lifetime_total_deposit_count,
          dis.lifetime_withdraw_amount,
          dis.lifetime_total_withdraw_count,
          dis.cash_casino_apd_flag,
          us.name as vip_host
      from fbg_reports.regulatory.distinct_osb_accounts dis
      inner join fbg_source.osb_source.accounts a 
          on dis.account_id = a.id
      left join fbg_analytics.trading.salesforce_email as sa 
          on a.email = sa.personemail
      left join fbg_source.salesforce.o_user as us 
          on us.id = sa.vip_host__c
  ),
  
  distinct_osb_account_fields as (
      select 
          account_id,
          max(current_casino_vip_flag) as current_casino_vip_flag,
          max(first_deposit_date) as first_deposit_date,
          max(casino_ftu_date) as casino_ftu_date,
          max(casino_ftcu_date_after_deposit) as casino_ftcu_date_after_deposit,
          max(lifetime_deposit_amount) as lifetime_deposit_amount,
          max(lifetime_total_deposit_count) as lifetime_total_deposit_count,
          max(lifetime_withdraw_amount) as lifetime_withdraw_amount,
          max(lifetime_total_withdraw_count) as lifetime_total_withdraw_count
      from fbg_reports.regulatory.distinct_osb_accounts
      group by all
  ),
  
  f2p_only_customers as (
      select 
          f2p.acco_id as account_id,
          date(convert_timezone('UTC','America/Anchorage', f2p.time_awarded)) as gaming_date_alk,
          coalesce(daf.current_casino_vip_flag, 0) as current_casino_vip_flag,
          daf.first_deposit_date,
          daf.casino_ftu_date,
          daf.casino_ftcu_date_after_deposit,
          coalesce(daf.lifetime_deposit_amount, 0) as lifetime_deposit_amount,
          coalesce(daf.lifetime_total_deposit_count, 0) as lifetime_total_deposit_count,
          coalesce(daf.lifetime_withdraw_amount, 0) as lifetime_withdraw_amount,
          coalesce(daf.lifetime_total_withdraw_count, 0) as lifetime_total_withdraw_count,
          0 as cash_casino_apd_flag,
          NULL as vip_host,
          
      from fbg_source.osb_source.f2p_game_session_results f2p
      inner join fbg_source.osb_source.accounts acc
          on acc.id = f2p.acco_id  
      left join acs_actives acs
          on acs.account_id = f2p.acco_id
          and acs.gaming_date_alk = date(convert_timezone('UTC','America/Anchorage', f2p.time_awarded))
      left join distinct_osb_account_fields daf
          on daf.account_id = f2p.acco_id
      where 1=1
          and acs.gaming_date_alk is null
          and acc.test = 0
  )
  
  select * from f2p_only_customers
  UNION
  select * from acs_actives
) "Custom SQL Query1"
