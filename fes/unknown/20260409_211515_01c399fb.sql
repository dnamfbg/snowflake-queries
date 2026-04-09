-- Query ID: 01c399fb-0112-6f44-0000-e307218b189a
-- Database: unknown
-- Schema: unknown
-- Warehouse: SNOWFLAKE_INTELLIGENCE_WH
-- Executed: 2026-04-09T21:15:15.767000+00:00
-- Elapsed: 4202ms
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
    a.private_fan_id
    ,fbg_acco_id
   -- ,a.profit_tier
    ,l12m_ecosystem_profit
    ,l12m_e_ecosystem_profit
    ,l12m_fbg_ngr
    ,l12m_fbg_cvp
    ,l12m_fbg_eCVP
    ,l12m_tlc_profit
    ,l12m_commerce_profit
    ,CASE WHEN l12m_blended_eco_profit >= 650000 THEN 'Tier 1'
    WHEN l12m_blended_eco_profit >= 175000 and l12m_blended_eco_profit < 650000 THEN 'Tier 2'
    WHEN l12m_blended_eco_profit >= 75000 and l12m_blended_eco_profit < 175000 THEN 'Tier 3'
    WHEN l12m_blended_eco_profit > 0 AND l12m_blended_eco_profit < 75000 THEN 'Tier 4'
    ELSE 'Tier 5' END AS rounded_profit_tier
FROM running_profit_tiers a
JOIN FANGRAPH.PRIVATE_FAN_ID.PFI_CUSTOMER_MART b ON a.private_fan_id = b.private_fan_id
LEFT JOIN FBG_FDE.FBG_USERS.V_FBG_CUSTOMER_MART c ON b.fbg_acco_id = c.acco_id
AND status = 'ACTIVE'
ORDER BY l12m_ecosystem_profit DESC;
