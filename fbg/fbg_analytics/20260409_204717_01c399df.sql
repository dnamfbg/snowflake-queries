-- Query ID: 01c399df-0212-6dbe-24dd-0703192ce2a3
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T20:47:17.576000+00:00
-- Elapsed: 6575ms
-- Environment: FBG

SELECT "Custom SQL Query"."VIP_HOST" AS "VIP_HOST"
FROM (
  select
          a.acco_id,
          convert_timezone('UTC', 'America/New_York', a.time_awarded) as datetime_et,
          a.prize_pool_id,
          b.description as f2p_prize_desc,
          b.casino_segment as f2p_segment,
          d.casino_value,
          a.jurisdiction_code as state,
          c.vip_host,
          count(a.acco_id) over (partition by b.prize_descriptor_id order by a.time_awarded) as f2p_prize_desc_count_won
      from fbg_source.osb_source.f2p_game_session_results a
      inner join fbg_source.osb_source.f2p_prize_pool b on a.prize_pool_id = b.id
      inner join fbg_analytics_engineering.customers.customer_mart c on a.acco_id = c.acco_id
      left join fbg_analytics.casino.casino_segments_historical d on a.acco_id = d.acco_id and date(convert_timezone('UTC', 'America/Anchorage', a.time_awarded)) = d.date
      where c.is_test_account = 0
      and b.prize_descriptor_id between 25 and 48
) "Custom SQL Query"
GROUP BY 1
ORDER BY 1 ASC NULLS FIRST
