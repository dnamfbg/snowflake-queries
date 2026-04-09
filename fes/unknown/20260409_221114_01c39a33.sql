-- Query ID: 01c39a33-0112-6029-0000-e307218cbd8a
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T22:11:14.986000+00:00
-- Elapsed: 175ms
-- Environment: FES

WITH loyalty_tier AS (
    SELECT private_fan_id, loyalty_tier 
    FROM FES_USERS.SANDBOX.F1_ATTRIBUTES
    WHERE loyalty_tier = 'ONE black'
)

,profit_metrics AS (
    SELECT 
        he.private_fan_id
        ,md5_hashed_email
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.ecosystem_profit, 0) ELSE 0 END)) AS l12m_ecosystem_profit
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.expected_ecosystem_profit, 0) ELSE 0 END)) AS l12m_e_ecosystem_profit
        ,ROUND(
            0.65 * SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.ecosystem_profit, 0) ELSE 0 END)
          + 0.35 * SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.expected_ecosystem_profit, 0) ELSE 0 END)
        ) AS l12m_blended_eco_profit
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.total_tlc_gross_profit, 0) ELSE 0 END)) AS l12m_tlc_profit
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.commerce_contribution_margin, 0) ELSE 0 END)) AS l12m_commerce_profit    
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.fbg_customer_variable_profit, 0) ELSE 0 END)) AS l12m_fbg_cvp
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.fbg_net_revenue, 0) ELSE 0 END)) AS l12m_fbg_ngr
        ,ROUND(SUM(CASE WHEN he.date_alk >= DATEADD(MONTH, -12, CURRENT_DATE) THEN IFNULL(he.fbg_expected_customer_variable_profit, 0) ELSE 0 
    END)) AS l12m_fbg_eCVP
    FROM FES_USERS.SANDBOX.HASHED_EMAIL_ECO_PROFIT he
    GROUP BY ALL
)

,ranked_customers AS (
    SELECT 
        p.*
        ,ROW_NUMBER() OVER (ORDER BY p.l12m_blended_eco_profit DESC) AS profit_rank
        ,SUM(CASE WHEN p.l12m_blended_eco_profit > 0 THEN p.l12m_blended_eco_profit ELSE 0 END) 
            OVER (ORDER BY p.l12m_blended_eco_profit DESC 
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum_blended_eco_profit
    FROM profit_metrics p
    JOIN loyalty_tier l ON p.private_fan_id = l.private_fan_id
    WHERE p.private_fan_id IS NOT NULL
)

,running_profit_tiers AS (
    SELECT 
        *
        ,CASE 
            WHEN l12m_blended_eco_profit > 0 THEN
                running_sum_blended_eco_profit 
                / SUM(CASE WHEN l12m_blended_eco_profit > 0 
                           THEN l12m_blended_eco_profit ELSE 0 END) OVER ()
            ELSE NULL
        END AS cumulative_profit_pct
        ,CASE
            WHEN l12m_blended_eco_profit <= 0 THEN 'Tier 5'
            WHEN running_sum_blended_eco_profit 
                 / SUM(CASE WHEN l12m_blended_eco_profit > 0 
                            THEN l12m_blended_eco_profit ELSE 0 END) OVER ()
                 <= 0.25 THEN 'Tier 1'
            WHEN running_sum_blended_eco_profit 
                 / SUM(CASE WHEN l12m_blended_eco_profit > 0 
                            THEN l12m_blended_eco_profit ELSE 0 END) OVER ()
                 <= 0.50 THEN 'Tier 2'
            WHEN running_sum_blended_eco_profit 
                 / SUM(CASE WHEN l12m_blended_eco_profit > 0 
                            THEN l12m_blended_eco_profit ELSE 0 END) OVER ()
                 <= 0.75 THEN 'Tier 3'
            ELSE 'Tier 4'
        END AS profit_tier
    FROM ranked_customers
    ORDER BY profit_rank
)

SELECT 
    COUNT(*) AS total_users
    ,tier_5_quartile
    ,TO_CHAR(ROUND(MIN(l12m_blended_eco_profit)), '$999,999,999') AS min_profit
    ,TO_CHAR(ROUND(MAX(l12m_blended_eco_profit)), '$999,999,999') AS max_profit
    ,TO_CHAR(ROUND(AVG(l12m_blended_eco_profit)), '$999,999,999') AS avg_profit
    ,TO_CHAR(ROUND(MEDIAN(l12m_blended_eco_profit)), '$999,999,999') AS med_profit
    ,TO_CHAR(ROUND(SUM(l12m_blended_eco_profit)), '$999,999,999') AS total_profit
FROM (
    SELECT 
        *
        ,NTILE(4) OVER (ORDER BY l12m_blended_eco_profit DESC) AS tier_5_quartile_num
        ,CASE NTILE(4) OVER (ORDER BY l12m_blended_eco_profit DESC)
            WHEN 1 THEN 'T5 - Q1 (least negative)'
            WHEN 2 THEN 'T5 - Q2'
            WHEN 3 THEN 'T5 - Q3'
            WHEN 4 THEN 'T5 - Q4 (most negative)'
        END AS tier_5_quartile
    FROM running_profit_tiers
    WHERE profit_tier = 'Tier 5'
)
GROUP BY ALL
ORDER BY MIN(tier_5_quartile_num);
