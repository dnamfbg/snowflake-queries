-- Query ID: 01c39a1d-0112-6ccc-0000-e307218bd64a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:49:20.257000+00:00
-- Elapsed: 1026ms
-- Environment: FES

WITH snowsight_transform_cte as (
    SELECT $1 as "LOYALTY_ACCOUNT_ID", $2 as "EARN_TXN_ID", $3 as "REDEEM_TXN_ID", $4 as "TXN_AMOUNT", $5 as "ORDER_ID", $6 as snowsight_transform_col_to_hide_6, $7 as "CREATION_TIME", $8 as snowsight_transform_col_to_hide_8, $9 as snowsight_transform_col_to_hide_9, $10 as "TENANT_ID", $11 as "EARN_TENANT_ID", $12 as "EARN_LOYALTY_TXN_REASON", $13 as snowsight_transform_col_to_hide_13, $14 as snowsight_transform_col_to_hide_14, $15 as "EARN_ORDER_ID", $16 as snowsight_transform_col_to_hide_16, $17 as snowsight_transform_col_to_hide_17, $18 as snowsight_transform_col_to_hide_18, $19 as snowsight_transform_col_to_hide_19, $20 as snowsight_transform_col_to_hide_20 FROM TABLE(RESULT_SCAN('01c39a1a-0112-6ccc-0000-e307218bd5c6'))
) SELECT * EXCLUDE (snowsight_transform_col_to_hide_6,snowsight_transform_col_to_hide_8,snowsight_transform_col_to_hide_9,snowsight_transform_col_to_hide_13,snowsight_transform_col_to_hide_14,snowsight_transform_col_to_hide_16,snowsight_transform_col_to_hide_17,snowsight_transform_col_to_hide_18,snowsight_transform_col_to_hide_19,snowsight_transform_col_to_hide_20) FROM snowsight_transform_cte;
