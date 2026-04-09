-- Query ID: 01c39a41-0212-67a8-24dd-07031943a23b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:25:40.846000+00:00
-- Elapsed: 65ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASH_BET_COUNT" AS "CASH_BET_COUNT",
  "Custom SQL Query"."CASH_BET_PAYOUT" AS "CASH_BET_PAYOUT",
  "Custom SQL Query"."CASH_BET_STAKE" AS "CASH_BET_STAKE",
  "Custom SQL Query"."CASINO_CREDIT_BET_PAYOUT" AS "CASINO_CREDIT_BET_PAYOUT",
  "Custom SQL Query"."CASINO_CREDIT_BET_STAKE" AS "CASINO_CREDIT_BET_STAKE",
  "Custom SQL Query"."CATEGORY" AS "CATEGORY",
  "Custom SQL Query"."FREESPIN_BET_PAYOUT" AS "FREESPIN_BET_PAYOUT",
  "Custom SQL Query"."FREESPIN_BET_STAKE" AS "FREESPIN_BET_STAKE",
  "Custom SQL Query"."GAME_NAME" AS "GAME_NAME",
  "Custom SQL Query"."GAME_PROVIDER" AS "GAME_PROVIDER",
  "Custom SQL Query"."GAME_QUALITY_SCORE_L14D" AS "GAME_QUALITY_SCORE_L14D",
  "Custom SQL Query"."GAME_TYPE" AS "GAME_TYPE",
  "Custom SQL Query"."GGR" AS "GGR",
  "Custom SQL Query"."GRANULAR_GAME_TYPE" AS "GRANULAR_GAME_TYPE",
  "Custom SQL Query"."HIT_RATE" AS "HIT_RATE",
  "Custom SQL Query"."IS_SKILL_GAME" AS "IS_SKILL_GAME",
  "Custom SQL Query"."JURISDICTIONS_ID" AS "JURISDICTIONS_ID",
  "Custom SQL Query"."NGR" AS "NGR",
  "Custom SQL Query"."SETTLED_DATE_ALK" AS "SETTLED_DATE_ALK",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."SUPPORT_JACKPOTS" AS "SUPPORT_JACKPOTS",
  "Custom SQL Query"."TAGLINE" AS "TAGLINE",
  "Custom SQL Query"."TOTAL_BET_COUNT" AS "TOTAL_BET_COUNT",
  "Custom SQL Query"."TOTAL_PAYOUT" AS "TOTAL_PAYOUT",
  "Custom SQL Query"."TOTAL_STAKE" AS "TOTAL_STAKE"
FROM (
  SELECT 
    dsa.acco_id,
    dsa.settled_date_alk,
    dsa.total_bet_count,
    dsa.cash_bet_count,
    gd.game_name,
    gd.game_provider,
    gd.game_type,
    gd.tagline,
    gd.support_jackpots,
   gd.category,
    gd.granular_game_type,
    gd.hit_rate,
    dsa.ggr,
    dsa.ngr,
    gd.is_skill_game,
    dsa.total_stake,
    dsa.cash_bet_stake,
    dsa.total_payout,
    dsa.cash_bet_payout,
    dsa.freespin_bet_stake,
    dsa.freespin_bet_payout,
    dsa.casino_credit_bet_stake,
    dsa.casino_credit_bet_payout,
    dsa.state,
    hsa.jurisdictions_id,
    hsa.game_quality_score_v2 as game_quality_score_l14d
  FROM 
  fbg_analytics_engineering.casino.casino_daily_settled_agg dsa 
  inner join fbg_analytics_engineering.casino.casino_game_details gd on dsa.game_id = gd.game_id
  left join fbg_analytics.casino.casino_game_quality_historical hsa on dsa.game_id = hsa.game_id AND hsa.calendar_date = dsa.settled_date_alk
  WHERE dsa.is_test_account = 0 AND
  settled_date_alk BETWEEN current_date() - INTERVAL '60 days' AND current_date() 
  group by ALL
) "Custom SQL Query"
