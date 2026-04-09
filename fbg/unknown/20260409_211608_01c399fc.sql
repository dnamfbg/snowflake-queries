-- Query ID: 01c399fc-0212-6cb9-24dd-07031933b5cb
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T21:16:08.318000+00:00
-- Elapsed: 515ms
-- Environment: FBG

select DATETRUNC_59 "Grid Date", ADD_91 "Active Users", LAG_107 "Active Users Previous Period", ADD_92 "Active Traders", LAG_108 "Active Traders Previous Period", ADD_93 "Funded Users", LAG_109 "Funded Users Previous Period", DIV_94 "Active Trader CVR", LAG_110 "Active Trader CVR Previous Period" from (select DATETRUNC_59, SUM_61 + SUM_62 + SUM_63 + SUM_64 ADD_91, SUM_73 + SUM_74 + SUM_75 ADD_92, SUM_82 + SUM_83 + SUM_84 ADD_93, ADD_92 / nullif(ADD_91, 0) DIV_94, lag(ADD_91, 28) over ( order by DATETRUNC_59 asc) LAG_107, lag(ADD_92, 28) over ( order by DATETRUNC_59 asc) LAG_108, lag(ADD_93, 28) over ( order by DATETRUNC_59 asc) LAG_109, lag(DIV_94, 28) over ( order by DATETRUNC_59 asc) LAG_110 from (select date_trunc(day, GRID_DATE::timestamp_ltz) DATETRUNC_59, sum(NEW_ACTIVE_USERS_28D) SUM_61, sum(RETAINED_ACTIVE_USERS_28D) SUM_62, sum(RESURRECTED_ACTIVE_USERS_28D) SUM_63, sum(PROSPECT_USER_ACTIVE_USERS_28D) SUM_64, sum(NEW_ACTIVE_TRADERS_28D) SUM_73, sum(RETAINED_ACTIVE_TRADERS_28D) SUM_74, sum(RESURRECTED_ACTIVE_TRADERS_28D) SUM_75, sum(NEW_FUNDED_USERS_28D) SUM_82, sum(RETAINED_FUNDED_USERS_28D) SUM_83, sum(RESURRECTED_FUNDED_USERS_28D) SUM_84 from FMX_ANALYTICS.CUSTOMER.FCT_CUSTOMER_GROWTH_ACCOUNTING_DAILY where date_trunc(day, GRID_DATE::timestamp_ltz) is not null and date_trunc(day, GRID_DATE::timestamp_ltz) >= to_timestamp_ltz('2026-03-10T00:00:00.000000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') and date_trunc(day, GRID_DATE::timestamp_ltz) <= to_timestamp_ltz('2026-04-08T23:59:59.999000000+00:00', 'YYYY-MM-DDTHH24:MI:SS.FF9TZH:TZM') group by DATETRUNC_59) Q1) Q2 order by DATETRUNC_59 asc limit 25001

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=5VCazyHK6O","kind":"adhoc","request-id":"g019d741a33017a6a896c8c165cfbbf5d","user-id":"upxSWBvFzGQ3hkOD2R8HTLHwY6Hwy","email":"karissa.chabalie@betfanatics.com"}
