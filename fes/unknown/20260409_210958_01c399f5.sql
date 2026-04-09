-- Query ID: 01c399f5-0112-6b51-0000-e307218af9fe
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:09:58.944000+00:00
-- Elapsed: 4800ms
-- Environment: FES

select TENANT_FAN_ID "Tenant Fan Id", ANY_538 "Email", ANY_540 "Survival Status", ANY_539 "Eliminated Week" from (select TENANT_FAN_ID, any_value(LAST_537) ANY_538, any_value(LAST_536) ANY_539, any_value(LAST_535) ANY_540 from (select Q2.TENANT_FAN_ID, last_value(Q1.SURVIVAL_STATUS) over (partition by Q2.TENANT_FAN_ID order by '' asc rows between unbounded preceding and unbounded following) LAST_535, last_value(Q1.USER_ELIMINATED_WEEK) over (partition by Q2.TENANT_FAN_ID order by '' asc rows between unbounded preceding and unbounded following) LAST_536, last_value(Q5.FANGRAPH_EMAIL) over (partition by Q2.TENANT_FAN_ID order by '' asc rows between unbounded preceding and unbounded following) LAST_537 from (select * from MONTEROSA.MONTEROSA_CORE.SURVIVOR_GAME_V where LEAGUE_ID = 'f69009a3-5e6b-49e6-ad51-3dbcd0b3d61e') Q1 left join FANGRAPH."ADMIN".FAN_ID_TENANT_MAP Q2 on Q1.EXTERNAL_ID = Q2.TENANT_FAN_ID left join FANGRAPH."ADMIN".FANGRAPH Q5 on Q2.FANGRAPH_ID = Q5.FANGRAPH_ID) Q4 group by TENANT_FAN_ID having ANY_540 = 'Eliminated') Q7 order by TENANT_FAN_ID asc limit 1000000

-- Sigma Σ {"kind":"export","request-id":"g019d741493207b3ba39dfae9dd21d4cb","user-id":"kDVcuCBmlytVGY0gOsQijqX272kOQ","email":"jackie.petrillo@betfanatics.com"}
