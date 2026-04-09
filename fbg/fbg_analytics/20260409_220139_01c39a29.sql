-- Query ID: 01c39a29-0212-67a8-24dd-0703193e3667
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: STRATEGY_XL_WH
-- Executed: 2026-04-09T22:01:39.673000+00:00
-- Elapsed: 346472ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AGGR" AS "AGGR",
  "Custom SQL Query"."ALL_IN_COMP" AS "ALL_IN_COMP",
  "Custom SQL Query"."APDS_THIS_MONTH" AS "APDS_THIS_MONTH",
  "Custom SQL Query"."BALANCE" AS "BALANCE",
  "Custom SQL Query"."BONUS_RECO" AS "BONUS_RECO",
  "Custom SQL Query"."CASINOBETS" AS "CASINOBETS",
  "Custom SQL Query"."CASINOCREDITISSUED" AS "CASINOCREDITISSUED",
  "Custom SQL Query"."CASINOGGR" AS "CASINOGGR",
  "Custom SQL Query"."CASINOHANDLE" AS "CASINOHANDLE",
  "Custom SQL Query"."COMMERCE_CURRENT_YEAR_TIER_POINTS" AS "COMMERCE_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."COMP" AS "COMP",
  "Custom SQL Query"."CURRENT_DR_HOOK" AS "CURRENT_DR_HOOK",
  "Custom SQL Query"."CURRENT_DR_TIER" AS "CURRENT_DR_TIER",
  "Custom SQL Query"."CURRENT_DR_UPSELL" AS "CURRENT_DR_UPSELL",
  "Custom SQL Query"."CURRENT_STATE" AS "CURRENT_STATE",
  "Custom SQL Query"."CVP" AS "CVP",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."DEPOSITS" AS "DEPOSITS",
  "Custom SQL Query"."DEPOSITS_SINCE_LAST_HOST_COMP" AS "DEPOSITS_SINCE_LAST_HOST_COMP",
  "Custom SQL Query"."ECVP" AS "ECVP",
  "Custom SQL Query"."EHOLD" AS "EHOLD",
  "Custom SQL Query"."EVENT_COMP" AS "EVENT_COMP",
  "Custom SQL Query"."F1_COMP" AS "F1_COMP",
  "Custom SQL Query"."FBG_GOODWILL_CURRENT_YEAR_TIER_POINTS" AS "FBG_GOODWILL_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."FCEARN" AS "FCEARN",
  "Custom SQL Query"."FTUDATE" AS "FTUDATE",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."GIFTING_COMP" AS "GIFTING_COMP",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."HOSTCOMP" AS "HOSTCOMP",
  "Custom SQL Query"."IS_STATUS_MATCH" AS "IS_STATUS_MATCH",
  "Custom SQL Query"."IS_STATUS_MATCH_90D_WINDOW" AS "IS_STATUS_MATCH_90D_WINDOW",
  "Custom SQL Query"."L365D_COMP_RATIO" AS "L365D_COMP_RATIO",
  "Custom SQL Query"."LAST_HOST_COMP" AS "LAST_HOST_COMP",
  "Custom SQL Query"."LAST_HOST_COMP_AMOUNT" AS "LAST_HOST_COMP_AMOUNT",
  "Custom SQL Query"."LAST_MESSAGE_DATE" AS "LAST_MESSAGE_DATE",
  "Custom SQL Query"."LAST_MESSAGE_TYPE" AS "LAST_MESSAGE_TYPE",
  "Custom SQL Query"."LAST_YEAR_TIER_POINTS" AS "LAST_YEAR_TIER_POINTS",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LIFECYCLE" AS "LIFECYCLE",
  "Custom SQL Query"."LOYALTY_TIER" AS "LOYALTY_TIER",
  "Custom SQL Query"."MANAGER" AS "MANAGER",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."NUMDEPOSITS" AS "NUMDEPOSITS",
  "Custom SQL Query"."OC_CURRENT_YEAR_TIER_POINTS" AS "OC_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."OSB_CURRENT_YEAR_TIER_POINTS" AS "OSB_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."OTHER_COMP_SINCE_LAST_HOST_COMP" AS "OTHER_COMP_SINCE_LAST_HOST_COMP",
  "Custom SQL Query"."OTHER_CURRENT_YEAR_TIER_POINTS" AS "OTHER_CURRENT_YEAR_TIER_POINTS",
  "Custom SQL Query"."PAYBACK_PROGRESS" AS "PAYBACK_PROGRESS",
  "Custom SQL Query"."PRODUCT_PREFERENCE" AS "PRODUCT_PREFERENCE",
  "Custom SQL Query"."PSEUDONYM" AS "PSEUDONYM",
  "Custom SQL Query"."PVIP" AS "PVIP",
  "Custom SQL Query"."REG_STATE" AS "REG_STATE",
  "Custom SQL Query"."RETCOMP" AS "RETCOMP",
  "Custom SQL Query"."RETENTION_ESPEND" AS "RETENTION_ESPEND",
  "Custom SQL Query"."RETENTION_SPEND" AS "RETENTION_SPEND",
  "Custom SQL Query"."RET_COMP_RATIO" AS "RET_COMP_RATIO",
  "Custom SQL Query"."RTC_TARGET" AS "RTC_TARGET",
  "Custom SQL Query"."SBKBETS" AS "SBKBETS",
  "Custom SQL Query"."SBK_EHOLD_BUCKET" AS "SBK_EHOLD_BUCKET",
  "Custom SQL Query"."SPORTSBOOKGGR" AS "SPORTSBOOKGGR",
  "Custom SQL Query"."SPORTSBOOKHANDLE" AS "SPORTSBOOKHANDLE",
  "Custom SQL Query"."STAKEFACTOR" AS "STAKEFACTOR",
  "Custom SQL Query"."STANDALONE_DEAL" AS "STANDALONE_DEAL",
  "Custom SQL Query"."STATE_TIER" AS "STATE_TIER",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."TRADING_BONUS_RECO" AS "TRADING_BONUS_RECO",
  "Custom SQL Query"."TRADING_PBT_ONLY" AS "TRADING_PBT_ONLY",
  "Custom SQL Query"."TW" AS "TW",
  "Custom SQL Query"."VIPTIER" AS "VIPTIER",
  "Custom SQL Query"."VIP_HOST" AS "VIP_HOST",
  "Custom SQL Query"."WAC" AS "WAC",
  "Custom SQL Query"."WITHDRAWALS_SINCE_LAST_HOST_COMP" AS "WITHDRAWALS_SINCE_LAST_HOST_COMP",
  "Custom SQL Query"."WITHDRAWAL" AS "WITHDRAWAL"
FROM (
  WITH STATE AS (
      SELECT
          a.acco_id,
          a.state,
          (COALESCE(SUM(osb_cash_handle),0)
          + COALESCE(SUM(oc_cash_handle),0)
          + COALESCE(SUM(osb_freebet_handle),0)
          + COALESCE(SUM(oc_freebet_handle),0)) AS total_handle
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CUSTOMER_VARIABLE_PROFIT AS a
      GROUP BY ALL
      HAVING total_handle IS NOT NULL
      QUALIFY ROW_NUMBER() OVER (PARTITION BY a.acco_id ORDER BY total_handle DESC) = 1
  ),
  
  /* ✅ ADDED: Tier points CTE */
  f1_tier_points AS (
      SELECT
          acco_id,
          last_year_tier_points,
          osb_current_year_tier_points,
          oc_current_year_tier_points,
          commerce_current_year_tier_points,
          fbg_goodwill_current_year_tier_points,
          other_current_year_tier_points
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES
  ),
  
  -- JACKPOT_WIN AS (
  -- ...
  -- ),
  
  STATS AS (
      SELECT
          DATE(day) AS Day,
          a.acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          IFNULL(SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('cash_back') THEN amount ELSE 0 END), 0) AS Issued,
          SUM(CASE WHEN (transaction = 'bonus used' AND promo_type = 'bonus_bet') THEN amount * 0.6
                     WHEN (transaction = 'bonus awarded' AND promo_type = 'fancash')
                   THEN amount * COALESCE(fc.fc_cost_factor,.6) ELSE 0 END) AS BBUsed,
          IFNULL(SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('cash_back')
                            AND "Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                            AND "SubCategory" NOT IN ('Migration')
                          THEN amount ELSE 0 END), 0) AS RetIssued,
          SUM(
              CASE
                  WHEN transaction = 'bonus used' AND promo_type = 'bonus_bet'
                       AND "Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                       AND "SubCategory" NOT IN ('Migration')
                      THEN amount * 0.6
                  WHEN transaction = 'bonus awarded' AND promo_type = 'fancash'
                       AND "Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                       AND "SubCategory" NOT IN ('Migration')
                      THEN amount * COALESCE(fc.fc_cost_factor,.6)
                  ELSE 0
              END
          ) AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          IFNULL(SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('cash_back')
                            AND "SubCategory" ILIKE '%VIP%'
                            AND "SubCategory" NOT IN ('VIP', 'VIP ', 'VIP Offer Library')
                          THEN amount ELSE 0 END), 0)
          + IFNULL(SUM(CASE WHEN (transaction = 'bonus awarded' AND promo_type IN ('fancash')
                                  AND "SubCategory" ILIKE '%VIP%')
                                OR (transaction = 'bonus used' AND promo_type = 'bonus_bet'
                                    AND "SubCategory" ILIKE '%VIP%'
                                    AND "SubCategory" NOT IN ('VIP', 'VIP ', 'VIP Offer Library'))
                          THEN amount ELSE 0 END), 0) AS HostComp,
          IFNULL(SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type = 'one_credit' AND date >= '2025-11-01'
                          THEN amount ELSE 0 END), 0) AS f1_comp,
          IFNULL(SUM(CASE WHEN ("Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                                AND "SubCategory" NOT IN ('Migration')
                                AND promo_type NOT IN ('profit_boost','boost_market')
                                AND transaction = 'bonus winnings')
                          THEN amount ELSE 0 END),0) AS retention_spend,
          IFNULL(SUM(CASE WHEN ("Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                                AND "SubCategory" NOT IN ('Migration')
                                AND promo_type NOT IN ('profit_boost','boost_market')
                                AND transaction = 'bonus expected winnings')
                          THEN amount ELSE 0 END),0) AS retention_espend,
          NULL AS GGR,
          NULL AS aGGR,
          NULL AS Handle,
          NULL AS TW,
          NULL AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          NULL AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          NULL AS SbkBets,
          SUM(CASE WHEN transaction = 'bonus awarded' AND "SubCategory" = 'FanCash 5/3/1' THEN amount ELSE 0 END) AS FCEarn,
          NULL AS correction
      FROM FBG_P13N.PROMO_SILVER_TABLE.PROMOTIONS_LEDGER_FINAL a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      LEFT JOIN fbg_analytics.product_and_customer.fancash_burn_distribution fc
        ON a.acco_id = fc.acco_id
      WHERE (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND date <> '2024-09-08 07:36:50.715'
        AND u.is_test_account = 'FALSE'
        AND "SubCategory" != 'Cashout'
        AND "SubCategory" NOT IN ('GOODWILL_APPEASEMENTS_VIP-RET_Trading_Issue',
                                  'GOODWILL_APPEASEMENTS_VIP_RET_Trading_Issue',
                                  'VIP-RET_Trading_Issue',
                                  'GOODWILL_APPEASEMENTS_VIP-RET_Technical_Outage_Recovery',
                                  'GOODWILL_APPEASEMENTS_VIP_RET_Technical_Outage_Recovery',
                                  'VIP-RET_Technical_Outage_Recovery')
      GROUP BY ALL
      HAVING (issued > 0 OR bbused > 0)
  
      UNION
  
      SELECT
          DATE(day) AS Day,
          a.acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('casino_credit', 'cash_back') THEN amount ELSE 0 END) AS Issued,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type = 'fancash' THEN amount * COALESCE(fc.fc_cost_factor,1) ELSE 0 END) AS BBUsed,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('casino_credit', 'cash_back')
                    AND "Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                    AND "SubCategory" NOT IN ('Migration')
                   THEN amount ELSE 0 END) AS RetIssued,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type = 'fancash'
                    AND "Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                    AND "SubCategory" NOT IN ('Migration')
                   THEN amount * COALESCE(fc.fc_cost_factor,1) ELSE 0 END) AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type IN ('casino_credit', 'fancash', 'cash_back')
                    AND ("SubCategory" ILIKE '%VIP%' OR "SubCategory" = 'Goodwill')
                   THEN amount ELSE 0 END) AS HostComp,
          IFNULL(SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type = 'fanatics_one_credit' AND date >= '2025-11-01'
                          THEN amount ELSE 0 END), 0) AS f1_comp,
          IFNULL(SUM(CASE WHEN ("Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                                AND "SubCategory" NOT IN ('Migration')
                                AND transaction = 'bonus winnings')
                          THEN amount ELSE 0 END),0) AS retention_spend,
          IFNULL(SUM(CASE WHEN ("Bonus Category" NOT IN ('Acquisition','CS Acquisition')
                                AND "SubCategory" NOT IN ('Migration')
                                AND transaction = 'bonus winnings')
                          THEN amount ELSE 0 END),0) AS retention_espend,
          NULL AS GGR,
          NULL AS aGGR,
          NULL AS Handle,
          NULL AS TW,
          NULL AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          SUM(CASE WHEN transaction = 'bonus awarded' AND promo_type = 'casino_credit' THEN amount ELSE 0 END) AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          NULL AS SbkBets,
          SUM(CASE WHEN transaction = 'bonus awarded' AND "SubCategory" = 'FanCash Casino Base' THEN amount ELSE 0 END) AS FCEarn,
          NULL AS correction
      FROM fbg_analytics.product_and_customer.casino_promotions_ledger a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      LEFT JOIN fbg_analytics.product_and_customer.fancash_burn_distribution fc
        ON a.acco_id = fc.acco_id
      WHERE (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND u.is_test_account = 'FALSE'
        AND "SubCategory" NOT IN ('GOODWILL_APPEASEMENTS_VIP-RET_Trading_Issue',
                                  'GOODWILL_APPEASEMENTS_VIP_RET_Trading_Issue',
                                  'VIP-RET_Trading_Issue',
                                  'GOODWILL_APPEASEMENTS_VIP-RET_Technical_Outage_Recovery',
                                  'GOODWILL_APPEASEMENTS_VIP_RET_Technical_Outage_Recovery',
                                  'VIP-RET_Technical_Outage_Recovery')
      GROUP BY ALL
      HAVING (issued > 0 OR bbused > 0)
  
      UNION
  
      SELECT 
          DATE(settled_date_alk) AS Day,
          c.acco_id, 
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE 
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          NULL AS Issued,
          NULL AS BBUsed,
          NULL AS RetIssued,
          NULL AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          NULL AS hostcomp,
          NULL AS f1_comp,
          NULL AS retention_spend,
          NULL AS retention_espend,
          IFNULL(SUM(ggr), 0) AS GGR,
          IFNULL(SUM(ggr), 0) AS aGGR,
          IFNULL(SUM(cash_bet_stake), 0) AS Handle,
          IFNULL(SUM(ggr), 0) AS TW,
          IFNULL(SUM(ngr), 0) AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          IFNULL(SUM(cash_bet_stake), 0) AS CasinoHandle,
          IFNULL(SUM(ggr), 0) AS CasinoGGR,
          IFNULL(SUM(cash_bet_count), 0) AS Casinobets,
          NULL AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          NULL AS SbkBets,
          NULL AS FCEarn,
          NULL AS correction
      FROM fbg_analytics_engineering.casino.casino_daily_settled_agg C
      INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
        ON A.ID = C.Acco_ID
      INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart U
        ON U.Acco_ID = C.Acco_ID
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = c.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      WHERE A.Test = 0
        AND (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND u.is_test_account = 'FALSE'
      GROUP BY ALL
  
      UNION
  
      SELECT
          DATE(wager_settlement_time_alk) AS Day,
          account_id AS acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE 
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          NULL AS Issued,
          NULL AS BBUsed,
          NULL AS RetIssued,
          NULL AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          NULL AS hostcomp,
          NULL AS f1_comp,
          NULL AS retention_spend,
          NULL AS retention_espend,
          IFNULL(SUM(total_cash_ggr_by_legs),0) AS GGR,
          IFNULL(SUM(expected_cash_ggr_by_legs), 0) AS aGGR,
          IFNULL(SUM(total_cash_stake_by_legs), 0) AS Handle,
          IFNULL(SUM(trading_win), 0) AS TW,
          IFNULL(SUM(total_ngr_by_legs), 0) AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          NULL AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          COUNT(DISTINCT CASE WHEN is_free_bet_wager = FALSE THEN wager_id END) AS SbkBets,
          NULL AS FCEarn,
          NULL AS correction
      FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.account_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.account_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      WHERE a.wager_status = 'SETTLED'
        AND a.wager_channel = 'INTERNET'
        AND (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND u.is_test_account = 'FALSE'
      GROUP BY ALL
  
      UNION
  
      SELECT
          DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', completed_at)) AS Day,
          a.acco_id AS acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE 
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          NULL AS Issued,
          NULL AS BBUsed,
          NULL AS RetIssued,
          NULL AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          NULL AS hostcomp,
          NULL AS f1_comp,
          NULL AS retention_spend,
          NULL AS retention_espend,
          NULL AS GGR,
          NULL AS aGGR,
          NULL AS Handle,
          NULL AS TW,
          NULL AS NGR,
          SUM(amount) AS Deposits,
          COUNT(DISTINCT a.id) AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          NULL AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          NULL AS SbkBets,
          NULL AS FCEarn,
          NULL AS correction
      FROM fbg_source.osb_source.deposits a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      WHERE a.status = 'DEPOSIT_SUCCESS'
        AND (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND u.is_test_account = 'FALSE'
      GROUP BY ALL
  
      UNION
  
      SELECT
          Day,
          acco_id,
          current_state,
          stakefactor,
          reg_state,
          vip_host,
          status,
          VIPTier,
          Pvip,
          lead_owner,
          FTUDate,
          Lifecycle,
          Issued,
          BBUsed,
          RetIssued,
          RetBBUsed,
          event_comp,
          gifting_comp,
          hostcomp,
          f1_comp,
          retention_spend,
          retention_espend,
          GGR,
          aGGR,
          Handle,
          TW,
          NGR,
          Deposits,
          numdeposits,
          SUM(Withdrawals) AS Withdrawals,
          CasinoHandle,
          CasinoGGR,
          Casinobets,
          CCIssued,
          eCVP,
          CVP,
          SbkBets,
          FCEarn,
          correction
      FROM (
          SELECT
              DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', completed_at)) AS Day,
              a.account_id AS acco_id,
              u.current_state,
              u.stake_factor AS stakefactor,
              u.registration_state AS reg_state,
              u.vip_host,
              u.status,
              u.coded_total_tier AS VIPTier,
              is_pvip AS Pvip,
              lead_owner,
              DATE(u.fbg_ftu_date_alk) AS FTUDate,
              CASE 
                  WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
                  WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
                  WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
                  WHEN lifecycle IN ('Reactivation') THEN 'Churned'
                  ELSE 'Other'
              END AS Lifecycle,
              NULL AS Issued,
              NULL AS BBUsed,
              NULL AS RetIssued,
              NULL AS RetBBUsed,
              NULL AS event_comp,
              NULL AS gifting_comp,
              NULL AS hostcomp,
              NULL AS f1_comp,
              NULL AS retention_spend,
              NULL AS retention_espend,
              NULL AS GGR,
              NULL AS aGGR,
              NULL AS Handle,
              NULL AS TW,
              NULL AS NGR,
              NULL AS Deposits,
              NULL AS numdeposits,
              SUM(COALESCE(amount, 0)) AS Withdrawals,
              NULL AS CasinoHandle,
              NULL AS CasinoGGR,
              NULL AS Casinobets,
              NULL AS CCIssued,
              NULL AS eCVP,
              NULL AS CVP,
              NULL AS SbkBets,
              NULL AS FCEarn,
              NULL AS correction
          FROM fbg_source.osb_source.withdrawals a
          JOIN fbg_analytics_engineering.customers.customer_mart u
            ON u.acco_id = a.account_id
          LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
            ON l.acco_id = a.account_id
           AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
          WHERE a.status = 'WITHDRAWAL_COMPLETED'
            AND (u.vip_host IS NOT NULL OR is_pvip = 1)
            AND u.is_test_account = 'FALSE'
          GROUP BY ALL
  
          UNION
  
          SELECT
              DATE(trans_date_alk) AS Day,
              a.transaction_account_id AS acco_id,
              u.current_state,
              u.stake_factor AS stakefactor,
              u.registration_state AS reg_state,
              u.vip_host,
              u.status,
              u.coded_total_tier AS VIPTier,
              is_pvip AS Pvip,
              lead_owner,
              DATE(u.fbg_ftu_date_alk) AS FTUDate,
              CASE 
                  WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
                  WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
                  WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
                  WHEN lifecycle IN ('Reactivation') THEN 'Churned'
                  ELSE 'Other'
              END AS Lifecycle,
              NULL AS Issued,
              NULL AS BBUsed,
              NULL AS RetIssued,
              NULL AS RetBBUsed,
              NULL AS event_comp,
              NULL AS gifting_comp,
              NULL AS hostcomp,
              NULL AS f1_comp,
              NULL AS retention_spend,
              NULL AS retention_espend,
              NULL AS GGR,
              NULL AS aGGR,
              NULL AS Handle,
              NULL AS TW,
              NULL AS NGR,
              NULL AS Deposits,
              NULL AS numdeposits,
              SUM(COALESCE(-1 * transaction_amount, 0)) AS Withdrawals,
              NULL AS CasinoHandle,
              NULL AS CasinoGGR,
              NULL AS Casinobets,
              NULL AS CCIssued,
              NULL AS eCVP,
              NULL AS CVP,
              NULL AS SbkBets,
              NULL AS FCEarn,
              NULL AS correction
          FROM FBG_ANALYTICS_ENGINEERING.FINANCE.FINANCE_TRANSACTIONS_MART a
          JOIN fbg_analytics_engineering.customers.customer_mart u
            ON u.acco_id = a.transaction_account_id
          LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
            ON l.acco_id = a.transaction_account_id
           AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
          WHERE a.transaction_type = 'FINANCE_CORRECTION_WITHDRAWAL'
            AND (transaction_description ILIKE '%patron request wire wd via vip am%'
                 OR transaction_description ILIKE '%patron request wire withdrawal via vip am%')
            AND (u.vip_host IS NOT NULL OR is_pvip = 1)
            AND u.is_test_account = 'FALSE'
          GROUP BY ALL
      )
      GROUP BY ALL
  
      UNION
  
      SELECT
          a.date AS Day,
          a.acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE 
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          NULL AS Issued,
          NULL AS BBUsed,
          NULL AS RetIssued,
          NULL AS RetBBUsed,
          SUM(ticket_cost) AS event_comp,
          SUM(gift_cost) AS gifting_comp,
          NULL AS hostcomp,
          NULL AS f1_comp,
          NULL AS retention_spend,
          NULL AS retention_espend,
          NULL AS GGR,
          NULL AS aGGR,
          NULL AS Handle,
          NULL AS TW,
          NULL AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          NULL AS CCIssued,
          SUM(ecustomer_variable_profit) AS eCVP,
          SUM(customer_variable_profit) AS CVP,
          NULL AS SbkBets,
          NULL AS FCEarn,
          NULL AS correction
      FROM fbg_analytics.product_and_customer.customer_variable_profit a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      WHERE (u.vip_host IS NOT NULL OR is_pvip = 1)
        AND u.is_test_account = 'FALSE'
      GROUP BY ALL
  
      UNION
  
      SELECT
          DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', trans_date)) AS Day,
          a.acco_id AS acco_id,
          u.current_state,
          u.stake_factor AS stakefactor,
          u.registration_state AS reg_state,
          u.vip_host,
          u.status,
          u.coded_total_tier AS VIPTier,
          is_pvip AS Pvip,
          lead_owner,
          DATE(u.fbg_ftu_date_alk) AS FTUDate,
          CASE 
              WHEN (DATEDIFF(day, fbg_ftu_date_alk, CURRENT_DATE) BETWEEN 0 AND 30) OR lifecycle = 'Onboarding' THEN 'New'
              WHEN lifecycle IN ('Active','Churn Prevention') THEN 'Active'
              WHEN lifecycle IN ('Active - Recently Reactivated') THEN 'Recently Reactivated'
              WHEN lifecycle IN ('Reactivation') THEN 'Churned'
              ELSE 'Other'
          END AS Lifecycle,
          NULL AS Issued,
          NULL AS BBUsed,
          NULL AS RetIssued,
          NULL AS RetBBUsed,
          NULL AS event_comp,
          NULL AS gifting_comp,
          NULL AS hostcomp,
          NULL AS f1_comp,
          NULL AS retention_spend,
          NULL AS retention_espend,
          NULL AS GGR,
          NULL AS aGGR,
          NULL AS Handle,
          NULL AS TW,
          NULL AS NGR,
          NULL AS Deposits,
          NULL AS numdeposits,
          NULL AS Withdrawals,
          NULL AS CasinoHandle,
          NULL AS CasinoGGR,
          NULL AS Casinobets,
          NULL AS CCIssued,
          NULL AS eCVP,
          NULL AS CVP,
          NULL AS SbkBets,
          NULL AS FCEarn,
          SUM(amount) AS Correction
      FROM fbg_source.osb_source.account_statements a
      JOIN fbg_analytics_engineering.customers.customer_mart u
        ON u.acco_id = a.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.fbg_lifecylce l
        ON l.acco_id = a.acco_id
       AND DATE(insert_date) = (SELECT MAX(DATE(insert_date)) FROM fbg_analytics.product_and_customer.fbg_lifecylce)
      WHERE a.acco_id = 3427257
        AND trans = 'CORRECTION'
      GROUP BY ALL
  ),
  
  casino_this_month AS (
      SELECT DISTINCT
          a.acco_id,
          DATE(a.settled_date_alk) AS apd
      FROM FBG_ANALYTICS_ENGINEERING.CASINO.CASINO_DAILY_SETTLED_AGG AS a
      WHERE DATE(DATE_TRUNC('month', a.settled_date_alk)) = DATE(DATE_TRUNC('month', CURRENT_TIMESTAMP))
        AND cash_bet_stake > 0
  ),
  
  sbk_this_month AS (
      SELECT DISTINCT
          a.account_id AS acco_id,
          DATE(a.wager_settlement_time_alk) AS apd
      FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART AS a
      WHERE DATE(DATE_TRUNC('month', a.wager_settlement_time_alk)) = DATE(DATE_TRUNC('month', CURRENT_TIMESTAMP))
        AND a.is_pointsbet_wager = FALSE
        AND a.wager_status IN ('ACCEPTED', 'SETTLED')
        AND total_cash_stake_by_legs > 0
  ),
  
  staging_raw_this_month AS (
      SELECT * FROM casino_this_month
      UNION ALL
      SELECT * FROM sbk_this_month
  ),
  
  staging_this_month AS (
      SELECT DISTINCT acco_id FROM staging_raw_this_month
  ),
  
  final_this_month AS (
      SELECT
          a.acco_id,
          COUNT(DISTINCT b.apd) AS apds_this_month
      FROM staging_this_month AS a
      LEFT JOIN staging_raw_this_month AS b
        ON a.acco_id = b.acco_id
      GROUP BY ALL
  ),
  
  final_staging AS (
      SELECT
          Day,
          a.acco_id,
          COALESCE(st.state, a.current_state) AS current_state,
          a.stakefactor,
          a.reg_state,
          a.vip_host,
          a.status,
          a.VIPTier,
          a.Pvip,
          a.Lead_Owner,
          a.FTUDate,
          a.lifecycle,
          CASE
              WHEN d.product_preference IN ('Casino Only', 'Casino-led') THEN 'Casino'
              WHEN d.product_preference IN ('Sportsbook Only', 'Sportsbook-led', 'Dual Player') THEN 'SBK'
              ELSE 'SBK'
          END AS product_preference,
          d.pseudonym,
          f1.loyalty_tier,
          ehold,
          c.apds_this_month,
          d.SBK_EHOLD_BUCKET,
  
          /* ✅ ADDED: tier points fields */
          tp.last_year_tier_points,
          tp.osb_current_year_tier_points,
          tp.oc_current_year_tier_points,
          tp.commerce_current_year_tier_points,
          tp.fbg_goodwill_current_year_tier_points,
          tp.other_current_year_tier_points,
  
          CASE
              WHEN COALESCE(st.state, a.current_state) IN ('AZ','MI','NJ','PA','MO') THEN 'Tier 1'
              WHEN COALESCE(st.state, a.current_state) IN ('CO','CT','IL','IN','LA','MA','MD','NC','OH','TN','VA','WV') THEN 'Tier 2'
              WHEN COALESCE(st.state, a.current_state) IN ('DC','IA','KS','KY','NY','VT','WY') THEN 'Tier 3'
              ELSE 'ERROR'
          END AS state_tier,
          COALESCE(rtc.rtc_target, 0.3) AS rtc_target,
          SUM(IFNULL(Issued, 0)) + SUM(IFNULL(BBUsed, 0)) + SUM(IFNULL(f1_comp, 0)) AS Comp,
          SUM(IFNULL(event_comp, 0)) AS event_comp,
          SUM(IFNULL(gifting_comp, 0)) AS gifting_comp,
          SUM(IFNULL(Issued, 0)) + SUM(IFNULL(BBUsed, 0)) + SUM(IFNULL(event_comp, 0)) + SUM(IFNULL(gifting_comp, 0)) + SUM(IFNULL(f1_comp, 0)) AS all_in_comp,
          SUM(IFNULL(RetIssued, 0)) + SUM(IFNULL(RetBBUsed, 0)) + SUM(IFNULL(event_comp, 0)) + SUM(IFNULL(gifting_comp, 0)) + SUM(IFNULL(f1_comp, 0)) AS RetComp,
          SUM(IFNULL(HostComp, 0)) + SUM(IFNULL(event_comp, 0)) + SUM(IFNULL(gifting_comp, 0)) AS HostComp,
          SUM(IFNULL(f1_comp, 0)) AS f1_comp,
          SUM(IFNULL(retention_spend, 0)) AS retention_spend,
          SUM(IFNULL(retention_espend, 0)) AS retention_espend,
          SUM(IFNULL(GGR, 0)) - SUM(IFNULL(correction,0)) AS GGR,
          SUM(IFNULL(aGGR, 0)) - SUM(IFNULL(correction,0)) AS aGGR,
          SUM(IFNULL(Handle, 0)) AS Handle,
          SUM(IFNULL(TW, 0)) - SUM(IFNULL(correction,0)) AS TW,
          SUM(IFNULL(NGR, 0)) - SUM(IFNULL(correction,0)) AS NGR,
          SUM(IFNULL(Deposits, 0)) AS Deposits,
          SUM(IFNULL(numdeposits, 0)) AS numdeposits,
          SUM(IFNULL(Withdrawals, 0)) AS Withdrawal,
          SUM(IFNULL(CasinoHandle, 0)) AS CasinoHandle,
          SUM(IFNULL(CasinoGGR, 0)) AS CasinoGGR,
          SUM(IFNULL(Casinobets, 0)) AS Casinobets,
          SUM(IFNULL(CCIssued, 0)) AS CasinoCreditissued,
          SUM(IFNULL(Handle, 0)) - SUM(IFNULL(CasinoHandle, 0)) AS SportsbookHandle,
          SUM(IFNULL(GGR, 0)) - SUM(IFNULL(correction,0)) - SUM(IFNULL(CasinoGGR, 0)) AS SportsbookGGR,
          SUM(IFNULL(eCVP, 0)) AS eCVP,
          SUM(IFNULL(CVP, 0)) AS CVP,
          SUM(IFNULL(SbkBets, 0)) AS SbkBets,
          SUM(IFNULL(FCEarn, 0)) AS FCEarn,
          balance,
          DIV0((SUM(IFNULL(Issued, 0)) + SUM(IFNULL(BBUsed, 0))), (SUM(IFNULL(GGR, 0)) - SUM(IFNULL(correction,0)))) AS ret_comp_ratio,
          wac.wac
      FROM stats a
      LEFT JOIN fbg_source.osb_source.account_balances b
        ON b.acco_id = a.acco_id
       AND fund_type_id = 1
      LEFT JOIN state st
        ON a.acco_id = st.acco_id
      LEFT JOIN final_this_month c
        ON a.acco_id = c.acco_id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart d
        ON a.acco_id = d.acco_id
      LEFT JOIN fbg_analytics.product_and_customer.value_bands_historical v
        ON v.acco_id = a.acco_id
       AND v.as_of_date = CURRENT_DATE - 1
      LEFT JOIN fbg_analytics.product_and_customer.f1_attributes f1
        ON f1.acco_id = a.acco_id
  
      /* ✅ ADDED join */
      LEFT JOIN f1_tier_points tp
        ON tp.acco_id = a.acco_id
  
      LEFT JOIN fbg_analytics.vip.rtc_targets_by_state_hold_group AS rtc
        ON LOWER(COALESCE(st.state, a.current_state)) = LOWER(rtc.state)
       AND LOWER(d.SBK_EHOLD_BUCKET) = LOWER(rtc.ehold_group)
      LEFT JOIN (SELECT * FROM fbg_analytics.vip.vip_wac_historical WHERE iscurrentweek = 1) AS wac
        ON a.acco_id = wac.acco_id
      WHERE day IS NOT NULL
      GROUP BY ALL
  ),
  
  -- last_30_staging AS (
  --     SELECT * FROM (
  --         SELECT
  --             acco_id,
  --             day,
  --             ROW_NUMBER() OVER (PARTITION BY acco_id ORDER BY day DESC) AS recent_cash_active_days
  --         FROM final_staging
  --         WHERE (Handle > 0 OR CasinoHandle > 0)
  --     )
  --     WHERE recent_cash_active_days <= 1000
  -- ),
  
  -- last_30_days AS (
  --     SELECT
  --         acco_id,
  --         MIN(day) AS start_date,
  --         MAX(day) AS end_date
  --     FROM last_30_staging
  --     GROUP BY ALL
  -- ),
  
  last_365_final AS (
      SELECT
          b.acco_id,
          -- SUM(b.retention_spend) AS l30_retetion,
          -- SUM(b.retention_espend) AS l30_eretetion,
          -- SUM(b.ggr) AS l30_ggr,
          -- SUM(b.aggr) AS l30_eggr,
          -- SUM(b.RetComp) AS l30_comp,
          DIV0(SUM(b.RetComp), SUM(b.ggr)) AS l365d_comp_ratio,
          -- DIV0(SUM(b.retention_spend), SUM(b.ggr)) AS rtc,
          -- DIV0(SUM(b.retention_espend), SUM(b.aggr)) AS ertc
      FROM final_staging AS b
      WHERE b.day >= DATEADD(DAY, -365, CURRENT_DATE)
      GROUP BY ALL
  ),
  
  status_match_staging AS (
      SELECT
          account_id AS acco_id,
          invite_date AS sm_date,
          override_tier AS sm_tier
      FROM FBG_STITCH.GS_F1_OVERRIDE.SUMMARY
      WHERE notes ILIKE '%status match%'
  
      UNION ALL
  
      SELECT
          acco_id,
          DATE(status_match_start_date) AS sm_date,
          CASE
              WHEN status_match_tier_name ILIKE '%platinum%' THEN 'Platinum'
              WHEN status_match_tier_name ILIKE '%gold%' THEN 'Gold'
              WHEN status_match_tier_name ILIKE '%black%' THEN 'Black'
              ELSE 'ERROR'
          END AS sm_tier
      FROM fbg_analytics.product_and_customer.status_match
      WHERE status_match_start IS NOT NULL
  ),
  
  status_match_final AS (
      SELECT *
      FROM status_match_staging
      QUALIFY ROW_NUMBER() OVER (PARTITION BY acco_id ORDER BY sm_date ASC) = 1
  ),
  
  final AS (
      SELECT
          a.*,
          b.l365d_comp_ratio,
          -- b.rtc,
          -- b.ertc,
          -- b.l30_retetion,
          -- b.l30_eretetion,
          -- b.l30_ggr,
          -- b.l30_eggr,
          -- b.l30_comp,
          c.bonus_reco AS trading_bonus_reco,
          CASE WHEN sm.acco_id IS NOT NULL THEN TRUE ELSE FALSE END AS is_status_match,
          CASE WHEN sm.acco_id IS NOT NULL AND sm.sm_date >= '2025-06-11' AND DATEADD(day, 90, sm.sm_date) >= CURRENT_DATE THEN TRUE ELSE FALSE END AS is_status_match_90d_window,
          CASE WHEN c.acco_id IS NOT NULL THEN 1 ELSE 0 END AS trading_pbt_only,
          CASE WHEN d.acco_id IS NOT NULL THEN 1 ELSE 0 END AS standalone_deal,
          e.manager
      FROM final_staging AS a
      LEFT JOIN last_365_final AS b
        ON a.acco_id = b.acco_id
      LEFT JOIN fbg_analytics.vip.vip_promo_trading_resitrictions AS c
        ON a.acco_id = c.acco_id
      LEFT JOIN fbg_analytics.vip.vip_standing_deals AS d
        ON a.acco_id = d.acco_id
      LEFT JOIN status_match_final AS sm
        ON a.acco_id = sm.acco_id
      LEFT JOIN fbg_analytics.vip.vip_employee_mapping AS e
        ON a.vip_host = e.name
  ),
  
  last_host_comp AS (
      SELECT DISTINCT
          acco_id,
          MAX(day) AS last_host_comp
      FROM final
      WHERE hostcomp > 0
      GROUP BY ALL
  ),
  
  last_host_comp_amount AS (
      SELECT DISTINCT
          f.acco_id,
          SUM(f.hostcomp) AS last_host_comp_amount
      FROM final AS f
      INNER JOIN last_host_comp AS l
        ON f.acco_id = l.acco_id
       AND f.day = l.last_host_comp
      GROUP BY ALL
  ),
  
  metrics_since_last_host_comp AS (
      SELECT DISTINCT
          l.acco_id,
          l.last_host_comp,
          COALESCE(SUM(r.deposits), 0) AS deposits_since_last_host_comp,
          COALESCE(SUM(r.withdrawal), 0) AS withdrawals_since_last_host_comp,
          COALESCE(SUM(r.all_in_comp), 0) AS other_comp_since_last_host_comp
      FROM last_host_comp AS l
      LEFT JOIN final AS r
        ON l.acco_id = r.acco_id
       AND l.last_host_comp < r.day
      GROUP BY ALL
  ),
  
  lifetime_bonus_reco AS (
      SELECT DISTINCT
          f.acco_id,
          CASE
              WHEN f.standalone_deal = 1 THEN 'Standalone Deal'
              WHEN v.test_group_id = 1 THEN 'No Generosity'
              WHEN f.l365d_comp_ratio > f.rtc_target THEN 'Overbonused - No Bonus'
              WHEN f.trading_pbt_only = 1 THEN trading_bonus_reco
              WHEN f.ehold < 0.025 THEN 'PBT Only'
              WHEN f.l365d_comp_ratio < 0 THEN 'PBT Only'
              ELSE 'No Restriction - Review RTC Before Bonusing'
          END AS bonus_reco
      FROM final AS f
      LEFT JOIN fbg_analytics.product_and_customer.viper_2_concierge_test_20260310 AS v 
          ON f.acco_id = v.acco_id
  ),
  
  last_contact AS (
      SELECT DISTINCT
          c.acco_id,
          DATE_TRUNC('DAY', c.message_date)::DATE AS last_message_date,
          c.message_type AS last_message_type
      FROM fbg_analytics.vip.vip_contact_history AS c
      INNER JOIN fbg_analytics_engineering.customers.customer_mart AS u
        ON c.acco_id = u.acco_id
       AND c.fbg_name = u.vip_host
      WHERE c.outbound = 1
      QUALIFY ROW_NUMBER() OVER (PARTITION BY c.acco_id ORDER BY c.message_date DESC) = 1
  )
  
  , offer_payback AS (
  select 
      acco_id,
      last_offer_date,
      atw_after_tax,
      btw_after_tax,
      reward_factor,
      previous_remainder,
      (nvl(btw_after_tax, 0) * reward_factor + nvl(previous_remainder, 0)) as contribution,
      
      total_cost,
      payback, -- contribution - total_cost
      
      contribution / total_cost as perc_paid_back,
      case 
          when is_qualified = 1 then 'Qualified today'
          when perc_paid_back <= 0 then 'Negative TW Since Last Offer'
          when perc_paid_back > 0 then concat((perc_paid_back*100)::int, '% Paid Back on Last Offer')
      end payback_progress
  
  from fbg_analytics.product_and_customer.one_rewards_targeting  
  where offer_date = current_date
  )
  
  , current_dr_tier_metric AS (
  SELECT DISTINCT 
  acco_id 
  , daily_rewards_offer_id
  FROM fbg_analytics.product_and_customer.daily_value_tier
  QUALIFY row_number() OVER (PARTITION BY acco_id ORDER BY as_of_date DESC) = 1
  )
  
  SELECT DISTINCT
      f.*,
      m.last_host_comp,
      h.last_host_comp_amount,
      m.deposits_since_last_host_comp,
      m.withdrawals_since_last_host_comp,
      m.other_comp_since_last_host_comp,
      l.bonus_reco,
      lc.last_message_date,
      lc.last_message_type,
      op.payback_progress,
      dvt.daily_rewards_offer_id AS current_dr_tier,
      dlc.hook AS current_dr_hook,
      dlc.upsell AS current_dr_upsell
  FROM final AS f
  LEFT JOIN metrics_since_last_host_comp AS m
    ON f.acco_id = m.acco_id
  LEFT JOIN lifetime_bonus_reco AS l
    ON f.acco_id = l.acco_id
  LEFT JOIN last_host_comp_amount AS h
    ON f.acco_id = h.acco_id
  LEFT JOIN last_contact AS lc
    ON f.acco_id = lc.acco_id
  LEFT JOIN offer_payback AS op
    ON f.acco_id = op.acco_id
  LEFT JOIN current_dr_tier_metric AS dvt 
    ON f.acco_id = dvt.acco_id 
  LEFT JOIN fbg_analytics.product_and_customer.dr_ladder_config AS dlc 
    ON dvt.daily_rewards_offer_id = dlc.tier
) "Custom SQL Query"
