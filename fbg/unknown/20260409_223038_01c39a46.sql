-- Query ID: 01c39a46-0212-6e7d-24dd-0703194496e7
-- Database: unknown
-- Schema: unknown
-- Warehouse: AE_SIGMA_PROD
-- Executed: 2026-04-09T22:30:38.814000+00:00
-- Elapsed: 539ms
-- Environment: FBG

select table_db, table_schema, table_name, last_update
	from
		(values ('FBG_FINANCE', 'TAX', 'TAX_730_FEDERAL_WAGERING', system$last_change_commit_time('"FBG_FINANCE"."TAX"."TAX_730_FEDERAL_WAGERING"')))
		as v (table_db, table_schema, table_name, last_update)
