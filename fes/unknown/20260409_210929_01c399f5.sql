-- Query ID: 01c399f5-0112-6ccc-0000-e307218b30a2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T21:09:29.659000+00:00
-- Elapsed: 9002ms
-- Environment: FES

with W1 as (select SURVIVOR_GAME_V.LEAGUE_ID, SURVIVOR_GAME_V.SURVIVAL_STATUS, Q2.TENANT_FAN_ID from MONTEROSA.MONTEROSA_CORE.SURVIVOR_GAME_V left join FANGRAPH."ADMIN".FAN_ID_TENANT_MAP Q2 on SURVIVOR_GAME_V.EXTERNAL_ID = Q2.TENANT_FAN_ID left join FANGRAPH."ADMIN".FANGRAPH Q4 on Q2.FANGRAPH_ID = Q4.FANGRAPH_ID) select ANY_544 "TopK Value", COUNT_547 "TopK Count", ISNULL_552 "TopK Null Sort" from (select *, ANY_544 is null ISNULL_552 from (select Q10.ANY_544, count(1) COUNT_547 from (select TENANT_FAN_ID from W1 Q6 where LEAGUE_ID = 'f69009a3-5e6b-49e6-ad51-3dbcd0b3d61e') Q7 left join (select any_value(LAST_536) ANY_544, TENANT_FAN_ID TENANT_FAN_ID_545 from (select TENANT_FAN_ID, last_value(SURVIVAL_STATUS) over (partition by TENANT_FAN_ID order by '' asc rows between unbounded preceding and unbounded following) LAST_536 from W1 Q8 where LEAGUE_ID = 'f69009a3-5e6b-49e6-ad51-3dbcd0b3d61e') Q9 group by TENANT_FAN_ID) Q10 on equal_null(Q7.TENANT_FAN_ID, Q10.TENANT_FAN_ID_545) group by Q10.ANY_544) Q12) Q13 order by ISNULL_552 desc, COUNT_547 desc, ANY_544 asc limit 201

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Survivor-Dash-6oEQV76N98fZ25d11EPNFS","kind":"adhoc","request-id":"g019d741420d67608a9ac5dc37f2adf57","user-id":"kDVcuCBmlytVGY0gOsQijqX272kOQ","email":"jackie.petrillo@betfanatics.com"}
