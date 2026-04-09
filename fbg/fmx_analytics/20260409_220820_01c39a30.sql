-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe27f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:20.044000+00:00
-- Elapsed: 1715ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.stg_sigma_manual_marketing_spend
    
    
    
    as (WITH latest_versions AS ( --noqa: disable=all
    SELECT
        "ID",
        MAX(row_version) AS max_row_version
    FROM FMX_ANALYTICS.SIGMA_FMX."SIGDS_c8a3a33c_fd65_4904_a156_8b43d89fef69"
    GROUP BY "ID"
)

SELECT
    src."ID" AS spend_id,
    src."JY-T_EQ42C" AS channel_group,
    src."2QRTXZK106" AS partner,
    src.wxggi19_ro AS subpartner,
    src.gkab10c0pa AS media_source,
    src.onnnmc_krq AS campaign,
    src.ihcjqzyed2 AS spend_amount,
    src.row_version,
    DATE(src.rwewhooj06) AS spend_start_date,
    DATE(src.l31duhrebf) AS spend_end_date
FROM FMX_ANALYTICS.SIGMA_FMX."SIGDS_c8a3a33c_fd65_4904_a156_8b43d89fef69" AS src
INNER JOIN latest_versions AS lv
    ON
        src."ID" = lv."ID"
        AND src.row_version = lv.max_row_version
WHERE src.ihcjqzyed2 > 0
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_sigma_manual_marketing_spend", "profile_name": "user", "target_name": "default"} */
