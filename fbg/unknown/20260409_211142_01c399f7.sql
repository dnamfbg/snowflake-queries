-- Query ID: 01c399f7-0212-67a8-24dd-07031932d3af
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:11:42.495000+00:00
-- Elapsed: 1219ms
-- Environment: FBG

select ACCO_ID UID, CAST_18 "Registration Date", CAST_20 "First Bet  Date", REGISTRATION_STATE "Registration State", ACQUISITION_BONUS_NAME "Acquisition Offer", COALESCE_19 "Double Dip Offer", CURRENT_VALUE_BAND "Sportsbook Segment", CURRENT_CASINO_SEGMENT "Casino Segment", CASINO_CASH_HANDLE "Casino Cash Handle Lifetime", IF_23 "KYC Status", NULL_EQ_21, NOT_EQ_24 "UEorXjcvRm_7M081KRAIS", EQ_25 "jmdfw5Mwh5_7M081KRAIS" from (select REGISTRATION_STATE, ACCO_ID, CURRENT_VALUE_BAND, ACQUISITION_BONUS_NAME, CURRENT_CASINO_SEGMENT, CASINO_CASH_HANDLE, REG_DATE::timestamp_ltz CAST_18, coalesce(DOUBLE_DIP_BONUS_NAME, 'No Double Dip Offer') COALESCE_19, FIRST_BET_DATE::timestamp_ltz CAST_20, equal_null(min(KYC_STATUS), max(KYC_STATUS)) NULL_EQ_21, iff(NULL_EQ_21, max(KYC_STATUS), null) IF_23, IF_23 <> 'ACTIVE' NOT_EQ_24, IF_23 = 'ACTIVE' EQ_25 from FBG_ANALYTICS.OPERATIONS.CASINO_CASH_HANDLE CASINO_CASH_HANDLE_0 where ACCO_ID = 6565732 group by CAST_20, CAST_18, ACCO_ID, COALESCE_19, REGISTRATION_STATE, ACQUISITION_BONUS_NAME, CURRENT_VALUE_BAND, CURRENT_CASINO_SEGMENT, CASINO_CASH_HANDLE) Q1 order by ACCO_ID asc, CAST_18 asc, CAST_20 asc, REGISTRATION_STATE asc, ACQUISITION_BONUS_NAME asc, COALESCE_19 asc, CURRENT_VALUE_BAND asc, CURRENT_CASINO_SEGMENT asc, CASINO_CASH_HANDLE asc limit 52601

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Acquisition-Bonus-Lookup-608HbP6mXSw2OofkxyUCm8?:displayNodeId=WBr1n3noP6","kind":"adhoc","request-id":"g019d7416239f797fb1988a7cf4ae2472","user-id":"0eQeJAl54Vxl1eAtx0IJWlT9PpoG3","email":"darren.begay@betfanatics.com"}
