-- Query ID: 01c399cd-0212-644a-24dd-07031928bd33
-- Database: FBG_ANALYTICS_DEV
-- Schema: KATE_SMOLKO
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:29:09.466000+00:00
-- Elapsed: 1094ms
-- Environment: FBG

insert into "FBG_ANALYTICS_DEV"."KATE_SMOLKO"."DBT_MODELS" select * from "FBG_ANALYTICS_DEV"."KATE_SMOLKO"."DBT_MODELS__tmp_20260409202905978540"
/* {"app": "dbt", "dbt_snowflake_query_tags_version": "2.5.0", "dbt_version": "2026.4.7+4533730", "project_name": "dbt_analytics_engineering", "target_name": "dev", "target_database": "FBG_ANALYTICS_DEV", "target_schema": "KATE_SMOLKO", "invocation_id": "fe539f03-296f-4d16-93de-9aa2fece3bbf", "run_started_at": "2026-04-09T20:28:50.708645+00:00", "full_refresh": true, "which": "run"} */;
