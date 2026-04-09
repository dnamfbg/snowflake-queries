-- Query ID: 01c39a50-0112-6029-0000-e307218d29d2
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:40:35.203000+00:00
-- Elapsed: 19071ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_amplitude (
            "PRIVATE_FAN_ID", "FANAPP_CHALLENGE_COMPONENT_VIEWS", "FANAPP_NFL_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_NFL_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_MLB_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_MLB_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_NCAA_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_NCAA_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_NBA_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_NBA_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_NHL_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_NHL_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_WWE_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_WWE_CAROUSEL_CLICKED_L30_DAYS", "FANAPP_SOCCER_CAROUSEL_CLICKED_ALL_TIME", "FANAPP_SOCCER_CAROUSEL_CLICKED_L30_DAYS"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FANAPP_CHALLENGE_COMPONENT_VIEWS", 
            
              __src."FANAPP_NFL_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_NFL_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_MLB_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_MLB_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_NCAA_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_NCAA_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_NBA_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_NBA_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_NHL_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_NHL_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_WWE_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_WWE_CAROUSEL_CLICKED_L30_DAYS", 
            
              __src."FANAPP_SOCCER_CAROUSEL_CLICKED_ALL_TIME", 
            
              __src."FANAPP_SOCCER_CAROUSEL_CLICKED_L30_DAYS"
            
          from ( SELECT
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
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_amplitude", "node_alias": "pfi_amplitude", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_amplitude.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_amplitude", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["amplitude_events_correction", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "1094d4359f86ade241c4c96c4e8cd06e"} */
