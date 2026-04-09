-- Query ID: 01c39a4f-0212-6dbe-24dd-070319465b23
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:39:13.694000+00:00
-- Elapsed: 914ms
-- Environment: FBG

select COUNT_80 "Registrations", SUM_81 "KYC Attempted", SUM_82 "KYC Verified", SUM_83 "Wallet Funded Attempted", SUM_84 "Trade Ready", SUM_85 "Attempted Trade" from (select count(1) COUNT_80, sum(iff(HAS_ATTEMPTED_KYC = 1, 1, 0)) SUM_81, sum(iff(HAS_VERIFIED_KYC = 1, 1, 0)) SUM_82, sum(iff(HAS_MADE_DEPOSIT_ATTEMPT = 1, 1, 0)) SUM_83, sum(iff(HAS_MADE_SUCCESSFUL_DEPOSIT = 1, 1, 0)) SUM_84, sum(iff(HAS_COMPLETED_ORDER = 1 or HAS_ATTEMPTED_ORDER = 1, 1, 0)) SUM_85 from FMX_ANALYTICS.CUSTOMER.DIM_FMX_CORE_CUSTOMER where REGISTRATION_STATE in ('CA', 'FL', 'TX', 'TN', 'NY', 'NC', 'GA', 'PA', 'MI', 'AZ', 'LA', 'NJ', 'WA', 'IL', 'CO', 'MA', 'SC', 'WI', 'AL', 'OH', 'MN', 'VA', 'UT', 'MS', 'MD', 'DE', 'MO', 'IA', 'IN', 'CT', 'OK', 'OR', 'NH', 'WV', 'ID', 'KS', 'RI', 'NM', 'HI', 'NE', 'WY', 'ME', 'KY', 'ND', 'SD', 'AR', 'AK', 'PR', 'NV', 'VT', 'DC', 'MT', 'GU', 'VI') and REGISTRATION_DATE_ALK >= to_timestamp_ntz('2026-04-07 00:00:00.000000000', 'YYYY-MM-DD HH24:MI:SS.FF9') and REGISTRATION_DATE_ALK <= to_timestamp_ntz('2026-04-07 23:59:59.999000000', 'YYYY-MM-DD HH24:MI:SS.FF9')) Q1

-- Sigma Σ {"sourceUrl":"https://app.sigmacomputing.com/bet-fanatics/workbook/FMX-Daily-Product-4IGH5kbMiHWuSgl5WL1li0?:displayNodeId=pBHNCY_aI-","kind":"adhoc","request-id":"g019d7466434f784abb6ea489090d574e","user-id":"NuR9TM833xsaOjrHV47hZKmC4dM1L","email":"heather.schiraldi@betfanatics.com"}
