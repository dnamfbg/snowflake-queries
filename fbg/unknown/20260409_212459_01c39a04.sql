-- Query ID: 01c39a04-0212-6e7d-24dd-070319358693
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:24:59.048000+00:00
-- Elapsed: 386ms
-- Environment: FBG

select SYMBOL "Symbol", TITLE "Title", PREDICT_CONTRACT_TYPE "Predict Contract Type", CAST_52 "Event Date", TOTAL_CONTRACTS_TRADED "Total Contracts Traded", ABS_51 "Net Position", IF_50 "Side", TOTAL_HANDLE "Total Handle", NET_PROFIT "Net Profit", COMPLETED_TRADES "Completed Trades", IF_45 "Unrealized P&L", SUB_49 "Realized P&L" from (select SYMBOL, TITLE, PREDICT_CONTRACT_TYPE, TOTAL_CONTRACTS_TRADED, TOTAL_HANDLE, COMPLETED_TRADES, NET_PROFIT, iff(try_to_timestamp_ltz(EVENT_DATE) > to_timestamp_ltz('2026-04-08T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM'), UNREALIZED_PNL, null) IF_45, NET_PROFIT - coalesce(IF_45, 0) SUB_49, case when NET_CONTRACTS_POSITION < 0 then 'Short' when NET_CONTRACTS_POSITION > 0 then 'Long' when NET_CONTRACTS_POSITION = 0 then 'No Current Position' end IF_50, abs(NET_CONTRACTS_POSITION) ABS_51, try_to_timestamp_ltz(EVENT_DATE) CAST_52 from FMX_ANALYTICS.MARKET_MAKER.SIGMA_DAILY_REPORTING_MM where try_to_timestamp_ltz(EVENT_DATE) >= to_timestamp_ltz('2026-04-09T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and try_to_timestamp_ltz(EVENT_DATE) <= to_timestamp_ltz('2026-04-18T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and abs(NET_CONTRACTS_POSITION) >= 0.01 and SETTLEMENT_TIME::timestamp_ltz is null) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Market-Maker-Trading-6R2FxbRY8q4N3ynnXwEGa0?:displayNodeId=pEmV_Kis-0","kind":"adhoc","request-id":"g019d74224d25778d86287f1a5b1df085","user-id":"Zaj53AHEk1C5XVAfcwbJObHz5Z4PM","email":"zach.spergel@betfanatics.com"}
