-- Query ID: 01c399c5-0212-67a8-24dd-070319274d37
-- Database: FBG_ANALYTICS_DEV
-- Schema: MATT_CHERNIS
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T20:21:38.779000+00:00
-- Elapsed: 312451ms
-- Environment: FBG

CREATE OR REPLACE TEMP TABLE rg_users AS
WITH Limit_Exclusion AS (
    SELECT DISTINCT acco_id 
    FROM FBG_ANALYTICS.VIP.vip_disqualified
)
, Age_Exclusion AS (
    WITH accounts AS (
        SELECT
            a.id,
            try_parse_json(a.kyc_info):KycInfo:dob::DATE AS dob,
            datediff(YEAR, dob, current_date) - CASE
                WHEN MONTH(dob) > MONTH(current_date)
                OR (
                    MONTH(dob) = MONTH(current_date)
                    AND DAY(dob) > DAY(current_date)
                ) THEN 1
                ELSE 0
            END AS age
        FROM
            FBG_SOURCE.OSB_SOURCE.ACCOUNTS AS a
        WHERE
            1 = 1
            AND age < 25
    )
    SELECT DISTINCT ID AS Acco_ID
    FROM Accounts
),
PAST_SUSPENSIONS AS (
    WITH Timezone AS (
        SELECT *
        FROM FBG_ANALYTICS.REFERENCE_TABLES.STATE_TIMEZONES_MAP
        WHERE IS_PRIMARY_TIMEZONE = 'TRUE'
    ),
    account_history_json AS (
        SELECT modified_acc_id, modified, data
        FROM FBG_SOURCE.OSB_SOURCE.ACCOUNT_HISTORY
    ),
    flatten_data AS (
        SELECT
            try_parse_json(data) AS my_json,
            try_parse_json(data):message AS message,
            ah.modified_acc_id,
            modified,
            try_parse_json(data):source AS source,
            key AS action,
            CASE
                WHEN key = 'blockAccount' OR source = 'blockAccount' THEN
                    CASE WHEN try_parse_json(data):message ILIKE '%timeout%' THEN 'TIMEOUT' ELSE 'SUSPENDED' END
                WHEN key IN ('Account UnBlocked', 'unblockAccount') OR source = 'unblockAccount' THEN 'ACTIVE'
                ELSE NULL
            END AS account_status
        FROM
            account_history_json ah,
            lateral flatten (input => my_json) j
        WHERE
            1 = 1
            AND (
                key IN ('blockAccount', 'Account UnBlocked', 'unblockAccount')
                OR source IN ('blockAccount', 'Account UnBlocked', 'unblockAccount')
            )
            AND message ilike '%suspended%'
    )
    SELECT DISTINCT E.id
    FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS E
    INNER JOIN flatten_data H ON E.ID = H.modified_acc_id
),
STATE_EXCLUSIONS AS (
    WITH account AS (
        WITH account_info AS (
            SELECT
                a.id, a.name,
                UPPER(substr(a.name, 1, 1)) as first_name_initial,
                UPPER(regexp_substr(a.name, '[^ ]+', 1, 2)) as last_name,
                try_parse_json(contact_details):ContactDetail:postCode::varchar as postal_code,
                (try_parse_json(KYC_INFO):KycInfo:dob)::date as date_of_birth,
                (try_parse_json(KYC_INFO):KycInfo:ssnLast4Digits)::varchar AS ssn_last_4_digits,
                try_parse_json(contact_details):ContactDetail:address1::varchar as address
            FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS a
            WHERE test = 0 AND status = 'ACTIVE'
        ),
        state_exc AS (
            SELECT
                DISTINCT ssn AS SE_SSN_last_4_digits,
                first_name AS SE_first_name,
                UPPER(SUBSTR(FIRST_NAME, 1, 1)) AS SE_first_name_initial,
                UPPER(LAST_NAME) as SE_last_name,
                DOB AS SE_date_of_birth,
                STREET_ADDRESS1 AS SE_address,
                status se_status
            FROM FBG_SOURCE.OSB_SOURCE.state_exclusions se
        )
        SELECT
            ai.id,
            ai.ssn_last_4_digits, se.se_ssn_last_4_digits,
            JAROWINKLER_SIMILARITY(ssn_last_4_digits, se_ssn_last_4_digits) as ssn_similarity_score,
            ai.first_name_initial, se.se_first_name_initial,
            JAROWINKLER_SIMILARITY(ai.first_name_initial, se.se_first_name_initial) as first_name_similarity_score,
            ai.last_name, se.se_last_name,
            JAROWINKLER_SIMILARITY(ai.last_name, se.se_last_name) as last_name_similarity_score,
            ai.address, se.SE_address,
            JAROWINKLER_SIMILARITY(ai.address, se.SE_address) as address_similarity_score,
            ai.date_of_birth, se.se_date_of_birth,
            DATEDIFF(DAY, ai.date_of_birth, se.se_date_of_birth) as date_difference,
            (
                JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 1), SPLIT_PART(se.se_date_of_birth, '-', 1))
                + JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 2), SPLIT_PART(se.se_date_of_birth, '-', 2))
                + JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 3), SPLIT_PART(se.se_date_of_birth, '-', 3))
            ) / 3 as dob_split_avg_similarity_score,
            CASE
                WHEN (dob_split_avg_similarity_score >= 80 AND last_name_similarity_score >= 80)
                    THEN 'Bucket 1 - SSN, FNI, DOB>80, LN>80'
                WHEN (dob_split_avg_similarity_score < 80 OR last_name_similarity_score < 80)
                    THEN 'Bucket 2 - SSN, FNI, (DOB<80 OR LN<80)'
                WHEN (ssn_similarity_score = 100 AND dob_split_avg_similarity_score = 100
                      AND first_name_similarity_score = 100 AND last_name_similarity_score AND address_similarity_score < 100)
                    THEN 'Bucket 4 - Full Match - FNI, LN, DOB, SSN, Address<100'
                ELSE NULL
            END AS Bucket,
            se.se_status
        FROM account_info ai
        JOIN state_exc se
            ON ai.ssn_last_4_digits = se.se_ssn_last_4_digits
            AND ai.first_name_initial = se.se_first_name_initial

        UNION ALL

        (
            WITH account_info AS (
                SELECT
                    a.id, a.name,
                    UPPER(substr(a.name, 1, 1)) as first_name_initial,
                    UPPER(regexp_substr(a.name, '[^ ]+', 1, 2)) as last_name,
                    try_parse_json(contact_details):ContactDetail:postCode::varchar as postal_code,
                    (try_parse_json(KYC_INFO):KycInfo:dob)::date as date_of_birth,
                    (try_parse_json(KYC_INFO):KycInfo:ssnLast4Digits)::varchar AS ssn_last_4_digits,
                    try_parse_json(contact_details):ContactDetail:address1::varchar as address,
                    a.status as NATS_status, a.last_login_time, a.creation_date
                FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS a
                WHERE test = 0 AND status = 'ACTIVE'
            ),
            state_exc AS (
                SELECT
                    DISTINCT ssn AS SE_SSN_last_4_digits,
                    first_name AS SE_first_name,
                    UPPER(SUBSTR(FIRST_NAME, 1, 1)) AS SE_first_name_initial,
                    UPPER(LAST_NAME) as SE_last_name,
                    DOB AS SE_date_of_birth,
                    STREET_ADDRESS1 AS SE_address,
                    status se_status
                FROM FBG_SOURCE.OSB_SOURCE.state_exclusions se
            )
            SELECT
                ai.id,
                ai.ssn_last_4_digits, se.se_ssn_last_4_digits,
                JAROWINKLER_SIMILARITY(ssn_last_4_digits, se_ssn_last_4_digits) as ssn_similarity_score,
                ai.first_name_initial, se.se_first_name_initial,
                JAROWINKLER_SIMILARITY(ai.first_name_initial, se.se_first_name_initial) as first_name_similarity_score,
                ai.last_name, se.se_last_name,
                JAROWINKLER_SIMILARITY(ai.last_name, se.se_last_name) as last_name_similarity_score,
                ai.address, se.SE_address,
                JAROWINKLER_SIMILARITY(ai.address, se.SE_address) as address_similarity_score,
                ai.date_of_birth, se.se_date_of_birth,
                DATEDIFF(DAY, ai.date_of_birth, se.se_date_of_birth) as date_difference,
                (
                    JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 1), SPLIT_PART(se.se_date_of_birth, '-', 1))
                    + JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 2), SPLIT_PART(se.se_date_of_birth, '-', 2))
                    + JAROWINKLER_SIMILARITY(SPLIT_PART(ai.date_of_birth, '-', 3), SPLIT_PART(se.se_date_of_birth, '-', 3))
                ) / 3 as dob_split_avg_similarity_score,
                CASE
                    WHEN ((ssn_similarity_score < 100 OR ssn_similarity_score IS NULL) AND dob_split_avg_similarity_score = 100)
                        THEN 'Bucket 3 - FNI, LN, DOB, SSN<100'
                    WHEN (ssn_similarity_score = 100 AND dob_split_avg_similarity_score = 100
                          AND first_name_similarity_score = 100 AND last_name_similarity_score AND address_similarity_score <= 100)
                        THEN 'Bucket 4 - Full Match - FNI, LN, DOB, SSN, Address<=100'
                    ELSE NULL
                END AS Bucket,
                se.se_status
            FROM account_info ai
            JOIN state_exc se
                ON ai.first_name_initial = se.se_first_name_initial
                AND ai.last_name = se.se_last_name
                AND ai.date_of_birth = se.se_date_of_birth
        )
    )
    SELECT DISTINCT id
    FROM account
    WHERE Bucket IN (
        'Bucket 3 - FNI, LN, DOB, SSN<100',
        'Bucket 4 - Full Match - FNI, LN, DOB, SSN, Address<=100'
    )
)

SELECT DISTINCT
    a.acco_id
    , a.status
    , a.stake_factor
FROM
    FBG_ANALYTICS_ENGINEERING.CUSTOMERS.CUSTOMER_MART as a
    LEFT JOIN limit_exclusion le ON a.acco_id = le.acco_id
    LEFT JOIN age_exclusion ae ON a.acco_id = ae.acco_id
    LEFT JOIN past_suspensions ps ON a.acco_id = ps.id
    LEFT JOIN STATE_EXCLUSIONS se ON a.acco_id = se.id
WHERE
    1 = 1
    AND (
        le.acco_id IS NOT NULL
        OR ae.acco_id IS NOT NULL
        OR ps.id IS NOT NULL
        OR se.id IS NOT NULL
        OR a.status <> 'ACTIVE'
        OR a.stake_factor < 0.99
        OR a.is_test_account
        OR a.is_kiosk
    );
