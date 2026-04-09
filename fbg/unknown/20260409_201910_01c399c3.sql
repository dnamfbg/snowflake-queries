-- Query ID: 01c399c3-0212-6b00-24dd-07031926ca3f
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:19:10.992000+00:00
-- Elapsed: 1233ms
-- Environment: FBG

SELECT
    vca.*,
    v.f1_loyalty_tier
FROM FBG_UNITY_CATALOG.APPLIED_ML.VIP_CONVERSATION_ANALYSIS vca
LEFT JOIN fbg_analytics.vip.vip_user_info v
    ON vca.acco_id = v.acco_id
WHERE vca.conversation_transcript IS NOT NULL
  -- AND vca.CONVERSATION_START_TIME >= DATEADD(day, -7, CURRENT_TIMESTAMP())
