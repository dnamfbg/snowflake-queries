-- Query ID: 01c399ce-0212-6e7d-24dd-070319293917
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:30:49.117000+00:00
-- Elapsed: 372583ms
-- Environment: FBG

create transient table "FBG_ANALYTICS"."SIGMA_FBG"."t_mat_2a5f97bcf197415f9413d2bb7dd1a5b1_0" comment = 'Created by jen.sans@betfanatics.com in Sigma Σ https://app.sigmacomputing.com/bet-fanatics/data-model/730-Federal-Wagering-Tax-Report-v2-Data-Model-23lqYyHW1BGVWQRZ6pVUD7?:nodeId=2gxHVLCuL3' as select CAST_8 "inode-5M4F38Z0mVHpnlc0in571W/Gaming Date", "State" "inode-5M4F38Z0mVHpnlc0in571W/State", "SOURCE" "inode-5M4F38Z0mVHpnlc0in571W/SOURCE", RETAIL_VENUE_NAME "inode-5M4F38Z0mVHpnlc0in571W/RETAIL_VENUE_NAME", CASH_WAGERS_PLACED "inode-5M4F38Z0mVHpnlc0in571W/CASH_WAGERS_PLACED", CANCEL_VOIDS "inode-5M4F38Z0mVHpnlc0in571W/CANCEL_VOIDS", TOTAL_AMOUNT "inode-5M4F38Z0mVHpnlc0in571W/TOTAL_AMOUNT", FEDERAL_TAX_730_AMOUNT "inode-5M4F38Z0mVHpnlc0in571W/FEDERAL_TAX_730_AMOUNT" from (select "State", "SOURCE", RETAIL_VENUE_NAME, CASH_WAGERS_PLACED, CANCEL_VOIDS, TOTAL_AMOUNT, FEDERAL_TAX_730_AMOUNT, "Gaming Date"::timestamp_ltz CAST_8 from FBG_FINANCE.TAX.TAX_730_FEDERAL_WAGERING) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/730-Federal-Wagering-Tax-Report-v2-Data-Model-23lqYyHW1BGVWQRZ6pVUD7?:displayNodeId=dpvAhSVKhi","kind":"materialization","request-id":"2a5f97bc-f197-415f-9413-d2bb7dd1a5b1","user-id":"Kg4bgHu8P6SU54tS1ctQT6fWKAG6I","email":"jen.sans@betfanatics.com"}
