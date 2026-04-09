-- Query ID: 01c39a3f-0212-67a9-24dd-07031943149f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:23:14.206000+00:00
-- Elapsed: 9623ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_customer_growth_accounting_daily
    
    
    
    as (select * from (
            



WITH daily_spine AS ( --noqa: disable=all

    SELECT *
    FROM FMX_ANALYTICS.CUSTOMER.cust_fmx_day_grid_growth_accounting

    

),

customers AS (

    SELECT
        acco_id,
        DATE(first_deposit_success_at_alk) AS first_funded_date,
        DATE(first_completed_order_created_at_alk) AS first_order_date

    FROM FMX_ANALYTICS.customer.dim_fmx_core_customer
    WHERE COALESCE(first_deposit_success_at_alk, first_completed_order_created_at_alk) IS NOT NULL

),

orders_daily AS (

    SELECT
        DATE(order_created_at_alk)              AS grid_date,
        account_id                              AS acco_id,
        COUNT_IF(order_status = 'COMPLETED')    AS completed_trades

    FROM FMX_ANALYTICS.CUSTOMER.fct_fmx_core_orders

    WHERE COALESCE(is_test_account, false) = false
    

    GROUP BY 1, 2

),

balances_daily AS (

    SELECT
        DATE(activity_date)                                           AS grid_date,
        account_id                                                    AS acco_id,
        -- Using $5, as over 50% of customers had very small idle balances in their wallet and we do not want to count these
        -- customers for the purposes of funded. However, if a customer has any active balance we consider them funded.
        IFF(total_customer_balance > 5 OR active_funds_usd > 0, 1, 0) AS funded_user
    FROM FMX_ANALYTICS.customer.cust_fmx_customer_daily_balance

    

),

account_daily AS (

    SELECT
        s.growth_accounting_account_day_id,
        s.grid_date,
        s.entity_id,
        s.entity_type,
        s.acco_id,
        s.registration_state,
        s.has_registered_fbg,
        s.first_active_date,
        c.first_funded_date,
        c.first_order_date,
        s.count_events,
        COALESCE(o.completed_trades, 0) AS completed_trades,
        COALESCE(b.funded_user, 0) AS funded_user

    FROM daily_spine s
    LEFT JOIN orders_daily o
        ON  o.acco_id   = s.acco_id
        AND o.grid_date = s.grid_date
    LEFT JOIN customers c
        ON  c.acco_id   = s.acco_id
    LEFT JOIN balances_daily b
        ON  b.acco_id   = s.acco_id
        AND b.grid_date = s.grid_date

),

-- Build a flat (metric, window) pair list so loop.last handles commas correctly
-- across the nested metric × window combinations below.



    
        
    
        
    
        
    

    
        
    
        
    
        
    

    
        
    
        
    
        
    


rolling AS (

    SELECT
        *,

        
        -- active_users 1d
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 0 PRECEDING AND CURRENT ROW
        ) AS active_users_1d,

        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS active_users_prev_1d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS active_users_lagged_1d,

        
        -- active_users 7d
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS active_users_7d,

        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 13 PRECEDING AND 7 PRECEDING
        ) AS active_users_prev_7d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS active_users_lagged_7d,

        
        -- active_users 28d
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 27 PRECEDING AND CURRENT ROW
        ) AS active_users_28d,

        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 55 PRECEDING AND 28 PRECEDING
        ) AS active_users_prev_28d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(count_events) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS active_users_lagged_28d,

        
        -- active_traders 1d
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 0 PRECEDING AND CURRENT ROW
        ) AS active_traders_1d,

        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS active_traders_prev_1d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS active_traders_lagged_1d,

        
        -- active_traders 7d
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS active_traders_7d,

        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 13 PRECEDING AND 7 PRECEDING
        ) AS active_traders_prev_7d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS active_traders_lagged_7d,

        
        -- active_traders 28d
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 27 PRECEDING AND CURRENT ROW
        ) AS active_traders_28d,

        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 55 PRECEDING AND 28 PRECEDING
        ) AS active_traders_prev_28d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(completed_trades) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS active_traders_lagged_28d,

        
        -- funded_users 1d
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 0 PRECEDING AND CURRENT ROW
        ) AS funded_users_1d,

        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS funded_users_prev_1d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING
        ) AS funded_users_lagged_1d,

        
        -- funded_users 7d
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS funded_users_7d,

        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 13 PRECEDING AND 7 PRECEDING
        ) AS funded_users_prev_7d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS funded_users_lagged_7d,

        
        -- funded_users 28d
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 27 PRECEDING AND CURRENT ROW
        ) AS funded_users_28d,

        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 55 PRECEDING AND 28 PRECEDING
        ) AS funded_users_prev_28d,

        -- Activity in the N days immediately before today (i.e. yesterday's current window).
        -- Used in states to guard against the sliding-window edge case: after a CHURN,
        -- prev_Nd stays positive for up to (2N - 1) days. If lagged_Nd = 0, the customer
        -- had no recent activity and a return should be RESURRECTED, not RETAINED.
        SUM(funded_user) OVER (
            PARTITION BY entity_id
            ORDER BY grid_date
            ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
        ) AS funded_users_lagged_28d

        

    FROM account_daily

),

states AS (

    -- Classify each entity-day. Anonymous entities only get active_users states (no state machine);
    -- registered entities go through the full state machine for both metrics.
    SELECT
        *,

        
        CASE
            
            -- ANONYMOUS: PROSPECT_USER if active in window, DORMANT if not. No state machine.
            WHEN entity_type = 'ANONYMOUS' AND active_users_1d > 0
                THEN 'PROSPECT_USER'
            WHEN entity_type = 'ANONYMOUS' AND active_users_1d = 0
                THEN 'DORMANT'
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_active_date IS NULL OR grid_date < first_active_date
                THEN 'PROSPECT_USER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_active_date, grid_date) BETWEEN 0 AND 0
                THEN 'NEW'
            WHEN active_users_prev_1d > 0
             AND active_users_1d = 0
                THEN 'CHURNED'
            WHEN active_users_1d > 0
             AND active_users_lagged_1d > 0
                THEN 'RETAINED'
            WHEN active_users_1d > 0
             AND active_users_lagged_1d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_users_state_1d,

        
        CASE
            
            -- ANONYMOUS: PROSPECT_USER if active in window, DORMANT if not. No state machine.
            WHEN entity_type = 'ANONYMOUS' AND active_users_7d > 0
                THEN 'PROSPECT_USER'
            WHEN entity_type = 'ANONYMOUS' AND active_users_7d = 0
                THEN 'DORMANT'
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_active_date IS NULL OR grid_date < first_active_date
                THEN 'PROSPECT_USER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_active_date, grid_date) BETWEEN 0 AND 6
                THEN 'NEW'
            WHEN active_users_prev_7d > 0
             AND active_users_7d = 0
                THEN 'CHURNED'
            WHEN active_users_7d > 0
             AND active_users_lagged_7d > 0
                THEN 'RETAINED'
            WHEN active_users_7d > 0
             AND active_users_lagged_7d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_users_state_7d,

        
        CASE
            
            -- ANONYMOUS: PROSPECT_USER if active in window, DORMANT if not. No state machine.
            WHEN entity_type = 'ANONYMOUS' AND active_users_28d > 0
                THEN 'PROSPECT_USER'
            WHEN entity_type = 'ANONYMOUS' AND active_users_28d = 0
                THEN 'DORMANT'
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_active_date IS NULL OR grid_date < first_active_date
                THEN 'PROSPECT_USER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_active_date, grid_date) BETWEEN 0 AND 27
                THEN 'NEW'
            WHEN active_users_prev_28d > 0
             AND active_users_28d = 0
                THEN 'CHURNED'
            WHEN active_users_28d > 0
             AND active_users_lagged_28d > 0
                THEN 'RETAINED'
            WHEN active_users_28d > 0
             AND active_users_lagged_28d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_users_state_28d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_order_date IS NULL OR grid_date < first_order_date
                THEN 'PROSPECT_TRADER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_order_date, grid_date) BETWEEN 0 AND 0
                THEN 'NEW'
            WHEN active_traders_prev_1d > 0
             AND active_traders_1d = 0
                THEN 'CHURNED'
            WHEN active_traders_1d > 0
             AND active_traders_lagged_1d > 0
                THEN 'RETAINED'
            WHEN active_traders_1d > 0
             AND active_traders_lagged_1d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_traders_state_1d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_order_date IS NULL OR grid_date < first_order_date
                THEN 'PROSPECT_TRADER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_order_date, grid_date) BETWEEN 0 AND 6
                THEN 'NEW'
            WHEN active_traders_prev_7d > 0
             AND active_traders_7d = 0
                THEN 'CHURNED'
            WHEN active_traders_7d > 0
             AND active_traders_lagged_7d > 0
                THEN 'RETAINED'
            WHEN active_traders_7d > 0
             AND active_traders_lagged_7d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_traders_state_7d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_order_date IS NULL OR grid_date < first_order_date
                THEN 'PROSPECT_TRADER'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_order_date, grid_date) BETWEEN 0 AND 27
                THEN 'NEW'
            WHEN active_traders_prev_28d > 0
             AND active_traders_28d = 0
                THEN 'CHURNED'
            WHEN active_traders_28d > 0
             AND active_traders_lagged_28d > 0
                THEN 'RETAINED'
            WHEN active_traders_28d > 0
             AND active_traders_lagged_28d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS active_traders_state_28d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_funded_date IS NULL OR grid_date < first_funded_date
                THEN 'PROSPECT_FUNDED'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_funded_date, grid_date) BETWEEN 0 AND 0
                THEN 'NEW'
            WHEN funded_users_prev_1d > 0
             AND funded_users_1d = 0
                THEN 'CHURNED'
            WHEN funded_users_1d > 0
             AND funded_users_lagged_1d > 0
                THEN 'RETAINED'
            WHEN funded_users_1d > 0
             AND funded_users_lagged_1d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS funded_users_state_1d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_funded_date IS NULL OR grid_date < first_funded_date
                THEN 'PROSPECT_FUNDED'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_funded_date, grid_date) BETWEEN 0 AND 6
                THEN 'NEW'
            WHEN funded_users_prev_7d > 0
             AND funded_users_7d = 0
                THEN 'CHURNED'
            WHEN funded_users_7d > 0
             AND funded_users_lagged_7d > 0
                THEN 'RETAINED'
            WHEN funded_users_7d > 0
             AND funded_users_lagged_7d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS funded_users_state_7d,

        
        CASE
            
            -- ANONYMOUS: metric not applicable
            WHEN entity_type = 'ANONYMOUS'
                THEN NULL
            
            -- REGISTERED: prospect if no start_date yet or pre-start
            WHEN first_funded_date IS NULL OR grid_date < first_funded_date
                THEN 'PROSPECT_FUNDED'
            -- REGISTERED: state machine
            WHEN DATEDIFF('day', first_funded_date, grid_date) BETWEEN 0 AND 27
                THEN 'NEW'
            WHEN funded_users_prev_28d > 0
             AND funded_users_28d = 0
                THEN 'CHURNED'
            WHEN funded_users_28d > 0
             AND funded_users_lagged_28d > 0
                THEN 'RETAINED'
            WHEN funded_users_28d > 0
             AND funded_users_lagged_28d = 0
                THEN 'RESURRECTED'
            ELSE 'DORMANT'
        END AS funded_users_state_28d

        

    FROM rolling

),

aggregated AS (

    -- Roll up to date + entity_type + registration_state + has_registered_fbg grain.
    SELECT
        md5(cast(coalesce(cast(grid_date as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(entity_type as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(registration_state as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(has_registered_fbg as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS growth_accounting_daily_id,
        grid_date,
        entity_type,
        registration_state,
        has_registered_fbg,

        
        COUNT_IF(active_users_state_1d = 'NEW')                              AS new_active_users_1d,
        COUNT_IF(active_users_state_1d = 'RETAINED')                         AS retained_active_users_1d,
        COUNT_IF(active_users_state_1d = 'CHURNED')                          AS churned_active_users_1d,
        COUNT_IF(active_users_state_1d = 'RESURRECTED')                      AS resurrected_active_users_1d,
        COUNT_IF(active_users_state_1d = 'DORMANT')                          AS dormant_active_users_1d,
        COUNT_IF(active_users_state_1d = 'PROSPECT_USER') AS prospect_user_active_users_1d,
        
        
        COUNT_IF(active_users_state_7d = 'NEW')                              AS new_active_users_7d,
        COUNT_IF(active_users_state_7d = 'RETAINED')                         AS retained_active_users_7d,
        COUNT_IF(active_users_state_7d = 'CHURNED')                          AS churned_active_users_7d,
        COUNT_IF(active_users_state_7d = 'RESURRECTED')                      AS resurrected_active_users_7d,
        COUNT_IF(active_users_state_7d = 'DORMANT')                          AS dormant_active_users_7d,
        COUNT_IF(active_users_state_7d = 'PROSPECT_USER') AS prospect_user_active_users_7d,
        
        
        COUNT_IF(active_users_state_28d = 'NEW')                              AS new_active_users_28d,
        COUNT_IF(active_users_state_28d = 'RETAINED')                         AS retained_active_users_28d,
        COUNT_IF(active_users_state_28d = 'CHURNED')                          AS churned_active_users_28d,
        COUNT_IF(active_users_state_28d = 'RESURRECTED')                      AS resurrected_active_users_28d,
        COUNT_IF(active_users_state_28d = 'DORMANT')                          AS dormant_active_users_28d,
        COUNT_IF(active_users_state_28d = 'PROSPECT_USER') AS prospect_user_active_users_28d,
        
        
        COUNT_IF(active_traders_state_1d = 'NEW')                              AS new_active_traders_1d,
        COUNT_IF(active_traders_state_1d = 'RETAINED')                         AS retained_active_traders_1d,
        COUNT_IF(active_traders_state_1d = 'CHURNED')                          AS churned_active_traders_1d,
        COUNT_IF(active_traders_state_1d = 'RESURRECTED')                      AS resurrected_active_traders_1d,
        COUNT_IF(active_traders_state_1d = 'DORMANT')                          AS dormant_active_traders_1d,
        COUNT_IF(active_traders_state_1d = 'PROSPECT_TRADER') AS prospect_trader_active_traders_1d,
        
        
        COUNT_IF(active_traders_state_7d = 'NEW')                              AS new_active_traders_7d,
        COUNT_IF(active_traders_state_7d = 'RETAINED')                         AS retained_active_traders_7d,
        COUNT_IF(active_traders_state_7d = 'CHURNED')                          AS churned_active_traders_7d,
        COUNT_IF(active_traders_state_7d = 'RESURRECTED')                      AS resurrected_active_traders_7d,
        COUNT_IF(active_traders_state_7d = 'DORMANT')                          AS dormant_active_traders_7d,
        COUNT_IF(active_traders_state_7d = 'PROSPECT_TRADER') AS prospect_trader_active_traders_7d,
        
        
        COUNT_IF(active_traders_state_28d = 'NEW')                              AS new_active_traders_28d,
        COUNT_IF(active_traders_state_28d = 'RETAINED')                         AS retained_active_traders_28d,
        COUNT_IF(active_traders_state_28d = 'CHURNED')                          AS churned_active_traders_28d,
        COUNT_IF(active_traders_state_28d = 'RESURRECTED')                      AS resurrected_active_traders_28d,
        COUNT_IF(active_traders_state_28d = 'DORMANT')                          AS dormant_active_traders_28d,
        COUNT_IF(active_traders_state_28d = 'PROSPECT_TRADER') AS prospect_trader_active_traders_28d,
        
        
        COUNT_IF(funded_users_state_1d = 'NEW')                              AS new_funded_users_1d,
        COUNT_IF(funded_users_state_1d = 'RETAINED')                         AS retained_funded_users_1d,
        COUNT_IF(funded_users_state_1d = 'CHURNED')                          AS churned_funded_users_1d,
        COUNT_IF(funded_users_state_1d = 'RESURRECTED')                      AS resurrected_funded_users_1d,
        COUNT_IF(funded_users_state_1d = 'DORMANT')                          AS dormant_funded_users_1d,
        COUNT_IF(funded_users_state_1d = 'PROSPECT_FUNDED') AS prospect_funded_funded_users_1d,
        
        
        COUNT_IF(funded_users_state_7d = 'NEW')                              AS new_funded_users_7d,
        COUNT_IF(funded_users_state_7d = 'RETAINED')                         AS retained_funded_users_7d,
        COUNT_IF(funded_users_state_7d = 'CHURNED')                          AS churned_funded_users_7d,
        COUNT_IF(funded_users_state_7d = 'RESURRECTED')                      AS resurrected_funded_users_7d,
        COUNT_IF(funded_users_state_7d = 'DORMANT')                          AS dormant_funded_users_7d,
        COUNT_IF(funded_users_state_7d = 'PROSPECT_FUNDED') AS prospect_funded_funded_users_7d,
        
        
        COUNT_IF(funded_users_state_28d = 'NEW')                              AS new_funded_users_28d,
        COUNT_IF(funded_users_state_28d = 'RETAINED')                         AS retained_funded_users_28d,
        COUNT_IF(funded_users_state_28d = 'CHURNED')                          AS churned_funded_users_28d,
        COUNT_IF(funded_users_state_28d = 'RESURRECTED')                      AS resurrected_funded_users_28d,
        COUNT_IF(funded_users_state_28d = 'DORMANT')                          AS dormant_funded_users_28d,
        COUNT_IF(funded_users_state_28d = 'PROSPECT_FUNDED') AS prospect_funded_funded_users_28d
        

    FROM states
    GROUP BY grid_date, entity_type, registration_state, has_registered_fbg

),

final AS (

    SELECT *
    FROM aggregated

    

)

SELECT * FROM final
        )
        order by (
            grid_date 
        )
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_customer_growth_accounting_daily", "profile_name": "user", "target_name": "default"} */
