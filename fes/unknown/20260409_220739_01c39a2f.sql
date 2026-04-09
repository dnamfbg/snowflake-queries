-- Query ID: 01c39a2f-0112-6bf9-0000-e307218c698a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T22:07:39.878000+00:00
-- Elapsed: 2325ms
-- Environment: FES

select DATETRUNC_83 "Date", SWITCH_82 "Game Type", GAME_NAME "Game Name", SWITCH_84 "Result", FANCASH_VALUE "Fancash Value", PRIVATE_FAN_ID "Private Fan Id", FANAPP_TENANT_FAN_ID "Fanapp Tenant Fan Id" from (select FANAPP_GAME_RESULTS.GAME_NAME, FANAPP_GAME_RESULTS.FANCASH_VALUE, Q2.PRIVATE_FAN_ID, Q2.FANAPP_TENANT_FAN_ID, case FANAPP_GAME_RESULTS.GAME_TYPE when 'survivor' then 'Survivor' when 'f5jackpotv2' then 'Fanatics 5' when 'quadGoals' then 'Quad Goals' when 'tieredPickem' then 'Pick''em' when 'fanatics5' then 'Fanatics 5' when 'spinToWin' then 'Spin to Win' when 'perfect9' then 'Perfect 9' when 'perfect9v2' then 'Perfect 9' else 'UNKNOWN' end SWITCH_82, date_trunc(day, FANAPP_GAME_RESULTS.USER_SESSION_START_TS::timestamp_ltz) DATETRUNC_83, case FANAPP_GAME_RESULTS.GAME_RESULT when 'win' then 'Win' when 'lost' then 'Loss' else null end SWITCH_84 from MONTEROSA.MONTEROSA_CORE.FANAPP_GAME_RESULTS left join FANGRAPH.PRIVATE_FAN_ID.PFI_CUSTOMER_MART Q2 on FANAPP_GAME_RESULTS.EXTERNAL_ID = Q2.FANAPP_TENANT_FAN_ID where lower(Q2.FANAPP_TENANT_FAN_ID) = lower('df8eef8c-7f1f-4bcd-a76e-0494249105e4')) Q1 order by DATETRUNC_83 desc nulls last limit 73801

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/CS-Customer-Lookups-60IfF4RUOlf52f043esuKd?:displayNodeId=fH-fON8W1t","kind":"adhoc","request-id":"g019d7449601c7a809e6dcdbf0153ba98","user-id":"AZr0HVISSWncCdBK80ukPYT6BSiIS","email":"rebecca.licht@betfanatics.com"}
