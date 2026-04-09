-- Query ID: 01c39a29-0212-6e7d-24dd-0703193e4a13
-- Database: FBG_ANALYTICS_DEV
-- Schema: unknown
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:57.688000+00:00
-- Elapsed: 345155ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AMOUNT" AS "AMOUNT",
  "Custom SQL Query"."FIRST_DEP_DATE" AS "FIRST_DEP_DATE",
  "Custom SQL Query"."FTD_STATE" AS "FTD_STATE",
  "Custom SQL Query"."FTU_FLAG" AS "FTU_FLAG",
  "Custom SQL Query"."FTU_STATE" AS "FTU_STATE",
  "Custom SQL Query"."FTU_TIME_EST" AS "FTU_TIME_EST"
FROM (
  WITH first_deposit AS (
    SELECT
      d.acco_id,
      j.jurisdiction_name AS dep_jurisdiction_name,
      DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC','America/New_York', d.completed_at)) AS first_dep_date,
      d.amount,
      d.completed_at,
      d.id
    FROM fbg_source.osb_source.deposits d
    LEFT JOIN fbg_source.osb_source.jurisdictions j
      ON d.jurisdictions_id = j.id
    WHERE d.status = 'DEPOSIT_SUCCESS'
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY d.acco_id
      ORDER BY d.completed_at ASC, d.id ASC
    ) = 1
  ),
  
  ftu AS (
    SELECT
      a.acco_id,
      j.jurisdiction_name AS ftu_jurisdiction_name,
      CASE WHEN a.game_id IS NULL THEN 'sbk' ELSE 'casino' END AS product,
      DATE_TRUNC('hour', CONVERT_TIMEZONE('UTC','America/New_York', a.trans_date)) AS ftu_date
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS a
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS acc
      ON a.acco_id = acc.id
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.JURISDICTIONS j
      ON a.jurisdictions_id = j.id
    WHERE a.trans IN ('STAKE', 'FREE_SPIN_STAKE', 'FREEBET_STAKE')
      AND acc.test = 0
    QUALIFY ROW_NUMBER() OVER (
      PARTITION BY a.acco_id
      ORDER BY a.trans_date ASC
    ) = 1
  )
  
  SELECT
    fd.acco_id,
    fd.dep_jurisdiction_name AS ftd_state,
    fd.first_dep_date,
    fd.amount,
    CASE
      WHEN ftu.acco_id IS NULL THEN 'NO FTU'
      WHEN ftu.product = 'sbk' THEN 'SBK FTU'
      WHEN ftu.product = 'casino' THEN 'CAS FTU'
      ELSE 'NO FTU'
    END AS ftu_flag,
    ftu.ftu_jurisdiction_name AS ftu_state,
    ftu.ftu_date AS ftu_time_est
  FROM first_deposit fd
  LEFT JOIN ftu
    ON fd.acco_id = ftu.acco_id
) "Custom SQL Query"
