-- Query ID: 01c399f0-0212-6b00-24dd-07031930a1e7
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:04:11.994000+00:00
-- Elapsed: 617197ms
-- Environment: FBG

SELECT "Custom SQL Query"."# of Active Weeks" AS "# of Active Weeks",
  "Custom SQL Query"."# of Football Active Weeks" AS "# of Football Active Weeks",
  "Custom SQL Query"."Acco ID" AS "Acco ID",
  "Custom SQL Query"."Avg Cash Bet" AS "Avg Cash Bet",
  "Custom SQL Query"."Avg Deposit" AS "Avg Deposit",
  "Custom SQL Query"."Avg Football Cash Bet" AS "Avg Football Cash Bet",
  "Custom SQL Query"."CVP" AS "CVP",
  "Custom SQL Query"."Cash Handle Last Week" AS "Cash Handle Last Week",
  "Custom SQL Query"."Current Cash Balance" AS "Current Cash Balance",
  "Custom SQL Query"."Current Fancash Balance" AS "Current Fancash Balance",
  "Custom SQL Query"."FairPlay Bets" AS "FairPlay Bets",
  "Custom SQL Query"."FairPlay Payout" AS "FairPlay Payout",
  "Custom SQL Query"."FanCash Bets" AS "FanCash Bets",
  "Custom SQL Query"."FanCash GGR" AS "FanCash GGR",
  "Custom SQL Query"."FanCash Handle" AS "FanCash Handle",
  "Custom SQL Query"."FanCash NGR" AS "FanCash NGR",
  "Custom SQL Query"."Favorite NCAAF Team" AS "Favorite NCAAF Team",
  "Custom SQL Query"."Favorite NFL Team" AS "Favorite NFL Team",
  "Custom SQL Query"."Football Cash Handle Last Week" AS "Football Cash Handle Last Week",
  "Custom SQL Query"."Football Last Active Week" AS "Football Last Active Week",
  "Custom SQL Query"."Football NGR Last Week" AS "Football NGR Last Week",
  "Custom SQL Query"."Football Parlay Handle" AS "Football Parlay Handle",
  "Custom SQL Query"."Football SGP Handle" AS "Football SGP Handle",
  "Custom SQL Query"."Football Single Handle" AS "Football Single Handle",
  "Custom SQL Query"."GDG Bets" AS "GDG Bets",
  "Custom SQL Query"."GDG FanCash Amount" AS "GDG FanCash Amount",
  "Custom SQL Query"."GDG Handle" AS "GDG Handle",
  "Custom SQL Query"."GDG NGR" AS "GDG NGR",
  "Custom SQL Query"."Host Comp Season" AS "Host Comp Season",
  "Custom SQL Query"."Individual Approach" AS "Individual Approach",
  "Custom SQL Query"."Largest Deposit" AS "Largest Deposit",
  "Custom SQL Query"."Largest Loss" AS "Largest Loss",
  "Custom SQL Query"."Largest Wager" AS "Largest Wager",
  "Custom SQL Query"."Largest Win" AS "Largest Win",
  "Custom SQL Query"."Last 30 Days All-In Comp Ratio" AS "Last 30 Days All-In Comp Ratio",
  "Custom SQL Query"."Last 30 Days Cash Handle" AS "Last 30 Days Cash Handle",
  "Custom SQL Query"."Last 30 Days Football Cash Handle" AS "Last 30 Days Football Cash Handle",
  "Custom SQL Query"."Last 30 Days Football NGR" AS "Last 30 Days Football NGR",
  "Custom SQL Query"."Last 30 Days NGR" AS "Last 30 Days NGR",
  "Custom SQL Query"."Last Active Week" AS "Last Active Week",
  "Custom SQL Query"."Last Cash Wager Date" AS "Last Cash Wager Date",
  "Custom SQL Query"."Last Deposit Date" AS "Last Deposit Date",
  "Custom SQL Query"."Last Week All-In Comp Ratio" AS "Last Week All-In Comp Ratio",
  "Custom SQL Query"."Lifetime All-In Comp Ratio" AS "Lifetime All-In Comp Ratio",
  "Custom SQL Query"."Loyalty Tier" AS "Loyalty Tier",
  "Custom SQL Query"."Manager" AS "Manager",
  "Custom SQL Query"."NGR Last Week" AS "NGR Last Week",
  "Custom SQL Query"."Parlay Handle" AS "Parlay Handle",
  "Custom SQL Query"."SGP Handle" AS "SGP Handle",
  "Custom SQL Query"."Season Long All-In Comp Ratio" AS "Season Long All-In Comp Ratio",
  "Custom SQL Query"."Season Long Cash Handle" AS "Season Long Cash Handle",
  "Custom SQL Query"."Season Long Football Cash Handle" AS "Season Long Football Cash Handle",
  "Custom SQL Query"."Season Long Football NGR" AS "Season Long Football NGR",
  "Custom SQL Query"."Season Long Football eNGR" AS "Season Long Football eNGR",
  "Custom SQL Query"."Season Long NGR" AS "Season Long NGR",
  "Custom SQL Query"."Season Long eNGR" AS "Season Long eNGR",
  "Custom SQL Query"."Single Handle" AS "Single Handle",
  "Custom SQL Query"."Status" AS "Status",
  "Custom SQL Query"."VIP Host" AS "VIP Host",
  "Custom SQL Query"."WAC" AS "WAC"
FROM (
  WITH users AS (
  SELECT DISTINCT 
  acco_id 
  , status 
  , f1_loyalty_tier
  FROM fbg_analytics_engineering.customers.customer_mart 
  WHERE is_test_account = FALSE
  AND vip_host IS NOT NULL
  )
  
  , STATE AS (
  select
  a.acco_id,
  a.state,
  (COALESCE(sum(osb_cash_handle),0) + COALESCE(sum(oc_cash_handle),0) + COALESCE(sum(osb_freebet_handle),0) + COALESCE(sum(oc_freebet_handle),0)) as total_handle
  from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT as a
  inner join users as u 
      on a.acco_id = u.acco_id
  group by all
  having total_handle is not null
  qualify row_number() OVER (partition BY a.acco_id order by total_handle desc) = 1
  ),
  
  -- JACKPOT_WIN AS (
  --     SELECT 
  --     acs.bet_id,
  --     SUM(jt.win_amount) as jackpot_win
  --     FROM FBG_SOURCE.OSB_SOURCE.JACKPOT_TRANSACTIONS as jt
  --     LEFT OUTER JOIN FBG_SOURCE.OSB_SOURCE.JACKPOTS j on j.ext_jackpot_id = jt.ext_jackpot_id
  --     LEFT JOIN fbg_source.osb_source.jurisdictions as jur on jt.jurisdictions_id = jur.id
  --     left join fbg_source.osb_source.account_statements acs
  --     on jt.game_play_id=acs.bet_id
  --     and acs.trans in('SETTLEMENT')
  --         inner join fbg_source.osb_source.accounts as a
  --     on acs.acco_id=a.id
  --     and a.test = 0
  --     WHERE transaction_type IN ('WIN')
  --     GROUP BY ALL
  --     ),
  -- WAGERS_CAS AS (
  -- select 
  --      CASE WHEN DATE(settled_time_utc) >= '2024-12-01' THEN DATE(convert_timezone('UTC','America/Anchorage',settled_time_utc)) ELSE DATE(settled_time_utc) END AS DATE,
  --     Acco_ID,
  --     J.JURISDICTION_CODE,
  --     sum(stake) as total_handle,
  --     sum(case when f.code = 'CASH' then stake else 0 end) as cash_handle,
  --     sum(case when code IN ('CASINO_CREDIT','FREE_SPIN') then stake else 0 end) as bonus_handle,
  --     sum(case when code = 'CASH' then payout - IFNULL(Jp.Jackpot_Win,0) else 0 end) as cash_payout,
  --     SUM(Payout - IFNULL(Jp.Jackpot_Win,0) ) AS Total_PAyout,
  --     cash_handle - cash_payout as cash_ggr,
  --     sum(stake - payout + IFNULL(Jp.Jackpot_Win,0)) as total_GGR, 
  --     cash_GGR - sum(case when code = 'FREE_SPIN' then payout - IFNULL(Jp.Jackpot_Win,0) else 0 end) as ngr
  --    from FBG_ANALYTICS_ENGINEERING.CASINO.casino_transactions_mart  as cb
  -- left join FBG_ANALYTICS_ENGINEERING.CASINO.casino_game_details cg on cb.game_id = cg.game_id
  -- INNER JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS A
  -- ON cb.ACCO_ID = A.id
  -- AND A.TEst = 0
  -- left join fbg_source.osb_source.fund_type f
  -- on cb.fund_type_id = f.id
  --     INNER JOIN FBG_SOURCE.OSB_SOURCE.Jurisdictions J
  --     ON J.ID = Cb.JURISDICTIONS_ID
  -- LEFT JOIN JACKPOT_WIN Jp
  -- On Jp.Bet_ID = Cb.Bet_ID 
  --     where a.test = 0
  --     and settled_time_utc is not null
  --     group by all 
  --  ),
   
  STATS AS (
  select
  date(day) as Day,
  a.acco_id,
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  ifnull(sum(case when transaction = 'bonus awarded' and promo_type in ('cash_back') then amount else 0 end), 0) as Issued,
  sum(case when (transaction = 'bonus used' and promo_type = 'bonus_bet') or (transaction = 'bonus awarded' and promo_type = 'fancash') then amount * 0.6 else 0 end) as BBUsed,
  -- ifnull(sum(case when transaction = 'bonus awarded' and promo_type in ('cash_back') and "Bonus Category" not in ('Acquisition','CS Acquisition') and "SubCategory" not in ('Migration') then amount else 0 end), 0) as RetIssued,
  -- sum(case when ((transaction = 'bonus used' and promo_type = 'bonus_bet') or (transaction = 'bonus awarded' and promo_type = 'fancash')) and "Bonus Category" not in ('Acquisition','CS Acquisition') and "SubCategory" not in ('Migration') then amount * 0.6 else 0 end) as RetBBUsed,
  null as event_comp,
  null as gifting_comp,
  ifnull(sum(case when transaction = 'bonus awarded' and promo_type in ('cash_back') and "SubCategory" ilike '%VIP%' and "SubCategory" not in ('VIP', 'VIP ', 'VIP Offer Library') then amount else 0 end), 0) + ifnull(sum(case when (transaction = 'bonus awarded' and promo_type in ('fancash') and "SubCategory" ilike '%VIP%') or (transaction = 'bonus used' and promo_type = 'bonus_bet' and "SubCategory" ilike '%VIP%' and "SubCategory" not in ('VIP', 'VIP ', 'VIP Offer Library')) then amount * 0.6 else 0 end), 0) as HostComp,
  -- ifnull(SUM(
  --     CASE WHEN ("Bonus Category" not in ('Acquisition','CS Acquisition')
  --                 AND "SubCategory" not in ('Migration')
  --                 AND promo_type not in ('profit_boost','boost_market')
  --                 AND transaction = 'bonus winnings') THEN amount ELSE 0 END
  --             ),0) AS retention_spend,
  -- ifnull(SUM(
  --     CASE WHEN ("Bonus Category" not in ('Acquisition','CS Acquisition')
  --                 AND "SubCategory" not in ('Migration')
  --                 AND promo_type not in ('profit_boost','boost_market')
  --                 AND transaction = 'bonus expected winnings') THEN amount ELSE 0 END
  --             ),0) AS retention_espend,
  null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- sum(case when transaction = 'bonus awarded' and "SubCategory" = 'FanCash 5/3/1' then amount else 0 end) as FCEarn,
  null as correction
  from
  FBG_P13N.PROMO_SILVER_TABLE.PROMOTIONS_LEDGER_FINAL a
  inner join users as ut
      on a.acco_id = ut.acco_id
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = a.acco_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  (u.vip_host is not null or is_pvip = 1)
  and date <> '2024-09-08 07:36:50.715'
  and u.is_test_account = 'FALSE'
  and "SubCategory" != 'Cashout'
  group by all
  having (issued > 0 or bbused > 0)
  
  UNION
  
  select
  date(day) as Day,
  a.acco_id,
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  sum(case when transaction = 'bonus awarded' and promo_type in ('casino_credit', 'cash_back') then amount else 0 end) as Issued,
  sum(case when transaction = 'bonus awarded' and promo_type = 'fancash' then amount * 0.6 else 0 end) as BBUsed,
  -- sum(case when transaction = 'bonus awarded' and promo_type in ('casino_credit', 'cash_back') and "Bonus Category" not in ('Acquisition','CS Acquisition') and "SubCategory" not in ('Migration') then amount else 0 end) as RetIssued,
  -- sum(case when transaction = 'bonus awarded' and promo_type = 'fancash' and "Bonus Category" not in ('Acquisition','CS Acquisition') and "SubCategory" not in ('Migration') then amount * 0.6 else 0 end) as RetBBUsed,
  null as event_comp,
  null as gifting_comp,
  sum(case when transaction = 'bonus awarded' and promo_type in ('casino_credit', 'fancash', 'cash_back') and ("SubCategory" ilike '%VIP%' or "SubCategory" = 'Goodwill') then amount else 0 end) as HostComp,
  -- ifnull(SUM(
  --     CASE WHEN ("Bonus Category" not in ('Acquisition','CS Acquisition')
  --                 AND "SubCategory" not in ('Migration')
  --                 AND transaction = 'bonus winnings') THEN amount ELSE 0 END
  --             ),0) AS retention_spend,
  -- ifnull(SUM(
  --     CASE WHEN ("Bonus Category" not in ('Acquisition','CS Acquisition')
  --                 AND "SubCategory" not in ('Migration')
  --                 AND transaction = 'bonus winnings') THEN amount ELSE 0 END
  --             ),0) AS retention_espend,
  null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- sum(case when transaction = 'bonus awarded' and promo_type = 'casino_credit' then amount else 0 end) as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- sum(case when transaction = 'bonus awarded' and "SubCategory" = 'FanCash Casino Base' then amount else 0 end) as FCEarn,
  null as correction
  from
  fbg_analytics.product_and_customer.casino_promotions_ledger a
  inner join users as ut
      on a.acco_id = ut.acco_id
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = a.acco_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  group by all
  having (issued > 0 or bbused > 0)
  
  UNION
  
  SELECT 
  date(settled_date_alk) as Day,
  c.acco_id, 
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
      null as Issued,
      null as BBUsed,
      -- null as RetIssued,
      -- null as RetBBUsed,
      null as event_comp,
      null as gifting_comp,
      null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  ifnull(SUM(ggr), 0) AS GGR,
  -- ifnull(sum(ggr), 0) as aGGR,
  -- ifnull(SUM(cash_bet_stake), 0) AS Handle,
  -- ifnull(SUM(ggr), 0) AS TW,
  -- ifnull(sum(ngr), 0) as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- ifnull(SUM(cash_bet_stake), 0) AS CasinoHandle,
  -- ifnull(SUM(ggr), 0) AS CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  null as correction
  FROM fbg_analytics_engineering.casino.casino_daily_settled_agg C
  inner join users as ut 
      on c.acco_id = ut.acco_id
  INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
  ON A.ID = C.Acco_ID
  INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart U
  ON U.Acco_ID = C.Acco_ID
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = c.acco_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  WHERE A.Test = 0
  and (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  GROUP BY ALL
  
  UNION
  
  select
  date(wager_settlement_time_alk) as Day,
  account_id as acco_id,
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  null as Issued,
  null as BBUsed,
  -- null as RetIssued,
  -- null as RetBBUsed,
  null as event_comp,
  null as gifting_comp,
  null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  ifnull(sum(total_cash_ggr_by_legs),0) as GGR,
  -- ifnull(sum(expected_cash_ggr_by_legs), 0) as aGGR,
  -- ifnull(sum(total_cash_stake_by_legs), 0) as Handle,
  -- ifnull(sum(trading_win), 0) as TW,
  -- ifnull(sum(total_ngr_by_legs), 0) as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- count(distinct case when is_free_bet_wager = FALSE then wager_id end) as SbkBets,
  -- null as FCEarn,
  null as correction
  from 
  fbg_analytics_engineering.trading.trading_sportsbook_mart a
  inner join users as ut 
      on a.account_id = ut.acco_id
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.account_id
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = a.account_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  a.wager_status = 'SETTLED'
  and a.wager_channel = 'INTERNET'
  and (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  group by all
  
  -- UNION
  
  -- select
  -- date(convert_timezone('UTC', 'America/Anchorage', completed_at)) as Day,
  -- a.acco_id as acco_id,
  -- -- u.current_state,
  -- -- u.stake_factor as stakefactor,
  -- -- u.registration_state as reg_state,
  -- -- u.vip_host,
  -- -- u.status,
  -- -- u.coded_total_tier as VIPTier,
  -- -- is_pvip as Pvip,
  -- -- lead_owner,
  -- -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- -- CASE 
  -- --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  -- --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  -- --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  -- --     when lifecycle in ('Reactivation') then 'Churned'
  -- --     else 'Other' end as Lifecycle,
  -- null as Issued,
  -- null as BBUsed,
  -- -- null as RetIssued,
  -- -- null as RetBBUsed,
  -- null as event_comp,
  -- null as gifting_comp,
  -- -- null as hostcomp,
  -- -- null as retention_spend,
  -- -- null as retention_espend,
  -- null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- sum(amount) as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  -- null as correction
  -- from 
  -- fbg_source.osb_source.deposits a
  -- join fbg_analytics_engineering.customers.customer_mart u
  -- on u.acco_id = a.acco_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.acco_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  -- where
  -- a.status = 'DEPOSIT_SUCCESS'
  -- and (u.vip_host is not null or is_pvip = 1)
  -- and u.is_test_account = 'FALSE'
  -- group by all
  
  -- UNION
  
  -- select Day,
  -- acco_id,
  -- current_state,
  -- stakefactor,
  -- reg_state,
  -- vip_host,
  -- status,
  -- VIPTier,
  -- Pvip,
  -- lead_owner,
  -- FTUDate,
  -- Lifecycle,
  -- Issued,
  -- BBUsed,
  -- RetIssued,
  -- RetBBUsed,
  -- event_comp,
  -- gifting_comp,
  -- hostcomp,
  -- retention_spend,
  -- retention_espend,
  -- GGR,
  -- aGGR,
  -- Handle,
  -- TW,
  -- NGR,
  -- Deposits,
  -- SUM(Withdrawals) AS Withdrawals,
  -- CasinoHandle,
  -- CasinoGGR,
  -- CCIssued,
  -- eCVP,
  -- CVP,
  -- SbkBets,
  -- FCEarn,
  -- correction
  -- from 
  -- (
  -- select
  -- date(convert_timezone('UTC', 'America/Anchorage', completed_at)) as Day,
  -- a.account_id as acco_id,
  -- u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  -- null as Issued,
  -- null as BBUsed,
  -- null as RetIssued,
  -- null as RetBBUsed,
  -- null as event_comp,
  -- null as gifting_comp,
  -- null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  -- null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- sum(coalesce(amount, 0)) as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  -- null as correction
  -- from 
  -- fbg_source.osb_source.withdrawals a
  -- join fbg_analytics_engineering.customers.customer_mart u
  -- on u.acco_id = a.account_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.account_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  -- where
  -- a.status = 'WITHDRAWAL_COMPLETED'
  -- and (u.vip_host is not null or is_pvip = 1)
  -- and u.is_test_account = 'FALSE'
  -- group by all
  
  -- UNION 
  
  -- select
  -- date(trans_date_alk) as Day,
  -- a.transaction_account_id as acco_id,
  -- u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  -- null as Issued,
  -- null as BBUsed,
  -- null as RetIssued,
  -- null as RetBBUsed,
  -- null as event_comp,
  -- null as gifting_comp,
  -- null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  -- null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- sum(coalesce(-1 * transaction_amount, 0)) as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  -- null as correction
  -- from 
  -- FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_TRANSACTIONS_MART a
  -- join fbg_analytics_engineering.customers.customer_mart u
  -- on u.acco_id = a.transaction_account_id
  -- left join fbg_analytics.product_and_customer.fbg_lifecylce l
  -- on l.acco_id = a.transaction_account_id
  -- AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  -- where a.transaction_type = 'FINANCE_CORRECTION_WITHDRAWAL' 
  -- and (transaction_description ilike '%patron request wire wd via vip am%' or transaction_description ilike '%patron request wire withdrawal via vip am%')
  -- and (u.vip_host is not null or is_pvip = 1)
  -- and u.is_test_account = 'FALSE'
  -- group by all
  -- )
  -- group by all
  
  UNION
  
  select
  a.date as Day,
  a.acco_id,
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  null as Issued,
  null as BBUsed,
  -- null as RetIssued,
  -- null as RetBBUsed,
  sum(ticket_cost) as event_comp,
  sum(gift_cost) as gifting_comp,
  null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- sum(ecustomer_variable_profit) as eCVP,
  -- sum(customer_variable_profit) as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  null as correction
  from 
  fbg_analytics.product_and_customer.customer_variable_profit a
  inner join users as ut 
      on a.acco_id = ut.acco_id
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = a.acco_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  (u.vip_host is not null or is_pvip = 1)
  and u.is_test_account = 'FALSE'
  group by all
  
  UNION
  
  select
  date(convert_timezone('UTC', 'America/Anchorage', trans_date)) as Day,
  a.acco_id as acco_id,
  u.current_state,
  -- u.stake_factor as stakefactor,
  -- u.registration_state as reg_state,
  -- u.vip_host,
  -- u.status,
  -- u.coded_total_tier as VIPTier,
  -- is_pvip as Pvip,
  -- lead_owner,
  -- date(u.fbg_ftu_date_alk) as FTUDate,
  -- CASE 
  --     when (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) or lifecycle = 'Onboarding' then 'New'
  --     WHEN lifecycle in ('Active','Churn Prevention') then 'Active'
  --     when lifecycle in ('Active - Recently Reactivated') then 'Recently Reactivated'
  --     when lifecycle in ('Reactivation') then 'Churned'
  --     else 'Other' end as Lifecycle,
  null as Issued,
  null as BBUsed,
  -- null as RetIssued,
  -- null as RetBBUsed,
  null as event_comp,
  null as gifting_comp,
  null as hostcomp,
  -- null as retention_spend,
  -- null as retention_espend,
  null as GGR,
  -- null as aGGR,
  -- null as Handle,
  -- null as TW,
  -- null as NGR,
  -- null as Deposits,
  -- null as Withdrawals,
  -- null as CasinoHandle,
  -- null as CasinoGGR,
  -- null as CCIssued,
  -- null as eCVP,
  -- null as CVP,
  -- null as SbkBets,
  -- null as FCEarn,
  sum(amount) as Correction
  from 
  fbg_source.osb_source.account_statements a
  inner join users as ut 
      on a.acco_id = ut.acco_id
  join fbg_analytics_engineering.customers.customer_mart u
  on u.acco_id = a.acco_id
  left join fbg_analytics.product_and_customer.fbg_lifecylce l
  on l.acco_id = a.acco_id
  AND date(insert_date) = (SELECT max(date(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
  where
  a.acco_id = 3427257
  and trans = 'CORRECTION'
  group by all
  ),
  -- casino_this_month as(
  --     select
  --         distinct
  --         a.acco_id,
  --         date(a.settled_date_alk) as apd
  --     from
  --         FBG_ANALYTICS_ENGINEERING.CASINO.CASINO_DAILY_SETTLED_AGG as a
  
  --     where date(date_trunc('month', a.settled_date_alk)) = date(date_trunc('month', current_timestamp))
  --     and cash_bet_stake > 0
  -- ),
  
  -- sbk_this_month as(
  --     select
  --         distinct
  --         a.account_id as acco_id,
  --         date(a.wager_settlement_time_alk) as apd
  --     from
  --         FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART as a
  --     where
  --         1 = 1
  --         and date(date_trunc('month', a.wager_settlement_time_alk)) = date(date_trunc('month', current_timestamp))
  --         and a.is_pointsbet_wager = FALSE
  --         and a.wager_status in ('ACCEPTED', 'SETTLED')
  --         and total_cash_stake_by_legs > 0
  -- ),
  
  -- staging_raw_this_month as(
  --     select
  --         *
  --     from
  --         casino_this_month
  --     union all
  --     select
  --         *
  --     from
  --         sbk_this_month
  -- ),
  -- staging_this_month as(
  --     select
  --         distinct acco_id
  --     from
  --         staging_raw_this_month
  -- ),
  -- final_this_month as(
  --     select
  --         a.acco_id,
  --         COUNT(DISTINCT b.apd) as apds_this_month
  --     from
  --         staging_this_month as a
  --         left join staging_raw_this_month as b on a.acco_id = b.acco_id
  --     group by all
  -- ),
  final_staging as(
  select
  Day AS day_,
  a.acco_id,
  COALESCE(st.state, a.current_state) as current_state,
  -- a.stakefactor,
  -- a.reg_state,
  -- a.vip_host,
  -- a.status,
  -- a.VIPTier,
  -- a.Pvip,
  -- a.Lead_Owner,
  -- a.FTUDate,
  -- a.lifecycle,
  -- CASE WHEN d.product_preference in ('Casino Only', 'Casino-led') THEN 'Casino'
  --      WHEN d.product_preference in ('Sportsbook Only', 'Sportsbook-led', 'Dual Player') THEN 'SBK'
  --      ELSE 'SBK'
  -- END as product_preference,
  -- d.pseudonym,
  -- f1.loyalty_tier,
  -- ehold,
  -- c.apds_this_month,
  -- d.SBK_EHOLD_BUCKET,
  -- CASE WHEN COALESCE(st.state, a.current_state) in ('AZ','MI','NJ','PA') THEN 'Tier 1'
  --      WHEN COALESCE(st.state, a.current_state) in ('CO','CT','IL','IN','LA','MA','MD','NC','OH','TN','VA','WV') THEN 'Tier 2'
  --      WHEN COALESCE(st.state, a.current_state) in ('DC','IA','KS','KY','NY','VT','WY') THEN 'Tier 3'
  --      ELSE 'ERROR'
  -- END as state_tier,
  -- rtc.rtc_target,
  -- sum(ifnull(Issued, 0)) + sum(ifnull(BBUsed, 0)) as Comp,
  -- sum(ifnull(event_comp, 0)) as event_comp,
  -- sum(ifnull(gifting_comp, 0)) as gifting_comp,
  sum(ifnull(Issued, 0)) + sum(ifnull(BBUsed, 0)) + sum(ifnull(event_comp, 0)) + sum(ifnull(gifting_comp, 0)) as all_in_comp,
  -- sum(ifnull(RetIssued, 0)) + sum(ifnull(RetBBUsed, 0)) + sum(ifnull(event_comp, 0)) + sum(ifnull(gifting_comp, 0)) as RetComp,
  sum(ifnull(HostComp, 0)) + sum(ifnull(event_comp, 0)) + sum(ifnull(gifting_comp, 0)) as HostComp,
  -- sum(ifnull(retention_spend, 0)) as retention_spend,
  -- sum(ifnull(retention_espend, 0)) as retention_espend,
  sum(ifnull(GGR, 0)) - sum(ifnull(correction,0)) as GGR,
  -- sum(ifnull(aGGR, 0)) - sum(ifnull(correction,0)) as aGGR,
  -- sum(ifnull(Handle, 0)) as Handle,
  -- sum(ifnull(TW, 0)) - sum(ifnull(correction,0)) as TW,
  -- sum(ifnull(NGR, 0)) - sum(ifnull(correction,0))  as NGR,
  -- sum(ifnull(Deposits, 0)) as Deposits,
  -- sum(ifnull(Withdrawals, 0)) as Withdrawal,
  -- sum(ifnull(CasinoHandle, 0)) as CasinoHandle,
  -- sum(ifnull(CasinoGGR, 0)) as CasinoGGR,
  -- sum(ifnull(CCIssued, 0)) as CasinoCreditissued,
  -- sum(ifnull(Handle, 0)) - sum(ifnull(CasinoHandle, 0)) AS SportsbookHandle,
  -- sum(ifnull(GGR, 0)) - sum(ifnull(correction,0)) - sum(ifnull(CasinoGGR, 0)) AS SportsbookGGR,
  -- sum(ifnull(eCVP, 0)) as eCVP,
  -- sum(ifnull(CVP, 0)) as CVP,
  -- sum(ifnull(SbkBets, 0)) as SbkBets,
  -- sum(ifnull(FCEarn, 0)) as FCEarn,
  -- balance,
  -- wac.wac
  from 
  stats a
  left join fbg_source.osb_source.account_balances b
  on b.acco_id = a.acco_id
  and fund_type_id = 1
  left join state as st
      on a.acco_id = st.acco_id
  -- left join final_this_month c
  -- on a.acco_id = c.acco_id
  left join fbg_analytics_engineering.customers.customer_mart as d
  on a.acco_id = d.acco_id
  left join fbg_analytics.product_and_customer.value_bands_historical v
  on v.acco_id = a.acco_id
  and v.as_of_date = current_date - 1
  left join fbg_analytics.product_and_customer.f1_attributes f1
  on f1.acco_id = a.acco_id
  left join fbg_analytics.vip.rtc_targets_by_state_hold_group as rtc
  on lower(COALESCE(st.state, a.current_state)) = lower(rtc.state)
  and lower(d.SBK_EHOLD_BUCKET) = lower(rtc.ehold_group)
  left join (select * from fbg_analytics.vip.vip_wac_historical where iscurrentweek = 1) as wac
      on a.acco_id = wac.acco_id
  
  where
  day is not null
  group by all
  ),
  
  all_in_comp_ratio_last_week_ AS (
  SELECT DISTINCT 
  acco_id
  , DIV0(SUM(all_in_comp) , SUM(ggr)) as all_in_comp_ratio_last_week
  FROM final_staging
  WHERE day_ >= DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7 - 7, CURRENT_DATE)
    AND day_ < DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7, CURRENT_DATE)
  GROUP BY
  ALL
  )
  
  , all_in_comp_ratio_l30_ AS (
  SELECT DISTINCT 
  acco_id
  , DIV0(SUM(all_in_comp) , SUM(ggr)) as all_in_comp_ratio_l30
  FROM final_staging
  WHERE day_ >= DATEADD(DAY, -30, CURRENT_DATE)
  GROUP BY
  ALL
  ) 
  
  , all_in_comp_ratio_season_ AS (
  SELECT DISTINCT 
  acco_id
  , DIV0(SUM(all_in_comp) , SUM(ggr)) as all_in_comp_ratio_season
  FROM final_staging
  WHERE day_ >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , host_comp_season_ AS (
  SELECT DISTINCT 
  acco_id 
  , SUM(hostcomp) AS host_comp_season 
  FROM final_staging
  WHERE day_ >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , all_in_comp_ratio_lifetime_ AS (
  SELECT DISTINCT 
  acco_id
  , DIV0(SUM(all_in_comp) , SUM(ggr)) as all_in_comp_ratio_lifetime
  FROM final_staging
  GROUP BY
  ALL
  )
  
  , wac_ AS (
  SELECT DISTINCT 
  w.acco_id
  , wac
  FROM fbg_analytics.vip.vip_wac_historical AS w 
  INNER JOIN users AS u 
      ON w.acco_id = u.acco_id
  WHERE iscurrentweek = 1
  )
  
  , last_cash_wager_ AS (
  SELECT DISTINCT 
  f.transaction_account_id AS acco_id
  , MAX(CONVERT_TIMEZONE('America/Toronto', f.trans_date_utc)) AS last_cash_wager_timestamp_est
  FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_TRANSACTIONS_MART AS f
  INNER JOIN users AS u 
      ON f.transaction_account_id = u.acco_id
  WHERE f.finance_transactions_fund_type_id = 1
  AND f.transaction_type = 'STAKE'
  AND f.finance_transaction_source = 'INTERNET'
  AND CONVERT_TIMEZONE('America/Toronto', f.trans_date_utc) >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , current_cash_balance_ AS (
  SELECT a.*
  FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES AS a
  INNER JOIN users AS u 
      ON a.acco_id = u.acco_id
  WHERE fund_type_id = 1
  )
  
  , latest_deposit_ AS (
  SELECT DISTINCT 
  d.acco_id
  , MAX(CONVERT_TIMEZONE('America/Toronto', completed_at)) AS max_deposit_est
  FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS AS d 
  INNER JOIN users AS u 
      ON d.acco_id = u.acco_id
  WHERE payment_brand <> 'TERMINAL'
  AND d.status = 'DEPOSIT_SUCCESS'
  AND CONVERT_TIMEZONE('America/Toronto', completed_at) >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , max_deposit__ AS (
  SELECT DISTINCT 
  d.acco_id
  , DATE_TRUNC('DAY', CONVERT_TIMEZONE('America/Toronto', completed_at)) AS day
  , SUM(amount) AS daily_deposit
  FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS AS d 
  INNER JOIN users AS u 
      ON d.acco_id = u.acco_id
  WHERE payment_brand <> 'TERMINAL'
  AND d.status = 'DEPOSIT_SUCCESS'
  AND CONVERT_TIMEZONE('America/Toronto', completed_at) >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , max_deposit_ AS (
  SELECT DISTINCT acco_id
  , MAX(daily_deposit) AS max_deposit
  FROM max_deposit__
  GROUP BY
  ALL
  )
  
  , fancash_balance_ AS (
  SELECT DISTINCT
  f.acco_id
  , fancash_balance
  FROM fbg_analytics.product_and_customer.fancash_balance AS f 
  INNER JOIN users AS u 
      ON f.acco_id = u.acco_id
  )
  
  , avg_deposit_ AS (
  SELECT DISTINCT 
  d.acco_id
  , AVG(amount) AS avg_deposit
  FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS AS d 
  INNER JOIN users AS u 
      ON d.acco_id = u.acco_id
  WHERE payment_brand <> 'TERMINAL'
  AND d.status = 'DEPOSIT_SUCCESS'
  AND CONVERT_TIMEZONE('America/Toronto', completed_at) >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , avg_bet_ AS (
  SELECT DISTINCT
  account_id AS acco_id
  , wager_id
  , SUM(total_cash_stake_by_legs) AS cash_handle
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END) AS football_cash_handle
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_status != 'REJECTED'
  AND wager_placed_time_est >= '2025-08-23'
  GROUP BY 
  ALL
  )
  
  , max_bet_ AS (
  SELECT DISTINCT
  account_id AS acco_id
  , DATE_TRUNC('DAY', wager_placed_time_est) AS day 
  , SUM(total_cash_stake_by_legs) AS cash_handle
  -- , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_stake_by_legs END) AS football_handle
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_status != 'REJECTED'
  AND wager_placed_time_est >= '2025-08-23'
  GROUP BY 
  ALL
  )
  
  , avg_bet_final_ AS (
  SELECT DISTINCT
  acco_id
  , AVG(cash_handle) AS avg_cash_bet
  , AVG(football_cash_handle) AS avg_football_cash_bet
  FROM avg_bet_
  GROUP BY
  ALL
  )
  
  , max_bet_final_ AS (
  SELECT DISTINCT 
  acco_id 
  , MAX(cash_handle) AS max_cash_bet
  FROM max_bet_
  GROUP BY
  ALL
  )
  
  , ngr_by_day AS (
  SELECT DISTINCT
  account_id AS acco_id
  , DATE_TRUNC('DAY', wager_placed_time_est) AS day 
  , SUM(total_ngr_by_legs) AS day_ngr
  -- , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_stake_by_legs END) AS football_handle
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_status != 'REJECTED'
  AND wager_placed_time_est >= '2025-08-23'
  GROUP BY 
  ALL
  )
  
  , max_win_ AS (
  SELECT DISTINCT 
  acco_id 
  , MIN(day_ngr) AS max_win
  FROM ngr_by_day 
  WHERE day_ngr < 0
  GROUP BY 
  ALL
  )
  
  , max_loss_ AS (
  SELECT DISTINCT 
  acco_id 
  , MAX(day_ngr) AS max_loss
  FROM ngr_by_day 
  WHERE day_ngr > 0
  GROUP BY 
  ALL
  )
  
  , handle_last_week AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_cash_stake_by_legs) AS cash_handle_last_week
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END) AS football_cash_handle_last_week
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7 - 7, CURRENT_DATE)
  AND wager_placed_time_est < DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7, CURRENT_DATE)
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , handle_l30d AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_cash_stake_by_legs) AS cash_handle_l30d
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END) AS football_cash_handle_l30d
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= DATEADD(DAY, -30, CURRENT_DATE)
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , handle_season AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_cash_stake_by_legs) AS cash_handle_season
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_cash_stake_by_legs END) AS football_cash_handle_season
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= '2025-08-23'
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , bet_type_season AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(CASE WHEN wager_bet_type = 'SINGLE' THEN total_cash_stake_by_legs END) AS single_handle
  , SUM(CASE WHEN wager_bet_type = 'SGP Stack' OR wager_bet_type = 'BETBUILDER' THEN total_cash_stake_by_legs END) AS sgp_handle
  , SUM(CASE WHEN wager_bet_type = 'MULTIPLE' OR wager_bet_type = 'TEASER' THEN total_cash_stake_by_legs END) AS parlay_handle
  , SUM(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND wager_bet_type = 'SINGLE' THEN total_cash_stake_by_legs END) AS football_single_handle
  , SUM(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND (wager_bet_type = 'SGP Stack' OR wager_bet_type = 'BETBUILDER') THEN total_cash_stake_by_legs END) AS football_sgp_handle
  , SUM(CASE WHEN (event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%') AND (wager_bet_type = 'MULTIPLE' OR wager_bet_type = 'TEASER') THEN total_cash_stake_by_legs END) AS football_parlay_handle
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= '2025-08-23'
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , ngr_last_week AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_ngr_by_legs) AS ngr_last_week
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_ngr_by_legs END) AS football_ngr_last_week
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7 - 7, CURRENT_DATE)
    AND wager_placed_time_est < DATEADD(DAY, 
                      - (DATE_PART(DOW, CURRENT_DATE) + 5) % 7, CURRENT_DATE)
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , ngr_l30d AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_ngr_by_legs) AS ngr_l30d
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_ngr_by_legs END) AS football_ngr_l30d
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= DATEADD(DAY, -30, CURRENT_DATE)
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , ngr_season AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , SUM(total_ngr_by_legs) AS ngr_season
  , SUM(expected_ngr_by_legs) AS engr_season
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN total_ngr_by_legs END) AS football_ngr_season
  , SUM(CASE WHEN event_league ILIKE '%NFL%' OR event_league ILIKE '%NCAAF%' THEN expected_ngr_by_legs END) AS football_engr_season
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE wager_placed_time_est >= '2025-08-23'
  AND wager_status != 'REJECTED'
  GROUP BY
  ALL
  )
  
  , last_active_week AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , week AS last_active_nfl_week
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  INNER JOIN fbg_analytics.vip.football_schedule AS f 
      ON t.wager_placed_time_est >= f.start_date 
      AND t.wager_placed_time_est <= f.end_date
  WHERE total_cash_stake_by_legs > 0 
  AND wager_status != 'REJECTED'
  AND f.year = 2025
  AND f.league = 'NFL'
  QUALIFY row_number() OVER (PARTITION BY account_id ORDER BY f.rank DESC) = 1
  )
  
  , football_last_active_week AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , week AS football_last_active_nfl_week
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  INNER JOIN fbg_analytics.vip.football_schedule AS f 
      ON t.wager_placed_time_est >= f.start_date 
      AND t.wager_placed_time_est <= f.end_date
  WHERE (t.event_league ILIKE '%NFL%' OR t.event_league ILIKE '%NCAAF%')
  AND wager_status != 'REJECTED'
  AND total_cash_stake_by_legs > 0 
  AND f.year = 2025
  AND f.league = 'NFL'
  QUALIFY row_number() OVER (PARTITION BY account_id ORDER BY f.rank DESC) = 1
  )
  
  , active_weeks AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , COALESCE(COUNT(DISTINCT f.week), 0) AS active_nfl_weeks
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  INNER JOIN fbg_analytics.vip.football_schedule AS f 
      ON t.wager_placed_time_est >= f.start_date 
      AND t.wager_placed_time_est <= f.end_date
  WHERE total_cash_stake_by_legs > 0 
  AND wager_status != 'REJECTED'
  AND f.year = 2025
  AND f.league = 'NFL'
  GROUP BY
  ALL
  )
  
  , football_active_weeks AS (
  SELECT DISTINCT 
  account_id AS acco_id
  , COALESCE(COUNT(DISTINCT f.week), 0) AS football_active_nfl_weeks
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  INNER JOIN fbg_analytics.vip.football_schedule AS f 
      ON t.wager_placed_time_est >= f.start_date 
      AND t.wager_placed_time_est <= f.end_date
  WHERE (t.event_league ILIKE '%NFL%' OR t.event_league ILIKE '%NCAAF%')
  AND total_cash_stake_by_legs > 0 
  AND wager_status != 'REJECTED'
  AND f.year = 2025
  AND f.league = 'NFL'
  GROUP BY
  ALL
  )
  
  , fancash_bets AS (
  SELECT DISTINCT 
  account_id AS acco_id 
  , COUNT(DISTINCT wager_id) AS fc_bets
  -- , COUNT(DISTINCT CASE WHEN wager_result = 'WIN' THEN wager_id END) AS winning_fc_bets
  -- , COUNT(DISTINCT CASE WHEN wager_result = 'LOSS' THEN wager_id END) AS losing_fc_bets
  , SUM(total_stake_by_legs) AS fc_handle
  , SUM(total_ggr_by_legs) AS fc_ggr
  , SUM(total_ngr_by_legs) AS fc_ngr
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE is_fancash_wager = TRUE 
  AND wager_status != 'REJECTED'
  AND wager_placed_time_est >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , cvp_ AS (
  SELECT DISTINCT 
  c.acco_id 
  , SUM(customer_variable_profit) AS cvp 
  FROM fbg_analytics.product_and_customer.customer_variable_profit AS c 
  INNER JOIN users AS u 
      ON c.acco_id = u.acco_id
  WHERE c.date >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , gdg_campaigns AS (
  SELECT DISTINCT
  bonus_campaign_id 
  , "Bonus Code"
  , description
  FROM fbg_analytics.product_and_customer.bonus_categories
  WHERE subcategory = 'GDG'
  )
  
  , gdg_bets_ AS (
  SELECT DISTINCT 
  ab.acco_id
  , g.*
  , REGEXP_SUBSTR(overrides,'betId=([0-9]+)',1,1,'e',1) AS bet_id
  , REGEXP_SUBSTR(overrides,'fanCashAmount=([0-9]+(\\.[0-9]+)?)',1,1,'e',1) AS fancash_amount
  FROM fbg_source.osb_source.account_bonuses AS ab 
  INNER JOIN gdg_campaigns AS g 
      ON ab.bonus_campaign_id = g.bonus_campaign_id 
  INNER JOIN users AS u 
      ON ab.acco_id = u.acco_id
  WHERE ab.state = 'EXECUTED'
  AND bet_id IS NOT NULL
  )
  
  , single_bet AS (
  SELECT DISTINCT 
  wager_id 
  , SUM(total_cash_stake_by_legs) AS cash_handle
  , SUM(total_ngr_by_legs) AS ngr 
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN gdg_bets_ AS g 
      ON t.wager_id = g.bet_id
  GROUP BY 
  ALL
  )
  
  , gdg_final AS (
  SELECT DISTINCT 
  g.acco_id 
  , COUNT(DISTINCT g.bet_id) AS gdg_bets
  , SUM(t.cash_handle) AS gdg_handle
  , SUM(g.fancash_amount) AS gdg_fancash_amount
  , SUM(t.ngr) AS gdg_ngr
  FROM single_bet AS t 
  INNER JOIN gdg_bets_ AS g 
      ON t.wager_id = g.bet_id
  GROUP BY 
  ALL
  )
  
  , fairplay_bets AS (
  SELECT DISTINCT 
  acco_id
  , wager_id
  , SUM(total_payout_by_legs) as fp_payout
  FROM fbg_analytics_engineering.trading.trading_sportsbook_mart AS t 
  INNER JOIN users AS u 
      ON t.account_id = u.acco_id
  WHERE leg_result_reason = 'FAIRNESS'
  AND wager_result IN ('WIN', 'PUSH')
  AND wager_placed_time_est >= '2025-08-23'
  GROUP BY
  ALL
  )
  
  , fairplay_final AS (
  SELECT DISTINCT 
  acco_id 
  , COUNT(DISTINCT wager_id) AS fairplay_bets
  , SUM(fp_payout) AS fairplay_payout
  FROM fairplay_bets 
  GROUP BY 
  ALL
  )
  
  
  , historical_host AS (
  SELECT DISTINCT
  e.org
  , e.sr_manager 
  , e.manager
  , e.name
  , e.host_type
  , e.team
  , h.acco_id 
  , MAX(h.as_of_date) as max_date
  FROM fbg_analytics.vip.vip_employee_mapping AS e 
  LEFT JOIN fbg_analytics.vip.vip_host_lead_historical AS h 
      ON e.name = h.vip_host
  --WHERE e.sr_manager != 'Taylor Gwiazdon'
  GROUP BY
  ALL
  )
  
  , current_host AS (
  SELECT DISTINCT 
  h.org
  , h.sr_manager
  , h.manager
  , h.name
  , h.host_type
  , h.team
  , h.acco_id 
  FROM historical_host AS h 
  INNER JOIN fbg_analytics_engineering.customers.customer_mart AS cm 
      ON h.acco_id = cm.acco_id
  WHERE h.max_date = CURRENT_DATE
  )
  
  SELECT DISTINCT
  ch.manager AS "Manager"
  , ch.name AS "VIP Host"
   ,cm.acco_id AS "Acco ID"
  , apt.individual_approach AS "Individual Approach"
  , apt.favorite_nfl_team AS "Favorite NFL Team"
  , apt.favorite_ncaaf_team AS "Favorite NCAAF Team"
  , cm.status AS "Status"
  , cm.f1_loyalty_tier AS "Loyalty Tier"
  , ccb.balance AS "Current Cash Balance"
  , w.wac AS "WAC"
  , COALESCE(fb.fancash_balance, 0) AS "Current Fancash Balance"
  , DATE_TRUNC('DAY', lcw.last_cash_wager_timestamp_est)::DATE AS "Last Cash Wager Date"
  , DATE_TRUNC('DAY', ld.max_deposit_est)::DATE AS "Last Deposit Date"
  , COALESCE(ad.avg_deposit, 0) AS "Avg Deposit"
  , COALESCE(abf.avg_cash_bet, 0) AS "Avg Cash Bet"
  , COALESCE(abf.avg_football_cash_bet, 0) AS "Avg Football Cash Bet"
  , COALESCE(hlw.cash_handle_last_week, 0) AS "Cash Handle Last Week"
  , COALESCE(hlw.football_cash_handle_last_week, 0) AS "Football Cash Handle Last Week"
  , COALESCE(hl3.cash_handle_l30d, 0) AS "Last 30 Days Cash Handle"
  , COALESCE(hl3.football_cash_handle_l30d, 0) AS "Last 30 Days Football Cash Handle"
  , COALESCE(hs.cash_handle_season, 0) AS "Season Long Cash Handle"
  , COALESCE(hs.football_cash_handle_season, 0) AS "Season Long Football Cash Handle"
  , COALESCE(nlw.ngr_last_week, 0) AS "NGR Last Week"
  , COALESCE(nlw.football_ngr_last_week, 0) AS "Football NGR Last Week"
  , COALESCE(nl3.ngr_l30d, 0) AS "Last 30 Days NGR"
  , COALESCE(nl3.football_ngr_l30d, 0) AS "Last 30 Days Football NGR"
  , COALESCE(ns.ngr_season, 0) AS "Season Long NGR"
  , COALESCE(ns.football_ngr_season, 0) AS "Season Long Football NGR"
  , COALESCE(ns.engr_season, 0) AS "Season Long eNGR"
  , COALESCE(ns.football_engr_season, 0) AS "Season Long Football eNGR"
  , law.last_active_nfl_week AS "Last Active Week"
  , flaw.football_last_active_nfl_week AS "Football Last Active Week"
  , COALESCE(aw.active_nfl_weeks, 0) AS "# of Active Weeks"
  , COALESCE(faw.football_active_nfl_weeks, 0) AS "# of Football Active Weeks"
  , COALESCE(crlw.all_in_comp_ratio_last_week, 0) AS "Last Week All-In Comp Ratio"
  , COALESCE(crl3.all_in_comp_ratio_l30, 0) AS "Last 30 Days All-In Comp Ratio"
  , COALESCE(crs.all_in_comp_ratio_season, 0) AS "Season Long All-In Comp Ratio"
  , COALESCE(crl.all_in_comp_ratio_lifetime, 0) AS "Lifetime All-In Comp Ratio"
  , COALESCE(fcb.fc_bets, 0) AS "FanCash Bets"
  , COALESCE(fcb.fc_handle, 0) AS "FanCash Handle"
  , COALESCE(fcb.fc_ggr, 0) AS "FanCash GGR"
  , COALESCE(fcb.fc_ngr, 0) AS "FanCash NGR"
  , COALESCE(c.cvp, 0) AS "CVP"
  , COALESCE(hcs.host_comp_season, 0) AS "Host Comp Season"
  , COALESCE(md.max_deposit, 0) AS "Largest Deposit"
  , COALESCE(mbf.max_cash_bet, 0) AS "Largest Wager"
  , COALESCE(mw.max_win, 0) AS "Largest Win"
  , COALESCE(ml.max_loss, 0) AS "Largest Loss"
  , COALESCE(gdg.gdg_bets, 0) AS "GDG Bets"
  , COALESCE(gdg.gdg_handle, 0) AS "GDG Handle"
  , COALESCE(gdg.gdg_fancash_amount, 0) AS "GDG FanCash Amount"
  , COALESCE(gdg.gdg_ngr, 0) AS "GDG NGR"
  , COALESCE(fpf.fairplay_bets, 0) AS "FairPlay Bets"
  , COALESCE(fpf.fairplay_payout, 0) AS "FairPlay Payout"
  , COALESCE(bts.single_handle, 0) AS "Single Handle"
  , COALESCE(bts.sgp_handle, 0) AS "SGP Handle"
  , COALESCE(bts.parlay_handle, 0) AS "Parlay Handle"
  , COALESCE(bts.football_single_handle, 0) AS "Football Single Handle"
  , COALESCE(bts.football_sgp_handle, 0) AS "Football SGP Handle"
  , COALESCE(bts.football_parlay_handle, 0) AS "Football Parlay Handle"
  FROM users AS cm 
  LEFT JOIN current_host AS ch 
      ON cm.acco_id = ch.acco_id
  LEFT JOIN wac_ AS w 
      ON cm.acco_id = w.acco_id
  LEFT JOIN last_cash_wager_ AS lcw 
      ON cm.acco_id = lcw.acco_id
  LEFT JOIN current_cash_balance_ AS ccb 
      ON cm.acco_id = ccb.acco_id
  LEFT JOIN latest_deposit_ AS ld 
      ON cm.acco_id = ld.acco_id
  LEFT JOIN fancash_balance_ AS fb 
      ON cm.acco_id = fb.acco_id
  LEFT JOIN avg_deposit_ AS ad 
      ON cm.acco_id = ad.acco_id
  LEFT JOIN avg_bet_final_ AS abf 
      ON cm.acco_id = abf.acco_id
  LEFT JOIN handle_last_week AS hlw
      ON cm.acco_id = hlw.acco_id
  LEFT JOIN handle_l30d AS hl3 
      ON cm.acco_id = hl3.acco_id 
  LEFT JOIN handle_season AS hs   
      ON cm.acco_id = hs.acco_id
  LEFT JOIN ngr_last_week AS nlw
      ON cm.acco_id = nlw.acco_id
  LEFT JOIN ngr_l30d AS nl3 
      ON cm.acco_id = nl3.acco_id 
  LEFT JOIN ngr_season AS ns   
      ON cm.acco_id = ns.acco_id
  LEFT JOIN last_active_week AS law 
      ON cm.acco_id = law.acco_id
  LEFT JOIN football_last_active_week AS flaw
      ON cm.acco_id = flaw.acco_id
  LEFT JOIN active_weeks AS aw
      ON cm.acco_id = aw.acco_id
  LEFT JOIN football_active_weeks AS faw 
      ON cm.acco_id = faw.acco_id
  LEFT JOIN all_in_comp_ratio_last_week_ AS crlw
      ON cm.acco_id = crlw.acco_id 
  LEFT JOIN all_in_comp_ratio_l30_ AS crl3
      ON cm.acco_id = crl3.acco_id
  LEFT JOIN all_in_comp_ratio_season_ AS crs 
      ON cm.acco_id = crs.acco_id
  LEFT JOIN all_in_comp_ratio_lifetime_ AS crl 
      ON cm.acco_id = crl.acco_id
  LEFT JOIN fbg_analytics.vip.am_preseason_tool_2025 AS apt 
      ON cm.acco_id = apt.acco_id
  LEFT JOIN fancash_bets AS fcb
      ON cm.acco_id = fcb.acco_id
  LEFT JOIN cvp_ AS c 
      ON cm.acco_id = c.acco_id
  LEFT JOIN host_comp_season_ AS hcs 
      ON cm.acco_id = hcs.acco_id 
  LEFT JOIN max_deposit_ AS md 
      ON cm.acco_id = md.acco_id
  LEFT JOIN max_bet_final_ AS mbf 
      ON cm.acco_id = mbf.acco_id
  LEFT JOIN max_win_ AS mw 
      ON cm.acco_id = mw.acco_id
  LEFT JOIN max_loss_ AS ml 
      ON cm.acco_id = ml.acco_id
  LEFT JOIN gdg_final AS gdg 
      ON cm.acco_id = gdg.acco_id
  LEFT JOIN fairplay_final AS fpf 
      ON cm.acco_id = fpf.acco_id
  LEFT JOIN bet_type_season AS bts 
      ON cm.acco_id = bts.acco_id
  WHERE ch.name IS NOT NULL
) "Custom SQL Query"
