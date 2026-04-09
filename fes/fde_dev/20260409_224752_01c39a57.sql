-- Query ID: 01c39a57-0112-6f84-0000-e307218db232
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:47:52.337000+00:00
-- Elapsed: 5713ms
-- Environment: FES

select * from (
        WITH mdm_teams AS (
    SELECT DISTINCT
        LOWER(league_nm) AS league_nm,
        LOWER(team_nm) AS team_nm
    FROM commerce_mde.mde_info.team_lkp_v
),

base AS (
    SELECT DISTINCT
        acco_id,
        LOWER(favorite_team_or_player_nfl_all_time) AS nfl_team,
        LOWER(favorite_team_or_player_cbb_all_time) AS cbb_team,
        LOWER(favorite_team_or_player_cfb_all_time) AS cfb_team,
        LOWER(favorite_team_or_player_nba_all_time) AS nba_team,
        LOWER(favorite_team_or_player_nhl_all_time) AS nhl_team,
        LOWER(favorite_team_or_player_mlb_all_time) AS mlb_team,
        favorite_team_or_player_nfl_all_time,
        favorite_team_or_player_cbb_all_time,
        favorite_team_or_player_cfb_all_time,
        favorite_team_or_player_nba_all_time,
        favorite_team_or_player_nhl_all_time,
        favorite_team_or_player_mlb_all_time
    FROM fbg_fde.fbg_users.v_fbg_customer_profiles
),

profile AS (
    SELECT
        b.acco_id,
        CASE WHEN t1.team_nm IS NOT NULL THEN b.nfl_team END AS favorite_team_or_player_nfl_all_time,
        CASE WHEN t2.team_nm IS NOT NULL THEN b.cbb_team END AS favorite_team_or_player_cbb_all_time,
        CASE WHEN t3.team_nm IS NOT NULL THEN b.cfb_team END AS favorite_team_or_player_cfb_all_time,
        CASE WHEN t4.team_nm IS NOT NULL THEN b.nba_team END AS favorite_team_or_player_nba_all_time,
        CASE WHEN t5.team_nm IS NOT NULL THEN b.nhl_team END AS favorite_team_or_player_nhl_all_time,
        CASE WHEN t6.team_nm IS NOT NULL THEN b.mlb_team END AS favorite_team_or_player_mlb_all_time
    FROM base AS b
    LEFT JOIN mdm_teams AS t1 ON b.nfl_team = t1.team_nm AND t1.league_nm = 'nfl'
    LEFT JOIN mdm_teams AS t2 ON b.cbb_team = t2.team_nm AND t2.league_nm = 'college'
    LEFT JOIN mdm_teams AS t3 ON b.cfb_team = t3.team_nm AND t3.league_nm = 'college'
    LEFT JOIN mdm_teams AS t4 ON b.nba_team = t4.team_nm AND t4.league_nm = 'nba'
    LEFT JOIN mdm_teams AS t5 ON b.nhl_team = t5.team_nm AND t5.league_nm = 'nhl'
    LEFT JOIN mdm_teams AS t6 ON b.mlb_team = t6.team_nm AND t6.league_nm = 'mlb'
),

league AS (
    SELECT
        acco_id,
        favorite_team_or_player_nfl_all_time,
        favorite_team_or_player_cbb_all_time,
        favorite_team_or_player_cfb_all_time,
        favorite_team_or_player_nba_all_time,
        favorite_team_or_player_nhl_all_time,
        favorite_team_or_player_mlb_all_time,
        CASE WHEN favorite_team_or_player_nfl_all_time IS NULL THEN 0 ELSE 1 END AS fbg_preference_nfl,
        CASE WHEN favorite_team_or_player_cbb_all_time IS NULL OR favorite_team_or_player_cfb_all_time IS NULL THEN 0 ELSE 1 END AS fbg_preference_ncaa,
        CASE WHEN favorite_team_or_player_nba_all_time IS NULL THEN 0 ELSE 1 END AS fbg_preference_nba,
        CASE WHEN favorite_team_or_player_nhl_all_time IS NULL THEN 0 ELSE 1 END AS fbg_preference_nhl,
        CASE WHEN favorite_team_or_player_mlb_all_time IS NULL THEN 0 ELSE 1 END AS fbg_preference_mlb
    FROM profile
),

fbg_account_to_pfi AS (
    SELECT
        fbg_acc.id AS fbg_account_id,
        fitm.fan_id AS private_fan_id
    FROM fbg_fde.fbg_users.fbg_to_fde_accounts AS fbg_acc
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_id_tenant_map AS fitm
        ON REPLACE(fbg_acc.ref1, 'AMELCO-', '') = fitm.tenant_fan_id
    WHERE
        fbg_acc.creation_date IS NOT NULL
        AND UPPER(fbg_acc.status) = 'ACTIVE'
        AND fitm.tenant_id = '100002'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY fbg_acc.id
        ORDER BY fitm.last_modified_time ASC
    ) = 1
)

SELECT
    pfi.private_fan_id,
    MAX(l.fbg_preference_nfl) AS fbg_preference_nfl,
    MAX(l.fbg_preference_ncaa) AS fbg_preference_ncaa,
    MAX(l.fbg_preference_nba) AS fbg_preference_nba,
    MAX(l.fbg_preference_nhl) AS fbg_preference_nhl,
    MAX(l.fbg_preference_mlb) AS fbg_preference_mlb,
    
    ARRAY_AGG(DISTINCT CASE WHEN l.fbg_preference_nfl = 1 THEN l.favorite_team_or_player_nfl_all_time END ) WITHIN GROUP (ORDER BY CASE WHEN l.fbg_preference_nfl = 1 THEN l.favorite_team_or_player_nfl_all_time END )
 AS fbg_preference_nfl_teams,
    
    ARRAY_AGG(DISTINCT CASE WHEN l.fbg_preference_ncaa = 1 THEN COALESCE(l.favorite_team_or_player_cbb_all_time, l.favorite_team_or_player_cfb_all_time) END ) WITHIN GROUP (ORDER BY CASE WHEN l.fbg_preference_ncaa = 1 THEN COALESCE(l.favorite_team_or_player_cbb_all_time, l.favorite_team_or_player_cfb_all_time) END )
 AS fbg_preference_ncaa_teams,
    
    ARRAY_AGG(DISTINCT CASE WHEN l.fbg_preference_nba = 1 THEN l.favorite_team_or_player_nba_all_time END ) WITHIN GROUP (ORDER BY CASE WHEN l.fbg_preference_nba = 1 THEN l.favorite_team_or_player_nba_all_time END )
 AS fbg_preference_nba_teams,
    
    ARRAY_AGG(DISTINCT CASE WHEN l.fbg_preference_nhl = 1 THEN l.favorite_team_or_player_nhl_all_time END ) WITHIN GROUP (ORDER BY CASE WHEN l.fbg_preference_nhl = 1 THEN l.favorite_team_or_player_nhl_all_time END )
 AS fbg_preference_nhl_teams,
    
    ARRAY_AGG(DISTINCT CASE WHEN l.fbg_preference_mlb = 1 THEN l.favorite_team_or_player_mlb_all_time END ) WITHIN GROUP (ORDER BY CASE WHEN l.fbg_preference_mlb = 1 THEN l.favorite_team_or_player_mlb_all_time END )
 AS fbg_preference_mlb_teams
FROM league AS l
INNER JOIN fbg_account_to_pfi AS pfi
    ON l.acco_id = pfi.fbg_account_id
GROUP BY pfi.private_fan_id 
    ) as __dbt_probe where 1=0
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "b7ed614f-77b0-47ed-9698-6a1d046fa903", "run_started_at": "2026-04-09T22:27:17.435553+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_fbg_favorites", "node_alias": "pfi_fbg_favorites", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_fbg_favorites.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_fbg_favorites", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph --exclude fangraph_fan_id_tenant_map", "node_refs": ["fan_id_tenant_map"], "materialized": "table", "raw_code_hash": "d840bc61b21df97c44446028b93ee3cd"} */
