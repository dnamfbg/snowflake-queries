-- Query ID: 01c399ca-0112-6be5-0000-e3072189d47e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:26:48.510000+00:00
-- Elapsed: 10959ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fbg_xsell (
            "PRIVATE_FAN_ID", "FBG_XSELL_VIEWS", "FBG_XSELL_CLICKS"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."FBG_XSELL_VIEWS", 
            
              __src."FBG_XSELL_CLICKS"
            
          from ( SELECT
    fitm.fan_id AS private_fan_id,
    SUM(
        CASE
            WHEN
                a.event_type = 'feed_card_viewed'
                AND a.event_properties:"card_id" IN (
                    '194', '202', '224', '225', '247', '246', '248', '249',
                    '280', '281', '282', '283', '290', '291', '292', '293',
                    '305', '306', '307', '308', '337', '336', '339', '340',
                    '361', '362', '373', '378', '385', '386', '387',
                    '401', '406', '407', '422', '444'
                ) THEN 1
            WHEN
                a.event_type = 'feed_card_viewed'
                AND a.event_properties:"card_type" = 'BETTING' THEN 1
            WHEN a.event_type = 'Viewed betslip_view' THEN 1
            WHEN
                a.event_type = 'monterosa_track_event'
                AND a.event_properties:"user_action_name" IN (
                    'fanatics_five_daily_BET_CONFIRMATION_PAGE_VIEW',
                    'fanatics_five_jackpot_BET_CONFIRMATION_PAGE_VIEW',
                    'perfect-nine-v2_BET_CONFIRMATION_PAGE_VIEW'
                ) THEN 1
            WHEN a.event_type = 'Viewed six_box_confirmation_view' THEN 1
            ELSE 0
        END
    ) AS fbg_xsell_views,
    SUM(
        CASE
            WHEN
                a.event_type = 'feed_card_clicked'
                AND a.event_properties:"card_id" IN (
                    '194', '202', '224', '225', '247', '246', '248', '249',
                    '280', '281', '282', '283', '290', '291', '292', '293',
                    '305', '306', '307', '308', '337', '336', '339', '340',
                    '361', '362', '373', '378', '385', '386', '387',
                    '401', '406', '407', '422', '444'
                ) THEN 1
            WHEN
                a.event_type = 'feed_card_clicked'
                AND a.event_properties:"card_type" = 'BETTING' THEN 1
            WHEN a.event_type = 'betslip_deeplink_tapped' THEN 1
            WHEN
                a.event_type = 'monterosa_track_event'
                AND a.event_properties:"user_action_name" IN (
                    'fanatics_five_daily_bet_cross_sell_click',
                    'fanatics_five_jackpot_bet_cross_sell_click',
                    'perfect-nine-v2_bet_cross_sell_click'
                ) THEN 1
            WHEN a.event_type = 'six_box_modal_cta_tapped' THEN 1
            ELSE 0
        END
    ) AS fbg_xsell_clicks
FROM FDE_DEV.FDE_INFO.amplitude_events_correction AS a
INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
    ON a.user_id_corrected = fitm.tenant_fan_id
WHERE fitm.tenant_id = 100005
GROUP BY fitm.fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "2948dd10-2bb5-4300-9509-eb344adbb3b6", "run_started_at": "2026-04-09T20:14:14.358270+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_xsell", "node_alias": "pfi_fbg_xsell", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_xsell.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_xsell", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["amplitude_events_correction", "fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "5a1a96f151721ddeb4609639f04c8b4c"} */
