-- Query ID: 01c399d4-0112-6ccc-0000-e3072189e8fe
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T20:36:31.008000+00:00
-- Elapsed: 2434ms
-- Environment: FES

CREATE  OR  REPLACE    TABLE  fangraph_dev.admin.fangraph_id_step3_subgraphs__dbt_tmp("IDX" BIGINT, "NODES" ARRAY)    AS  SELECT  *  FROM ( SELECT "IDX",  CAST (parse_json("NODES") AS ARRAY) AS "NODES" FROM ( SELECT  *  FROM (SNOWPARK_TEMP_TABLE_JT8PDMOLU6)))
