-- Query ID: 01c39a2a-0212-6e7d-24dd-0703193e4ac3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:02:02.762000+00:00
-- Elapsed: 12290ms
-- Environment: FBG

SELECT "Custom SQL Query2"."ACCO_ID" AS "ACCO_ID (Custom SQL Query2)",
  "Custom SQL Query2"."OB_DM_BONUS_ACCOUNT_BONUS_ID" AS "OB_DM_BONUS_ACCOUNT_BONUS_ID",
  "Custom SQL Query2"."OB_DM_BONUS_CREATED" AS "OB_DM_BONUS_CREATED",
  "Custom SQL Query2"."OB_DM_BONUS_NAME" AS "OB_DM_BONUS_NAME",
  "Custom SQL Query2"."OB_DM_BONUS_OPT_IN_TIME" AS "OB_DM_BONUS_OPT_IN_TIME",
  "Custom SQL Query2"."OB_DM_BONUS_STATE" AS "OB_DM_BONUS_STATE",
  "Custom SQL Query2"."OG_DM_BONUS_BONUS_ID" AS "OG_DM_BONUS_BONUS_ID",
  "Custom SQL Query2"."OG_DM_BONUS_CREATED" AS "OG_DM_BONUS_CREATED",
  "Custom SQL Query2"."OG_DM_BONUS_NAME" AS "OG_DM_BONUS_NAME",
  "Custom SQL Query2"."OG_DM_BONUS_OPT_IN_TIME" AS "OG_DM_BONUS_OPT_IN_TIME",
  "Custom SQL Query2"."OG_DM_BONUS_STATE" AS "OG_DM_BONUS_STATE",
  "Custom SQL Query2"."OP_DM_BONUS_BONUS_ID" AS "OP_DM_BONUS_BONUS_ID",
  "Custom SQL Query2"."OP_DM_BONUS_CREATED" AS "OP_DM_BONUS_CREATED",
  "Custom SQL Query2"."OP_DM_BONUS_NAME" AS "OP_DM_BONUS_NAME",
  "Custom SQL Query2"."OP_DM_BONUS_OPT_IN_TIME" AS "OP_DM_BONUS_OPT_IN_TIME",
  "Custom SQL Query2"."OP_DM_BONUS_STATE" AS "OP_DM_BONUS_STATE",
  "Custom SQL Query2"."PUNCHCARD_BONUS_CREATED" AS "PUNCHCARD_BONUS_CREATED",
  "Custom SQL Query2"."PUNCHCARD_BONUS_ID" AS "PUNCHCARD_BONUS_ID",
  "Custom SQL Query2"."PUNCHCARD_BONUS_NAME" AS "PUNCHCARD_BONUS_NAME",
  "Custom SQL Query2"."PUNCHCARD_BONUS_OPT_IN_TIME" AS "PUNCHCARD_BONUS_OPT_IN_TIME",
  "Custom SQL Query2"."PUNCHCARD_BONUS_STATE" AS "PUNCHCARD_BONUS_STATE"
FROM (
  with status_matches as (
    select *
    from fbg_analytics.product_and_customer.status_match
    where date(status_match_start_date) >= '2026-01-01'
      and status_match_tier_name in ('ONEgold', 'ONEplatinum', 'ONEblack')
  ),
  base as (
    select
      a.acco_id,
      b.id as bonus_id,
      b.created,
      b.state,
      b.bonus_campaign_id,
      parse_json(c.data):Bonus:name::string as bonus_name,
      b.overrides,
      convert_timezone(
        'UTC','America/New_York',
        to_timestamp(split_part(regexp_substr(b.overrides, 'optInTime\\W+\\w+'), '=', 2))
      ) as opt_in_time
    from status_matches a
    left join FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES b
      on a.acco_id = b.acco_id
    left join FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS c
      on b.bonus_campaign_id = c.id
    where b.bonus_campaign_id in (1015807, 1015808, 1015809, 1015810)
      and date(b.created) >= '2026-01-01'
  )
  
  select
    acco_id,
  
    /* 1015807 */
    max(iff(bonus_campaign_id = 1015807, bonus_name, null)) as punchcard_bonus_name,
    max(iff(bonus_campaign_id = 1015807, state, null))      as punchcard_bonus_state,
    max(iff(bonus_campaign_id = 1015807, created, null))    as punchcard_bonus_created,
    max(iff(bonus_campaign_id = 1015807, opt_in_time, null))as punchcard_bonus_opt_in_time,
    max(iff(bonus_campaign_id = 1015807, bonus_id, null))   as punchcard_bonus_id,
  
    /* 1015808 */
    max(iff(bonus_campaign_id = 1015808, bonus_name, null)) as og_dm_bonus_name,
    max(iff(bonus_campaign_id = 1015808, state, null))      as og_dm_bonus_state,
    max(iff(bonus_campaign_id = 1015808, created, null))    as og_dm_bonus_created,
    max(iff(bonus_campaign_id = 1015808, opt_in_time, null))as og_dm_bonus_opt_in_time,
    max(iff(bonus_campaign_id = 1015808, bonus_id, null))   as og_dm_bonus_bonus_id,
  
    /* 1015809 */
    max(iff(bonus_campaign_id = 1015809, bonus_name, null)) as op_dm_bonus_name,
    max(iff(bonus_campaign_id = 1015809, state, null))      as op_dm_bonus_state,
    max(iff(bonus_campaign_id = 1015809, created, null))    as op_dm_bonus_created,
    max(iff(bonus_campaign_id = 1015809, opt_in_time, null))as op_dm_bonus_opt_in_time,
    max(iff(bonus_campaign_id = 1015809, bonus_id, null))   as op_dm_bonus_bonus_id,
  
    /* 1015810 */
    max(iff(bonus_campaign_id = 1015810, bonus_name, null)) as ob_dm_bonus_name,
    max(iff(bonus_campaign_id = 1015810, state, null))      as ob_dm_bonus_state,
    max(iff(bonus_campaign_id = 1015810, created, null))    as ob_dm_bonus_created,
    max(iff(bonus_campaign_id = 1015810, opt_in_time, null))as ob_dm_bonus_opt_in_time,
    max(iff(bonus_campaign_id = 1015810, bonus_id, null))   as ob_dm_bonus_account_bonus_id
  
  from base
  group by acco_id
) "Custom SQL Query2"
