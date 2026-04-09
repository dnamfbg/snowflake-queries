-- Query ID: 01c39a27-0212-644a-24dd-0703193d8993
-- Database: FBG_ANALYTICS_DEV
-- Schema: GHIBRIAN_AVILA
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:59:16.074000+00:00
-- Elapsed: 96861ms
-- Environment: FBG

CREATE OR REPLACE TABLE OFFER_USAGE AS

WITH awards AS (

    ---- rewards unpacked
    SELECT
        ats_account_id AS acco_id,
        bonus_campaign AS bc,
        DATE(created_date) AS dt,
        SUM(fancash_amount) AS awarded_amount
    FROM FBG_SOURCE.FANX_MONGODB.FANCASH
    WHERE bonus_campaign IN ('1004794','1004793','221031','220955','154338','154337','154336','153594','172028')
    GROUP BY ALL

    UNION

    ----- punch card
    SELECT
        ats_account_id AS acco_id,
        bonus_campaign AS bc,
        DATE(created_date) AS dt,
        SUM(fancash_amount) AS awarded_amount
    FROM FBG_SOURCE.FANX_MONGODB.FANCASH
    WHERE bonus_campaign = '1010364'
    GROUP BY ALL

    UNION

    ---- deposit match
    SELECT
        ats_account_id AS acco_id,
        bonus_campaign AS bc,
        DATE(created_date) AS dt,
        SUM(fancash_amount) * .6 AS awarded_amount
    FROM FBG_SOURCE.FANX_MONGODB.FANCASH
    WHERE bonus_campaign IN ('1027079','1028359')
    GROUP BY ALL

    UNION

    ---- EL Profit Boost used-side logic unchanged
    SELECT
        account_id AS acco_id,
        promotion_id AS bc,
        MAX(wager_settlement_time_alk) AS dt,
        MAX(NVL(WAGER_BOOST_TOKEN_PAYOUT,0)) AS awarded_amount
    FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART
    WHERE promotion_id IN (
        SELECT DISTINCT id AS bonus_id
        FROM FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS
        WHERE PARSE_JSON(data):Bonus:bonusCode::STRING ILIKE '%el_50pbt%'
          AND PARSE_JSON(data):Bonus:oddsBoost:boostPercentage::FLOAT = 50.0
    )
      AND DATE(wager_settlement_time_alk) >= '2025-11-01'
    GROUP BY ALL

    UNION

    -- Other Campaigns
    SELECT
        acco_id,
        bonus_campaign_id AS bc,
        DATE(trans_date) AS dt,
        SUM(amount) AS awarded_amount
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS
    WHERE bonus_campaign_id IN (
        SELECT DISTINCT bonus_campaign_id
        FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.BONUS_CATEGORIES
        WHERE subcategory = 'Early Life'
    )
       OR bonus_campaign_id IN (1031002, 1040090)
    GROUP BY ALL
),

vt AS (

    WITH acq_temp AS (
        SELECT
            acm.acco_id,
            sportsbook_ftu_date_alk
        FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQUISITION_CUSTOMER_MART acm
        INNER JOIN awards
            ON awards.acco_id = acm.acco_id
    ),

    handle_temp AS (
        SELECT
            account_id AS acco_id,
            DATE(sportsbook_ftu_date_alk) AS ftu_date,
            COUNT(DISTINCT DATE(wager_placed_time_alk)) AS active_days,
            SUM(total_cash_stake_by_legs) AS cash_stake,
            COUNT(DISTINCT wager_id) AS num_cash_bets
        FROM acq_temp a
        LEFT JOIN FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART t
            ON t.account_id = a.acco_id
           AND t.wager_placed_time_alk >= a.sportsbook_ftu_date_alk
           AND DATE(t.wager_placed_time_alk) < DATEADD('day',7,DATE(a.sportsbook_ftu_date_alk))
        WHERE total_cash_stake_by_wager > 0
          AND wager_channel = 'INTERNET'
          AND wager_status IN ('SETTLED', 'ACCEPTED')
        GROUP BY ALL
    ),

    value_tier AS (
        SELECT
            a.acco_id,
            CASE
                WHEN cash_stake >= 250 THEN 'high potential'
                ELSE 'low potential'
            END AS value_tier
        FROM handle_temp a
        LEFT JOIN acq_temp b
            ON a.acco_id = b.acco_id
        GROUP BY ALL
    )

    SELECT
        acco_id,
        value_tier
    FROM value_tier
),

acq AS (
    SELECT
        acco_id,
        DATE(sportsbook_ftu_date_alk) AS ftu_date,
        DATE_TRUNC('WEEK', DATE(sportsbook_ftu_date_alk)) AS week_of_ftu_date,
        w2_retained
    FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.ACQUISITION_CUSTOMER_MART
),

used_base AS (
    SELECT
        awards.acco_id,
        p.id,
        vt.value_tier,
        awards.dt,
        awards.awarded_amount,
        awards.bc,
        PARSE_JSON(p.data):Bonus:bonusCode::STRING AS bonus_code,
        PARSE_JSON(p.data):Bonus:name::STRING AS bonus_name,
        CASE
            WHEN PARSE_JSON(p.data):Bonus:bonusCode::STRING = '111325_CAS_LC_PUNCH_CC_50'
                THEN 'OC Punch Card'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Rewards Unpacked%'
                THEN 'Rewards Unpacked'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%VIP%No Sweat Bet%'
                THEN NULL
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%No Sweat Bet%'
              OR PARSE_JSON(p.data):Bonus:bonusCode::STRING ILIKE '%NSB%'
                THEN 'No Sweat Bet'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Live Profit Boost%'
              OR PARSE_JSON(p.data):Bonus:bonusCode::STRING ILIKE '%LivePBT%'
                THEN 'Live Profit Boost'
            WHEN PARSE_JSON(p.data):Bonus:bonusCode::STRING ILIKE '%el_50pbt%'
              OR PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%EL Profit Boost%'
                THEN 'Profit Boost'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Early Life Punch Card%'
              OR PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%OSB Punch Card%'
                THEN 'OSB Punch Card'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Deposit Match up to $100%'
                THEN 'Deposit Match up to $100'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Deposit Match up to $50%'
                THEN 'Deposit Match up to $50'
            WHEN PARSE_JSON(p.data):Bonus:name::STRING ILIKE '%Deposit Match%'
                THEN 'Deposit Match'
            ELSE PARSE_JSON(p.data):Bonus:name::STRING
        END AS promo_group,
        1 AS used_flag,
        0 AS eligible_flag
    FROM awards
    LEFT JOIN vt
        ON vt.acco_id = awards.acco_id
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS p
        ON p.id = awards.bc
),

used_final AS (
    SELECT
        u.acco_id,
        u.id,
        u.value_tier,
        u.dt,
        u.awarded_amount,
        u.bc,
        u.bonus_code,
        u.bonus_name,
        u.promo_group,
        u.used_flag,
        u.eligible_flag
    FROM used_base u
    WHERE u.promo_group IS NOT NULL
),

eligible_final AS (

    /* OSB Punch Card */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'OSB Punch Card' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE a.customer_segments_id = 190190

    UNION ALL

    /* OC Punch Card */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'OC Punch Card' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE a.customer_segments_id = 165264

    UNION ALL

    /* Rewards Unpacked */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'Rewards Unpacked' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    JOIN FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
        ON a.customer_segments_id = cs.id
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE TO_VARCHAR(cs.data) ILIKE '%FCPack%'
       OR TO_VARCHAR(cs.data) ILIKE '%Welcome Pack%'
       OR TO_VARCHAR(cs.data) ILIKE '%Starter Pack%'

    UNION ALL

    /* Live Profit Boost */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'Live Profit Boost' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    JOIN FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
        ON a.customer_segments_id = cs.id
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE TO_VARCHAR(cs.data) ILIKE '%LivePBT%'
       OR TO_VARCHAR(cs.data) ILIKE '%Live Profit Boost%'

    UNION ALL

    /* Deposit Match up to $100 */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'Deposit Match up to $100' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    JOIN FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
        ON a.customer_segments_id = cs.id
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE TO_VARCHAR(cs.data) ILIKE '%100dm%'

    UNION ALL

    /* Deposit Match up to $50 */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'Deposit Match up to $50' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
    JOIN FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
        ON a.customer_segments_id = cs.id
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE TO_VARCHAR(cs.data) ILIKE '%50dm%'

    UNION ALL

    /* Profit Boost - narrowed to 50PBT and not Live */
    SELECT DISTINCT
        a.accounts_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(a.created) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'Profit Boost' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS cs
    JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNT_SEGMENTS a
        ON a.customer_segments_id = cs.id
    LEFT JOIN vt
        ON vt.acco_id = a.accounts_id
    WHERE TO_VARCHAR(cs.data) ILIKE '%50PBT%'
      AND TO_VARCHAR(cs.data) NOT ILIKE '%LIVE%'
      AND cs.created >= '2026-01-01'

    UNION ALL

    /* No Sweat Bet */
    SELECT DISTINCT
        t.account_id AS acco_id,
        NULL AS id,
        vt.value_tier,
        DATE(t.wager_settlement_time_alk) AS dt,
        0 AS awarded_amount,
        NULL AS bc,
        NULL AS bonus_code,
        NULL AS bonus_name,
        'No Sweat Bet' AS promo_group,
        0 AS used_flag,
        1 AS eligible_flag
    FROM FBG_ANALYTICS_ENGINEERING.TRADING.TRADING_SPORTSBOOK_MART t
    LEFT JOIN vt
        ON vt.acco_id = t.account_id
    WHERE t.promotion_id IN (
        SELECT DISTINCT id
        FROM FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS
        WHERE PARSE_JSON(data):Bonus:bonusCode::STRING ILIKE '%NSB%'
          AND PARSE_JSON(data):Bonus:bonusCode::STRING NOT ILIKE '%exclu%'
          AND COALESCE(PARSE_JSON(data):Bonus:name::STRING, '') NOT ILIKE '%VIP%'
    )
      AND DATE(t.wager_settlement_time_alk) >= '2025-11-01'
),

combined AS (
    SELECT * FROM used_final
    UNION ALL
    SELECT * FROM eligible_final
)

SELECT
    c.acco_id,
    c.id,
    c.value_tier,
    c.dt,
    c.awarded_amount,
    c.bc,
    c.bonus_code,
    c.bonus_name,
    c.promo_group,
    c.used_flag,
    c.eligible_flag,
    acq.ftu_date,
    acq.week_of_ftu_date,
    CASE
        WHEN acq.ftu_date <= DATEADD('day', -14, CURRENT_DATE()) THEN 1
        ELSE 0
    END AS w2_eligible_flag,
    acq.w2_retained
FROM combined c
LEFT JOIN acq
    ON acq.acco_id = c.acco_id
;
