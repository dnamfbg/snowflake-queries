-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e4943
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:01:51.107000+00:00
-- Elapsed: 42582ms
-- Environment: FBG

SELECT "Custom SQL Query"."COUNT" AS "COUNT",
  "Custom SQL Query"."DAY" AS "DAY",
  "Custom SQL Query"."REGISTRATION_STATE" AS "REGISTRATION_STATE",
  "Custom SQL Query"."TYPE" AS "TYPE"
FROM (
  WITH KYC_DATE AS (
      SELECT
          a.account_id AS acco_id,
          b.email AS email,
          COALESCE(c.jurisdiction_code, d.jurisdiction_code) AS state,
          CONVERT_TIMEZONE('UTC', 'America/New_York', MAX(created)) AS kyc_date,
          ac.registration_state
      FROM fbg_source.osb_source.kyc_check_results AS a
      INNER JOIN fbg_source.osb_source.accounts AS b
          ON a.account_id = b.id
      LEFT JOIN fbg_source.osb_source.jurisdictions AS c
          ON b.current_jurisdictions_id = c.id
      LEFT JOIN fbg_source.osb_source.jurisdictions AS d
          ON b.reg_jurisdictions_id = d.id
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart ac
          ON a.account_id = ac.acco_id
      WHERE b.test = 0 
          --AND ac.is_pb_user = 0 
          AND ac.duplicate_excluded_list_flag != 1
      GROUP BY a.account_id, b.email, c.jurisdiction_code, d.jurisdiction_code, ac.registration_state
  ),
  
  first_step AS (
      SELECT
          'first_step' AS funnel,
          CASE 
              WHEN decision = 'VERIFIED' THEN 'Verified'
              WHEN decision = 'DEFER' THEN 'DocV'
              WHEN decision = 'RESUBMIT' THEN 'Resubmit'
              WHEN decision = 'REJECTED' THEN 'Rejected'
              WHEN decision = 'MANUAL_REVIEW' THEN 'Watchlist Review'
              WHEN decision = 'KYC_CHECK_FAILED' THEN 'Rejected'
              ELSE 'error'
          END AS formresult,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):kyc:decision)::VARCHAR AS kyc_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):phoneRisk:decision)::VARCHAR AS phone_risk_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):deviceRisk:decision)::VARCHAR AS device_risk_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):globalWatchlist:decision)::VARCHAR AS watchlist_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):documentVerification:decision)::VARCHAR AS docv_decision,
          *,
          ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY created DESC) AS row_n
      FROM fbg_source.osb_source.kyc_check_results
      WHERE step = 1
      QUALIFY row_n = 1
  ),
  
  docv_result AS (
      SELECT
          'doc_v' AS funnel,
          CASE 
              WHEN decision = 'VERIFIED' THEN 'Verified'
              WHEN decision = 'RESUBMIT' THEN 'Resubmit'
              WHEN decision = 'REJECTED' THEN 'Rejected'
              WHEN decision = 'MANUAL_REVIEW' THEN 'Watchlist Review'
              ELSE 'error'
          END AS docvresult,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):kyc:decision)::VARCHAR AS kyc_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):phoneRisk:decision)::VARCHAR AS phone_risk_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):deviceRisk:decision)::VARCHAR AS device_risk_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):globalWatchlist:decision)::VARCHAR AS watchlist_decision,
          (PARSE_JSON(REPLACE(extra_details, ' None', 'null')):documentVerification:decision)::VARCHAR AS docv_decision,
          *,
          ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY created DESC) AS row_n
      FROM fbg_source.osb_source.kyc_check_results
      WHERE step = 3
      QUALIFY row_n = 1
  ),
  
  cs_manual AS (
      SELECT DISTINCT a.id AS acco_id
      FROM fbg_source.osb_source.accounts AS a
      LEFT JOIN (SELECT DISTINCT account_id FROM fbg_source.osb_source.kyc_check_results WHERE decision = 'VERIFIED') AS b
          ON a.id = b.account_id
      WHERE a.status = 'ACTIVE'
          AND a.test = 0
          AND b.account_id IS NULL
  ),
  
  kyc_final AS (
      SELECT
          a.acco_id,
          a.email,
          a.state,
          a.kyc_date,
          a.registration_state,
          b.formresult AS kycformresult,
          b.kyc_decision AS first_decision_kyc,
          b.phone_risk_decision AS first_decision_phone_risk,
          b.device_risk_decision AS first_decision_device_risk,
          b.watchlist_decision AS first_decision_watchlist,
          c.docvresult AS docv_result,
          c.docv_decision,
          CASE WHEN d.acco_id IS NOT NULL THEN 1 ELSE 0 END AS cs_manual,
          b.extra_details AS first_extra_details,
          c.extra_details AS doc_v_extra_details
      FROM KYC_DATE AS a
      LEFT JOIN first_step AS b
          ON a.acco_id = b.account_id
      LEFT JOIN docv_result AS c
          ON a.acco_id = c.account_id
      LEFT JOIN cs_manual AS d
          ON a.acco_id = d.acco_id
  )
  
  -- Final Query: Aggregating Data by Date and Type
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'firsttimeverified' AS type,
      COUNT_IF(kycformresult = 'Verified') AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'initialresultdocvcsmanual' AS type,
      COUNT_IF(kycformresult = 'DocV' AND docv_result != 'Verified' AND cs_manual = 1) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'initialresultdocvverified' AS type,
      COUNT_IF(kycformresult = 'DocV' AND docv_result = 'Verified') AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'csmanual' AS type,
      COUNT_IF(kycformresult NOT IN ('DocV', 'Verified') AND cs_manual = 1) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'docvabandons' AS type,
      COUNT_IF(kycformresult = 'DocV' AND DocV_Result IS NULL) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'docvresubmits' AS type,
      COUNT_IF(kycformresult = 'DocV' AND DocV_Result = 'Resubmit' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'initialresultresubmits' AS type,
      COUNT_IF(kycformresult = 'Resubmit' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'docvrejects' AS type,
      COUNT_IF(kycformresult = 'DocV' AND DocV_Result = 'Rejected' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'initialresultsrejects' AS type,
      COUNT_IF(kycformresult = 'Rejected' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'initialresultswatchlist' AS type,
      COUNT_IF(kycformresult = 'Watchlist Review' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  UNION ALL
  SELECT 
      DATE_TRUNC('day', TO_DATE(kyc_date)) AS day,
      'error' AS type,
      COUNT_IF(kycformresult = 'DocV' AND DocV_Result = 'error' AND cs_manual = 0) AS count,
      registration_state
  FROM kyc_final
  GROUP BY day, registration_state
  ORDER BY day DESC
) "Custom SQL Query"
