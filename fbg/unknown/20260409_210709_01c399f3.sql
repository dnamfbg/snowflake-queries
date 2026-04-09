-- Query ID: 01c399f3-0212-6dbe-24dd-07031931803f
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:07:09.528000+00:00
-- Elapsed: 211ms
-- Environment: FBG

select SUM_306 "American Football", SUM_307 "Baseball", SUM_308 "Basketball", SUM_309 "Ice Hockey", SUM_310 "Soccer", SUM_311 "Tennis", SUM_312 "Other Sports", SUM_313 "Singles", SUM_314 "Parlay", SUM_315 SGP, SUM_316 "Roulette", SUM_317 "Slots Handle", SUM_318 "Blackjack Handle", SUM_319 "Othercasino Handle" from (select sum(AMERICANFOOTBALLHANDLE) SUM_306, sum(BASEBALLHANDLE) SUM_307, sum(BASKETBALLHANDLE) SUM_308, sum(ICEHOCKEYHANDLE) SUM_309, sum(SOCCERHANDLE) SUM_310, sum(TENNISHANDLE) SUM_311, sum(OTHERSPORTSHANDLE) SUM_312, sum(SINGLEHANDLE) SUM_313, sum(PARLAYHANDLE) SUM_314, sum(SGPHANDLE) SUM_315, sum(ROULETTEHANDLE) SUM_316, sum(SLOTSHANDLE) SUM_317, sum(BLACKJACKHANDLE) SUM_318, sum(OTHERCASINOHANDLE) SUM_319 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where ACCO_ID = 718751 and SK_DATE >= to_date('2026-03-20', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-03-23', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=it3-AYxJ3M","kind":"adhoc","request-id":"g019d7411fd2c73d18a55bb2b93a8119b","user-id":"B1FTu9bkRuek0OxmECFzFAk4nZeum","email":"Sameer.Khaled@betfanatics.com"}
