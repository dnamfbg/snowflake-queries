-- Query ID: 01c399e8-0112-6bf9-0000-e3072189fbca
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:56:11.386000+00:00
-- Elapsed: 159ms
-- Environment: FES

select * from (
        SELECT
    fitm.fan_id AS private_fan_id,
    SUM(CASE WHEN a.event_type = 'challenge_id_viewed' THEN 1 ELSE 0 END) AS fanapp_challenge_component_views,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nfl_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_nfl_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nfl_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_nfl_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('mlb_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_mlb_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('mlb_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_mlb_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('ncaa_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_ncaa_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('ncaa_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_ncaa_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nba_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_nba_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nba_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_nba_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nhl_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_nhl_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('nhl_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_nhl_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('wwe_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_wwe_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('wwe_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_wwe_carousel_clicked_l30_days,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('mls_commerce_deeplink', 'soccer_commerce_deeplink')
            THEN 1
        ELSE 0
    END) AS fanapp_soccer_carousel_clicked_all_time,
    SUM(CASE
        WHEN
            a.event_type = 'feed_card_clicked'
            AND a.event_properties:"card_id" IN ('mls_commerce_deeplink', 'soccer_commerce_deeplink')
            AND DATE(a.event_time) BETWEEN DATEADD('day', -30, DATE(CURRENT_DATE)) AND DATE(CURRENT_DATE)
            THEN 1
        ELSE 0
    END) AS fanapp_soccer_carousel_clicked_l30_days
FROM FDE_DEV.FDE_INFO.amplitude_events_correction AS a
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
    ON a.user_id_corrected = fitm.tenant_fan_id
WHERE fitm.tenant_id = 100005
GROUP BY fitm.fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_amplitude", "node_alias": "pfi_amplitude", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_amplitude.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_amplitude", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["amplitude_events_correction", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "1094d4359f86ade241c4c96c4e8cd06e"} */
