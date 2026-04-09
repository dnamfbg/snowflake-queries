-- Query ID: 01c39a3c-0212-6e7d-24dd-070319427963
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:20:23.296000+00:00
-- Elapsed: 126386ms
-- Environment: FBG

WITH base AS (
SELECT t.calendar_date AS date
, p.*
FROM fbg_analytics.vip.project_250_campaigns AS p 
INNER JOIN fbg_analytics.product_and_customer.t_calendar AS t 
    ON t.calendar_date >= p.campaign_start_date::DATE
    AND t.calendar_date <= CURRENT_DATE
WHERE p.campaign_name NOT ILIKE '%Follow%Up%' -- remove follow ups with addition of stages
AND p.lead_owner NOT IN ('Tim Riley', 'Kyle McQuillan')
)

, base_helper AS (
SELECT DISTINCT 
lead_id
, lead_owner
, acco_id 
, campaign_name
, campaign_start_date
FROM base
)

, base_helper_final AS (
SELECT DISTINCT 
lead_id
, lead_owner
, acco_id 
FROM base_helper
)

, lead_history AS (
SELECT DISTINCT
ld.lead_id 
, ld.as_of_date 
, ld.lead_owner
, ld.acco_id
, ld.customer_status
, b.campaign_name 
, b.campaign_start_date
FROM fbg_analytics.vip.leads_daily AS ld
INNER JOIN base AS b 
    ON ld.lead_id = b.lead_id 
    AND ld.as_of_date = b.date
)

, lead_status_history AS (
SELECT DISTINCT 
leadid AS lead_id
, TO_TIMESTAMP_TZ(createddate, 'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM')::TIMESTAMP_NTZ AS createddate
, newvalue AS status
, oldvalue AS prev_status
FROM fbg_source.salesforce.o_lead_history
WHERE field = 'Status'
)

, lead_status_history_final AS (
SELECT DISTINCT 
lead_id 
, createddate AS valid_from 
, COALESCE(LEAD(createddate) OVER(PARTITION BY lead_id ORDER BY createddate), '9999-01-01'::TIMESTAMP) AS valid_to 
, status 
, prev_status
FROM lead_status_history
WHERE status != prev_status OR prev_status IS NULL
)

, account_bonus_extracts as (
    select
        a.acco_id,
        a.created,
        -- bc.bonus_campaign_id,
        -- bc.bonus_campaign_name,
        b.bonus_name,
        b.qual_bonus_pct,
        concat(round(b.qual_bonus_pct),'% Offer')::string as offer_selected,
        b.bonus_stakes_amount,
        b.bonus_stakes_amount / b.qual_bonus_pct * 100 as max_qual_deposit_amount,   

        CASE 
          WHEN regexp_substr(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
            TO_NUMBER(CAST(REGEXP_SUBSTR(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) AS NUMBER(12,2)))
          ELSE NULL
        END as fancash_amount, 
        fancash_amount / bonus_stakes_amount as perc_max_deposit,
        fancash_amount / b.qual_bonus_pct * 100 as perc_max_deposit_1,
    
        a.state as account_bonus_state,
        a.modified as last_modified_time,
        
        CASE 
          WHEN regexp_substr(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
            -- convert_timezone(
            TO_TIMESTAMP_NTZ(CAST(REGEXP_SUBSTR(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) AS NUMBER) / 1000)
          ELSE NULL
        END as opt_in_time
    from fbg_source.osb_source.account_bonuses a
    inner join base b 
        on a.bonus_campaign_id = b.bonus_campaign_id
        and a.acco_id = b.acco_id
),

log_ins as (
    select
        b.acco_id,
        b.campaign_name,
        a.last_login_time,
        case when a.last_login_time >= b.campaign_start_date then 1 else 0 end has_logged_on
    from base as b 
    inner join fbg_source.osb_source.accounts as a
        on b.acco_id = a.id 
    where a.test = 0
),

-- deposits as (
--         SELECT a.acco_id
--         , SUM(amount) AS deposits
--         , min(a.completed_at) as deposit_time
--         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
--         INNER JOIN base b
--             on a.acco_id = b.acco_id
--             and a.completed_at >= b.bonus_campaign_start_date
--         WHERE a.status = 'DEPOSIT_SUCCESS'
--         GROUP BY all
--     ),

-- deposits_post_offer as (
--         SELECT a.acco_id
--         , a.completed_at::DATE AS date
--         , SUM(amount) AS deposits_post_offer
--         , min(a.completed_at) as deposit_time
--         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
--         INNER JOIN base_helper b
--             on a.acco_id = b.acco_id
--             and a.completed_at >= b.bonus_campaign_start_date
--         WHERE a.status = 'DEPOSIT_SUCCESS'
--         GROUP BY all
--     ),

deposits_post_offer as (
        SELECT a.acco_id 
        , a.date
        , b.campaign_name
        , SUM(a.final_deposit_amount) AS deposits_post_offer
        , MIN(a.date) AS deposit_time
        FROM fbg_analytics.vip.deposits_withdrawals a 
        INNER JOIN base_helper b 
            ON a.acco_id = b.acco_id
            AND a.date >= b.campaign_start_date::DATE
        GROUP BY ALL
),

first_deposit_post_offer as (
        SELECT a.acco_id 
        , b.campaign_name
        , MIN(a.date) AS first_deposit_date_post_offer
        FROM fbg_analytics.vip.deposits_withdrawals a 
        INNER JOIN base_helper b 
            ON a.acco_id = b.acco_id
            AND a.date >= b.campaign_start_date::DATE
        WHERE a.deposit_amount > 0
        GROUP BY ALL
),

first_deposit_time_post_offer as (
        SELECT a.transaction_account_id AS acco_id
        , b.campaign_name
        , a.trans_date_utc AS first_deposit_time_post_offer
        FROM fbg_analytics_engineering.transactions.transactions_mart AS a 
        INNER JOIN first_deposit_post_offer AS b 
            ON a.transaction_account_id = b.acco_id
            AND a.trans_date_utc::DATE = b.first_deposit_date_post_offer
            AND a.transaction_type = 'DEPOSIT'
        QUALIFY row_number() OVER (PARTITION BY a.transaction_account_id, b.campaign_name ORDER BY a.trans_date_utc ASC) = 1 -- first deposit timestamp
),

-- last_deposit as (
--         SELECT a.acco_id
--         , max(convert_timezone('America/New_York',a.completed_at))::date as last_deposit_date
--         FROM FBG_SOURCE.OSB_SOURCE.DEPOSITS a
--         INNER JOIN base_helper b
--             on a.acco_id = b.acco_id
--         WHERE a.status = 'DEPOSIT_SUCCESS'
--         GROUP BY all
--     ),

last_deposit as (
        SELECT a.acco_id 
        , MAX(a.date) AS last_deposit_date
        FROM fbg_analytics.vip.deposits_withdrawals a 
        INNER JOIN base_helper_final b 
            ON a.acco_id = b.acco_id
        WHERE final_deposit_amount > 0
        GROUP BY ALL
),


-- withdrawals as (
--         SELECT a.account_id AS acco_id, SUM(amount) AS withdrawals, min(a.completed_at) as next_withdrawal
--         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
--         INNER JOIN base b
--             on a.account_id = b.acco_id
--             and a.completed_at >= b.opt_in_time
--         WHERE a.status = 'WITHDRAWAL_COMPLETED'
--         GROUP BY all
--     ),

-- withdrawals_post_offer as (
--         SELECT a.account_id AS acco_id
--         , a.completed_at::DATE AS date
--         , SUM(amount) AS withdrawals_post_offer
--         , min(a.completed_at) as next_withdrawal
--         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
--         INNER JOIN base_helper b
--             on a.account_id = b.acco_id
--             and a.completed_at >= b.bonus_campaign_start_date
--         WHERE a.status = 'WITHDRAWAL_COMPLETED'
--         GROUP BY all
--     ),

withdrawals_post_offer as (
        SELECT a.acco_id 
        , a.date 
        , b.campaign_name
        , SUM(a.final_withdrawal_amount) AS withdrawals_post_offer
        , MIN(a.date) AS next_withdrawal
        FROM fbg_analytics.vip.deposits_withdrawals a 
        INNER JOIN base_helper b 
            ON a.acco_id = b.acco_id 
            AND a.date >= b.campaign_start_date::DATE
        GROUP BY ALL
),

-- last_withdrawal as (
--         SELECT a.account_id AS acco_id
--         , max(convert_timezone('America/New_York',a.completed_at))::date as last_withdrawal_date
--         FROM FBG_SOURCE.OSB_SOURCE.WITHDRAWALS a
--         INNER JOIN base_helper b
--             on a.account_id = b.acco_id
--         WHERE a.status = 'WITHDRAWAL_COMPLETED'
--         GROUP BY all
--     )

last_withdrawal as (
        SELECT a.acco_id 
        , MAX(a.date) AS last_withdrawal_date
        FROM fbg_analytics.vip.deposits_withdrawals a 
        INNER JOIN base_helper_final b 
            ON a.acco_id = b.acco_id 
        WHERE final_withdrawal_amount > 0
        GROUP BY ALL
)


-- oc_stake as (
-- SELECT a.acco_id
-- , sum(stake) AS oc_cash_stake
-- FROM fbg_analytics_engineering.casino.casino_transactions_mart a
-- INNER JOIN account_bonus_extracts b
--     on a.acco_id = b.acco_id
--     and a.placed_time_utc >= b.opt_in_time
-- WHERE fund_type_id = 1
-- GROUP BY ALL
-- )

-- , oc_metrics as (
-- SELECT a.acco_id
-- , sum(ngr) as oc_ngr
-- , sum(expected_ngr) AS oc_engr
-- FROM fbg_analytics_engineering.casino.casino_daily_settled_agg a
-- INNER JOIN account_bonus_extracts b
--     on a.acco_id = b.acco_id
--     and a.settled_date_alk >= b.opt_in_time
-- GROUP BY ALL 
-- ) 

-- , osb_metrics AS (
-- SELECT 
-- account_id as acco_id
-- , sum(total_cash_stake_by_legs) AS osb_cash_stake
-- , sum(total_ngr_by_legs) as osb_ngr
-- , sum(expected_ngr_by_legs) AS osb_engr
-- FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
-- INNER JOIN account_bonus_extracts b
--     on a.account_id = b.acco_id
--     and a.wager_placed_time_utc >= b.opt_in_time
-- WHERE is_test_wager = FALSE 
-- AND wager_status = 'SETTLED'
-- GROUP BY ALL
-- ) 

, oc_stake_post_offer as (
SELECT a.acco_id
, a.placed_time_alk::DATE AS date
, b.campaign_name
, sum(stake) AS oc_cash_stake_post_offer
FROM fbg_analytics_engineering.casino.casino_transactions_mart a
INNER JOIN base_helper b
    on a.acco_id = b.acco_id
    and a.placed_time_alk >= b.campaign_start_date
WHERE fund_type_id = 1
GROUP BY ALL
)

, first_oc_stake_post_offer as (
SELECT a.acco_id
, b.campaign_name
, min(a.placed_time_utc) AS first_oc_cash_stake_time_post_offer
FROM fbg_analytics_engineering.casino.casino_transactions_mart a
INNER JOIN base_helper b
    on a.acco_id = b.acco_id
    and a.placed_time_utc >= b.campaign_start_date
WHERE fund_type_id = 1
AND stake > 0
GROUP BY ALL
)

, oc_metrics_post_offer as (
SELECT a.acco_id
, a.settled_date_alk::DATE AS date
, b.campaign_name
, sum(ngr) as oc_ngr_post_offer
, sum(expected_ngr) AS oc_engr_post_offer
FROM fbg_analytics_engineering.casino.casino_daily_settled_agg a
INNER JOIN base_helper b
    on a.acco_id = b.acco_id
    and a.settled_date_alk >= b.campaign_start_date
GROUP BY ALL 
) 

, osb_metrics_post_offer AS (
SELECT 
account_id as acco_id
, a.wager_placed_time_alk::DATE AS date
, b.campaign_name
, sum(total_cash_stake_by_legs) AS osb_cash_stake_post_offer
, sum(CASE WHEN wager_status = 'SETTLED' THEN total_ngr_by_legs END) as osb_ngr_post_offer
, sum(CASE WHEN wager_status = 'SETTLED' THEN expected_ngr_by_legs END) AS osb_engr_post_offer
FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
INNER JOIN base_helper b
    on a.account_id = b.acco_id
    and a.wager_placed_time_alk >= b.campaign_start_date
WHERE is_test_wager = FALSE 
--AND wager_status = 'SETTLED'
GROUP BY ALL
)

, first_osb_stake_post_offer AS (
SELECT 
account_id as acco_id
, b.campaign_name
, MIN(a.wager_placed_time_utc) AS first_osb_cash_stake_time_post_offer
FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
INNER JOIN base_helper b
    on a.account_id = b.acco_id
    and a.wager_placed_time_utc >= b.campaign_start_date
WHERE is_test_wager = FALSE 
AND total_cash_stake_by_legs > 0
GROUP BY ALL
)

, osb_open_metrics_post_offer AS (
SELECT 
account_id as acco_id
, sum(total_cash_stake_by_legs) AS osb_open_cash_stake
FROM fbg_analytics_engineering.trading.trading_sportsbook_mart a
INNER JOIN base_helper_final b
    on a.account_id = b.acco_id
WHERE is_test_wager = FALSE 
AND wager_status = 'ACCEPTED'
GROUP BY ALL
)

, current_balance as (
        SELECT a.acco_id, balance as current_balance
        FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES a
        WHERE a.fund_type_id = 1
    )

-- , next_direct_investment as (
--     select 
--         d.acco_id,
--         di.groups as next_trigger,
--         di.offer_date as next_di_offer_date,
--         di.offer as next_di_offer,
--         count(*) over (partition by di.acco_id) num_di_offers
    
--     from base d 
--     left join fbg_analytics.product_and_customer.direct_investments_history di
--     on di.acco_id = d.acco_id
--     and di.offer_date > d.bonus_campaign_start_date
--     where 1=1
--         and di.gets_offer = 'Y'
--         --and offer_date > '2025-08-18'
--         -- and offer_date < '2025-08-25'
--     qualify row_number() over (partition by di.acco_id order by offer_date) = 1
-- )

, pre_offer_activity AS (
SELECT DISTINCT 
cvp.acco_id
, b.campaign_name
, b.campaign_start_date
, SUM(COALESCE(osb_cash_handle, 0) + COALESCE(oc_cash_handle, 0)) AS cash_handle_90_days_pre_offer
FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
INNER JOIN base_helper AS b
    ON cvp.acco_id = b.acco_id
    AND cvp.date < DATE_TRUNC('DAY', b.campaign_start_date)
    AND cvp.date >= DATEADD(DAY, -90, DATE_TRUNC('DAY', b.campaign_start_date))
-- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
--     ON b.campaign_cohort_id = bc.bonus_campaign_id
--     AND cvp.date < DATE_TRUNC('DAY', bc.bonus_campaign_start_date)
--     AND cvp.date >= DATEADD(DAY, -90, DATE_TRUNC('DAY', bc.bonus_campaign_start_date))
GROUP BY ALL
)

, post_offer_activity AS (
SELECT DISTINCT 
cvp.acco_id
, cvp.date
, b.campaign_name
, b.campaign_start_date
, SUM(COALESCE(customer_variable_profit, 0)) AS cvp_post_offer
, SUM(COALESCE(ecustomer_variable_profit, 0)) AS ecvp_post_offer
FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
INNER JOIN base_helper AS b
    ON cvp.acco_id = b.acco_id
    AND cvp.date >= b.campaign_start_date
-- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
--     ON b.campaign_cohort_id = bc.bonus_campaign_id
--     AND cvp.date >= bc.bonus_campaign_start_date
GROUP BY ALL
)

, last_cash_active as (
SELECT DISTINCT 
cvp.acco_id
, MAX(cvp.date) AS last_cash_active_date
FROM fbg_analytics.product_and_customer.customer_variable_profit AS cvp 
INNER JOIN base_helper_final AS b
    ON cvp.acco_id = b.acco_id
-- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
--     ON b.campaign_cohort_id = bc.bonus_campaign_id
--     AND cvp.date >= bc.bonus_campaign_start_date
WHERE cvp.osb_cash_handle > 0 OR cvp.oc_cash_handle > 0
GROUP BY ALL
)

, tier_point_activity AS (
SELECT DISTINCT
c.acco_id 
, b.campaign_name
, SUM(f.tier_points_amount) AS tier_points_since_offer
FROM FDE_FBG_INFO.FDE_FBG_INFO.TIER_POINTS_LEDGER_V AS f 
INNER JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART c 
    ON f.tenant_fan_id = c.tenant_fan_id
INNER JOIN base_helper AS b
    ON c.acco_id = b.acco_id
    AND f.transaction_timestamp > b.campaign_start_date
-- INNER JOIN fbg_p13n.promo_bronze_table.bonus_campaign_extracts AS bc 
--     ON b.campaign_cohort_id = bc.bonus_campaign_id
--     AND f.transaction_timestamp > bc.bonus_campaign_start_date
WHERE COALESCE(f.notes, '') != 'EOY-Rollover'
GROUP BY ALL
)

, last_contacts AS (
SELECT b.lead_id
, MAX(CASE WHEN ld.total_comms_inbound > 0 THEN ld.as_of_date END) AS last_inbound_contact_date
, MAX(CASE WHEN ld.total_comms_outbound > 0 THEN ld.as_of_date END) AS last_outbound_contact_date
FROM fbg_analytics.vip.leads_daily AS ld
INNER JOIN base_helper_final AS b 
    ON ld.lead_id = b.lead_id
GROUP BY ALL
)

, contact_metrics AS (
SELECT DISTINCT 
b.lead_id
, b.campaign_name
, CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
--, CONVERT_TIMEZONE('UTC', 'America/New_York', lc.message_date)::DATE AS date
, SUM(inbound) AS total_comms_inbound
, SUM(CASE WHEN message_type = 'Text' THEN inbound ELSE 0 END) AS texts_inbound
, SUM(CASE WHEN message_type = 'Email' THEN inbound ELSE 0 END) AS emails_inbound
, SUM(CASE WHEN message_type = 'Call' THEN inbound ELSE 0 END) AS calls_inbound
, SUM(outbound) AS total_comms_outbound
, SUM(CASE WHEN message_type = 'Text' THEN outbound ELSE 0 END) AS texts_outbound
, SUM(CASE WHEN message_type = 'Email' THEN outbound ELSE 0 END) AS emails_outbound
, SUM(CASE WHEN message_type = 'Call' THEN outbound ELSE 0 END) AS calls_outbound
FROM fbg_analytics.vip.lead_contact_history AS lc
INNER JOIN base_helper AS b 
    ON lc.lead_id = b.lead_id
    --AND lc.fbg_name = b.lead_owner
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE  >=  b.campaign_start_date::DATE
GROUP BY 
ALL
)

, contact_metrics_detailed AS (
SELECT DISTINCT 
b.campaign_name
, CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::TIMESTAMP AS message_date 
, lc.message_type
, lc.outbound 
, lc.inbound
, lc.subject 
, lc.description 
, lc.lead_id 
, lc.user_phone
, lc.user_email
, lc.fbg_owner_id 
, lc.fbg_name 
, lc.fbg_phone
, lc.fbg_email
FROM fbg_analytics.vip.lead_contact_history AS lc
INNER JOIN base_helper AS b 
    ON lc.lead_id = b.lead_id
    --AND lc.fbg_name = b.lead_owner
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
)

, first_inbound_contact_metrics AS (
SELECT DISTINCT 
lead_id 
, campaign_name 
, MIN(message_date) AS first_inbound_contact_time_post_offer
FROM contact_metrics_detailed
WHERE inbound = 1
GROUP BY ALL
)

, last_contact_metrics_lead_owner AS (
SELECT DISTINCT 
b.lead_id
, b.campaign_name
, MAX(CASE WHEN lc.outbound = 1 THEN CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE END) AS last_outbound_contact_date_lead_owner
, MAX(CASE WHEN lc.outbound = 1 AND lc.message_type = 'Email' THEN CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE END) AS last_outbound_email_date_lead_owner
FROM fbg_analytics.vip.lead_contact_history AS lc
INNER JOIN lead_history AS b 
    ON lc.lead_id = b.lead_id
    AND lc.fbg_name = b.lead_owner
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE = b.as_of_date
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
GROUP BY 
ALL
) 

, contact_metrics_lead_owner AS (
SELECT DISTINCT 
b.lead_id
, b.campaign_name
, CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
, SUM(inbound) AS total_comms_inbound_lead_owner
, SUM(CASE WHEN message_type = 'Text' THEN inbound ELSE 0 END) AS texts_inbound_lead_owner
, SUM(CASE WHEN message_type = 'Email' THEN inbound ELSE 0 END) AS emails_inbound_lead_owner
, SUM(CASE WHEN message_type = 'Call' THEN inbound ELSE 0 END) AS calls_inbound_lead_owner
, SUM(outbound) AS total_comms_outbound_lead_owner
, SUM(CASE WHEN message_type = 'Text' THEN outbound ELSE 0 END) AS texts_outbound_lead_owner
, SUM(CASE WHEN message_type = 'Email' THEN outbound ELSE 0 END) AS emails_outbound_lead_owner
, SUM(CASE WHEN message_type = 'Call' THEN outbound ELSE 0 END) AS calls_outbound_lead_owner
FROM fbg_analytics.vip.lead_contact_history AS lc
INNER JOIN lead_history AS b 
    ON lc.lead_id = b.lead_id
    AND lc.fbg_name = b.lead_owner
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE = b.as_of_date
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
GROUP BY 
ALL
)

, loyalty_tier_metrics AS (
SELECT DISTINCT 
f.acco_id
, b.campaign_name
, f.loyalty_tier AS loyalty_tier_campaign_start
FROM fbg_analytics.product_and_customer.f1_attributes_audits AS f 
INNER JOIN base_helper AS b 
    ON f.acco_id = b.acco_id 
    AND f.as_of_date = b.campaign_start_date::DATE
)

, email_days AS (
SELECT DISTINCT
b.lead_id
, b.campaign_name
, CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE AS date
, MAX(IFF(outbound = 1 AND message_type = 'Email', 1, 0)) AS has_outbound_email
, MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%President of VIP%', 1, 0)) AS has_herm_email
, MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%Fanatics Fest%', 1, 0)) AS has_fanatics_fest_email
, MAX(IFF(outbound = 1 AND message_type = 'Email' AND subject ILIKE '%Fanatics Head of VIP%', 1, 0)) AS has_rob_follow_up_email
FROM fbg_analytics.vip.lead_contact_history AS lc
INNER JOIN base_helper AS b 
    ON lc.lead_id = b.lead_id
    AND CONVERT_TIMEZONE('America/New_York', 'UTC', lc.message_date)::DATE >=  b.campaign_start_date::DATE
GROUP BY ALL
)

, hosting_metrics AS (
SELECT DISTINCT 
b.lead_id 
, b.campaign_name 
, b.acco_id 
, h.as_of_date 
, h.vip_host
FROM fbg_analytics.vip.vip_host_lead_historical AS h 
INNER JOIN base_helper AS b
    ON h.acco_id = b.acco_id 
    AND h.as_of_date >= b.campaign_start_date
)

, first_hosting_metrics AS (
SELECT DISTINCT 
b.lead_id 
, b.campaign_name 
, b.acco_id 
, MIN(CASE WHEN h.vip_host IS NOT NULL THEN h.as_of_date END) AS first_hosted_date_since_campaign
FROM fbg_analytics.vip.vip_host_lead_historical AS h 
INNER JOIN base_helper AS b
    ON h.acco_id = b.acco_id 
    AND h.as_of_date >= b.campaign_start_date
GROUP BY ALL
)

, final__ as (
select distinct
    b.date,
    b.campaign_name,
    DATEDIFF(DAY, b.campaign_start_date::DATE, b.date) AS days_since_offer,
    DATEDIFF(WEEK, b.campaign_start_date::DATE, b.date) AS weeks_since_offer,
    DATEDIFF(WEEK, fdpo.first_deposit_date_post_offer, b.date) AS weeks_since_first_deposit_post_offer,
    DATEDIFF(DAY, fdpo.first_deposit_date_post_offer, b.date) AS days_since_first_deposit_post_offer,
    CASE WHEN days_since_offer <= 7 THEN TRUE ELSE FALSE END AS within_7_days_of_offer,
    CASE WHEN days_since_first_deposit_post_offer <= 7 THEN TRUE ELSE FALSE END AS within_7_days_of_first_deposit,
    CASE WHEN days_since_offer <= 7 THEN '0-7'
            WHEN days_since_offer > 7 AND days_since_offer <= 14 THEN '7-14'
            WHEN days_since_offer > 14 AND days_since_offer <= 21 THEN '14-21'
            WHEN days_since_offer > 21 AND days_since_offer <= 28 THEN '21-28'
            ELSE '28+' END AS date_cohort,
    b.lead_id,
    b.lead_source,
    CASE WHEN b.lead_source_detailed = 'Dynasty Rewards' THEN 'Dynasty Rewards'
         WHEN b.lead_source_detailed = 'Dave & Busters' THEN 'Dave & Busters'
         WHEN b.lead_source_detailed = 'Arbys' THEN 'Arbys' 
         WHEN b.lead_source_detailed = 'Trustly' THEN 'Trustly' ELSE b.lead_subsource END AS lead_subsource,
    lm.acco_id,
    b.campaign_start_date,
    lm.signup_date,
    case when lm.signup_date >= b.campaign_start_date::DATE THEN TRUE ELSE FALSE END AS is_new_signup,
    convert_timezone('UTC', 'America/New_York', l.last_login_time) as last_login_time_est, 
    cm.vip_host,
    ol.ownerid,
    CONCAT(ou.firstname, ' ', ou.lastname) as lead_owner,
    lh.lead_owner AS lead_owner_daily,
    cm.current_value_band,
    cm.f1_loyalty_tier,
    cm.f1_points_tier,
    cm.pseudonym,
    b.campaign_name AS campaign_name_,
    b.bonus_name,
    bc.bonus_campaign_id,
    bc.bonus_campaign_name,
    bc.qual_bonus_pct,
    bc.bonus_stakes_amount,
    bc.max_qual_deposit_amount,
    a.fancash_amount,
    a.perc_max_deposit,
    a.opt_in_time,
    a.last_modified_time,        
    a.account_bonus_state,
    a.offer_selected,
    --a.di_offer_name,
    -- case when account_bonus_state is null and has_logged_on = 0 then 'Not Logged In - Not Used' 
    --      when account_bonus_state is null and has_logged_on = 1 then 'Logged In - Not Used' 
    --      when account_bonus_state = 'OPT_IN' then 'Offer Selected'
    --      when account_bonus_state = 'EXECUTED' then 'DM Executed'
    -- else null end bonus_status,
    case when account_bonus_state = 'AVAILABLE' then 'Logged In - Not Used' 
         when account_bonus_state = 'OPT_IN' then 'Offer Selected'
         when account_bonus_state = 'EXECUTED' then 'DM Executed'
    else 'Not Logged In' end bonus_status,
    case when fancash_amount = bc.bonus_stakes_amount then 1 else 0 end maxed_out,
    -- dep.deposits,
    -- dep.deposit_time,
    deppo.deposits_post_offer,
    deppo.deposit_time as deposit_time_post_offer,
    fdpo.first_deposit_date_post_offer,
    -- wit.withdrawals,
    -- wit.next_withdrawal,
    witpo.withdrawals_post_offer,
    witpo.next_withdrawal as next_withdrawal_post_offer,
    CASE WHEN datediff('day',deppo.deposit_time, witpo.next_withdrawal) < 0 THEN 0 ELSE datediff('day',deppo.deposit_time, witpo.next_withdrawal) END as time_to_withdrawal,
    -- cs.oc_cash_stake,
    cspo.oc_cash_stake_post_offer,
    -- ocm.oc_ngr,
    ocmpo.oc_ngr_post_offer,
    -- ocm.oc_engr,
    ocmpo.oc_engr_post_offer,
    -- osm.osb_cash_stake,
    osmpo.osb_cash_stake_post_offer,
    -- osm.osb_ngr,
    osmpo.osb_ngr_post_offer,
    -- osm.osb_engr,
    osmpo.osb_engr_post_offer,
    cb.current_balance,
    oompo.osb_open_cash_stake,
    -- case when ndi.acco_id is not null then 1 else 0 end di_requalified,
    -- ndi.next_trigger,
    -- datediff(day, a.created, ndi.next_di_offer_date) days_to_new_offer,
    -- ndi.next_di_offer_date,
    -- ndi.next_di_offer,
    -- ndi.num_di_offers,
    initcap(cm.status) as account_status,
    coalesce(poa.cash_handle_90_days_pre_offer, 0) as cash_handle_90_days_pre_offer,
    coalesce(tpa.tier_points_since_offer, 0) as tier_points_since_offer,
    coalesce(deppo.deposits_post_offer, 0) - coalesce(witpo.withdrawals_post_offer, 0) as net_deposits_post_offer,
    coalesce(pooa.cvp_post_offer, 0) AS cvp_post_offer,
    coalesce(pooa.ecvp_post_offer, 0) AS ecvp_post_offer,
    lm.state,
    lm.status_match_submitted_time,
    lm.status_match_tier_name,
    lm.status_match_operator,
    lm.status_match_operator_tier,
    lm.status_match_trial_start,
    lm.status_match_status,
    sm.status_match_tier_points,
    w.wac,
    ld.last_deposit_date,
    lw.last_withdrawal_date,
    lca.last_cash_active_date,
    lc.last_inbound_contact_date,
    lc.last_outbound_contact_date,
    lcml.last_outbound_contact_date_lead_owner,
    lcml.last_outbound_email_date_lead_owner,
    lm.lead_status,
    conm.total_comms_inbound,
    conm.texts_inbound,
    conm.emails_inbound,
    conm.calls_inbound,
    conm.total_comms_outbound,
    conm.texts_outbound,
    conm.emails_outbound,
    conm.calls_outbound,
    conmlo.total_comms_inbound_lead_owner,
    conmlo.texts_inbound_lead_owner,
    conmlo.emails_inbound_lead_owner,
    conmlo.calls_inbound_lead_owner,
    conmlo.total_comms_outbound_lead_owner,
    conmlo.texts_outbound_lead_owner,
    conmlo.emails_outbound_lead_owner,
    conmlo.calls_outbound_lead_owner,
    ltm.loyalty_tier_campaign_start,
    case when (lm.acco_id is not null and cm.status = 'ACTIVE' and dq.acco_id is null and lm.lead_status != 'Disqualified') or (lm.acco_id is null and lm.rg_status = 'RG Passed - Name Cleared' and lm.lead_status != 'Disqualified') then true else false end as can_contact,
    case when (lh.acco_id is not null and lh.customer_status = 'ACTIVE' and dq.acco_id is null and lshf.status != 'Disqualified') or (lh.acco_id is null and lm.rg_status = 'RG Passed - Name Cleared' and lshf.status != 'Disqualified') then true else false end as can_contact_daily,
    case when lm.lead_status = 'Disqualified' then 'Lead Disqualified'
            when lm.acco_id is not null and (cm.status != 'ACTIVE' or dq.acco_id is not null) then 'Account Status Non-Active / Perm DQ'
            when lm.acco_id is null and coalesce(lm.rg_status, 'none') != 'RG Passed - Name Cleared' then 'Lead Not RG Cleared'
            else null end as can_contact_reason,
    case when lshf.status = 'Disqualified' then 'Lead Disqualified'
            when lh.acco_id is not null and (lh.customer_status != 'ACTIVE' or dq.acco_id is not null) then 'Account Status Non-Active / Perm DQ'
            when lh.acco_id is null and coalesce(lm.rg_status, 'none') != 'RG Passed - Name Cleared' then 'Lead Not RG Cleared'
            else null end as can_contact_reason_daily,
    case when coalesce(osb_cash_stake_post_offer, 0) + coalesce(oc_cash_stake_post_offer, 0) > 0 THEN 1 ELSE 0 END AS is_active,
    focs.first_oc_cash_stake_time_post_offer,
    CONVERT_TIMEZONE('UTC', 'America/Anchorage',focs.first_oc_cash_stake_time_post_offer) AS first_oc_cash_stake_time_post_offer_alk,
    fosbs.first_osb_cash_stake_time_post_offer,
    CONVERT_TIMEZONE('UTC', 'America/Anchorage', fosbs.first_osb_cash_stake_time_post_offer) AS first_osb_cash_stake_time_post_offer_alk,
    case when focs.first_oc_cash_stake_time_post_offer is not null or fosbs.first_osb_cash_stake_time_post_offer is not null then least(coalesce(focs.first_oc_cash_stake_time_post_offer, '9999-01-01'), coalesce(fosbs.first_osb_cash_stake_time_post_offer, '9999-01-01')) else null end as first_cash_stake_time_post_offer,
    CONVERT_TIMEZONE('UTC', 'America/Anchorage', first_cash_stake_time_post_offer) AS first_cash_stake_time_post_offer_alk,
    case when coalesce(deposits_post_offer, 0) > 0 THEN 1 ELSE 0 END AS has_deposit,
    fdt.first_deposit_time_post_offer,
    case when coalesce(total_comms_inbound, 0) > 0 THEN 1 ELSE 0 END AS has_response,
    fic.first_inbound_contact_time_post_offer,
    case when coalesce(emails_outbound_lead_owner, 0) > 0 THEN 1 ELSE 0 END AS has_outbound_email_lead_owner,
    case when coalesce(total_comms_outbound_lead_owner, 0) > 0 THEN 1 ELSE 0 END AS has_outbound_contact_lead_owner,
    ed.has_outbound_email,
    ed.has_herm_email,
    ed.has_fanatics_fest_email,
    ed.has_rob_follow_up_email,
    hm.vip_host AS vip_host_daily,
    fhm.first_hosted_date_since_campaign,
    datediff(DAY, b.campaign_start_date, fhm.first_hosted_date_since_campaign) as days_until_first_hosted
from base b 
inner join fbg_source.salesforce.o_lead ol 
on b.lead_id = ol.id 
left join fbg_p13n.promo_bronze_table.bonus_campaign_extracts bc 
on b.bonus_campaign_id = bc.bonus_campaign_id
inner join fbg_analytics.vip.lead_machine lm 
on b.lead_id = lm.lead_id
left join fbg_source.salesforce.o_user ou 
on ol.ownerid = ou.id
left join account_bonus_extracts a 
on lm.acco_id = a.acco_id
and b.bonus_name = a.bonus_name
left join fbg_analytics_engineering.customers.customer_mart cm
on cm.acco_id = lm.acco_id 
left join log_ins l 
on l.acco_id = lm.acco_id
and b.campaign_name = l.campaign_name
-- left join deposits dep
-- on lm.acco_id = dep.acco_id
left join deposits_post_offer deppo
on lm.acco_id = deppo.acco_id
and b.date = deppo.date
and b.campaign_name = deppo.campaign_name
-- left join withdrawals wit
-- on lm.acco_id = wit.acco_id
left join withdrawals_post_offer witpo
on lm.acco_id = witpo.acco_id
and b.date = witpo.date
and b.campaign_name = deppo.campaign_name
-- left join oc_stake cs
-- on lm.acco_id = cs.acco_id
-- left join oc_metrics ocm 
-- on lm.acco_id = ocm.acco_id
-- left join osb_metrics osm 
-- on lm.acco_id = osm.acco_id
left join oc_stake_post_offer cspo
on lm.acco_id = cspo.acco_id
and b.date = cspo.date
and b.campaign_name = cspo.campaign_name
left join oc_metrics_post_offer ocmpo 
on lm.acco_id = ocmpo.acco_id
and b.date = ocmpo.date
and b.campaign_name = ocmpo.campaign_name
left join osb_metrics_post_offer osmpo
on lm.acco_id = osmpo.acco_id
and b.date = osmpo.date
and b.campaign_name = osmpo.campaign_name
left join current_balance cb
on lm.acco_id = cb.acco_id
-- left join next_direct_investment ndi 
-- on ndi.acco_id = lm.acco_id
left join pre_offer_activity poa
on lm.acco_id = poa.acco_id
and b.campaign_name = poa.campaign_name
left join tier_point_activity tpa
on lm.acco_id = tpa.acco_id
and b.campaign_name = tpa.campaign_name
left join post_offer_activity pooa
on lm.acco_id = pooa.acco_id
and b.date = pooa.date
and b.campaign_name = pooa.campaign_name
left join fbg_analytics.vip.vip_wac_historical w
on lm.acco_id = w.acco_id 
and w.iscurrentweek = 1
left join last_deposit ld
on lm.acco_id = ld.acco_id
left join last_withdrawal lw 
on lm.acco_id = lw.acco_id
left join last_cash_active lca
on lm.acco_id = lca.acco_id
left join last_contacts lc 
on b.lead_id = lc.lead_id
left join contact_metrics conm 
on b.lead_id = conm.lead_id
and b.date = conm.date
and b.campaign_name = conm.campaign_name
left join contact_metrics_lead_owner conmlo
on b.lead_id = conmlo.lead_id
and b.date = conmlo.date
and b.campaign_name = conmlo.campaign_name
left join loyalty_tier_metrics ltm 
on lm.acco_id = ltm.acco_id
and b.campaign_name = ltm.campaign_name
left join fbg_analytics.product_and_customer.status_match sm 
on lm.acco_id = sm.acco_id
left join fbg_analytics.vip.vip_disqualified dq 
on lm.acco_id = dq.acco_id
left join first_deposit_post_offer fdpo
on lm.acco_id = fdpo.acco_id
and b.campaign_name = fdpo.campaign_name
and b.date >= first_deposit_date_post_offer
left join osb_open_metrics_post_offer oompo
on lm.acco_id = oompo.acco_id
left join email_days ed 
on b.lead_id = ed.lead_id 
and b.date = ed.date 
and b.campaign_name = ed.campaign_name
left join lead_history lh 
on b.lead_id = lh.lead_id 
and b.date = lh.as_of_date
and b.campaign_name = lh.campaign_name
left join last_contact_metrics_lead_owner lcml
on b.lead_id = lcml.lead_id
and b.campaign_name = lcml.campaign_name
left join lead_status_history_final lshf
on b.lead_id = lshf.lead_id 
and lshf.valid_from <= b.date 
and lshf.valid_to > b.date
left join hosting_metrics hm 
on b.acco_id = hm.acco_id
and b.campaign_name = hm.campaign_name
and b.date = hm.as_of_date
left join first_hosting_metrics fhm 
on b.acco_id = fhm.acco_id
and b.campaign_name = fhm.campaign_name
left join first_deposit_time_post_offer fdt
on b.acco_id = fdt.acco_id
and b.campaign_name = fdt.campaign_name
left join first_oc_stake_post_offer focs 
on b.acco_id = focs.acco_id
and b.campaign_name = focs.campaign_name
left join first_osb_stake_post_offer fosbs 
on b.acco_id = fosbs.acco_id
and b.campaign_name = fosbs.campaign_name
left join first_inbound_contact_metrics fic 
on b.lead_id = fic.lead_id
and b.campaign_name = fic.campaign_name
)

, p250_engaged AS (
select distinct 
lead_id 
, MAX(has_deposit) as deposit_since_campaign 
, MAX(has_response) as response_since_campaign
, MAX(is_active) as active_since_campaign
FROM final__ 
GROUP BY 1
HAVING deposit_since_campaign = 1 OR response_since_campaign = 1 OR active_since_campaign = 1
)

, ftd_post_lead AS (
SELECT DISTINCT 
c.lead_id 
, c.acco_id 
, c.lead_creation_date
, MIN(d.date) AS lead_ftd_date
FROM fbg_analytics.vip.lead_machine AS c
LEFT JOIN FBG_ANALYTICS.VIP.deposits_withdrawals AS d
    ON c.acco_id = d.acco_id
    AND d.date >= c.lead_creation_date
    AND d.deposit_amount > 0
GROUP BY ALL
)

, comp_plan_start AS (
SELECT DISTINCT 
lead_id 
, acco_id 
, coalesce(lead_ftd_date, current_date) AS comp_plan_start_date
FROM ftd_post_lead
)

, tp_earn AS (
SELECT DISTINCT 
c.*
, SUM(COALESCE(a.tier_points_earned, 0)) AS tp_earned_since_comp_plan_start
FROM fbg_analytics.vip.tier_points_daily AS a
INNER JOIN comp_plan_start AS c
    ON a.acco_id = c.acco_id
    AND a.date >= c.comp_plan_start_date
GROUP BY ALL
)

, last_inbound_contact AS (
SELECT DISTINCT 
lead_id 
, MAX(message_date) AS last_inbound
FROM fbg_analytics.vip.lead_contact_history
WHERE inbound = 1 
GROUP BY 1
HAVING last_inbound >= dateadd(day, -30, current_date)
)

, comp_plan AS (
SELECT DISTINCT 
lead_id 
, SUM(proposed_points_earned_that_day_capped) AS points
FROM fbg_analytics.vip.vip_acquisition_comp_plan_quarterly_v2
GROUP BY 1
HAVING points > 0
)

, dup_lead AS (
SELECT DISTINCT acco_id 
, COUNT(*) AS total
FROM fbg_analytics.vip.lead_machine 
GROUP BY 1 
HAVING total > 1
)

select distinct  
lm.lead_owner 
, lm.lead_id
-- , lm.name 
-- , lm.lead_phone
-- , lm.lead_email
, lm.account_status
, lm.state 
, tp.tp_earned_since_comp_plan_start
, l.projected_value_ngr__c
, lm.lead_source
, lm.lead_subsource
, case when lm.lead_source = 'Direct' or lm.lead_subsource != 'Direct' or lm.lead_source != 'Referral' then true else false end as is_direct 
, case when p.lead_id is not null then true else false end as is_p250 
, case when cps.comp_plan_start_date >= dateadd(day, -365, current_date) then true else false end as is_eligible_for_comp_plan
, case when pe.lead_id is null and lic.lead_id is null and c.lead_id is null and d.acco_id is null and lm.lead_status != 'Disqualified' then true else false end as is_reassignment_eligible
from fbg_analytics.vip.lead_machine as lm
left join fbg_analytics.vip.project_250_campaigns as p 
    on lm.lead_id = p.lead_id
left join ftd_post_lead as f 
    on lm.lead_id = f.lead_id
left join fbg_source.salesforce.o_lead as l 
    on lm.lead_id = l.id 
left join p250_engaged as pe 
    on lm.lead_id = pe.lead_id 
left join last_inbound_contact as lic 
    on lm.lead_id = lic.lead_id
left join comp_plan as c 
    on lm.lead_id = c.lead_id
left join dup_lead AS d 
    on lm.acco_id = d.acco_id
left join comp_plan_start as cps 
    on lm.lead_id = cps.lead_id
left join tp_earn as tp 
    on lm.acco_id = tp.acco_id
where coalesce(try_to_number(l.projected_value_ngr__c), 0) >= 50000
and coalesce(tp.tp_earned_since_comp_plan_start, 0) < 10
and lm.lead_owner != 'VIP Registration Submission'
and lm.state in ('AZ', 'CO', 'CT', 'DC', 'IA', 'IL', 'IN', 'KS', 'KY', 'LA', 'MD', 'MA', 'MI', 'MO', 'NJ', 'NY', 'NC', 'OH', 'PA', 'TN', 'VT', 'VA', 'WV', 'WY')
and is_reassignment_eligible = true
and is_eligible_for_comp_plan
and lm.lead_owner not in ('Chris Bukowski', 'Gregg Hiller', 'Michael Bernstein', 'Michael Del Zotto', 'Jamie Fitzsimmons', 'Taylor OBrien', 'Dana White', 'Darren OBrien', 'Will Rolapp', 'Michael Hermalyn', 'Robert Ferrara', 'Taylor Gwiazdon', 'Kyle McQuillan', 'Tim Riley'
)
and lm.name != 'MissingLastName'
--and coalesce(lm.account_status, 'ACTIVE') = 'ACTIVE'
order by 1,3,4 desc
