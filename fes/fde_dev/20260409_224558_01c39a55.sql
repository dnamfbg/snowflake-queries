-- Query ID: 01c39a55-0112-6f82-0000-e307218d0f7a
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:45:58.184000+00:00
-- Elapsed: 9973ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_fanapp_games (
            "PRIVATE_FAN_ID", "TIMES_PLAYED", "EVER_WON", "TIMES_WON", "LAST_PLAYED_DATE", "F5JACKPOTV2_TIMES_PLAYED", "F5JACKPOTV2_EVER_WON", "F5JACKPOTV2_TIMES_WON", "F5JACKPOTV2_LAST_PLAYED_DATE", "FANATICS5_TIMES_PLAYED", "FANATICS5_EVER_WON", "FANATICS5_TIMES_WON", "FANATICS5_LAST_PLAYED_DATE", "PERFECT9_TIMES_PLAYED", "PERFECT9_EVER_WON", "PERFECT9_TIMES_WON", "PERFECT9_LAST_PLAYED_DATE", "PERFECT9V2_TIMES_PLAYED", "PERFECT9V2_EVER_WON", "PERFECT9V2_TIMES_WON", "PERFECT9V2_LAST_PLAYED_DATE", "QUADGOALS_TIMES_PLAYED", "QUADGOALS_EVER_WON", "QUADGOALS_TIMES_WON", "QUADGOALS_LAST_PLAYED_DATE", "TIEREDPICKEM_TIMES_PLAYED", "TIEREDPICKEM_EVER_WON", "TIEREDPICKEM_TIMES_WON", "TIEREDPICKEM_LAST_PLAYED_DATE", "SPINTOWIN_TIMES_PLAYED", "SPINTOWIN_EVER_WON", "SPINTOWIN_TIMES_WON", "SPINTOWIN_LAST_PLAYED_DATE", "SURVIVOR_TIMES_PLAYED", "SURVIVOR_EVER_WON", "SURVIVOR_TIMES_WON", "SURVIVOR_LAST_PLAYED_DATE"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."TIMES_PLAYED", 
            
              __src."EVER_WON", 
            
              __src."TIMES_WON", 
            
              __src."LAST_PLAYED_DATE", 
            
              __src."F5JACKPOTV2_TIMES_PLAYED", 
            
              __src."F5JACKPOTV2_EVER_WON", 
            
              __src."F5JACKPOTV2_TIMES_WON", 
            
              __src."F5JACKPOTV2_LAST_PLAYED_DATE", 
            
              __src."FANATICS5_TIMES_PLAYED", 
            
              __src."FANATICS5_EVER_WON", 
            
              __src."FANATICS5_TIMES_WON", 
            
              __src."FANATICS5_LAST_PLAYED_DATE", 
            
              __src."PERFECT9_TIMES_PLAYED", 
            
              __src."PERFECT9_EVER_WON", 
            
              __src."PERFECT9_TIMES_WON", 
            
              __src."PERFECT9_LAST_PLAYED_DATE", 
            
              __src."PERFECT9V2_TIMES_PLAYED", 
            
              __src."PERFECT9V2_EVER_WON", 
            
              __src."PERFECT9V2_TIMES_WON", 
            
              __src."PERFECT9V2_LAST_PLAYED_DATE", 
            
              __src."QUADGOALS_TIMES_PLAYED", 
            
              __src."QUADGOALS_EVER_WON", 
            
              __src."QUADGOALS_TIMES_WON", 
            
              __src."QUADGOALS_LAST_PLAYED_DATE", 
            
              __src."TIEREDPICKEM_TIMES_PLAYED", 
            
              __src."TIEREDPICKEM_EVER_WON", 
            
              __src."TIEREDPICKEM_TIMES_WON", 
            
              __src."TIEREDPICKEM_LAST_PLAYED_DATE", 
            
              __src."SPINTOWIN_TIMES_PLAYED", 
            
              __src."SPINTOWIN_EVER_WON", 
            
              __src."SPINTOWIN_TIMES_WON", 
            
              __src."SPINTOWIN_LAST_PLAYED_DATE", 
            
              __src."SURVIVOR_TIMES_PLAYED", 
            
              __src."SURVIVOR_EVER_WON", 
            
              __src."SURVIVOR_TIMES_WON", 
            
              __src."SURVIVOR_LAST_PLAYED_DATE"
            
          from ( WITH fanapp_game_results AS (
    SELECT
        fitm.fan_id AS private_fan_id,
        

    
        COUNT_IF(v.game_type = 'quadGoals') AS quadGoals_times_played,
        MAX(IFF(v.game_type = 'quadGoals' AND v.game_result = 'win', 'yes', 'no')) AS quadGoals_ever_won,
        COUNT_IF(v.game_type = 'quadGoals' AND v.game_result = 'win') AS quadGoals_times_won,
        MAX(IFF(v.game_type = 'quadGoals', v.user_session_end_ts::DATE, NULL)) AS quadGoals_last_played_date,
    
        COUNT_IF(v.game_type = 'fanatics5') AS fanatics5_times_played,
        MAX(IFF(v.game_type = 'fanatics5' AND v.game_result = 'win', 'yes', 'no')) AS fanatics5_ever_won,
        COUNT_IF(v.game_type = 'fanatics5' AND v.game_result = 'win') AS fanatics5_times_won,
        MAX(IFF(v.game_type = 'fanatics5', v.user_session_end_ts::DATE, NULL)) AS fanatics5_last_played_date,
    
        COUNT_IF(v.game_type = 'perfect9v2') AS perfect9v2_times_played,
        MAX(IFF(v.game_type = 'perfect9v2' AND v.game_result = 'win', 'yes', 'no')) AS perfect9v2_ever_won,
        COUNT_IF(v.game_type = 'perfect9v2' AND v.game_result = 'win') AS perfect9v2_times_won,
        MAX(IFF(v.game_type = 'perfect9v2', v.user_session_end_ts::DATE, NULL)) AS perfect9v2_last_played_date,
    
        COUNT_IF(v.game_type = 'tieredPickem') AS tieredPickem_times_played,
        MAX(IFF(v.game_type = 'tieredPickem' AND v.game_result = 'win', 'yes', 'no')) AS tieredPickem_ever_won,
        COUNT_IF(v.game_type = 'tieredPickem' AND v.game_result = 'win') AS tieredPickem_times_won,
        MAX(IFF(v.game_type = 'tieredPickem', v.user_session_end_ts::DATE, NULL)) AS tieredPickem_last_played_date,
    
        COUNT_IF(v.game_type = 'f5jackpotv2') AS f5jackpotv2_times_played,
        MAX(IFF(v.game_type = 'f5jackpotv2' AND v.game_result = 'win', 'yes', 'no')) AS f5jackpotv2_ever_won,
        COUNT_IF(v.game_type = 'f5jackpotv2' AND v.game_result = 'win') AS f5jackpotv2_times_won,
        MAX(IFF(v.game_type = 'f5jackpotv2', v.user_session_end_ts::DATE, NULL)) AS f5jackpotv2_last_played_date,
    
        COUNT_IF(v.game_type = 'perfect9') AS perfect9_times_played,
        MAX(IFF(v.game_type = 'perfect9' AND v.game_result = 'win', 'yes', 'no')) AS perfect9_ever_won,
        COUNT_IF(v.game_type = 'perfect9' AND v.game_result = 'win') AS perfect9_times_won,
        MAX(IFF(v.game_type = 'perfect9', v.user_session_end_ts::DATE, NULL)) AS perfect9_last_played_date,
    
        COUNT_IF(v.game_type = 'spinToWin') AS spinToWin_times_played,
        MAX(IFF(v.game_type = 'spinToWin' AND v.game_result = 'win', 'yes', 'no')) AS spinToWin_ever_won,
        COUNT_IF(v.game_type = 'spinToWin' AND v.game_result = 'win') AS spinToWin_times_won,
        MAX(IFF(v.game_type = 'spinToWin', v.user_session_end_ts::DATE, NULL)) AS spinToWin_last_played_date,
    

  -- noqa
        COUNT(*) AS times_played,  -- noqa
        MAX(IFF(v.game_result = 'win', 'yes', 'no')) AS ever_won,
        COUNT_IF(v.game_result = 'win') AS times_won,
        MAX(v.user_session_end_ts::DATE) AS last_played_date
    FROM MONTEROSA_DEV.MONTEROSA_CORE.fanapp_game_results AS v
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON v.external_id = fitm.tenant_fan_id
    WHERE v.game_type <> 'survivor'
    GROUP BY ALL
),

fanapp_survivor AS (
    SELECT
        fitm.fan_id AS private_fan_id,
        COUNT_IF(s.answer_is_correct IS NOT NULL) AS times_played,
        IFF(SUM(s.answer_is_correct) > 0, 'yes', 'no') AS ever_won,
        COUNT_IF(s.answer_is_correct = 1) AS times_won,
        MAX(s.user_session_end_ts::DATE) AS last_played_date
    FROM MONTEROSA_DEV.MONTEROSA_CORE.survivor_game_v AS s
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON s.external_id = fitm.tenant_fan_id
    WHERE s.league_type = 'public'
    GROUP BY fitm.fan_id
)

SELECT
    COALESCE(gr.private_fan_id, s.private_fan_id) AS private_fan_id,
    (COALESCE(gr.times_played, 0) + COALESCE(s.times_played, 0)) AS times_played,
    GREATEST(COALESCE(gr.ever_won, 'no'), COALESCE(s.ever_won, 'no')) AS ever_won,
    (COALESCE(gr.times_won, 0) + COALESCE(s.times_won, 0)) AS times_won,
    CASE
        WHEN gr.last_played_date IS NULL THEN s.last_played_date
        WHEN s.last_played_date IS NULL THEN gr.last_played_date
        ELSE GREATEST(gr.last_played_date, s.last_played_date)
    END AS last_played_date,
    COALESCE(gr.f5jackpotv2_times_played, 0) AS f5jackpotv2_times_played,
    COALESCE(gr.f5jackpotv2_ever_won, 'no') AS f5jackpotv2_ever_won,
    COALESCE(gr.f5jackpotv2_times_won, 0) AS f5jackpotv2_times_won,
    gr.f5jackpotv2_last_played_date,
    COALESCE(gr.fanatics5_times_played, 0) AS fanatics5_times_played,
    COALESCE(gr.fanatics5_ever_won, 'no') AS fanatics5_ever_won,
    COALESCE(gr.fanatics5_times_won, 0) AS fanatics5_times_won,
    gr.fanatics5_last_played_date,
    COALESCE(gr.perfect9_times_played, 0) AS perfect9_times_played,
    COALESCE(gr.perfect9_ever_won, 'no') AS perfect9_ever_won,
    COALESCE(gr.perfect9_times_won, 0) AS perfect9_times_won,
    gr.perfect9_last_played_date,
    COALESCE(gr.perfect9v2_times_played, 0) AS perfect9v2_times_played,
    COALESCE(gr.perfect9v2_ever_won, 'no') AS perfect9v2_ever_won,
    COALESCE(gr.perfect9v2_times_won, 0) AS perfect9v2_times_won,
    gr.perfect9v2_last_played_date,
    COALESCE(gr.quadgoals_times_played, 0) AS quadgoals_times_played,
    COALESCE(gr.quadgoals_ever_won, 'no') AS quadgoals_ever_won,
    COALESCE(gr.quadgoals_times_won, 0) AS quadgoals_times_won,
    gr.quadgoals_last_played_date,
    COALESCE(gr.tieredpickem_times_played, 0) AS tieredpickem_times_played,
    COALESCE(gr.tieredpickem_ever_won, 'no') AS tieredpickem_ever_won,
    COALESCE(gr.tieredpickem_times_won, 0) AS tieredpickem_times_won,
    gr.tieredpickem_last_played_date,
    COALESCE(gr.spintowin_times_played, 0) AS spintowin_times_played,
    COALESCE(gr.spintowin_ever_won, 'no') AS spintowin_ever_won,
    COALESCE(gr.spintowin_times_won, 0) AS spintowin_times_won,
    gr.spintowin_last_played_date,
    COALESCE(s.times_played, 0) AS survivor_times_played,
    COALESCE(s.ever_won, 'no') AS survivor_ever_won,
    COALESCE(s.times_won, 0) AS survivor_times_won,
    s.last_played_date AS survivor_last_played_date
FROM fanapp_game_results AS gr
FULL OUTER JOIN fanapp_survivor AS s
    ON gr.private_fan_id = s.private_fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fanapp_games", "node_alias": "pfi_fanapp_games", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fanapp_games.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fanapp_games", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["fanapp_game_results", "fan_id_tenant_map", "survivor_game_v"], "materialized": "table", "raw_code_hash": "1fe679337f58e421d0e82eb6f3bd2d21"} */
