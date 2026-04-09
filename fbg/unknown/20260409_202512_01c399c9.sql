-- Query ID: 01c399c9-0212-6dbe-24dd-0703192835b7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:25:12.870000+00:00
-- Elapsed: 121ms
-- Environment: FBG

select ORDER_ID "Order Id", ACCOUNT_ID "Account Id", COMBO_SYMBOL "Combo Symbol", LEG_MARKETS_GROUPING "Leg Markets Grouping", LEG_MARKET_NAME "Leg Market Name", LEG_MARKET_TITLE "Leg Market Title", LEG_PREDICT_CONTRACT_TYPE "Leg Predict Contract Type", LEG_SYMBOL "Leg Symbol", CAST_45 "Order Created at Alk", TRADE_ACTION "Trade Action", ATTEMPTED_HANDLE_USD "Attempted Handle Usd", FILL_RATE_PERCENTAGE "Fill Rate Percentage", LEG_PREDICT_MARKET_TYPE "Leg Predict Market Type", LEG_EVENT_DATE "Leg Event Date", LEG_TRADING_STATUS "Leg Trading Status", COMBO_TYPE "Combo Type", REJECTION_REASON "Rejection Reason" from (select ORDER_ID, ACCOUNT_ID, COMBO_SYMBOL, REJECTION_REASON, TRADE_ACTION, ATTEMPTED_HANDLE_USD, FILL_RATE_PERCENTAGE, LEG_SYMBOL, LEG_MARKETS_GROUPING, LEG_MARKET_NAME, LEG_MARKET_TITLE, LEG_PREDICT_MARKET_TYPE, LEG_PREDICT_CONTRACT_TYPE, LEG_EVENT_DATE, LEG_TRADING_STATUS, COMBO_TYPE, ORDER_CREATED_AT_ALK::timestamp_ltz CAST_45 from FMX_ANALYTICS.CUSTOMER.FCT_FMX_COMBO_LEG_DETAILS where ORDER_STATUS = 'FAILED' and IS_TEST_ACCOUNT) Q1 limit 29201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=VYD8NCopHA","kind":"adhoc","request-id":"g019d73eb8d2671b3bb6cba9d5c802dde","user-id":"SApx2czsCNSal7ZnQBRssii1lAl4g","email":"mateo.pedroza@betfanatics.com"}
