-- Query ID: 01c39a4f-0212-6dbe-24dd-070319465f0f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:39:40.258000+00:00
-- Elapsed: 497ms
-- Environment: FBG

select ACCO_ID UID, CAST_18 "Registration Date", CAST_20 "First Bet  Date", REGISTRATION_STATE "Registration State", ACQUISITION_BONUS_NAME "Acquisition Offer", COALESCE_19 "Double Dip Offer", CURRENT_VALUE_BAND "Sportsbook Segment", CURRENT_CASINO_SEGMENT "Casino Segment", CASINO_CASH_HANDLE "Casino Cash Handle Lifetime", IF_23 "KYC Status", NULL_EQ_21, NOT_EQ_24 "UEorXjcvRm_7M081KRAIS", EQ_25 "jmdfw5Mwh5_7M081KRAIS" from (select REGISTRATION_STATE, ACCO_ID, CURRENT_VALUE_BAND, ACQUISITION_BONUS_NAME, CURRENT_CASINO_SEGMENT, CASINO_CASH_HANDLE, REG_DATE::timestamp_ltz CAST_18, coalesce(DOUBLE_DIP_BONUS_NAME, 'No Double Dip Offer') COALESCE_19, FIRST_BET_DATE::timestamp_ltz CAST_20, equal_null(min(KYC_STATUS), max(KYC_STATUS)) NULL_EQ_21, iff(NULL_EQ_21, max(KYC_STATUS), null) IF_23, IF_23 <> 'ACTIVE' NOT_EQ_24, IF_23 = 'ACTIVE' EQ_25 from FBG_ANALYTICS.OPERATIONS.CASINO_CASH_HANDLE CASINO_CASH_HANDLE_0 where ACCO_ID = 1836101 group by CAST_20, CAST_18, ACCO_ID, COALESCE_19, REGISTRATION_STATE, ACQUISITION_BONUS_NAME, CURRENT_VALUE_BAND, CURRENT_CASINO_SEGMENT, CASINO_CASH_HANDLE) Q1 order by ACCO_ID asc, CAST_18 asc, CAST_20 asc, REGISTRATION_STATE asc, ACQUISITION_BONUS_NAME asc, COALESCE_19 asc, CURRENT_VALUE_BAND asc, CURRENT_CASINO_SEGMENT asc, CASINO_CASH_HANDLE asc limit 54001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Acquisition-Bonus-Lookup-608HbP6mXSw2OofkxyUCm8?:displayNodeId=WBr1n3noP6","kind":"adhoc","request-id":"g019d7466ab3578d596294db3057e3aca","user-id":"3mSO99bL02kUMF8DwcSCdcC4FC1iN","email":"christine.anderson@betfanatics.com"}
