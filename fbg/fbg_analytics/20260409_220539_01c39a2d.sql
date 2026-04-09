-- Query ID: 01c39a2d-0212-6e7d-24dd-0703193f176f
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:05:39.832000+00:00
-- Elapsed: 23469ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."AS_OF_DATE" AS "AS_OF_DATE",
  "Custom SQL Query"."BASE_POINTS" AS "BASE_POINTS",
  "Custom SQL Query"."FBG_NAME" AS "FBG_NAME",
  "Custom SQL Query"."INC_BASE" AS "INC_BASE",
  "Custom SQL Query"."INC_EXTRA" AS "INC_EXTRA",
  "Custom SQL Query"."INC_OB" AS "INC_OB",
  "Custom SQL Query"."INC_OP" AS "INC_OP",
  "Custom SQL Query"."INTERNAL_REFERRER" AS "INTERNAL_REFERRER",
  "Custom SQL Query"."LEAD_CREATOR" AS "LEAD_CREATOR",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."LOYALTY_TIER" AS "LOYALTY_TIER",
  "Custom SQL Query"."OB_EARNED_POINTS" AS "OB_EARNED_POINTS",
  "Custom SQL Query"."OP_EARNED_POINTS" AS "OP_EARNED_POINTS",
  "Custom SQL Query"."POINTS_TIER" AS "POINTS_TIER",
  "Custom SQL Query"."QUARTER" AS "QUARTER",
  "Custom SQL Query"."QUARTER_POINTS_CAPPED" AS "QUARTER_POINTS_CAPPED",
  "Custom SQL Query"."QUARTER_START" AS "QUARTER_START",
  "Custom SQL Query"."RAF_NAME" AS "RAF_NAME",
  "Custom SQL Query"."TIER_CREDIT_POINTS_CAPPED" AS "TIER_CREDIT_POINTS_CAPPED",
  "Custom SQL Query"."TIER_CREDIT_POINTS_CAPPED_INDIVIDUAL" AS "TIER_CREDIT_POINTS_CAPPED_INDIVIDUAL"
FROM (
  WITH raf as(
  select c.vip_host, b.acco_id
  FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.REFERRAL_USER_DETAILS as a
      inner join FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as b
          on a.re_account_id = b.acco_id
      inner join fbg_analytics.vip.vip_host_lead_historical as c
          on a.referrer_account_id = c.acco_id
          and date(b.registration_date_alk) = c.as_of_date
  where c.vip_host is not null
  QUALIFY ROW_NUMBER() OVER (PARTITION BY b.acco_id ORDER BY c.vip_host ASC) = 1
  ),
  first_ob AS (
      SELECT
          acco_id,
          current_year_tier_points,
          as_of_date AS date
      FROM fbg_analytics.product_and_customer.f1_attributes_audits
      WHERE loyalty_tier = 'ONEblack'
      QUALIFY ROW_NUMBER() OVER (PARTITION BY acco_id ORDER BY as_of_date ASC) = 1
  ),
  ob_day_30 AS (
      SELECT
          a.acco_id,
          a.as_of_date,
          (a.current_year_tier_points - b.current_year_tier_points) AS earned_points_in_30_days
      FROM fbg_analytics.product_and_customer.f1_attributes_audits a
      INNER JOIN first_ob b
          ON a.acco_id = b.acco_id
         AND a.as_of_date <= DATEADD('day',30,b.date)
      WHERE a.loyalty_tier = 'ONEblack'
        AND earned_points_in_30_days >= 2000
      QUALIFY ROW_NUMBER() OVER (PARTITION BY a.acco_id ORDER BY a.as_of_date ASC) = 1
  ),
  op_status_match AS (
      SELECT *
      FROM fbg_analytics.product_and_customer.status_match
      WHERE status_match_tier_name = 'ONEplatinum'
        AND trial_status = 'Success'
  ),
  ob_status_match AS (
      SELECT *
      FROM fbg_analytics.product_and_customer.status_match
      WHERE status_match_tier_name = 'ONEblack'
        AND trial_status = 'Success'
  ),
  /* --- Snapshots we care about (Q3 end + current) --- */
  base_data AS (
      SELECT 
          a.as_of_date,
          a.acco_id,
          a.points_tier,
          a.loyalty_tier,
          COALESCE(lo.name,'') AS lead_owner,
          COALESCE(lc.name,'') AS lead_creator,
          COALESCE(ir.name,'') AS internal_referrer,
          COALESCE(raf2.name,'') AS raf_name,
          current_year_tier_points,
          /* Base point */
          CASE 
              WHEN points_tier IN ('ONEgold','ONEplatinum','ONEblack')
                OR loyalty_tier IN ('ONEplatinum','ONEblack')
                OR (c.is_status_match = TRUE AND c.status_match_date <= a.as_of_date)
              THEN 1 ELSE 0
          END AS base_points,
          /* OP earned */
          CASE 
              WHEN points_tier IN ('ONEplatinum','ONEblack') THEN 2
              WHEN op.acco_id IS NOT NULL AND DATE(op.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob.acco_id IS NOT NULL AND DATE(ob.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob2.acco_id IS NOT NULL AND ob2.as_of_date <= a.as_of_date THEN 2
              ELSE 0
          END AS op_earned_points,
          /* OB earned */
          CASE 
              WHEN points_tier = 'ONEblack' THEN 2
              WHEN ob.acco_id IS NOT NULL AND DATE(ob.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob2.acco_id IS NOT NULL AND ob2.as_of_date <= a.as_of_date THEN 2
              ELSE 0
          END AS ob_earned_points,
          /* Extra tier credit capped at 5 */
          CASE 
              WHEN current_year_tier_points < 20000 THEN 0
              WHEN FLOOR((current_year_tier_points - 20000) / 10000) > 5 THEN 5
              ELSE FLOOR((current_year_tier_points - 20000) / 10000)
          END AS tier_credit_points_capped_individual,
          /* Total capped points */
          ( 
            CASE 
              WHEN points_tier IN ('ONEgold','ONEplatinum','ONEblack')
                OR loyalty_tier IN ('ONEplatinum','ONEblack')
                OR (c.is_status_match = TRUE AND c.status_match_date <= a.as_of_date)
              THEN 1 ELSE 0
            END
            + 
            CASE 
              WHEN points_tier IN ('ONEplatinum','ONEblack') THEN 2
              WHEN op.acco_id IS NOT NULL AND DATE(op.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob.acco_id IS NOT NULL AND DATE(ob.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob2.acco_id IS NOT NULL AND ob2.as_of_date <= a.as_of_date THEN 2
              ELSE 0
            END
            +
            CASE 
              WHEN points_tier = 'ONEblack' THEN 2
              WHEN ob.acco_id IS NOT NULL AND DATE(ob.trial_completed_date) <= a.as_of_date THEN 2
              WHEN ob2.acco_id IS NOT NULL AND ob2.as_of_date <= a.as_of_date THEN 2
              ELSE 0
            END
            +
            CASE 
              WHEN current_year_tier_points < 20000 THEN 0
              WHEN FLOOR((current_year_tier_points - 20000) / 10000) > 5 THEN 5
              ELSE FLOOR((current_year_tier_points - 20000) / 10000)
            END
          ) AS tier_credit_points_capped
      FROM fbg_analytics.product_and_customer.f1_attributes_audits a
      INNER JOIN fbg_analytics_engineering.customers.customer_mart b 
          ON a.acco_id = b.acco_id
      INNER JOIN fbg_analytics.vip.vip_user_info c 
          ON a.acco_id = c.acco_id
      LEFT JOIN raf raf ON a.acco_id = raf.acco_id
      LEFT JOIN fbg_analytics.vip.vip_employee_mapping lo ON c.lead_owner = lo.name
      LEFT JOIN fbg_analytics.vip.vip_employee_mapping lc ON c.lead_creator = lc.name
      LEFT JOIN fbg_analytics.vip.vip_employee_mapping ir ON c.internal_referrer = ir.name
      LEFT JOIN fbg_analytics.vip.vip_employee_mapping raf2 ON raf.vip_host = raf2.name
      LEFT JOIN op_status_match op ON a.acco_id = op.acco_id
      LEFT JOIN ob_status_match ob ON a.acco_id = ob.acco_id
      LEFT JOIN ob_day_30 ob2 ON a.acco_id = ob2.acco_id
      WHERE a.as_of_date IN (DATE_TRUNC('QUARTER', a.as_of_date))   -- Q3 end & Q4-to-date
        AND b.is_test_account = FALSE
  ),
  /* --- Add quarter label and compute deltas vs previous snapshot --- */
  quarter_deltas AS (
      SELECT
          acco_id,
          lead_owner,
          lead_creator,
          internal_referrer,
          raf_name,
          points_tier,
          loyalty_tier,
          current_year_tier_points,
          as_of_date,
          DATE_TRUNC('quarter', as_of_date) AS quarter_start,
          TO_VARCHAR(DATE_PART(year, as_of_date::DATE)) || '-Q' || DATE_PART(quarter, as_of_date::DATE) AS quarter,
          base_points,
          op_earned_points,
          ob_earned_points,
          tier_credit_points_capped_individual,
          tier_credit_points_capped,
          /* Incremental (this quarter only) = current minus prior snapshot */
          base_points - COALESCE(LAG(base_points) OVER (PARTITION BY acco_id ORDER BY as_of_date), 0) AS inc_base,
          op_earned_points - COALESCE(LAG(op_earned_points) OVER (PARTITION BY acco_id ORDER BY as_of_date), 0) AS inc_op,
          ob_earned_points - COALESCE(LAG(ob_earned_points) OVER (PARTITION BY acco_id ORDER BY as_of_date), 0) AS inc_ob,
          tier_credit_points_capped_individual 
              - COALESCE(LAG(tier_credit_points_capped_individual) OVER (PARTITION BY acco_id ORDER BY as_of_date), 0) AS inc_extra,
          tier_credit_points_capped 
              - COALESCE(LAG(tier_credit_points_capped) OVER (PARTITION BY acco_id ORDER BY as_of_date), 0) AS inc_quarterly_points_capped
      FROM base_data
  ),
  /* --- Fanatics name explosion (owner/creator/referrer) --- */
  expanded AS (
      SELECT lead_owner AS fbg_name, q.* FROM quarter_deltas q
      UNION ALL
      SELECT lead_creator AS fbg_name, q.* FROM quarter_deltas q
      WHERE lead_creator IS NOT NULL
          AND lead_creator <> lead_owner
      UNION ALL
      SELECT internal_referrer AS fbg_name, q.* FROM quarter_deltas q
      WHERE internal_referrer IS NOT NULL
        AND internal_referrer <> lead_owner
        AND internal_referrer <> lead_creator
      UNION ALL
      SELECT raf_name AS fbg_name, q.* FROM quarter_deltas q
      WHERE raf_name IS NOT NULL
        AND raf_name <> lead_owner
        AND raf_name <> lead_creator
        AND raf_name <> internal_referrer
  ),
  staging AS (
      SELECT *
      FROM expanded
      WHERE fbg_name IN (SELECT DISTINCT name FROM fbg_analytics.vip.vip_employee_mapping)
  ),
  final AS (
  SELECT DISTINCT
      acco_id,
      quarter,
      quarter_start,
      as_of_date,
      fbg_name,
      lead_owner,
      lead_creator,
      internal_referrer,
      raf_name,
      points_tier,
      loyalty_tier,
      /* quarter-only increments */
      inc_base,
      inc_op,
      inc_ob,
      inc_extra,
      inc_quarterly_points_capped AS quarter_points_capped,
      /* optional: the running totals as-of the snapshot */
      base_points,
      op_earned_points,
      ob_earned_points,
      tier_credit_points_capped_individual,
      tier_credit_points_capped
  FROM staging
  ORDER BY acco_id, as_of_date
  )
  select * from final
) "Custom SQL Query"
