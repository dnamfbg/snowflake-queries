-- Query ID: 01c39a5a-0212-6e7d-24dd-070319491027
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Last Executed: 2026-04-09T22:50:55.623000+00:00
-- Elapsed: 279183ms
-- Run Count: 10
-- Environment: FBG

SELECT "Custom SQL Query"."DATA_AS_OF_ALK" AS "DATA_AS_OF_ALK",
  "Custom SQL Query"."DOW" AS "DOW",
  "Custom SQL Query"."HANDLE_CASH_OSB_FC" AS "HANDLE_CASH_OSB_FC",
  "Custom SQL Query"."HOURLY_HANDLE_CASH_OSB_FORECAST" AS "HOURLY_HANDLE_CASH_OSB_FORECAST",
  "Custom SQL Query"."HOURLY_HANDLE_FC_PERC" AS "HOURLY_HANDLE_FC_PERC",
  "Custom SQL Query"."HOUR" AS "HOUR",
  "Custom SQL Query"."PLACED_DATE_ALK" AS "PLACED_DATE_ALK",
  "Custom SQL Query"."STAKE_7_DAYS_AGO" AS "STAKE_7_DAYS_AGO",
  "Custom SQL Query"."STAKE_7_DAYS_AGO_CUMULATIVE" AS "STAKE_7_DAYS_AGO_CUMULATIVE",
  "Custom SQL Query"."STAKE_7_DAYS_AGO_SETTLED" AS "STAKE_7_DAYS_AGO_SETTLED",
  "Custom SQL Query"."STAKE_7_DAYS_AGO_SETTLED_CUMULATIVE" AS "STAKE_7_DAYS_AGO_SETTLED_CUMULATIVE",
  "Custom SQL Query"."STAKE_TODAY" AS "STAKE_TODAY",
  "Custom SQL Query"."STAKE_TODAY_CUMULATIVE" AS "STAKE_TODAY_CUMULATIVE",
  "Custom SQL Query"."STAKE_TODAY_SETTLED" AS "STAKE_TODAY_SETTLED",
  "Custom SQL Query"."STAKE_TODAY_SETTLED_CUMULATIVE" AS "STAKE_TODAY_SETTLED_CUMULATIVE",
  "Custom SQL Query"."TOTAY_FORECAST_CUMULATIVE" AS "TOTAY_FORECAST_CUMULATIVE"
FROM (
  WITH ak_today AS (
    SELECT DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE())) AS d
  ),
  
  /* ----- Extract and aggregate bonus amounts from ACCOUNT_BONUSES once ----- */
  fortuna_bets AS (
    SELECT
      TRY_TO_NUMBER(REGEXP_SUBSTR(overrides, 'betId=(\\d+)', 1, 1, 'e', 1))                                         AS bet_id,
      TRY_TO_NUMBER(REGEXP_SUBSTR(overrides, 'bonusBetAmt=(\\d+(\\.\\d+)?)', 1, 1, 'e', 1))::NUMBER(36,2)          AS bonus_bet_amount
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES
    WHERE bonus_bet_amount IS NOT NULL AND ABS(bonus_bet_amount) > 0
  ),
  
  fortuna_bets_agg AS (
    SELECT
      bet_id,
      /* Use SUM; swap to MAX if there’s at most one record per bet_id */
      SUM(bonus_bet_amount)::NUMBER(36,2) AS bonus_bet_amount
    FROM fortuna_bets
    GROUP BY 1
  ),
  
  /* ----- Enrich bets with adjusted flags and stake amounts ----- */
  bets_enriched AS (
    SELECT
      b.*,
      /* Adjusted FREE_BET flag: if fancash stake present, treat as free bet */
      CASE
        WHEN b.fancash_stake_amount > 0 AND NVL(b.free_bet, FALSE) = FALSE THEN TRUE
        ELSE NVL(b.free_bet, FALSE)
      END AS free_bet_eff,
  
      /* Adjusted TOTAL_STAKE: if fancash stake present and not originally free bet, use SFSA bonus amount */
      CASE
        WHEN b.fancash_stake_amount > 0 AND NVL(b.free_bet, FALSE) = FALSE
          THEN COALESCE(sfsa.bonus_bet_amount, 0)
        ELSE b.total_stake
      END AS total_stake_eff
    FROM FBG_SOURCE.OSB_SOURCE.BETS b
    LEFT JOIN fortuna_bets_agg sfsa
      ON b.id = sfsa.bet_id
  ),
  
  hours AS (
    SELECT SEQ4()::INT AS h
    FROM TABLE(GENERATOR(ROWCOUNT => 24))
  ),
  
  /* ----- Today (AK) ----- */
  today AS (
    SELECT
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)) AS hour_ak,
        /* Use stake only when adjusted free_bet is FALSE */
        SUM(CASE WHEN b.free_bet_eff = FALSE THEN b.total_stake_eff END)                 AS stake_today,
        MAX(CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time))                 AS data_as_of_alk
    FROM bets_enriched b
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON acc.id = b.acco_id
    WHERE
        acc.test = 0
        AND b.acco_id <> 2026159           -- exclude SVIP
        AND b.channel = 'INTERNET'
        AND b.status IN ('ACCEPTED', 'SETTLED')
        AND CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)::DATE = DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE()))
    GROUP BY 1
  ),
  /* ----- Today Settled (AK) ----- */
  today_settled AS (
    SELECT
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time)) AS hour_ak,
        /* Use stake only when adjusted free_bet is FALSE */
        SUM(CASE WHEN b.free_bet_eff = FALSE THEN b.total_stake_eff END)                 AS stake_today,
        MAX(CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time))                 AS data_as_of_alk
    FROM bets_enriched b
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON acc.id = b.acco_id
    WHERE
        acc.test = 0
        AND b.acco_id <> 2026159           -- exclude SVIP
        AND b.channel = 'INTERNET'
        AND b.status IN ('SETTLED')
        AND CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time)::DATE = DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE()))
    GROUP BY 1
  ),
  
  /* ----- Same hour windows 7 days ago (AK) ----- */
  last_week AS (
    SELECT
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)) AS hour_ak,
        SUM(CASE WHEN b.free_bet_eff = FALSE THEN b.total_stake_eff END)                 AS stake_7_days_ago
    FROM bets_enriched b
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON acc.id = b.acco_id
    WHERE
        acc.test = 0
        AND b.acco_id <> 2026159
        AND b.channel = 'INTERNET'
        AND b.status IN ('ACCEPTED', 'SETTLED')
        AND CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.placed_time)::DATE = DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE())) - 7
    GROUP BY 1
  ),
  /* ----- Same hour windows 7 days ago settled (AK) ----- */
  last_week_settled AS (
    SELECT
        DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time)) AS hour_ak,
        /* Use stake only when adjusted free_bet is FALSE */
        SUM(CASE WHEN b.free_bet_eff = FALSE THEN b.total_stake_eff END)                 AS stake_7_days_ago,
        MAX(CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time))                 AS data_as_of_alk
    FROM bets_enriched b
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON acc.id = b.acco_id
    WHERE
        acc.test = 0
        AND b.acco_id <> 2026159           -- exclude SVIP
        AND b.channel = 'INTERNET'
        AND b.status IN ('SETTLED')
        AND CONVERT_TIMEZONE('UTC', 'America/Anchorage', b.settlement_time)::DATE = DATE(CONVERT_TIMEZONE('UTC','America/Anchorage', SYSDATE())) - 7
    GROUP BY 1
  ),
  
  /* ----- Build the hourly frame for today (AK) and attach measures ----- */
  base AS (
    SELECT
      DATEADD(hour, hours.h, ak_today.d)::TIMESTAMP_NTZ AS placed_date_alk,  -- each hour today (AK)
      COALESCE(t.stake_today, 0)                        AS stake_today,
      COALESCE(ts.stake_today, 0)                       AS stake_today_settled,
      COALESCE(lw.stake_7_days_ago, 0)                  AS stake_7_days_ago,
      COALESCE(lws.stake_7_days_ago, 0)                 AS stake_7_days_ago_settled,
      hours.h                                           AS hour,
      MAX(t.data_as_of_alk)                             AS data_as_of_alk
    FROM ak_today
    JOIN hours ON 1=1
    LEFT JOIN today t
      ON t.hour_ak = DATEADD(hour, hours.h, ak_today.d)
    LEFT JOIN today_settled ts
      ON ts.hour_ak = DATEADD(hour, hours.h, ak_today.d)
    LEFT JOIN last_week lw
      ON lw.hour_ak = DATEADD(day, -7, DATEADD(hour, hours.h, ak_today.d))
    LEFT JOIN last_week_settled lws
      ON lws.hour_ak = DATEADD(day, -7, DATEADD(hour, hours.h, ak_today.d))
    GROUP BY ALL
  )
  
  /* ----- Final output ----- */
  SELECT
    placed_date_alk,
    dayofweek(placed_date_alk) AS dow,
    a.hour,
    data_as_of_alk,
    b.osb_cash_handle :: INT                                   AS handle_cash_osb_fc,
    f.hourly_handle_fc_perc,
    NVL(hourly_handle_fc_perc,0) * b.osb_cash_handle :: INT    AS hourly_handle_cash_osb_forecast,
    stake_today,
    stake_7_days_ago,
    stake_today_settled,
    stake_7_days_ago_settled,
    SUM(stake_today)      OVER (ORDER BY placed_date_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS stake_today_cumulative,
    SUM(stake_7_days_ago) OVER (ORDER BY placed_date_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS stake_7_days_ago_cumulative,
    SUM(stake_today_settled)      OVER (ORDER BY placed_date_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS stake_today_settled_cumulative,
    SUM(stake_7_days_ago_settled) OVER (ORDER BY placed_date_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS stake_7_days_ago_settled_cumulative,
    SUM(NVL(hourly_handle_fc_perc,0) * b.osb_cash_handle :: INT)
        OVER (ORDER BY placed_date_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)                    AS totay_forecast_cumulative
  FROM base a
  LEFT JOIN FBG_STITCH.GS_FBG_DAILY_FORECASTING.FBG_DAILY_FORECAST b
    ON a.placed_date_alk :: DATE = b.date :: DATE
  LEFT JOIN FBG_ANALYTICS_DEV.JORDAN_PLUCHAR.INTRADAY_FC f
    ON dayofweek(a.placed_date_alk) = f.dow AND a.hour = f.hour
  ORDER BY placed_date_alk
) "Custom SQL Query"
