-- Query ID: 01c39a56-0212-67a9-24dd-07031948110b
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Last Executed: 2026-04-09T22:46:22.282000+00:00
-- Elapsed: 120673ms
-- Run Count: 10
-- Environment: FBG

SELECT "Custom SQL Query"."BETS" AS "BETS",
  "Custom SQL Query"."BET_PROB" AS "BET_PROB",
  "Custom SQL Query"."DATE_" AS "DATE_",
  "Custom SQL Query"."DAY_NAME" AS "DAY_NAME",
  "Custom SQL Query"."EXPECTED_HANDLE_PLACED" AS "EXPECTED_HANDLE_PLACED",
  "Custom SQL Query"."EXPECTED_TW_PLACED" AS "EXPECTED_TW_PLACED",
  "Custom SQL Query"."FULL_DAILY_HANDLE_FORECAST" AS "FULL_DAILY_HANDLE_FORECAST",
  "Custom SQL Query"."FULL_DAILY_HANDLE_RUN_RATE" AS "FULL_DAILY_HANDLE_RUN_RATE",
  "Custom SQL Query"."FULL_DAILY_TW_FORECAST" AS "FULL_DAILY_TW_FORECAST",
  "Custom SQL Query"."FULL_DAILY_TW_PERC_FORECAST" AS "FULL_DAILY_TW_PERC_FORECAST",
  "Custom SQL Query"."FULL_HANDLE_ESTIMATE" AS "FULL_HANDLE_ESTIMATE",
  "Custom SQL Query"."FULL_HANDLE_ESTIMATE_VS_FC" AS "FULL_HANDLE_ESTIMATE_VS_FC",
  "Custom SQL Query"."FULL_TW_ESTIMATE" AS "FULL_TW_ESTIMATE",
  "Custom SQL Query"."FULL_TW_ESTIMATE_VS_FC" AS "FULL_TW_ESTIMATE_VS_FC",
  "Custom SQL Query"."FULL_TW_PERC_ESTIMATE" AS "FULL_TW_PERC_ESTIMATE",
  "Custom SQL Query"."FULL_TW_PERC_ESTIMATE_VS_FC" AS "FULL_TW_PERC_ESTIMATE_VS_FC",
  "Custom SQL Query"."HANDLE" AS "HANDLE",
  "Custom SQL Query"."HANDLE_TO_BE_PLACED_ESTIMATE" AS "HANDLE_TO_BE_PLACED_ESTIMATE",
  "Custom SQL Query"."ID" AS "ID",
  "Custom SQL Query"."MINS_BEFORE_END_OF_DAY_" AS "MINS_BEFORE_END_OF_DAY_",
  "Custom SQL Query"."PCT_HANDLE" AS "PCT_HANDLE",
  "Custom SQL Query"."REMAINING_HANDLE_PLACED" AS "REMAINING_HANDLE_PLACED",
  "Custom SQL Query"."REMAINING_TW_PLACED" AS "REMAINING_TW_PLACED",
  "Custom SQL Query"."SETTLED_BETS" AS "SETTLED_BETS",
  "Custom SQL Query"."SETTLED_HANDLE" AS "SETTLED_HANDLE",
  "Custom SQL Query"."SETTLED_TW" AS "SETTLED_TW",
  "Custom SQL Query"."TW_TO_BE_PLACED_ESTIMATE" AS "TW_TO_BE_PLACED_ESTIMATE",
  "Custom SQL Query"."UNSETTLED_BETS" AS "UNSETTLED_BETS",
  "Custom SQL Query"."UNSETTLED_NO_BET_PROB" AS "UNSETTLED_NO_BET_PROB"
FROM (
  WITH uplift_table AS (
  
      WITH stage_ AS (
          SELECT
              dayname(DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time))) set_day_name,
              DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) set_date_,
              CASE
                  WHEN DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) < DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) THEN 0
                  ELSE 1
              END placed_on_set_date,
              CASE
                  WHEN DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time)) = DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', bets.settlement_time)) THEN date_trunc(minute, CONVERT_TIMEZONE('UTC','America/Anchorage', bets.placed_time))
              END placed_time_on_set_date,
              SUM(total_stake / num_lines) AS cash_handle
  
          FROM
              fbg_source.osb_source.bets
          INNER JOIN
              fbg_source.osb_source.accounts
              ON bets.acco_id = accounts.id
          WHERE
              channel = 'INTERNET'
              AND DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.settlement_time)) between '2026-02-16' AND '2026-02-22'
              AND accounts.test = 0
              AND bets.status <> 'VOID'
              AND bets.free_bet = FALSE
              AND bets.fancash_stake_amount = 0
              AND bets.acco_id <> 2026159
          GROUP BY
              ALL
      ),
      stage_2 AS (
          SELECT
              *,
              MIN(CASE WHEN placed_on_set_date = 1 THEN set_date_::TIMESTAMP END) OVER (partition by set_date_) AS first_min_,
              MAX(DATEADD(minute, -1, DATEADD(day, 1, set_date_::TIMESTAMP))) OVER (partition by set_date_) AS last_minute_ts
          FROM
              stage_
      ),
      stage_3 AS (
          SELECT
              set_day_name,
              set_date_,
              DATEDIFF(minute,
                  CASE
                      WHEN placed_on_set_date = 0 THEN first_min_
                      ELSE placed_time_on_set_date
                  END,
                  last_minute_ts
              ) mins_before_end_of_day,
              SUM(cash_handle) AS cash_handle
          FROM
              stage_2
          GROUP BY
              ALL
      ),
      days AS (
          SELECT
              day_name
          FROM VALUES
              ('Sat'), ('Sun'), ('Mon'), ('Tue'),
              ('Wed'), ('Thu'), ('Fri')
              v(day_name)
      ),
      minutes AS (
          SELECT
              ROW_NUMBER() OVER (ORDER BY seq4()) AS minute_of_day
          FROM TABLE(GENERATOR(ROWCOUNT => 1440))
      ),
      day_and_minute AS (
          SELECT
              d.day_name,
              m.minute_of_day
          FROM days d
          CROSS JOIN minutes m
      ),
      joined_ AS (
          SELECT
              day_and_minute.*,
              COALESCE(cash_handle,0) AS cash_handle_
          FROM
              day_and_minute
          LEFT OUTER JOIN
              stage_3
          ON day_and_minute.day_name = stage_3.set_day_name AND day_and_minute.minute_of_day = (1440-stage_3.mins_before_end_of_day)
      ),
      cumulative_ AS (
          SELECT
              *,
              SUM(cash_handle_) OVER (
                  PARTITION by day_name
                  ORDER BY minute_of_day
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
              ) AS cum_cash_handle
          FROM
              joined_
      ),
      max_daily_handle AS (
          SELECT
              *,
              MAX(cum_cash_handle) OVER (PARTITION by day_name) AS total_daily_handle
          FROM
              cumulative_
      )
      SELECT
          day_name,
          minute_of_day,
          cum_cash_handle /  NULLIF(total_daily_handle,0) pct_handle
      FROM
          max_daily_handle
  ),
  
  placed_already AS (
  
      WITH unsettled AS
      (SELECT
          id,
          CONVERT_TIMEZONE('America/New_York', 'America/Anchorage', placed_time_et) placed_time_alk ,
          handle,
          LAST_EVENT_DATE_ALK,
          DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', CURRENT_TIMESTAMP)) as Current_Date_ALK,
          current_bet_prob,
          xTrading_Win,
          prob_settle_today,
          prob_settle_today*handle as Expected_Handle_Today,
          case when LAST_EVENT_DATE_ALK > Current_Date_ALK then Expected_Handle_Today
               else prob_settle_today*xTrading_Win
               end as Expected_TW_Today
      FROM fbg_analytics.trading.current_bet_probabilities
      WHERE is_free_bet = FALSE
      ),
      max_bet_prob AS
      (SELECT
          max(placed_time_alk) AS max_placed_time_alk
      FROM unsettled
      ),
      was_price AS (
          SELECT
              instrument_id,
              MAX(non_boosted_price) AS non_boosted_price
          FROM (
              SELECT
                  *,
                  POSITION('(was', LOWER(selection)) AS abc,
                  REPLACE(SUBSTR(selection, abc + 5, 6), ' ', '') AS american_odds,
                  SUBSTR(american_odds, 1, 1) AS neg_pos,
                  CASE
                      WHEN abc = 0 THEN '0'
                      WHEN neg_pos NOT IN ('-', '+') THEN '0'
                      ELSE REPLACE(SUBSTR(american_odds, 2, 4), ')', '')
                  END AS odds_value,
                  TO_DOUBLE(
                      CASE
                          WHEN LOWER(odds_value) LIKE '%x%' THEN '0'
                          ELSE odds_value
                      END
                  ) AS odds_value_2,
                  CASE
                      WHEN odds_value_2 = 0 THEN price
                      WHEN neg_pos = '+' THEN ((1 / 100) * odds_value) + 1
                      WHEN neg_pos = '-' THEN (1 - (100 / (odds_value * -1)))
                  END AS non_boosted_price
              FROM (
                  SELECT
                      instrument_id,
                      MAX(selection) AS selection,
                      MIN(CASE
                              WHEN original_price IS NOT NULL THEN original_price
                              ELSE price
                          END) AS price
                  FROM
                      FBG_SOURCE.OSB_SOURCE.BETS
                      INNER JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS
                          ON (BETS.ID = BET_PARTS.BET_ID)
                  WHERE
                      channel = 'INTERNET'
                      AND DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.settlement_time)) >=  DATEADD(DAY, -3, DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', current_timestamp())))
                      AND free_bet = FALSE
                      AND odds_boost_bonus = FALSE
                      AND CASE
                              WHEN comp ILIKE '%boost%' THEN 1
                              WHEN Market ILIKE '%boost%' THEN 1
                              WHEN Mrkt_Type ILIKE '%boost%' THEN 1
                              ELSE 0
                          END = 1
                  GROUP BY ALL
              )
          )
          GROUP BY ALL
      ),
      stage_ AS
      (SELECT
          bets.status,
          case when u.id is not null then 1 else 0 end as Has_Current_Prob,
          bets.id,
          num_lines,
          payout,
          parlay_type,
          bet_Type,
          result,
          data,
          odds_boost_bonus_winnings,
          odds_boost_bonus,
          non_boosted_price,
          original_price,
          price,
          total_price,
          CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.settlement_time) set_time_alk,
          CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.placed_time) placed_time_alk,
          CASE WHEN bets.fancash_stake_amount > 0 AND bets.free_bet = FALSE THEN TRUE
               ELSE bets.free_bet
               END AS free_bet,
          bets.total_Stake,
          u.LAST_EVENT_DATE_ALK,
          u.Current_Date_ALK,
          u.current_bet_prob,
          u.xTrading_Win,
          u.prob_settle_today,
          coalesce(u.Expected_Handle_Today,0) as Expected_Handle_Today,
          coalesce(u.Expected_TW_Today,0) as Expected_TW_Today
      FROM FBG_SOURCE.OSB_SOURCE.BETS
      JOIN FBG_SOURCE.OSB_SOURCE.BET_PARTS ON (BETS.ID = BET_PARTS.BET_ID)
      JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS ON (BETS.ACCO_ID = ACCOUNTS.ID)
      LEFT JOIN was_price ON (BET_PARTS.INSTRUMENT_ID = was_price.INSTRUMENT_ID)
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS ON (BETS.BONUS_CAMPAIGN_ID = BONUS_CAMPAIGNS.ID)
      LEFT JOIN unsettled u on u.id = bets.id
  
      WHERE channel = 'INTERNET'
      AND (DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.settlement_time)) = DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', current_timestamp())) OR bets.status = 'ACCEPTED')
      AND accounts.test = 0
      AND bets.status in ('ACCEPTED','SETTLED')
      and coalesce(bets.fancash_stake_amount,0) = 0
      AND bets.FREE_BET = FALSE
      AND (DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', bets.settlement_time)) <= (SELECT max_placed_time_alk FROM max_bet_prob) OR bets.status = 'ACCEPTED')
      AND (bets.status = 'SETTLED' or u.expected_handle_today > 0 or u.id is null)
      ),
      bet_Stage as
      (SELECT
          id,
          status,
          Has_Current_Prob,
          parlay_type,
          bet_Type,
          SUM(total_stake / num_lines) AS handle,
          SUM(CASE WHEN status = 'SETTLED' THEN total_stake / num_lines ELSE 0 END) AS settled_handle,
          CASE WHEN status = 'SETTLED' then (
                  SUM(
                      CASE
                          WHEN free_bet = FALSE THEN total_stake / num_lines - payout / num_lines
                          ELSE 0
                      END
                  )
                  +
                  SUM(
                      CASE
                          WHEN free_bet = FALSE
                              AND payout > 0
                              AND payout >= total_stake
                              AND CASE
                                      WHEN NVL(odds_boost_bonus_winnings, 0) > 0 THEN 1
                                      WHEN odds_boost_bonus = TRUE THEN 1
                                      ELSE 0
                                  END = 1
                              AND result <> 4
                          THEN (
                              (
                                  (payout / total_stake)
                                  - (
                                      (
                                          (PARSE_JSON(data):Bonus:oddsBoost:boostPercentage) / 100
                                          + (payout / total_stake)
                                      )
                                      /
                                      (
                                          (PARSE_JSON(data):Bonus:oddsBoost:boostPercentage) / 100 + 1
                                      )
                                  )
                              ) * total_stake
                          ) / num_lines
                          ELSE 0
                      END
                  )
                  +
                  SUM(
                      CASE
                          WHEN free_bet = FALSE
                              AND payout > 0
                              AND result <> 4
                              AND non_boosted_price IS NOT NULL
                              AND non_boosted_price < CASE
                                                          WHEN original_price IS NOT NULL THEN original_price
                                                          ELSE price
                                                      END
                              AND CASE
                                      WHEN original_price IS NULL THEN price
                                      ELSE original_price
                                  END <= price
                          THEN (
                              (
                                  CASE
                                      WHEN original_price IS NOT NULL THEN original_price
                                      ELSE price
                                  END - non_boosted_price
                              ) * (total_stake / num_lines)
                          ) * (
                              payout / (
                                  total_stake * CASE
                                      WHEN free_bet = TRUE THEN total_price - 1
                                      ELSE total_price
                                  END
                              )
                          )
                          ELSE 0
                      END
                  )
                  ) ELSE 0 END AS settled_trading_win,
          sum(Expected_Handle_Today/num_lines) as expected_handle,
          sum(Expected_TW_Today/num_lines) as expected_TW,
          case when expected_handle > 0 then expected_handle
               when status = 'ACCEPTED' and Has_Current_Prob = 0 then handle
               else 0
               end as Remaining_Handle,
  
          case when expected_handle > 0 then expected_TW
               when status = 'ACCEPTED' and Has_Current_Prob = 0 then handle*0.1
               else 0
               end as Remaining_TW,
  
          MAX(set_time_alk) AS max_set_time_alk,
          MAX(max_set_time_alk) OVER (partition by 1) AS max_settled,
          MAX(DATEADD(minute, -1, DATEADD(day, 1, date(max_set_time_alk)))) OVER (partition by 1) AS last_minute_ts
  
      FROM stage_
      GROUP BY ALL
      )
  
      SELECT
          DATE(last_minute_ts) AS date_,
          dayname(DATE(last_minute_ts)) AS day_name,
          DATEDIFF(minute, date_trunc(minute,max_settled), last_minute_ts) mins_before_end_of_day_,
          COUNT(DISTINCT id) AS Bets,
          COUNT(DISTINCT case when status = 'SETTLED' then id end) AS Settled_Bets,
          COUNT(DISTINCT case when status = 'ACCEPTED' then id end) AS Unsettled_Bets,
          COUNT(DISTINCT case when Has_Current_Prob = 1 then id end) AS Bet_Prob,
          COUNT(DISTINCT case when status = 'ACCEPTED' and Has_Current_Prob = 0 then id end) AS Unsettled_No_Bet_Prob,
          sum(settled_handle) as Settled_Handle,
          sum(settled_trading_win) as Settled_TW,
          sum(expected_handle) as expected_handle_placed,
          sum(expected_tw) as expected_TW_placed,
          sum(Remaining_Handle) as remaining_handle_placed,
          sum(Remaining_TW) as remaining_TW_placed
  
      FROM bet_Stage
      group by all
  ),
  
  latest_daily_view_of_trading_win AS (
  
      with daily_forecast AS
      (SELECT
          forecast_date,
          SUM(handle) AS handle,
          sum(trading_win) as trading_win,
          sum(trading_win)/SUM(handle) as tw_perc
      FROM fbg_analytics_dev.andrew_mcmahon.daily_forecast
      GROUP BY ALL
      )
      SELECT
          p.*,
          u.pct_handle,
          df.handle,
          (Settled_Handle + remaining_handle_placed) / NULLIF(u.pct_handle,0) as full_daily_handle_run_rate,
          df.handle as full_daily_handle_forecast,
          df.trading_win AS full_daily_tw_forecast,
          df.tw_perc AS full_daily_tw_perc_forecast,
          -- CASE WHEN pct_handle <= 0.25 THEN df.handle
          --      ELSE full_daily_handle_run_rate
          --      END as Full_handle_estimate,
          -- Full_handle_estimate - (Settled_Handle + remaining_handle_placed) as Handle_to_be_placed_estimate,
          -- Handle_to_be_placed_estimate * tw_perc AS TW_to_be_placed_estimate,
          -- Settled_TW + expected_TW_placed + TW_to_be_placed_estimate as Full_TW_estimate,   
          CASE
              WHEN u.pct_handle <= 0.25 THEN df.handle
              ELSE (p.settled_handle + p.remaining_handle_placed) / NULLIF(u.pct_handle, 0)
          END AS full_handle_estimate,
  
          (CASE
              WHEN u.pct_handle <= 0.25 THEN df.handle
              ELSE (p.settled_handle + p.remaining_handle_placed) / NULLIF(u.pct_handle, 0)
          END) - (p.settled_handle + p.remaining_handle_placed) AS handle_to_be_placed_estimate,
  
          ((CASE
              WHEN u.pct_handle <= 0.25 THEN df.handle
              ELSE (p.settled_handle + p.remaining_handle_placed) / NULLIF(u.pct_handle, 0)
          END) - (p.settled_handle + p.remaining_handle_placed)) * df.tw_perc AS tw_to_be_placed_estimate,
          p.settled_tw + p.expected_tw_placed
            + (((CASE
                  WHEN u.pct_handle <= 0.25 THEN df.handle
                  ELSE (p.settled_handle + p.remaining_handle_placed) / NULLIF(u.pct_handle, 0)
                END) - (p.settled_handle + p.remaining_handle_placed)) * df.tw_perc)
            AS full_tw_estimate,
      
          DIV0(full_tw_estimate, full_daily_handle_forecast) AS Full_TW_perc_estimate,
  
          (full_handle_estimate - full_daily_handle_forecast) / full_daily_handle_forecast AS full_handle_estimate_vs_fc,
          (Full_TW_estimate - full_daily_tw_forecast) / full_daily_tw_forecast AS full_tw_estimate_vs_fc,
          (Full_TW_perc_estimate - full_daily_tw_perc_forecast) / full_daily_tw_perc_forecast AS full_tw_perc_estimate_vs_fc
  
      FROM placed_already p
      JOIN uplift_table AS u ON (1440-p.mins_before_end_of_day_) = u.minute_of_day AND p.day_name = u.day_name
      JOIN daily_forecast AS df ON p.date_ = df.forecast_date
  )
  
  SELECT
      *,
      MD5(CONCAT_WS('-', TO_VARCHAR(date_), TO_VARCHAR(mins_before_end_of_day_))) AS id
  FROM latest_daily_view_of_trading_win
) "Custom SQL Query"
