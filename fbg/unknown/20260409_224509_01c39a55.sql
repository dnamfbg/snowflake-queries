-- Query ID: 01c39a55-0212-6dbe-24dd-07031947aa9b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:45:09.091000+00:00
-- Elapsed: 250ms
-- Environment: FBG

select "DATE" "Date", REPORT "Report", CAST_43 "Account Id", SHARP_PROB "Sharp Prob", SHARP_WINDOW "Sharp Window", CLV "Clv", CLV_ELIGIBLE "Clv Eligible", LIVE_EV "Live Ev", LIVE_WINDOW "Live Window", ORIGINAL_PM_SF "Original Pm Sf", ORIGINAL_LIVE_SF "Original Live Sf", ORIGINAL_IPD "Original Ipd", REC_ACTION "Rec Action", TRADER "Trader", SHARP_OR_REC_OVERALL "Sharp or Rec Overall", NEW_PM_SF "New Pm Sf", NEW_LIVE_SF "New Live Sf", NEW_IPD "New Ipd", "COMMENTS" "Comments", "ACTION" "Action" from (select "DATE", REPORT, SHARP_PROB, SHARP_WINDOW, CLV, CLV_ELIGIBLE, LIVE_EV, LIVE_WINDOW, ORIGINAL_PM_SF, ORIGINAL_LIVE_SF, ORIGINAL_IPD, REC_ACTION, TRADER, "COMMENTS", SHARP_OR_REC_OVERALL, NEW_PM_SF, NEW_LIVE_SF, NEW_IPD, "ACTION", try_to_double(ACCOUNT_ID) CAST_43 from FBG_ANALYTICS.TRADING.CM_HUB_COMPLETED_ENTRIES where try_to_double(ACCOUNT_ID) = 6497670) Q1 order by "DATE" asc nulls last limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/User-Aggregated-Report-2Ldbx1IVdxCU6guEN5hCqp?:displayNodeId=czDuMpvxtz","kind":"adhoc","request-id":"g019d746bb495716db52f29fa0d533bf6","user-id":"vmIDr6JeIgfvB7dWYRqc7f8jUv8Ad","email":"jordan.polo@betfanatics.com"}
