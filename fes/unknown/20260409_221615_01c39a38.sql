-- Query ID: 01c39a38-0112-6f84-0000-e307218ca4ca
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:16:15.026000+00:00
-- Elapsed: 720ms
-- Environment: FES

select FANAPP_FTU_ATTRIBUTION "Fanapp Ftu Attribution", PRIVATE_FAN_ID "Private Fan Id", CAST_22 "Ftu Day", CAST_20 "First Game Played Dt", CAST_21 "First Game Played Ts", CAST_23 "Last Game Played Dt", CAST_24 "Last Game Played Ts", GAMES_PLAYED "Games Played", F5_DAILY_PLAYED "F 5 Daily Played", QUAD_GOALS_PLAYED "Quad Goals Played", STW_PLAYED "Stw Played", TD_PICKEM_PLAYED "Td Pickem Played", P9_PLAYED "P 9 Played", F5_JACKPOT_PLAYED "F 5 Jackpot Played", SURVIVOR_PLAYED "Survivor Played", MOST_PLAYED_GAME "Most Played Game", FIRST_PLAYED_GAME "First Played Game", LAST_PLAYED_GAME "Last Played Game", FIRST_TO_LAST "First to Last", LAST_TO_FTU "Last to Ftu" from (select FANAPP_FTU_ATTRIBUTION, PRIVATE_FAN_ID, GAMES_PLAYED, F5_DAILY_PLAYED, QUAD_GOALS_PLAYED, STW_PLAYED, TD_PICKEM_PLAYED, P9_PLAYED, F5_JACKPOT_PLAYED, SURVIVOR_PLAYED, MOST_PLAYED_GAME, FIRST_PLAYED_GAME, LAST_PLAYED_GAME, FIRST_TO_LAST, LAST_TO_FTU, FIRST_GAME_PLAYED_DT::timestamp_ltz CAST_20, FIRST_GAME_PLAYED_TS::timestamp_ltz CAST_21, FTU_DAY::timestamp_ltz CAST_22, LAST_GAME_PLAYED_DT::timestamp_ltz CAST_23, LAST_GAME_PLAYED_TS::timestamp_ltz CAST_24 from FES_USERS.DYLAN_TUCH.FTP_TO_FTU_TIME) Q1 limit 10001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Exploration-4n7fOrbLZEmv0ju5Rf3tXk?:displayNodeId=jSfEhcuqRH","kind":"adhoc","request-id":"g019d74513f077137bcd8c9f739e4c5c2","user-id":"50PPW5hnmj2PC5GjwSOs6j5sY4B15","email":"dylan.tuch@betfanatics.com"}
