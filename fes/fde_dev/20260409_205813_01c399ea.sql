-- Query ID: 01c399ea-0112-6029-0000-e307218a5486
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:58:13.455000+00:00
-- Elapsed: 38567ms
-- Environment: FES

INSERT OVERWRITE INTO fangraph_dev.private_fan_id.pfi_commerce_preferences (
            "PRIVATE_FAN_ID", "COMMERCE_PRODUCT_LEAGUE", "COMMERCE_PREFERENCE_NFL", "COMMERCE_PREFERENCE_NCAA", "COMMERCE_PREFERENCE_NBA", "COMMERCE_PREFERENCE_NHL", "COMMERCE_PREFERENCE_MLB", "COMMERCE_PREFERENCE_NFL_TEAMS", "COMMERCE_PREFERENCE_NCAA_TEAMS", "COMMERCE_PREFERENCE_NBA_TEAMS", "COMMERCE_PREFERENCE_NHL_TEAMS", "COMMERCE_PREFERENCE_MLB_TEAMS", "COMMERCE_PRODUCT_PLAYER_NAME", "COMMERCE_PRODUCT_PLAYER_DESCRIPTION", "COMMERCE_PRODUCT_TEAM"
          )
          select
            
              __src."PRIVATE_FAN_ID", 
            
              __src."COMMERCE_PRODUCT_LEAGUE", 
            
              __src."COMMERCE_PREFERENCE_NFL", 
            
              __src."COMMERCE_PREFERENCE_NCAA", 
            
              __src."COMMERCE_PREFERENCE_NBA", 
            
              __src."COMMERCE_PREFERENCE_NHL", 
            
              __src."COMMERCE_PREFERENCE_MLB", 
            
              __src."COMMERCE_PREFERENCE_NFL_TEAMS", 
            
              __src."COMMERCE_PREFERENCE_NCAA_TEAMS", 
            
              __src."COMMERCE_PREFERENCE_NBA_TEAMS", 
            
              __src."COMMERCE_PREFERENCE_NHL_TEAMS", 
            
              __src."COMMERCE_PREFERENCE_MLB_TEAMS", 
            
              __src."COMMERCE_PRODUCT_PLAYER_NAME", 
            
              __src."COMMERCE_PRODUCT_PLAYER_DESCRIPTION", 
            
              __src."COMMERCE_PRODUCT_TEAM"
            
          from ( WITH product_lkp_properties AS (
    SELECT
        pl.product_id,
        po.value:name::string AS name,
        po.value:value::string AS value
    FROM MDE_DEV.MDE_CORE.product_lkp AS pl,
        LATERAL FLATTEN(INPUT => pl.propertyvalues) AS po
),

product_lkp_properties_pivot AS (
    SELECT *
    FROM product_lkp_properties
    PIVOT (MAX(value) FOR name IN ('League', 'PrimaryOrganization')) AS p
),

preference_base AS (
    SELECT
        fkfim.fan_id AS private_fan_id,
        actor_lkp.actor_type_nm AS commerce_product_player_description,
        actor_lkp.actor_nm AS commerce_product_player_name,
        plp."'League'" AS commerce_product_league,
        plp."'PrimaryOrganization'" AS commerce_product_team,
        MAX(COALESCE(purch_dtl.order_ts, purch_dtl.processing_timestamp)) AS last_ordered_timestamp,
        COUNT(*) AS row_count
    FROM COMMERCE_DEV.ORDERS.fct_purchase_dtl AS purch_dtl
    INNER JOIN COMMERCE_DEV.FAN_KEY.fan_key_fan_id_map AS fkfim
        ON purch_dtl.fan_key = fkfim.fan_key
    LEFT JOIN product_lkp_properties_pivot AS plp
        ON purch_dtl.product_id = plp.product_id
    LEFT JOIN MDE_DEV.MDE_CORE.actor_lkp AS actor_lkp
        ON purch_dtl.actor_id = actor_lkp.actor_id
    WHERE
        purch_dtl.fan_key IS NOT NULL
        AND fkfim.fan_id IS NOT NULL
    GROUP BY ALL
),

league_agg AS (
    SELECT
        private_fan_id,
        commerce_product_league,
        MAX(last_ordered_timestamp) AS last_ordered_timestamp,
        SUM(row_count) AS total_count
    FROM preference_base
    WHERE commerce_product_league IS NOT NULL
    GROUP BY ALL
),

league_pfi AS (
    SELECT
        private_fan_id,
        commerce_product_league
    FROM league_agg
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY total_count DESC, last_ordered_timestamp DESC, commerce_product_league ASC
    ) = 1
),

mdm_teams AS (
    SELECT DISTINCT
        LOWER(league_nm) AS league_nm,
        LOWER(team_nm) AS team_nm
    FROM commerce_mde.mde_info.team_lkp_v
),

league_team_base AS (
    SELECT DISTINCT
        private_fan_id,
        LOWER(commerce_product_league) AS commerce_product_league_lc,
        LOWER(commerce_product_team) AS commerce_product_team_lc,
        commerce_product_team
    FROM preference_base
),

mdm_check AS (
    SELECT
        b.private_fan_id,
        b.commerce_product_league_lc,
        CASE WHEN t.team_nm IS NOT NULL THEN b.commerce_product_team_lc END AS commerce_product_team,
        t.league_nm
    FROM league_team_base AS b
    LEFT JOIN mdm_teams AS t
        ON b.commerce_product_team_lc = t.team_nm
),

league_team_pfi AS (
    SELECT
        private_fan_id,
        MAX(CASE WHEN commerce_product_league_lc = 'nfl' THEN 1 ELSE 0 END) AS commerce_preference_nfl,
        MAX(CASE WHEN commerce_product_league_lc = 'college' THEN 1 ELSE 0 END) AS commerce_preference_ncaa,
        MAX(CASE WHEN commerce_product_league_lc = 'nba' THEN 1 ELSE 0 END) AS commerce_preference_nba,
        MAX(CASE WHEN commerce_product_league_lc = 'nhl' THEN 1 ELSE 0 END) AS commerce_preference_nhl,
        MAX(CASE WHEN commerce_product_league_lc = 'mlb' THEN 1 ELSE 0 END) AS commerce_preference_mlb,
        
    ARRAY_AGG(DISTINCT CASE WHEN commerce_product_league_lc = 'nfl' AND league_nm = 'nfl' THEN commerce_product_team END ) WITHIN GROUP (ORDER BY CASE WHEN commerce_product_league_lc = 'nfl' AND league_nm = 'nfl' THEN commerce_product_team END )
 AS commerce_preference_nfl_teams,
        
    ARRAY_AGG(DISTINCT CASE WHEN commerce_product_league_lc = 'college' AND league_nm = 'college' THEN commerce_product_team END ) WITHIN GROUP (ORDER BY CASE WHEN commerce_product_league_lc = 'college' AND league_nm = 'college' THEN commerce_product_team END )
 AS commerce_preference_ncaa_teams,
        
    ARRAY_AGG(DISTINCT CASE WHEN commerce_product_league_lc = 'nba' AND league_nm = 'nba' THEN commerce_product_team END ) WITHIN GROUP (ORDER BY CASE WHEN commerce_product_league_lc = 'nba' AND league_nm = 'nba' THEN commerce_product_team END )
 AS commerce_preference_nba_teams,
        
    ARRAY_AGG(DISTINCT CASE WHEN commerce_product_league_lc = 'nhl' AND league_nm = 'nhl' THEN commerce_product_team END ) WITHIN GROUP (ORDER BY CASE WHEN commerce_product_league_lc = 'nhl' AND league_nm = 'nhl' THEN commerce_product_team END )
 AS commerce_preference_nhl_teams,
        
    ARRAY_AGG(DISTINCT CASE WHEN commerce_product_league_lc = 'mlb' AND league_nm = 'mlb' THEN commerce_product_team END ) WITHIN GROUP (ORDER BY CASE WHEN commerce_product_league_lc = 'mlb' AND league_nm = 'mlb' THEN commerce_product_team END )
 AS commerce_preference_mlb_teams
    FROM mdm_check
    WHERE commerce_product_league_lc IS NOT NULL
    GROUP BY private_fan_id
),

player_agg AS (
    SELECT
        private_fan_id,
        commerce_product_player_description,
        commerce_product_player_name,
        MAX(last_ordered_timestamp) AS last_ordered_timestamp,
        SUM(row_count) AS total_count
    FROM preference_base
    WHERE commerce_product_player_name IS NOT NULL
    GROUP BY ALL
),

player_pfi AS (
    SELECT
        private_fan_id,
        commerce_product_player_description,
        commerce_product_player_name
    FROM player_agg
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY total_count DESC, last_ordered_timestamp DESC, commerce_product_player_name ASC
    ) = 1
),

team_agg AS (
    SELECT
        private_fan_id,
        commerce_product_team,
        MAX(last_ordered_timestamp) AS last_ordered_timestamp,
        SUM(row_count) AS total_count
    FROM preference_base
    WHERE commerce_product_team IS NOT NULL
    GROUP BY ALL
),

team_pfi AS (
    SELECT
        private_fan_id,
        commerce_product_team
    FROM team_agg
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY private_fan_id
        ORDER BY total_count DESC, last_ordered_timestamp DESC, commerce_product_team ASC
    ) = 1
)

SELECT
    COALESCE(lt.private_fan_id, l.private_fan_id, p.private_fan_id, t.private_fan_id) AS private_fan_id,
    l.commerce_product_league,
    COALESCE(lt.commerce_preference_nfl, 0) AS commerce_preference_nfl,
    COALESCE(lt.commerce_preference_ncaa, 0) AS commerce_preference_ncaa,
    COALESCE(lt.commerce_preference_nba, 0) AS commerce_preference_nba,
    COALESCE(lt.commerce_preference_nhl, 0) AS commerce_preference_nhl,
    COALESCE(lt.commerce_preference_mlb, 0) AS commerce_preference_mlb,
    lt.commerce_preference_nfl_teams,
    lt.commerce_preference_ncaa_teams,
    lt.commerce_preference_nba_teams,
    lt.commerce_preference_nhl_teams,
    lt.commerce_preference_mlb_teams,
    p.commerce_product_player_name,
    p.commerce_product_player_description,
    t.commerce_product_team
FROM league_team_pfi AS lt
FULL OUTER JOIN league_pfi AS l ON lt.private_fan_id = l.private_fan_id
FULL OUTER JOIN player_pfi AS p
    ON COALESCE(lt.private_fan_id, l.private_fan_id) = p.private_fan_id
FULL OUTER JOIN team_pfi AS t
    ON COALESCE(lt.private_fan_id, l.private_fan_id, p.private_fan_id) = t.private_fan_id 
          ) as __src
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "1.8.7", "project_name": "fes_data", "target_name": "dev", "target_database": "FDE_DEV", "target_schema": "FDE_STAGE", "invocation_id": "4da07dc3-e2f1-44d1-a315-46ab6ea0b58f", "run_started_at": "2026-04-09T20:49:10.366178+00:00", "full_refresh": false, "which": "run", "node_name": "pfi_commerce_preferences", "node_alias": "pfi_commerce_preferences", "node_package_name": "fes_data", "node_original_file_path": "models/fangraph/private_fan_id/staging/pfi_commerce_preferences.sql", "node_database": "fangraph_dev", "node_schema": "private_fan_id", "node_id": "model.fes_data.pfi_commerce_preferences", "node_resource_type": "model", "node_meta": {}, "node_tags": ["fangraph"], "invocation_command": "dbt run -m fangraph", "node_refs": ["product_lkp", "fct_purchase_dtl", "fan_key_fan_id_map", "actor_lkp"], "materialized": "table", "raw_code_hash": "f70043085c88c172c4120278d41700e9"} */
