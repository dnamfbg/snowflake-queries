-- Query ID: 01c399f2-0112-6b51-0000-e307218a6e6e
-- Database: FDE_DEV
-- Schema: FDE_STAGE
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T21:06:40.495000+00:00
-- Elapsed: 2313ms
-- Environment: FES

( SELECT "SOURCE", "TARGET" FROM ( SELECT concat('fi-', fan_id) as SOURCE, concat('fk-', fan_key) as TARGET FROM ( SELECT  *  FROM fangraph_dev.admin.fangraph_id_step2_id_mapping_for_graph WHERE ("FAN_ID" IS NOT NULL AND "FAN_KEY" IS NOT NULL))) GROUP BY "SOURCE", "TARGET") UNION ALL ( SELECT "SOURCE", "TARGET" FROM ( SELECT concat('fk-', fan_key) as SOURCE, concat('ai-', account_id) as TARGET FROM ( SELECT  *  FROM fangraph_dev.admin.fangraph_id_step2_id_mapping_for_graph WHERE ("FAN_KEY" IS NOT NULL AND "ACCOUNT_ID" IS NOT NULL))) GROUP BY "SOURCE", "TARGET") UNION ALL ( SELECT "SOURCE", "TARGET" FROM ( SELECT concat('ai-', account_id) as SOURCE, concat('fi-', fan_id) as TARGET FROM ( SELECT  *  FROM fangraph_dev.admin.fangraph_id_step2_id_mapping_for_graph WHERE ("ACCOUNT_ID" IS NOT NULL AND "FAN_ID" IS NOT NULL))) GROUP BY "SOURCE", "TARGET")
