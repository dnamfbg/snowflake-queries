-- Query ID: 01c399e5-0212-67a8-24dd-0703192e340b
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_XSM_WH
-- Executed: 2026-04-09T20:53:42.443000+00:00
-- Elapsed: 1968ms
-- Environment: FBG

WITH gifts AS (
    SELECT DISTINCT
        try_to_number(acco_id) as acco_Id,
       gift_type,
        tracking,
    
    FROM fbg_sheetzu.default.loyalty_gifting_tracker 
    WHERE campaign = 'Masters 2026'

),

users AS (
    SELECT
        g.acco_id,
        cm.status,
        vu.vip_host,
        g.gift_type,
        g.tracking,
    FROM gifts g
    LEFT JOIN FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART cm
        ON g.acco_id = cm.acco_id
    LEFT JOIN FBG_ANALYTICS.VIP.VIP_USER_INFO vu
        ON g.acco_id = vu.acco_id
    WHERE cm.status = 'ACTIVE'
      AND COALESCE(vu.is_test_account, FALSE) = FALSE
)

SELECT DISTINCT
    u.acco_id,
    u.status,
    u.vip_host,
    ou.id AS vip_host_id,
    oa.id AS accountid,
    

    CONCAT(
        'Your customer (', u.acco_id, ') is receiving a Masters Package from Fanatics ONE.',
        'The gift includes a polo, quarter zip and hat. The tracking number is ', u.tracking,
        '.'
    ) AS description,

    DATE('2026-04-13') AS due_date,

    CONCAT(
        u.acco_id, '|', u.tracking, '|', TO_VARCHAR(DATE('2026-04-13'))
    ) AS primary_key

FROM users u
LEFT JOIN FBG_SOURCE.SALESFORCE.O_USER ou
    ON ou.name = u.vip_host
LEFT JOIN FBG_SOURCE.SALESFORCE.O_ACCOUNT oa
    ON TO_CHAR(u.acco_id) = oa.amelco_account__c
WHERE ou.isactive = TRUE
