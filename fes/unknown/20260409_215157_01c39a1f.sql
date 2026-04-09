-- Query ID: 01c39a1f-0112-6029-0000-e307218b8dc6
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:51:57.677000+00:00
-- Elapsed: 1486ms
-- Environment: FES

select DATETRUNC_83 "Date", SWITCH_82 "Game Type", GAME_NAME "Game Name", SWITCH_84 "Result", FANCASH_VALUE "Fancash Value", PRIVATE_FAN_ID "Private Fan Id", FANAPP_TENANT_FAN_ID "Fanapp Tenant Fan Id" from (select FANAPP_GAME_RESULTS.GAME_NAME, FANAPP_GAME_RESULTS.FANCASH_VALUE, Q2.PRIVATE_FAN_ID, Q2.FANAPP_TENANT_FAN_ID, case FANAPP_GAME_RESULTS.GAME_TYPE when 'survivor' then 'Survivor' when 'f5jackpotv2' then 'Fanatics 5' when 'quadGoals' then 'Quad Goals' when 'tieredPickem' then 'Pick''em' when 'fanatics5' then 'Fanatics 5' when 'spinToWin' then 'Spin to Win' when 'perfect9' then 'Perfect 9' when 'perfect9v2' then 'Perfect 9' else 'UNKNOWN' end SWITCH_82, date_trunc(day, FANAPP_GAME_RESULTS.USER_SESSION_START_TS::timestamp_ltz) DATETRUNC_83, case FANAPP_GAME_RESULTS.GAME_RESULT when 'win' then 'Win' when 'lost' then 'Loss' else null end SWITCH_84 from MONTEROSA.MONTEROSA_CORE.FANAPP_GAME_RESULTS left join FANGRAPH.PRIVATE_FAN_ID.PFI_CUSTOMER_MART Q2 on FANAPP_GAME_RESULTS.EXTERNAL_ID = Q2.FANAPP_TENANT_FAN_ID where lower(Q2.FANAPP_TENANT_FAN_ID) = lower(' 8220076e-9ec3-46de-8630-5539ff6c3dc2')) Q1 order by DATETRUNC_83 desc nulls last limit 71801

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/CS-Customer-Lookups-60IfF4RUOlf52f043esuKd?:displayNodeId=fH-fON8W1t","kind":"adhoc","request-id":"g019d743b0030701894c874036708bd66","user-id":"AZr0HVISSWncCdBK80ukPYT6BSiIS","email":"rebecca.licht@betfanatics.com"}
