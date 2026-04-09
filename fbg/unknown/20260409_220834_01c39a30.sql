-- Query ID: 01c39a30-0212-67a8-24dd-0703193faa47
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:08:34.539000+00:00
-- Elapsed: 1844ms
-- Environment: FBG

WITH base AS (
  SELECT
    PARSE_JSON(payload):adjustedPrice::FLOAT                  AS adjusted_price,
    PARSE_JSON(payload):sgpPriceAdjustmentDescription::STRING AS sgp_price_adjustment_description,
    PARSE_JSON(payload):sgpPriceAdjustmentStatus::STRING      AS sgp_price_adjustment_status,
    PARSE_JSON(payload):betId::STRING                         AS bet_id,
    PARSE_JSON(payload):correlationId::STRING                 AS correlation_id,
    PARSE_JSON(payload):customerId::STRING                    AS customer_id,
    PARSE_JSON(payload):longestLegPrice::FLOAT                AS longest_leg_price,
    PARSE_JSON(payload):longestLegProbability::FLOAT          AS longest_leg_probability,
    PARSE_JSON(payload):simulatedProbability::FLOAT           AS simulated_probability,
    PARSE_JSON(payload):unadjustedPrice::FLOAT                AS unadjusted_price,
    timestamp::TIMESTAMP_NTZ                                  AS event_timestamp
  FROM FBG_UNITY_CATALOG.ODDSFACTORY_SOURCE.SGP_PLACEMENT_ANALYTICS_RAW
  WHERE timestamp::TIMESTAMP_NTZ >= '2026-03-03 16:30:00'::TIMESTAMP_NTZ
    AND TRY_TO_NUMBER(TRIM(PARSE_JSON(payload):customerId::STRING)) IS NOT NULL
)
select * from base limit 100;
