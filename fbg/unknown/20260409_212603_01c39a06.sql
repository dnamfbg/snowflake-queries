-- Query ID: 01c39a06-0212-67a9-24dd-07031935aedf
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:26:03.377000+00:00
-- Elapsed: 1248ms
-- Environment: FBG

select ACCO_ID, CURRENT_VALUE_BAND "Current Sports Segment", CASINO_CLUSTER "Current Casino Cluster", CURRENT_CASINO_SEGMENT "Current Casino Segment", RECOMMENDED_SPORTS_BONUS "Recommended Sports Bonus", RECOMMENDED_CASINO_BONUS "Recommended Casino Bonus", SUM_13 "Sports Last 7D Bonus Given ($)", SUM_14 "Sports Last 30D Cash Handle ($)", SUM_12 "Casino Last 7D Bonus Given ($)", SUM_15 "Casino Last 30D Cash Handle ($)" from (select ACCO_ID, CURRENT_VALUE_BAND, CURRENT_CASINO_SEGMENT, CASINO_CLUSTER, RECOMMENDED_CASINO_BONUS, RECOMMENDED_SPORTS_BONUS, sum(CASINO_7D_BONUS_TOTAL) SUM_12, sum(SPORTS_7D_BONUS_TOTAL) SUM_13, sum(SPORTS_CASH_HANDLE_30D) SUM_14, sum(CASINO_CASH_HANDLE_30D) SUM_15 from FBG_ANALYTICS.OPERATIONS.AGENT_GOODWILL_BONUSING where ACCO_ID = 1281095 group by ACCO_ID, CURRENT_VALUE_BAND, CASINO_CLUSTER, CURRENT_CASINO_SEGMENT, RECOMMENDED_SPORTS_BONUS, RECOMMENDED_CASINO_BONUS) Q1 order by ACCO_ID asc, CURRENT_VALUE_BAND asc, CASINO_CLUSTER asc, CURRENT_CASINO_SEGMENT asc, RECOMMENDED_SPORTS_BONUS asc, RECOMMENDED_CASINO_BONUS asc limit 45701

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/Goodwill-Bonusing-Dashboard-75rWHjwO1U00w6mvW2Tvjr?:displayNodeId=A6X3_RpMGM","kind":"adhoc","request-id":"g019d74234932708c8659682c42260b7e","user-id":"Wm5FtO70fxzoLV7v276qGgKUHaido","email":"sky.krokus@betfanatics.com"}
