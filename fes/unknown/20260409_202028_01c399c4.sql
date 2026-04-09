-- Query ID: 01c399c4-0112-6806-0000-e3072188bfe2
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_SIGMA_WH
-- Executed: 2026-04-09T20:20:28.347000+00:00
-- Elapsed: 3300ms
-- Environment: FES

select COUNT_9 "Count of Loginattemptid" from (select count(LOGINATTEMPTID) COUNT_9 from FANFLOW.ACCOUNT_EVENTS.LOGINS where "TIMESTAMP" >= to_timestamp_ntz('2026-04-01 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and "TIMESTAMP" <= to_timestamp_ntz('2026-04-02 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and EVENT_NAME = 'FACTOR_VERIFY_ERROR' and LOGIN_TYPE = 'PASSWORD') Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/fes-sigma/workbook/Fanatics-ID-Logins-3DErWDXmBds5GdGq7BpGdD?:displayNodeId=ZQ26WWtuRY","kind":"adhoc","request-id":"g019d73e73f7373859c9b2cffc782b88b","user-id":"K8MB72BYH0CEoXNVNJs67KZGj2A5z","email":"zoe.sarwar@betfanatics.com"}
