-- Query ID: 01c39a48-0212-67a9-24dd-07031944f603
-- Database: FBG_ANALYTICS_DEV
-- Schema: JORDAN_PLUCHAR
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:32:38.997000+00:00
-- Elapsed: 2720ms
-- Environment: FBG

SELECT
  XMLGET(PARSE_XML(RESPONSE_PAYLOAD), 'geolocate_in'):"$"::INT AS geolocate_in_val,
  COALESCE(
    CASE WHEN XMLGET(PARSE_XML(RESPONSE_PAYLOAD), 'gps'):"@primary" = '1'
         THEN XMLGET(PARSE_XML(RESPONSE_PAYLOAD), 'gps'):"@dist_to_border"::FLOAT END,
    CASE WHEN XMLGET(PARSE_XML(RESPONSE_PAYLOAD), 'wifi'):"@primary" = '1'
         THEN XMLGET(PARSE_XML(RESPONSE_PAYLOAD), 'wifi'):"@dist_to_border"::FLOAT END
  ) AS dist_to_border_m
FROM fbg_analytics_engineering.application.geolocation_pings_combined
WHERE RESPONSE_PAYLOAD LIKE '<?xml%'
  AND ERROR_CODE = '0'
LIMIT 5000
