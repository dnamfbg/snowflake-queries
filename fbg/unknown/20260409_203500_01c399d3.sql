-- Query ID: 01c399d3-0212-67a9-24dd-0703192a4407
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T20:35:00.933000+00:00
-- Elapsed: 903ms
-- Environment: FBG

select SUM_306 "American Football", SUM_307 "Baseball", SUM_308 "Basketball", SUM_309 "Ice Hockey", SUM_310 "Soccer", SUM_311 "Tennis", SUM_312 "Other Sports", SUM_313 "Singles", SUM_314 "Parlay", SUM_315 SGP, SUM_316 "Roulette", SUM_317 "Slots Handle", SUM_318 "Blackjack Handle", SUM_319 "Othercasino Handle" from (select sum(AMERICANFOOTBALLHANDLE) SUM_306, sum(BASEBALLHANDLE) SUM_307, sum(BASKETBALLHANDLE) SUM_308, sum(ICEHOCKEYHANDLE) SUM_309, sum(SOCCERHANDLE) SUM_310, sum(TENNISHANDLE) SUM_311, sum(OTHERSPORTSHANDLE) SUM_312, sum(SINGLEHANDLE) SUM_313, sum(PARLAYHANDLE) SUM_314, sum(SGPHANDLE) SUM_315, sum(ROULETTEHANDLE) SUM_316, sum(SLOTSHANDLE) SUM_317, sum(BLACKJACKHANDLE) SUM_318, sum(OTHERCASINOHANDLE) SUM_319 from FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.VIP_TABLEAU_DS where SK_DATE >= to_date('2026-01-10', 'YYYY-MM-DD') and SK_DATE <= to_date('2026-04-09', 'YYYY-MM-DD')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/VIP-Customer-Dashboard-5Sd96Rf9IqJJ1z7sZvhkPp?:displayNodeId=it3-AYxJ3M","kind":"adhoc","request-id":"g019d73f48f6f7e41b7f788aa131b0b17","user-id":"KKHxtqTq3l0qSi0sR3WFE0rCwPJuX","email":"vinny.ortega@betfanatics.com"}
