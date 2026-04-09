-- Query ID: 01c399cb-0212-6dbe-24dd-070319283d63
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:27:01.788000+00:00
-- Elapsed: 529ms
-- Environment: FBG

WITH track_2_recent_notes AS (
  SELECT 
    account_id,
    ROUND(MAX_BY(one_k_pts_threshold, CASE WHEN one_k_pts_threshold IS NOT NULL THEN last_updated_at END), 2) AS one_k_pts_threshold,
    MAX_BY(one_k_threshold_reasoning, CASE WHEN one_k_pts_threshold IS NOT NULL THEN last_updated_at END) AS one_k_threshold_reasoning,
    ROUND(MAX_BY(monetary_risk_days_threshold, CASE WHEN monetary_risk_days_threshold IS NOT NULL THEN last_updated_at END), 0) AS monetary_risk_days_threshold,
    MAX_BY(monetary_risk_change_reasoning, CASE WHEN monetary_risk_days_threshold IS NOT NULL THEN last_updated_at END) AS monetary_risk_change_reasoning,
    ROUND(MAX_BY(insufficient_funds_count_change, CASE WHEN insufficient_funds_count_change IS NOT NULL THEN last_updated_at END), 0) AS nsf_daily_count_threshold,
    ROUND(MAX_BY(insufficient_alert_day_override, CASE WHEN insufficient_alert_day_override IS NOT NULL THEN last_updated_at END), 0) AS nsf_alert_day_threshold,
    MAX_BY(insufficient_change_reason, CASE WHEN insufficient_funds_count_change IS NOT NULL THEN last_updated_at END) AS nsf_reasoning
  FROM FBG_ANALYTICS.SIGMA_FBG.PATH_2_RG_NOTES
  WHERE account_id IS NOT NULL
  GROUP BY account_id
)
SELECT * FROM track_2_recent_notes
