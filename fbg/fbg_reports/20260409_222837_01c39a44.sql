-- Query ID: 01c39a44-0212-6e7d-24dd-0703194444b7
-- Database: FBG_REPORTS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Last Executed: 2026-04-09T22:28:37.792000+00:00
-- Elapsed: 14745ms
-- Run Count: 2
-- Environment: FBG

SELECT "Custom SQL Query2"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query2"."ACTIVE" AS "ACTIVE",
  "Custom SQL Query2"."BONUS_ID" AS "BONUS_ID",
  "Custom SQL Query2"."CASINO_SEGMENT" AS "CASINO_SEGMENT (Custom SQL Query2)",
  "Custom SQL Query2"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query2"."F2P_TRANS_DATE" AS "F2P_TRANS_DATE",
  "Custom SQL Query2"."FREESPINS_COUNT" AS "FREESPINS_COUNT",
  "Custom SQL Query2"."FREESPIN_GAME" AS "FREESPIN_GAME",
  "Custom SQL Query2"."FREESPIN_GAME_ID" AS "FREESPIN_GAME_ID",
  "Custom SQL Query2"."FREESPIN_VALUE" AS "FREESPIN_VALUE",
  "Custom SQL Query2"."ID" AS "ID",
  "Custom SQL Query2"."PRIZE_DESCRIPTION" AS "PRIZE_DESCRIPTION",
  "Custom SQL Query2"."PRIZE_DESCRIPTOR_ID" AS "PRIZE_DESCRIPTOR_ID",
  "Custom SQL Query2"."PRIZE_POOL_ID" AS "PRIZE_POOL_ID",
  "Custom SQL Query2"."QUANTITY_AVAILABLE" AS "QUANTITY_AVAILABLE",
  "Custom SQL Query2"."TEST" AS "TEST (Custom SQL Query2)",
  "Custom SQL Query2"."TIME_AWARDED" AS "TIME_AWARDED",
  "Custom SQL Query2"."TIME_CLAIMED" AS "TIME_CLAIMED",
  "Custom SQL Query2"."TYPE" AS "TYPE",
  "Custom SQL Query2"."VALUE" AS "VALUE",
  "Custom SQL Query2"."WEIGHT" AS "WEIGHT"
FROM (
  select 
      gs.id,
      gs.acco_id,
      date(convert_timezone('UTC','America/Anchorage', gs.time_awarded)) as f2p_trans_date,
      gs.time_awarded,
      gs.time_claimed,
      gs.prize_pool_id,
      pp.bonus_id,
      pp.active,
      pp.description,
      pp.casino_segment,
      pp.type,
      pp.freespins_count,
      pp.freespin_value,
      pp.freespin_game,
      pp.quantity_available,
      pp.prize_descriptor_id,
      pd.value,
      pp.freespin_game_id,
      pp.weight,
      pp.value as prize_description,
      acc.test
  from fbg_source.osb_source.f2p_game_session_results as gs
  join fbg_source.osb_source.f2p_prize_pool as pp
      on pp.id = gs.prize_pool_id
  join fbg_source.osb_source.f2p_prize_descriptors as pd
      on pd.id = pp.prize_descriptor_id
  join fbg_source.osb_source.accounts as acc
      on acc.id = gs.acco_id
  where 1=1
) "Custom SQL Query2"
