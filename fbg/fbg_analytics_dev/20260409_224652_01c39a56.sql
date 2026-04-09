-- Query ID: 01c39a56-0212-67a9-24dd-07031948156f
-- Database: FBG_ANALYTICS_DEV
-- Schema: ZACK_ASHLEY
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:46:52.760000+00:00
-- Elapsed: 6935ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID",
  "Custom SQL Query"."CASINO_SEGMENT" AS "CASINO_SEGMENT",
  "Custom SQL Query"."CASINO_VIP" AS "CASINO_VIP",
  "Custom SQL Query"."F1_LOYALTY_TIER" AS "F1_LOYALTY_TIER",
  "Custom SQL Query"."FUND_TYPE" AS "FUND_TYPE",
  "Custom SQL Query"."LIFETIME_GGR" AS "LIFETIME_GGR",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."PAYOUT" AS "PAYOUT",
  "Custom SQL Query"."SESSION_END_TIME_ALK" AS "SESSION_END_TIME_ALK",
  "Custom SQL Query"."SESSION_TIME_ET" AS "SESSION_TIME_ET",
  "Custom SQL Query"."STAKE" AS "STAKE",
  "Custom SQL Query"."STATE" AS "STATE",
  "Custom SQL Query"."TYPE" AS "TYPE"
FROM (
  SELECT 
  cg.game_type as type, 
  (c.settled_time_alk) AS Session_END_Time_ALK,
   cg.game_name as name, 
  CONVERT_TIMEZONE('America/Anchorage','America/New_York',settled_time_alk) AS Session_Time_ET,
  C.acco_id,
   stake, 
  payout,
  U.f1_loyalty_tier Casino_Segment,
  u.f1_loyalty_tier,
  A.Casino_VIP,
  f.code as Fund_Type,
  L.Cas_GGR AS Lifetime_GGR,
  J.Jurisdiction_Code AS State
  FROM FBG_ANALYTICS_ENGINEERING.casino.casino_transactions_mart C
  left join FBG_ANALYTICS_ENGINEERING.CASINO.casino_game_details cg on c.game_id = cg.game_id
  INNER JOIN FBG_SOURCE.OSB_SOURCE.Accounts A
  ON A.ID = C.Acco_ID
  INNER JOIN FBG_ANALYTICS_ENGINEERING.customers.customer_mart U
  ON U.Acco_ID = C.Acco_ID
  LEFT JOIN FBG_SOURCE.OSB_SOURCE.Jurisdictions J
  ON C.Jurisdictions_ID = J.ID
  LEFT JOIN CAS_LIFETIME L
  ON L.Acco_ID = C.Acco_ID
  left join fbg_source.osb_source.fund_type f
  on c.fund_type_id = f.id
  WHERE A.Test = 0
  AND settled_time_alk is not null
  AND DATE(SETTLED_TIME_ALK) >= DATEADD(Day,-8,current_Date)
  AND (u.is_vip = TRUE or u.is_casino_vip = TRUE or u.vip_host is not null)
) "Custom SQL Query"
