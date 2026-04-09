-- Query ID: 01c399f6-0112-6b51-0000-e307218afbf2
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:10:49.793000+00:00
-- Elapsed: 2476ms
-- Environment: FES

CREATE  OR  REPLACE    TABLE  fangraph_dev.admin.fangraph_id_step3_subgraphs__dbt_tmp("IDX" BIGINT, "NODES" ARRAY)    AS  SELECT  *  FROM ( SELECT "IDX",  CAST (parse_json("NODES") AS ARRAY) AS "NODES" FROM ( SELECT  *  FROM (SNOWPARK_TEMP_TABLE_E9ELVPA52A)))
