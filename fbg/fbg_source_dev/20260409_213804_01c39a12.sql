-- Query ID: 01c39a12-0212-67a9-24dd-07031938c7f3
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:38:04.048000+00:00
-- Elapsed: 12553ms
-- Environment: FBG

SELECT ( "SUBQUERY_0"."SEND_DATE" ) AS "SUBQUERY_1_COL_0" , ( "SUBQUERY_0"."PLATFORM_NUM_BETS_30D" ) AS "SUBQUERY_1_COL_1" , ( "SUBQUERY_0"."PLATFORM_HANDLE_30D" ) AS "SUBQUERY_1_COL_2" FROM ( SELECT * FROM ( ( WITH campaign_sends AS (
    SELECT DISTINCT DATE(TO_TIMESTAMP(c.timestamp)) AS send_date
    FROM FBG_SOURCE.XTREMEPUSH.CAMPAIGNS c
    WHERE c.interaction_type = 'sent'
      AND c.campaign_name IN (
          '10.18.24-SURV1-REC-SBK-EMA',
          '10.18.24-SURV2-REC-SBK-EMA',
          '10.18.24-SURV3-REC-SBK-EMA'
      )
      AND DATE(TO_TIMESTAMP(c.timestamp)) BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
),

platform_daily AS (
    SELECT
        bus_date,
        SUM(COALESCE(bet_count, 0)) AS platform_num_bets_daily,
        SUM(COALESCE(total_handle, 0)) AS platform_handle_daily
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACCOUNT_REVENUE_SUMMARY_DAILY
    GROUP BY 1
),

platform_activity_30d AS (
    SELECT
        sd.send_date,
        COALESCE(SUM(pd.platform_num_bets_daily), 0) AS platform_num_bets_30d,
        COALESCE(SUM(pd.platform_handle_daily), 0) AS platform_handle_30d
    FROM campaign_sends sd
    LEFT JOIN platform_daily pd
        ON pd.bus_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
    GROUP BY 1
)
SELECT *
FROM platform_activity_30d
ORDER BY send_date ) ) AS "SF_CONNECTOR_QUERY_ALIAS" ) AS "SUBQUERY_0"
