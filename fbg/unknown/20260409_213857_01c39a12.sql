-- Query ID: 01c39a12-0212-67a9-24dd-0703193961b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T21:38:57.781000+00:00
-- Elapsed: 5964ms
-- Environment: FBG

WITH paysafe AS (
    SELECT
        CONF_NBR,
        SPLIT_PART(ACCOUNT_NAME, ' - ', 2) AS "State Code",
        AVS,
        BRAND,
        MERCHANT_TRANS_ID,
        CARD_BIN AS "Bin",
        CARD_ENDING AS "Last4"
    FROM FBG_SOURCE.PAYSAFE.TRANSACTIONS
    WHERE CONF_NBR IN (
'26316738034',
'26316750224',
'26256837384',
'26316765304',
'26256799534',
'26291351794',
'26034237324',
'26106044764')
),

deposits AS (
    SELECT
        d.trans_ref,
        d.acco_id,
        d.created,
        d.status AS "Deposit Status",
        d.ip_address AS "IP Address",
        d.device_context AS "Device ID",
        v.high_level_segment AS "Segment at Time of Transaction",
        ac.current_value_band AS "Current Segment"
    FROM fbg_source.osb_source.deposits d
    LEFT JOIN fbg_analytics.product_and_customer.value_bands_historical v
        ON d.acco_id = v.acco_id AND TO_DATE(d.created) = v.as_of_date
    LEFT JOIN fbg_analytics_engineering.customers.customer_mart ac
        ON d.acco_id = ac.acco_id
    WHERE d.trans_ref IN (SELECT MERCHANT_TRANS_ID FROM paysafe)
),

cashbalance AS (
    SELECT acco_id, SUM(balance) AS cashbalance
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_BALANCES
    WHERE FUND_TYPE_ID = 1
      AND acco_id IN (SELECT acco_id FROM deposits)
    GROUP BY ALL
),

customer_details AS (
    SELECT
        cm.acco_id,
        cm.f1_loyalty_tier AS "Fanatics One Tier",
        cm.registration_state AS "Registration State",
        cm.status,
        cm.acquisition_bonus_name
    FROM fbg_analytics_engineering.customers.customer_mart cm
    WHERE cm.acco_id IN (SELECT acco_id FROM deposits)
)

SELECT
    p.CONF_NBR,
    p."State Code",
    p.AVS,
    p.BRAND,
    p.MERCHANT_TRANS_ID,
    p."Bin",
    p."Last4",
    dep.trans_ref,
    dep.acco_id,
    dep.created,
    dep."Deposit Status",
    dep."Segment at Time of Transaction",
    dep."Current Segment",
    dep."IP Address",
    dep."Device ID",
    cd."Fanatics One Tier",
    cd."Registration State",
    cd.status,
    cd.acquisition_bonus_name,
    cb.cashbalance AS "Current Cash Balance"
FROM paysafe p
LEFT JOIN deposits dep ON p.MERCHANT_TRANS_ID = dep.trans_ref
LEFT JOIN cashbalance cb ON dep.acco_id = cb.acco_id
LEFT JOIN customer_details cd ON dep.acco_id = cd.acco_id
ORDER BY p.CONF_NBR;
