-- Query ID: 01c39a50-0212-6cb9-24dd-07031946e5ff
-- Database: FBG_ANALYTICS_DEV
-- Schema: DANIEL_RUSTICO
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T22:40:38.459000+00:00
-- Elapsed: 13671ms
-- Run Count: 7
-- Environment: FBG

CREATE OR REPLACE TEMPORARY TABLE vip_host AS(
select acc.id as acco_id, b.name
from fbg_source.salesforce.o_account as a
inner join fbg_source.salesforce.o_user as b
on a.vip_host__c = b.id
left join fbg_source.osb_source.accounts as acc
on a.personemail = acc.email
)
