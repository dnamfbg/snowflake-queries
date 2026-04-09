-- Query ID: 01c39a4c-0212-6cb9-24dd-070319456dc3
-- Database: FBG_SOURCE
-- Schema: OSB_SOURCE
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:36:20.188000+00:00
-- Elapsed: 124113ms
-- Environment: FBG

WITH driver_bets as (
    WITH base AS (
      SELECT
          user_id,
          event_type,
          MIN(event_id)   AS event_id,
          MIN(event_time) AS event_time,
          PARSE_JSON(event_properties):deeplink_url::string AS deeplink_url
      FROM fbg_source.amplitude.event
      WHERE event_type IN ('deeplink_app_open')
        AND event_time > '2025-11-01'
        AND PARSE_JSON(event_properties):deeplink_url::string ILIKE '%deep_link_sub1=%'
        AND PARSE_JSON(event_properties):deeplink_url::string ILIKE '%eventId%'
        AND PARSE_JSON(event_properties):deeplink_url::string ILIKE '%af_siteid=KAX%'
        AND PARSE_JSON(event_properties):deeplink_url::string ILIKE '%af_channel=affiliateother%'
      GROUP BY ALL
    ),
    param AS (
      SELECT
        user_id, event_type, event_id, event_time, deeplink_url,

        SPLIT_PART(
          SPLIT_PART(deeplink_url, 'deep_link_sub1=', 2),
          '&',
          1
        ) AS deep_link_sub1_enc,

        SPLIT_PART(SPLIT_PART(deeplink_url, 'af_siteid=', 2), '&', 1)   AS af_siteid,
        SPLIT_PART(SPLIT_PART(deeplink_url, 'af_prt=', 2),    '&', 1)   AS af_prt,
        SPLIT_PART(SPLIT_PART(deeplink_url, 'af_channel=', 2),'&', 1)   AS af_channel,
        SPLIT_PART(SPLIT_PART(deeplink_url, 'c=', 2),         '&', 1)   AS campaign
      FROM base
      WHERE POSITION('deep_link_sub1=' IN deeplink_url) > 0
    ),
    decoded AS (
      SELECT
        user_id, event_type, event_id, event_time,
        af_siteid, af_prt, af_channel, campaign,
        deeplink_url,

        REGEXP_REPLACE(
          REGEXP_REPLACE(
            REGEXP_REPLACE(
              REGEXP_REPLACE(
                REGEXP_REPLACE(
                  REGEXP_REPLACE(
                    REGEXP_REPLACE(deep_link_sub1_enc, '%22', '"', 1, 0, 'i'),  -- "
                    '%3A', ':', 1, 0, 'i'),                                     -- :
                  '%2C', ',', 1, 0, 'i'),                                       -- ,
                '%7B', '{', 1, 0, 'i'),                                         -- {
              '%7D', '}', 1, 0, 'i'),                                           -- }
            '%5B', '[', 1, 0, 'i'),                                             -- [
          '%5D', ']', 1, 0, 'i')                                                -- ]
          AS deep_link_sub1_json
      FROM param
      WHERE deep_link_sub1_enc IS NOT NULL
    )
    SELECT DISTINCT
      d.user_id,
      d.event_id,
      d.event_type,
      d.event_time,
      d.af_siteid,
      d.af_prt,
      d.af_channel,
      d.campaign,
      leg.value:eventId::string      AS event_id_url,
      leg.value:marketId::string     AS market_id_url,
      leg.value:selectionId::string  AS selection_id,
      d.deeplink_url
    FROM decoded d,
         LATERAL FLATTEN(
           input => TRY_PARSE_JSON(d.deep_link_sub1_json):legs
         ) AS leg
    WHERE leg.value:selectionId IS NOT NULL
    ORDER BY 1,2
),

driver_bets_summary as (
    select
      user_id,
      event_time,
      event_type,
      event_id,
      deeplink_url,
      count(distinct selection_id) as legs_url,
      af_siteid,
      af_prt,
      af_channel,
      campaign,
      min(selection_id) as min_selection_id_url,
      max(selection_id) as max_selection_id_url
    from driver_bets
    group by all
),

trading_market_joins as (
    select
      account_id,
      wager_id,
      b.event_type,
      count(distinct leg_id) as legs_trading,
      legs_url,
      event_time,
      deeplink_url,
      b.af_siteid,
      b.af_prt,
      b.af_channel,
      b.campaign
    from fbg_analytics_engineering.trading.trading_sportsbook_mart a
    inner join driver_bets_summary b
      on a.account_id = b.user_id
     and b.event_time <= a.wager_placed_time_utc
     and a.selection_id between min_selection_id_url and max_selection_id_url
    where a.wager_channel = 'INTERNET'
      and a.wager_status = 'SETTLED'
      and a.is_pointsbet_wager = false
    group by all
    having legs_trading = legs_url
),

summary_table as (
    select distinct a.*
    from trading_market_joins a
    inner join fbg_analytics_engineering.trading.trading_sportsbook_mart b
      on a.account_id = b.account_id
     and a.wager_id = b.wager_id
),

kax_tracker as (
      select
        a.account_id,
        a.af_siteid,
        a.af_prt,
        a.af_channel,
        a.campaign,
        date(a.event_time) as click_time_utc,
        a.event_type,
        b.wager_placed_time_est,
        b.wager_bet_type,
        b.wager_id,
        b.number_of_lines_by_wager,
        b.leg_id,
        b.is_free_bet_wager as free_bet,
        b.leg_probability,
        b.event_sport_name,
        b.event_name,
        b.leg_market,
        b.leg_result_type,
        b.total_stake_by_legs as handle_leg,
        b.total_ggr_by_legs as ggr_leg,
        b.wager_result
      from trading_market_joins a
      inner join fbg_analytics_engineering.trading.trading_sportsbook_mart b
        on a.account_id = b.account_id
       and a.wager_id = b.wager_id
      where b.wager_channel = 'INTERNET'
        and b.wager_status = 'SETTLED'
        and b.is_pointsbet_wager = false
      group by all
      order by 1,8,6
)

select * from kax_tracker
;
