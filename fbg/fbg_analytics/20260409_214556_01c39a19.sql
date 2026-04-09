-- Query ID: 01c39a19-0212-6b00-24dd-0703193ac623
-- Database: FBG_ANALYTICS
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Executed: 2026-04-09T21:45:56.542000+00:00
-- Elapsed: 87671ms
-- Environment: FBG

SELECT "Custom SQL Query"."FTUS_7_DAYS_AGO" AS "FTUS_7_DAYS_AGO",
  "Custom SQL Query"."FTUS_7_DAYS_AGO_CUMULATIVE" AS "FTUS_7_DAYS_AGO_CUMULATIVE",
  "Custom SQL Query"."FTUS_OSB_FC" AS "FTUS_OSB_FC",
  "Custom SQL Query"."FTUS_TODAY" AS "FTUS_TODAY",
  "Custom SQL Query"."FTUS_TODAY_CUMULATIVE" AS "FTUS_TODAY_CUMULATIVE",
  "Custom SQL Query"."FTU_HOUR_ALK" AS "FTU_HOUR_ALK"
FROM (
  WITH ftu_stg AS (
      SELECT
          a.acco_id,
          CASE 
              WHEN a.game_id IS NULL THEN 'sbk' 
              ELSE 'casino' 
          END AS product,
          DATE_TRUNC(
              'hour',
              CONVERT_TIMEZONE('UTC', 'America/Anchorage', a.trans_date)
          ) AS ftu_date
      FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS AS a
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
          ON a.acco_id = acc.id
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j
          ON acc.current_jurisdictions_id = j.id
      WHERE a.trans IN ('STAKE', 'FREE_SPIN_STAKE', 'FREEBET_STAKE')
        AND acc.test = 0
      QUALIFY ROW_NUMBER() OVER (
          PARTITION BY a.acco_id 
          ORDER BY a.trans_date ASC
      ) = 1
  ),
  
  ftu AS (
      SELECT
          ftu_date AS ftu_time_alk,
          COUNT(DISTINCT CASE WHEN product = 'sbk' THEN acco_id END)    AS SBK_FTUs,
          COUNT(DISTINCT CASE WHEN product = 'casino' THEN acco_id END) AS Casino_FTUs,
          COUNT(*) AS Total_FTUs
      FROM ftu_stg
      GROUP BY ALL
      ORDER BY 1 DESC
  ),
  
  ak_today AS (
      SELECT 
          DATE(CONVERT_TIMEZONE('UTC', 'America/Anchorage', SYSDATE())) AS d
  ),
  
  hours AS (
      SELECT SEQ4()::INT AS h
      FROM TABLE(GENERATOR(ROWCOUNT => 24))
  ),
  
  today AS (
      SELECT
          ftu_time_alk AS hour_ak,
          SBK_FTUs     AS ftus_today
      FROM ftu
      WHERE hour_ak::DATE = CURRENT_DATE
  ),
  
  last_week AS (
      SELECT
          ftu_time_alk AS hour_ak,
          SBK_FTUs     AS ftus_7_days_ago
      FROM ftu
      WHERE hour_ak::DATE = DATEADD(day, -7, CURRENT_DATE)
  ),
  
  base AS (
      SELECT
          DATEADD(hour, hours.h, ak_today.d)::TIMESTAMP_NTZ AS ftu_hour_alk,  -- each hour today (AK)
          COALESCE(t.ftus_today, 0)       AS ftus_today,
          COALESCE(lw.ftus_7_days_ago, 0) AS ftus_7_days_ago
      FROM ak_today
      JOIN hours ON 1 = 1
      LEFT JOIN today t
          ON t.hour_ak = DATEADD(hour, hours.h, ak_today.d)
      LEFT JOIN last_week lw
          ON lw.hour_ak = DATEADD(day, -7, DATEADD(hour, hours.h, ak_today.d))
  )
  
  SELECT
      ftu_hour_alk,
      b.osb_ftus::INT AS ftus_osb_fc,
      ftus_today,
      ftus_7_days_ago,
      SUM(ftus_today) 
          OVER (ORDER BY ftu_hour_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ftus_today_cumulative,
      SUM(ftus_7_days_ago) 
          OVER (ORDER BY ftu_hour_alk ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ftus_7_days_ago_cumulative
  FROM base a
  LEFT JOIN FBG_STITCH.GS_FBG_DAILY_FORECASTING.FBG_DAILY_FORECAST b 
      ON a.ftu_hour_alk::DATE = b.date::DATE
  ORDER BY ftu_hour_alk
) "Custom SQL Query"
