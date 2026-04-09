-- Query ID: 01c399fa-0212-644a-24dd-07031933610f
-- Database: FBG_SOURCE_DEV
-- Schema: OSB_SOURCE
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:14:46.745000+00:00
-- Elapsed: 891628ms
-- Environment: FBG

SELECT ( "SUBQUERY_0"."ACCO_ID" ) AS "SUBQUERY_1_COL_0" , ( "SUBQUERY_0"."SEND_DATE" ) AS "SUBQUERY_1_COL_1" , ( "SUBQUERY_0"."TARGET_SEGMENT" ) AS "SUBQUERY_1_COL_2" , ( "SUBQUERY_0"."SURVEY_SEGMENT" ) AS "SUBQUERY_1_COL_3" , ( "SUBQUERY_0"."CAMPAIGN_NAME" ) AS "SUBQUERY_1_COL_4" , ( "SUBQUERY_0"."SENT_FLAG" ) AS "SUBQUERY_1_COL_5" , ( "SUBQUERY_0"."DAYS_SINCE_REGISTRATION" ) AS "SUBQUERY_1_COL_6" , ( "SUBQUERY_0"."DAYS_SINCE_LAST_ACTIVE" ) AS "SUBQUERY_1_COL_7" , ( "SUBQUERY_0"."NGR_30D" ) AS "SUBQUERY_1_COL_8" , ( "SUBQUERY_0"."HANDLE_30D" ) AS "SUBQUERY_1_COL_9" , ( "SUBQUERY_0"."NUM_BETS_30D" ) AS "SUBQUERY_1_COL_10" , ( "SUBQUERY_0"."ACTIVE_DAYS_30D" ) AS "SUBQUERY_1_COL_11" , ( "SUBQUERY_0"."APD_30D" ) AS "SUBQUERY_1_COL_12" , ( "SUBQUERY_0"."ACTIVE_DAYS_7D" ) AS "SUBQUERY_1_COL_13" , ( "SUBQUERY_0"."BETS_7D" ) AS "SUBQUERY_1_COL_14" , ( "SUBQUERY_0"."ACTIVE_DAYS_60D" ) AS "SUBQUERY_1_COL_15" , ( "SUBQUERY_0"."HAS_EVER_CASH_BET" ) AS "SUBQUERY_1_COL_16" , ( "SUBQUERY_0"."DAYS_SINCE_FIRST_CASH_BET" ) AS "SUBQUERY_1_COL_17" , ( "SUBQUERY_0"."HAD_SURVEY_IN_61D" ) AS "SUBQUERY_1_COL_18" , ( "SUBQUERY_0"."NUM_BETS_WON_30D" ) AS "SUBQUERY_1_COL_19" , ( "SUBQUERY_0"."NUM_BETS_LOST_30D" ) AS "SUBQUERY_1_COL_20" , ( "SUBQUERY_0"."DOLLARS_WON_30D" ) AS "SUBQUERY_1_COL_21" , ( "SUBQUERY_0"."DOLLARS_LOST_30D" ) AS "SUBQUERY_1_COL_22" , ( "SUBQUERY_0"."SPORT_BET_COUNTS_30D" ) AS "SUBQUERY_1_COL_23" , ( "SUBQUERY_0"."LOYALTY_TIER" ) AS "SUBQUERY_1_COL_24" , ( "SUBQUERY_0"."EXP_GENEROSITY_COST_30D" ) AS "SUBQUERY_1_COL_25" , ( "SUBQUERY_0"."RESPONDED" ) AS "SUBQUERY_1_COL_26" , ( "SUBQUERY_0"."RESPONSE_DATE" ) AS "SUBQUERY_1_COL_27" , ( "SUBQUERY_0"."RESPONSE_SEGMENT" ) AS "SUBQUERY_1_COL_28" , ( "SUBQUERY_0"."DAYS_TO_RESPOND" ) AS "SUBQUERY_1_COL_29" FROM ( SELECT * FROM ( ( WITH campaign_sends AS (
    SELECT
        p.customer_id AS acco_id,
        c.campaign_name,
        DATE(TO_TIMESTAMP(c.timestamp)) AS send_date,
        CASE c.campaign_name
            WHEN '10.18.24-SURV1-REC-SBK-EMA' THEN 'New'
            WHEN '10.18.24-SURV2-REC-SBK-EMA' THEN 'Active'
            WHEN '10.18.24-SURV3-REC-SBK-EMA' THEN 'Lapsed'
        END AS survey_segment
    FROM FBG_SOURCE.XTREMEPUSH.CAMPAIGNS c
    JOIN FBG_SOURCE.XTREMEPUSH.PROFILES p
        ON c.user_id = p.user_id
    WHERE p.customer_id IS NOT NULL
        AND c.interaction_type = 'sent'
        AND c.campaign_name IN (
            '10.18.24-SURV1-REC-SBK-EMA',
            '10.18.24-SURV2-REC-SBK-EMA',
            '10.18.24-SURV3-REC-SBK-EMA'
        )
        AND DATE(TO_TIMESTAMP(c.timestamp)) BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
),

sent_accounts AS (
    SELECT DISTINCT acco_id, send_date, campaign_name, survey_segment
    FROM campaign_sends
),

send_dates AS (
    SELECT DISTINCT send_date
    FROM campaign_sends
),

date_bounds AS (
    SELECT
        MIN(send_date) AS min_send_date,
        MAX(send_date) AS max_send_date
    FROM send_dates
),

account_revenue_daily_deduped AS (
    SELECT
        r.acco_id,
        r.bus_date,
        MAX(COALESCE(r.is_active_day, 0)) AS is_active_day,
        SUM(COALESCE(r.bet_count, 0)) AS bet_count,
        SUM(COALESCE(r.sportsbook_ngr, 0)) AS sportsbook_ngr,
        SUM(COALESCE(r.total_handle, 0)) AS total_handle,
        SUM(COALESCE(r.cash_handle, 0)) AS cash_handle
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACCOUNT_REVENUE_SUMMARY_DAILY r
    WHERE r.bus_date BETWEEN (SELECT DATEADD('day', -60, min_send_date) FROM date_bounds)
                         AND (SELECT max_send_date FROM date_bounds)
    GROUP BY 1, 2
),

eligible_accounts AS (
    SELECT DISTINCT acco_id
    FROM account_revenue_daily_deduped
    UNION
    SELECT DISTINCT acco_id
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQUISITION_CUSTOMER_MART
    WHERE registration_date_est <= (SELECT max_send_date FROM date_bounds)
),

first_cash_bet AS (
    SELECT
        acco_id,
        MIN(bus_date) AS first_cash_bet_date
    FROM account_revenue_daily_deduped
    WHERE cash_handle > 0
    GROUP BY 1
),

account_send_spine AS (
    SELECT
        sd.send_date,
        ea.acco_id
    FROM send_dates sd
    CROSS JOIN eligible_accounts ea
),

prior_survey_flags AS (
    SELECT
        sd.send_date,
        ps.acco_id,
        1 AS had_survey_in_61d
    FROM send_dates sd
    INNER JOIN sent_accounts ps
        ON ps.send_date BETWEEN DATEADD('day', -61, sd.send_date) AND DATEADD('day', -1, sd.send_date)
    GROUP BY 1, 2
),

account_revenue_features AS (
    SELECT
        sd.send_date,
        r.acco_id,
        MAX(CASE WHEN r.is_active_day = 1 THEN r.bus_date END) AS last_active_bus_date,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -7, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.is_active_day ELSE 0 END), 0) AS active_days_7d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -7, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.bet_count ELSE 0 END), 0) AS bets_7d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.sportsbook_ngr ELSE 0 END), 0) AS ngr_30d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.total_handle ELSE 0 END), 0) AS handle_30d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.bet_count ELSE 0 END), 0) AS num_bets_30d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.is_active_day ELSE 0 END), 0) AS active_days_30d,
        COALESCE(SUM(CASE
            WHEN r.bus_date BETWEEN DATEADD('day', -60, sd.send_date) AND DATEADD('day', -1, sd.send_date)
            THEN r.is_active_day ELSE 0 END), 0) AS active_days_60d
    FROM send_dates sd
    INNER JOIN account_revenue_daily_deduped r
        ON r.bus_date BETWEEN DATEADD('day', -60, sd.send_date) AND DATEADD('day', -1, sd.send_date)
    GROUP BY 1, 2
),

account_features AS (
    SELECT
        spine.send_date,
        spine.acco_id,
        DATEDIFF('day', a.registration_date_est, spine.send_date) AS days_since_registration,
        DATEDIFF('day', arf.last_active_bus_date, spine.send_date) AS days_since_last_active,
        COALESCE(arf.active_days_7d, 0) AS active_days_7d,
        COALESCE(arf.bets_7d, 0) AS bets_7d,
        COALESCE(arf.ngr_30d, 0) AS ngr_30d,
        COALESCE(arf.handle_30d, 0) AS handle_30d,
        COALESCE(arf.num_bets_30d, 0) AS num_bets_30d,
        COALESCE(arf.active_days_30d, 0) AS active_days_30d,
        COALESCE(arf.active_days_60d, 0) AS active_days_60d,
        CASE WHEN fcb.first_cash_bet_date IS NOT NULL AND fcb.first_cash_bet_date < spine.send_date THEN 1 ELSE 0 END AS has_ever_cash_bet,
        DATEDIFF('day', fcb.first_cash_bet_date, spine.send_date) AS days_since_first_cash_bet,
        COALESCE(psf.had_survey_in_61d, 0) AS had_survey_in_61d
    FROM account_send_spine spine
    LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQUISITION_CUSTOMER_MART a
        ON spine.acco_id = a.acco_id
    LEFT JOIN account_revenue_features arf
        ON spine.send_date = arf.send_date
       AND spine.acco_id = arf.acco_id
    LEFT JOIN first_cash_bet fcb
        ON spine.acco_id = fcb.acco_id
    LEFT JOIN prior_survey_flags psf
        ON spine.send_date = psf.send_date
       AND spine.acco_id = psf.acco_id
),

account_segmented AS (
    SELECT
        af.*,
        CASE WHEN af.active_days_30d > 0 THEN af.handle_30d / af.active_days_30d ELSE 0 END AS apd_30d,
        CASE
            WHEN af.days_since_registration = 6
                 AND af.has_ever_cash_bet = 1
                THEN 'New'
            WHEN af.days_since_registration > 30
                 AND af.active_days_7d >= 2
                 AND af.has_ever_cash_bet = 1
                THEN 'Active'
            WHEN af.days_since_last_active BETWEEN 29 AND 37
                 AND af.has_ever_cash_bet = 1
                THEN 'Lapsed'
            ELSE 'Other'
        END AS target_segment
    FROM account_features af
),

wager_deduped AS (
    SELECT
        account_id,
        wager_id,
        wager_result,
        leg_sport_category,
        total_cash_stake_by_wager,
        total_payout_by_wager,
        DATE(wager_settlement_time_est) AS settlement_date
    FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART
    WHERE wager_result IN ('WIN', 'LOSS', 'PUSH', 'CASHOUT')
      AND DATE(wager_settlement_time_est)
          BETWEEN (SELECT DATEADD('day', -30, min_send_date) FROM date_bounds)
              AND (SELECT DATEADD('day', -1, max_send_date) FROM date_bounds)
    QUALIFY ROW_NUMBER() OVER (PARTITION BY wager_id ORDER BY wager_settlement_time_est) = 1
),

betting_wager_stats AS (
    SELECT
        w.account_id AS acco_id,
        sd.send_date,
        COUNT(CASE WHEN w.wager_result = 'WIN' THEN 1 END) AS num_bets_won_30d,
        COUNT(CASE WHEN w.wager_result = 'LOSS' THEN 1 END) AS num_bets_lost_30d,
        COALESCE(SUM(CASE WHEN w.wager_result = 'WIN' THEN w.total_payout_by_wager END), 0) AS dollars_won_30d,
        COALESCE(SUM(CASE WHEN w.wager_result = 'LOSS' THEN w.total_cash_stake_by_wager END), 0) AS dollars_lost_30d
    FROM send_dates sd
    INNER JOIN wager_deduped w
        ON w.settlement_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
    WHERE w.wager_result IN ('WIN', 'LOSS')
    GROUP BY w.account_id, sd.send_date
),

sport_bet_counts AS (
    SELECT
        acco_id,
        send_date,
        OBJECT_AGG(leg_sport_category, total_bet_cnt::VARIANT) AS sport_bet_counts_30d
    FROM (
        SELECT
            w.account_id AS acco_id,
            sd.send_date,
            w.leg_sport_category,
            COUNT(DISTINCT w.wager_id) AS total_bet_cnt
        FROM send_dates sd
        INNER JOIN wager_deduped w
            ON w.settlement_date BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
        GROUP BY w.account_id, sd.send_date, w.leg_sport_category
    )
    GROUP BY acco_id, send_date
),

generosity_stats AS (
    SELECT
        g.acco_id,
        sd.send_date,
        SUM(g.exp_generosity_cost) AS exp_generosity_cost_30d
    FROM send_dates sd
    INNER JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.OSB_GENEROSITY_COST g
        ON DATE(g.wager_settlement_time_alk) BETWEEN DATEADD('day', -30, sd.send_date) AND DATEADD('day', -1, sd.send_date)
    WHERE DATE(g.wager_settlement_time_alk)
        BETWEEN (SELECT DATEADD('day', -30, min_send_date) FROM date_bounds)
            AND (SELECT DATEADD('day', -1, max_send_date) FROM date_bounds)
    GROUP BY g.acco_id, sd.send_date
),

enriched AS (
    SELECT
        aseg.acco_id,
        aseg.send_date,
        aseg.target_segment,
        sa.survey_segment,
        sa.campaign_name,
        CASE WHEN sa.acco_id IS NOT NULL THEN 1 ELSE 0 END AS sent_flag,
        aseg.days_since_registration,
        aseg.days_since_last_active,
        aseg.ngr_30d,
        aseg.handle_30d,
        aseg.num_bets_30d,
        aseg.active_days_30d,
        aseg.apd_30d,
        aseg.active_days_7d,
        aseg.bets_7d,
        aseg.active_days_60d,
        aseg.has_ever_cash_bet,
        aseg.days_since_first_cash_bet,
        aseg.had_survey_in_61d,
        COALESCE(bws.num_bets_won_30d, 0) AS num_bets_won_30d,
        COALESCE(bws.num_bets_lost_30d, 0) AS num_bets_lost_30d,
        COALESCE(bws.dollars_won_30d, 0) AS dollars_won_30d,
        COALESCE(bws.dollars_lost_30d, 0) AS dollars_lost_30d,
        sbc.sport_bet_counts_30d,
        loy.loyalty_tier,
        COALESCE(gs.exp_generosity_cost_30d, 0) AS exp_generosity_cost_30d
    FROM account_segmented aseg
    LEFT JOIN sent_accounts sa
        ON aseg.acco_id = sa.acco_id
       AND aseg.send_date = sa.send_date
    LEFT JOIN betting_wager_stats bws
        ON aseg.acco_id = bws.acco_id
       AND aseg.send_date = bws.send_date
    LEFT JOIN sport_bet_counts sbc
        ON aseg.acco_id = sbc.acco_id
       AND aseg.send_date = sbc.send_date
    LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.F1_ATTRIBUTES_AUDITS loy
        ON aseg.acco_id = loy.acco_id
       AND loy.as_of_date = aseg.send_date
    LEFT JOIN generosity_stats gs
        ON aseg.acco_id = gs.acco_id
       AND aseg.send_date = gs.send_date
    WHERE aseg.target_segment IN ('New', 'Active', 'Lapsed')
),

survey_responses AS (
    SELECT TRY_CAST(ID AS NUMBER) AS acco_id,
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE AS response_date,
        'New' AS response_segment
    FROM FBG_ANALYTICS.JLG.SURVEY_NEW_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
    UNION ALL
    SELECT TRY_CAST(ID AS NUMBER),
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE,
        'Active'
    FROM FBG_ANALYTICS.JLG.SURVEY_ACTIVE_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
    UNION ALL
    SELECT TRY_CAST(ID AS NUMBER),
        COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE,
        'Lapsed'
    FROM FBG_ANALYTICS.JLG.SURVEY_LAPSED_FEB_2026_RAW
    WHERE TRY_CAST(ID AS NUMBER) IS NOT NULL
      AND STATUS = 'Complete'
      AND COALESCE(
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MM/DD/YY HH24:MI'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'YYYY-MM-DD HH24:MI:SS'),
            TRY_TO_TIMESTAMP(DATE_SUBMITTED, 'MON DD, YYYY HH12:MI:SS AM'),
            TRY_CAST(DATE_SUBMITTED AS TIMESTAMP)
        )::DATE BETWEEN TO_DATE('2025-05-01') AND TO_DATE('2026-04-06')
),

responses_matched AS (
    SELECT
        r.acco_id,
        r.response_date,
        r.response_segment,
        s.send_date AS matched_send_date,
        ROW_NUMBER() OVER (
            PARTITION BY r.acco_id, r.response_date, r.response_segment
            ORDER BY s.send_date DESC
        ) AS rn
    FROM survey_responses r
    LEFT JOIN sent_accounts s
        ON r.acco_id = s.acco_id
       AND r.response_segment = s.survey_segment
       AND s.send_date <= r.response_date
),

responses_final AS (
    SELECT acco_id, response_date, response_segment, matched_send_date
    FROM responses_matched
    WHERE rn = 1
)

SELECT
    e.*,
    CASE WHEN rm.acco_id IS NOT NULL THEN 1 ELSE 0 END AS responded,
    rm.response_date,
    rm.response_segment,
    DATEDIFF('day', rm.matched_send_date, rm.response_date) AS days_to_respond
FROM enriched e
LEFT JOIN responses_final rm
    ON e.acco_id = rm.acco_id
   AND e.send_date = rm.matched_send_date
   AND e.survey_segment = rm.response_segment ) ) AS "SF_CONNECTOR_QUERY_ALIAS" ) AS "SUBQUERY_0"
