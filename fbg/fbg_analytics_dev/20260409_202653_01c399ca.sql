-- Query ID: 01c399ca-0212-6cb9-24dd-070319284c9f
-- Database: FBG_ANALYTICS_DEV
-- Schema: MATT_CHERNIS
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:26:53.175000+00:00
-- Elapsed: 49577ms
-- Environment: FBG

create or replace temp table geo_locations as
WITH geo_base AS (
    SELECT
        p.account_id
      , p.timestamp
      , TRY_TO_DOUBLE(p.latitude)  AS lat
      , TRY_TO_DOUBLE(p.longitude) AS lon
    FROM FBG_ANALYTICS_ENGINEERING.APPLICATION.GEOLOCATION_PINGS_FANGEO p
    WHERE DATE(p.timestamp) >= '2026-04-05'
      AND TRY_TO_DOUBLE(p.latitude)  IS NOT NULL
      AND TRY_TO_DOUBLE(p.longitude) IS NOT NULL
)

, filtered AS (
    SELECT
        account_id
      , timestamp
    FROM geo_base
    WHERE ST_DISTANCE(
            ST_MAKEPOINT(-82.0200, 33.5030)
          , ST_MAKEPOINT(lon, lat)
        ) <= 4000   -- 5 miles
)

--, joiner as (
SELECT
    account_id as acco_id
  , MIN(timestamp) AS first_ping_ts
FROM filtered
GROUP BY
    account_id
ORDER BY
    first_ping_ts
;
