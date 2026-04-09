-- Query ID: 01c399c3-0212-6cb9-24dd-07031926bebf
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: APPLICATION
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T20:19:32.943000+00:00
-- Elapsed: 44253ms
-- Environment: FBG

WITH params AS (
    SELECT
        30  AS lookback_days,   -- how many days back
        150 AS radius_m,        -- radius in meters
        42.39422119980256 AS ref_latitude,   -- <-- set this
        -71.2567004339764 AS ref_longitude   -- <-- set this
),
account_location AS (
    SELECT
        ref_latitude  AS ref_lat,
        ref_longitude AS ref_lon
    FROM params
),
distance_calculation AS (
    SELECT 
        p.account_id,
        p.fan_id,
        TRY_TO_DOUBLE(p.latitude)  AS ip_latitude,
        TRY_TO_DOUBLE(p.longitude) AS ip_longitude,
        p.row_created_time,
        ST_DISTANCE(
            TO_GEOGRAPHY(ST_MAKEPOINT(al.ref_lon, al.ref_lat)),
            TO_GEOGRAPHY(ST_MAKEPOINT(TRY_TO_DOUBLE(p.longitude), TRY_TO_DOUBLE(p.latitude)))
        ) AS distance_m
    FROM FBG_ANALYTICS_ENGINEERING.APPLICATION.GEOLOCATION_PINGS_FANGEO p
    JOIN account_location al ON TRUE
    JOIN params par ON TRUE
    WHERE TRY_TO_DOUBLE(p.latitude)  IS NOT NULL
      AND TRY_TO_DOUBLE(p.longitude) IS NOT NULL
      AND p.row_created_time >= DATEADD(DAY, -par.lookback_days, CURRENT_TIMESTAMP())
),
punter_colour_lookup AS (
    SELECT
        LOWER(TO_VARCHAR(b.account_ref)) AS account_ref_norm,
        b.punter_colour
    FROM FBG_SOURCE.OSB_SOURCE.BETS b
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY LOWER(TO_VARCHAR(b.account_ref))
        ORDER BY b.placed_time DESC
    ) = 1
)
SELECT 
    dc.account_id,
    COUNT(*) AS times_within_150_meters,
    ANY_VALUE(dc.ip_latitude)  AS ip_latitude,
    ANY_VALUE(dc.ip_longitude) AS ip_longitude,
    pcl.punter_colour,
    MIN(dc.distance_m) AS min_distance_m,
    MAX(dc.distance_m) AS max_distance_m
FROM distance_calculation dc
JOIN params par ON TRUE
LEFT JOIN punter_colour_lookup pcl
  ON pcl.account_ref_norm = LOWER(TO_VARCHAR(dc.fan_id))
WHERE dc.distance_m <= par.radius_m
GROUP BY dc.account_id, pcl.punter_colour
ORDER BY times_within_150_meters DESC;
