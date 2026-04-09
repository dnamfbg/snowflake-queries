-- Query ID: 01c39a0b-0112-6f44-0000-e307218b1f3e
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_FES_ANALYST_XL_WH
-- Executed: 2026-04-09T21:31:47.195000+00:00
-- Elapsed: 44329ms
-- Environment: FES

WITH commerce_earns AS (
    -- Get all fancash earned from commerce orders in last 60 days
    SELECT
        loyalty_account_id,
        loyalty_txn_id AS earn_txn_id,
        order_id AS commerce_order_id,
        txn_amount AS earned_amount,
        creation_time AS earn_time,
        hashed_email,
        external_reference_id
    FROM loyalty.loyalty_core.loyalty_analytics_ledger
    WHERE
        STARTSWITH(txn_status, 'ADD')
        AND tenant_id = '100001'  -- Commerce tenant
        AND order_id IS NOT NULL
        AND txn_amount > 0
        AND creation_time >= DATEADD(DAY, -60, CURRENT_DATE)
),

fbg_burns_of_commerce_fc AS (
    -- Find burns on FBG that used fancash earned from commerce
    -- The mapper table tracks which specific earn funded which burn via FIFO
    -- txn_amount here shows HOW MUCH of this burn came from this specific Commerce earn
    SELECT
        mapper.loyalty_account_id,
        mapper.earn_txn_id,
        mapper.redeem_txn_id,
        mapper.earn_order_id AS commerce_order_id,
        mapper.txn_amount AS burned_amount_from_commerce,
        mapper.creation_time AS burn_time,
        mapper.is_void_redeem
    FROM loyalty.loyalty_core.loyalty_earn_burn_mapper AS mapper
    WHERE
        mapper.earn_tenant_id = '100001'  -- Earned from commerce
        AND mapper.tenant_id = '100002'  -- Burned on FBG
        AND mapper.creation_time >= DATEADD(DAY, -60, CURRENT_DATE)
),

-- Get total burn amount for each redeem transaction
total_burn_amounts AS (
    SELECT
        redeem_txn_id,
        loyalty_account_id,
        SUM(txn_amount) AS total_burned
    FROM loyalty.loyalty_core.loyalty_earn_burn_mapper
    WHERE
        tenant_id = '100002'  -- FBG burns
        AND creation_time >= DATEADD(DAY, -60, CURRENT_DATE)
    GROUP BY redeem_txn_id, loyalty_account_id
),

-- Get balance before Commerce earn by looking at the most recent transaction before the earn
-- The fancash_balance column in ledger is a running balance (balance AFTER that transaction)
prior_transactions AS (
    SELECT
        e.loyalty_account_id,
        e.earn_txn_id,
        e.earn_time,
        l.fancash_balance,
        l.creation_time,
        ROW_NUMBER() OVER (
            PARTITION BY e.loyalty_account_id, e.earn_txn_id
            ORDER BY l.creation_time DESC
        ) AS rn
    FROM commerce_earns AS e
    LEFT JOIN loyalty.loyalty_core.loyalty_analytics_ledger AS l
        ON e.loyalty_account_id = l.loyalty_account_id
        AND l.creation_time < e.earn_time
),

balance_before_earn AS (
    SELECT
        loyalty_account_id,
        earn_txn_id,
        COALESCE(fancash_balance, 0) AS balance_before_commerce_earn
    FROM prior_transactions
    WHERE rn = 1
),

commerce_cancellations AS (
    -- Get all commerce order cancellations (fancash clawbacks) in last 60 days
    -- When FC is already burned, clawback creates additional redemption to offset against remaining balance
    SELECT
        loyalty_account_id,
        loyalty_txn_id AS cancel_txn_id,
        order_id AS cancelled_order_id,
        creation_time AS cancel_time,
        txn_amount AS clawed_back_amount
    FROM loyalty.loyalty_core.loyalty_analytics_ledger
    WHERE
        txn_status = 'VOID_1'
        AND loyalty_txn_reason = 'reclaimed_fancash'
        AND tenant_id = '100001'  -- Commerce cancellations
        AND creation_time >= DATEADD(DAY, -60, CURRENT_DATE)
)

-- Combine to find the fraud pattern
SELECT
    e.loyalty_account_id,
    e.hashed_email,
    e.commerce_order_id,
    e.earn_txn_id,
    e.earned_amount,
    e.earn_time,
    bal.balance_before_commerce_earn,
    b.redeem_txn_id,
    b.burned_amount_from_commerce,
    tb.total_burned,
    ROUND(b.burned_amount_from_commerce * 100.0 / NULLIF(tb.total_burned, 0), 2) AS pct_burn_from_clawed_commerce,
    b.burn_time,
    c.cancel_txn_id,
    c.clawed_back_amount,
    c.cancel_time,
    DATEDIFF('hour', e.earn_time, b.burn_time) AS hours_earn_to_burn,
    DATEDIFF('hour', b.burn_time, c.cancel_time) AS hours_burn_to_cancel,
    DATEDIFF('hour', e.earn_time, c.cancel_time) AS hours_earn_to_cancel,
    -- Flag if burn wouldn't have been possible without the Commerce FC
    CASE
        WHEN bal.balance_before_commerce_earn < tb.total_burned THEN TRUE
        ELSE FALSE
    END AS burn_required_commerce_fc,
    -- Calculate how much of the burn was "unauthorized" (came from clawed-back FC and exceeded prior balance)
    CASE
        WHEN bal.balance_before_commerce_earn < tb.total_burned
            THEN LEAST(b.burned_amount_from_commerce, tb.total_burned - bal.balance_before_commerce_earn)
        ELSE 0
    END AS unauthorized_burn_amount
FROM commerce_earns AS e
INNER JOIN fbg_burns_of_commerce_fc AS b
    ON e.loyalty_account_id = b.loyalty_account_id
    AND e.commerce_order_id = b.commerce_order_id
INNER JOIN total_burn_amounts AS tb
    ON b.redeem_txn_id = tb.redeem_txn_id
    AND b.loyalty_account_id = tb.loyalty_account_id
LEFT JOIN balance_before_earn AS bal
    ON e.loyalty_account_id = bal.loyalty_account_id
    AND e.earn_txn_id = bal.earn_txn_id
INNER JOIN commerce_cancellations AS c
    ON e.loyalty_account_id = c.loyalty_account_id
    AND e.commerce_order_id = c.cancelled_order_id
WHERE
    b.burn_time < c.cancel_time  -- Burned BEFORE cancelling
ORDER BY c.cancel_time DESC
