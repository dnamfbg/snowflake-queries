-- Query ID: 01c39a65-0212-6dbe-24dd-0703194b0967
-- Database: FBG_ANALYTICS_DEV
-- Schema: KEVIN_MURPHY
-- Warehouse: BI_SM_WH
-- Last Executed: 2026-04-09T23:01:09.313000+00:00
-- Elapsed: 8821ms
-- Run Count: 3
-- Environment: FBG

SELECT * FROM ( ( SELECT
            convert_timezone('UTC', 'America/New_York',GETDATE()) AS SnapshotDate,
            COUNT(DISTINCT aa.casenumber) AS OpenCases,
            CASE 
                WHEN aa.status = 'New' THEN 'New'
                WHEN aa.status = 'Partner Escalation' THEN 'On Hold'
                WHEN aa.status = 'Internal Ops Escalation' THEN 'On Hold'
                WHEN aa.status = 'In-progress' THEN 'In-Progress'
                WHEN aa.status = 'In Progress' THEN 'In-Progress'
                WHEN aa.status = 'Under Review' THEN 'In-Progress'
                WHEN aa.status = 'Pending' THEN 'Pending'
                WHEN aa.status = 'Awaiting Customer Response' THEN 'Pending'
                WHEN aa.status = 'Awaiting feedback' THEN 'Pending'
                WHEN aa.status = 'Pending Ops Internal Response' THEN 'On Hold'
                WHEN aa.status = 'Past due' THEN 'Past Due'
                ELSE aa.status
            END AS GroupedStatus
        FROM FBG_SOURCE.SALESFORCE.O_CASE aa
        left join fbg_analytics_engineering.customers.customer_mart u on u.salesforce_id = aa.accountid
        WHERE aa.status <> 'Closed' AND aa.status <> 'Resolved' AND aa.status <> 'Merged' and u.is_test_account = 0
        GROUP BY all ) ) AS "SF_CONNECTOR_QUERY_ALIAS"
