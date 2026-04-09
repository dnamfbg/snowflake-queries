-- Query ID: 01c39a38-0212-644a-24dd-07031941d523
-- Database: FBG_SOURCE
-- Schema: PUBLIC
-- Warehouse: TABLEAU_INTRADAY_EXEC_SUMMARY_L_WH
-- Executed: 2026-04-09T22:16:21.311000+00:00
-- Elapsed: 10453ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."DATE" AS "DATE",
  "Custom SQL Query"."KYC_ACCOUNT_ID" AS "KYC_ACCOUNT_ID"
FROM (
  WITH KYC_DATE AS
  (
    SELECT
        a.account_id AS acco_id
      , b.email AS email
      , COALESCE(c.jurisdiction_code, d.jurisdiction_code) AS state
      , CONVERT_TIMEZONE('UTC','America/Anchorage', MIN(created)) AS KYC_DATE
    FROM fbg_source.osb_source.kyc_check_results AS a
    INNER JOIN fbg_source.osb_source.accounts AS b
      ON a.account_id = b.id
    LEFT JOIN fbg_source.osb_source.jurisdictions AS c
      ON b.current_jurisdictions_id = c.id
    LEFT JOIN fbg_source.osb_source.jurisdictions AS d
      ON b.reg_jurisdictions_id = d.id
    LEFT JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart ac
      ON a.account_id = ac.acco_id
    WHERE b.test = 0
      AND ac.duplicate_excluded_list_flag <> 1
    GROUP BY ALL
  ),
  
  first_step AS
  (
    SELECT
        'first_step' AS funnel
      , CASE
          WHEN decision = 'VERIFIED'        THEN 'Verified'
          WHEN decision = 'DEFER'           THEN 'DocV'
          WHEN decision = 'RESUBMIT'        THEN 'Resubmit'
          WHEN decision = 'REJECTED'        THEN 'Rejected'
          WHEN decision = 'MANUAL_REVIEW'   THEN 'Watchlist Review'
          WHEN decision = 'KYC_CHECK_FAILED'THEN 'Rejected'
          ELSE 'error'
        END AS formresult
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):kyc:decision)::varchar         AS kyc_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):phoneRisk:decision)::varchar   AS phone_risk_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):deviceRisk:decision)::varchar  AS device_risk_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):globalWatchlist:decision)::varchar AS watchlist_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):documentVerification:decision)::varchar AS docv_decision
      , *
      , ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY created DESC) AS row_n
    FROM fbg_source.osb_source.kyc_check_results
    WHERE step = 1
    QUALIFY row_n = 1
  ),
  
  docv_result AS
  (
    SELECT
        'doc_v' AS funnel
      , CASE
          WHEN decision = 'VERIFIED'        THEN 'Verified'
          WHEN decision = 'RESUBMIT'        THEN 'Resubmit'
          WHEN decision = 'REJECTED'        THEN 'Rejected'
          WHEN decision = 'MANUAL_REVIEW'   THEN 'Watchlist Review'
          ELSE 'error'
        END AS docvresult
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):kyc:decision)::varchar         AS kyc_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):phoneRisk:decision)::varchar   AS phone_risk_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):deviceRisk:decision)::varchar  AS device_risk_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):globalWatchlist:decision)::varchar AS watchlist_decision
      , (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):documentVerification:decision)::varchar AS docv_decision
      , *
      , ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY created DESC) AS row_n
    FROM fbg_source.osb_source.kyc_check_results
    WHERE step = 3
    QUALIFY row_n = 1
  ),
  
  cs_manual AS
  (
    SELECT DISTINCT a.id AS acco_id
    FROM fbg_source.osb_source.accounts AS a
    LEFT JOIN (
        SELECT DISTINCT account_id
        FROM fbg_source.osb_source.kyc_check_results
        WHERE decision = 'VERIFIED'
    ) AS b
      ON a.id = b.account_id
    WHERE a.status = 'ACTIVE'
      AND a.test = 0
      AND b.account_id IS NULL
  ),
  
  kyc_final AS
  (
    SELECT
        a.acco_id
      , a.email
      , a.state
      , a.kyc_date
      , b.formresult AS kycformresult
      , b.kyc_decision               AS first_decision_kyc
      , b.phone_risk_decision        AS first_decision_phone_risk
      , b.device_risk_decision       AS first_decision_device_risk
      , b.watchlist_decision         AS first_decision_watchlist
      , c.docvresult                 AS docv_result
      , c.docv_decision
      , CASE WHEN d.acco_id IS NOT NULL THEN 1 ELSE 0 END AS cs_manual
      , b.extra_details              AS first_extra_details
      , c.extra_details              AS doc_v_extra_details
    FROM kyc_date AS a
    LEFT JOIN first_step  AS b ON a.acco_id = b.account_id
    LEFT JOIN docv_result AS c ON a.acco_id = c.account_id
    LEFT JOIN cs_manual   AS d ON a.acco_id = d.acco_id
  )
  
  SELECT
      KYC_DATE AS Date,
      CASE WHEN kycformresult = 'Verified'
             OR docv_result = 'Verified'
             OR cs_manual = 1
           THEN acco_id END AS KYC_Account_ID,
      acco_id AS Account_ID
  FROM kyc_final
  -- Evaluate the cutoff in Alaska local time as well:
  WHERE KYC_DATE >= DATEADD(
            day,
            -2,
            CONVERT_TIMEZONE('UTC','America/Anchorage', CURRENT_TIMESTAMP())
        )
) "Custom SQL Query"
