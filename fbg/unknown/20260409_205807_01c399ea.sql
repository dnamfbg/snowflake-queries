-- Query ID: 01c399ea-0212-644a-24dd-0703192f4257
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T20:58:07.433000+00:00
-- Elapsed: 6968ms
-- Environment: FBG

with Deposits1 as(
SELECT Acco_ID,
SUM(Amount) AS LifetimeDeposits
FROM FBG_SOURCE.OSB_SOURCE.Deposits
WHERE Status = 'DEPOSIT_SUCCESS'
GROUP BY ALL),
Withdrawals1 as (
SELECT Account_ID,
SUM(Amount) AS LifetimeWithdrawals
FROM FBG_SOURCE.OSB_SOURCE.Withdrawals
WHERE Status = 'WITHDRAWAL_COMPLETED'
GROUP BY ALL),
Bets1 AS(
SELECT Acco_ID,
SUM(Winnings) AS LifetimeWinnings
FROM FBG_SOURCE.OSB_SOURCE.Bets
WHERE Status = 'SETTLED'
GROUP BY ALL)
SELECT
    A.ID AS Account_ID, Username,status,
    CONVERT_TIMEZONE('UTC','America/New_York', A.Creation_Date) AS Registration_Date, // In EST
    A.Email, a.name, RTRIM(LTRIM(PARSE_JSON(a.contact_details):ContactDetail:address1,'"'),'"') as street, a.town, RTRIM(LTRIM(PARSE_JSON(a.contact_details):ContactDetail:address4,'"'),'"') as
    jurisdiction, RTRIM(LTRIM(PARSE_JSON(a.contact_details):ContactDetail:postCode,'"'),'"') as zipcode,
    PARSE_JSON(A.Contact_Details):ContactDetail:address4 AS KYC_STate,
    J.Jurisdiction_Code AS State,
    D.LifetimeDeposits,
    W.LifetimeWithdrawals,
    B. LifetimeWinnings,
    VIP,
    CASINO_VIP
FROM FBG_SOURCE.OSB_SOURCE.ACCOUNTS A
INNER JOIN FBG_SOURCE.OSB_SOURCE.Jurisdictions J
    ON J.ID = A.Reg_Jurisdictions_Id
LEFT JOIN Deposits1 D
    ON A.ID = D.ACCO_ID
LEFT JOIN Withdrawals1 W
    ON W.Account_ID = A.ID
LEFT JOIN Bets1 B
    ON B.Acco_ID = A.ID
WHERE
   a.ID IN (6556352,
6556302,
6509295
)
