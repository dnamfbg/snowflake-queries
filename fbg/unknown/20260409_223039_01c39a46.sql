-- Query ID: 01c39a46-0212-6dbe-24dd-07031944787b
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:30:39.439000+00:00
-- Elapsed: 356795ms
-- Environment: FBG

create transient table "FBG_ANALYTICS"."SIGMA_FBG"."t_mat_9b2a133204fc4ba29a34a87849c174b8_0" comment = 'Created by jen.sans@betfanatics.com in Sigma Σ https://app.sigmacomputing.com/bet-fanatics/data-model/730-Federal-Wagering-Tax-Report-v2-Data-Model-23lqYyHW1BGVWQRZ6pVUD7?:nodeId=2gxHVLCuL3' as select CAST_8 "inode-5M4F38Z0mVHpnlc0in571W/Gaming Date", "State" "inode-5M4F38Z0mVHpnlc0in571W/State", "SOURCE" "inode-5M4F38Z0mVHpnlc0in571W/SOURCE", RETAIL_VENUE_NAME "inode-5M4F38Z0mVHpnlc0in571W/RETAIL_VENUE_NAME", CASH_WAGERS_PLACED "inode-5M4F38Z0mVHpnlc0in571W/CASH_WAGERS_PLACED", CANCEL_VOIDS "inode-5M4F38Z0mVHpnlc0in571W/CANCEL_VOIDS", TOTAL_AMOUNT "inode-5M4F38Z0mVHpnlc0in571W/TOTAL_AMOUNT", FEDERAL_TAX_730_AMOUNT "inode-5M4F38Z0mVHpnlc0in571W/FEDERAL_TAX_730_AMOUNT" from (select "State", "SOURCE", RETAIL_VENUE_NAME, CASH_WAGERS_PLACED, CANCEL_VOIDS, TOTAL_AMOUNT, FEDERAL_TAX_730_AMOUNT, "Gaming Date"::timestamp_ltz CAST_8 from FBG_FINANCE.TAX.TAX_730_FEDERAL_WAGERING) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/data-model/730-Federal-Wagering-Tax-Report-v2-Data-Model-23lqYyHW1BGVWQRZ6pVUD7?:displayNodeId=dpvAhSVKhi","kind":"materialization","request-id":"9b2a1332-04fc-4ba2-9a34-a87849c174b8","user-id":"Kg4bgHu8P6SU54tS1ctQT6fWKAG6I","email":"jen.sans@betfanatics.com"}
