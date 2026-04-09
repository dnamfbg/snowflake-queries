-- Query ID: 01c39a12-0212-67a9-24dd-07031938ced7
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_L_WH
-- Executed: 2026-04-09T21:38:43.741000+00:00
-- Elapsed: 41836ms
-- Environment: FBG

WITH email_cases AS (
  SELECT
    c.case_id AS caseid,
    c.case_number,
    c.case_status,
    DATE(CONVERT_TIMEZONE('UTC','America/New_York', c.case_closed_est)) AS closed_date_et
  FROM FBG_ANALYTICS.OPERATIONS.CS_CASES c
  WHERE c.case_closed_est IS NOT NULL
    AND (DATE(CONVERT_TIMEZONE('UTC','America/New_York', c.case_closed_est)) >= ('2026-04-08 21:38:43')::timestamp AND DATE(CONVERT_TIMEZONE('UTC','America/New_York', c.case_closed_est)) < ('2026-04-09 21:38:43')::timestamp) 
    AND c.case_source IN ('Inbound: Email','Outbound: Email')
),

case_hist AS (
  SELECT
    h.caseid,
    case_number,
    case_status,
    h.field,
    h.oldvalue,
    h.newvalue,
    TRY_TO_TIMESTAMP_TZ(
      h.createddate::STRING,
      'YYYY-MM-DD"T"HH24:MI:SS.FF3TZHTZM'
    ) AS created_ts
  FROM fbg_source.salesforce.o_case_history h
  JOIN email_cases ec
    ON ec.caseid = h.caseid
  WHERE h.newvalue IS NOT NULL
),

owner_events AS (
  SELECT
      ch.caseid,
          case_status,
      case_number,
      ch.created_ts AS owner_start_ts,
      CASE
        WHEN REGEXP_LIKE(ch.newvalue::STRING, '^[A-Za-z0-9]{15}([A-Za-z0-9]{3})?$')
          THEN COALESCE(r.agent_name, ch.newvalue::STRING)
        ELSE ch.newvalue::STRING
      END AS agent_name,
            LEAD(ch.created_ts) OVER (PARTITION BY ch.caseid ORDER BY ch.created_ts) AS next_owner_start_ts

  FROM case_hist ch
  LEFT JOIN FBG_ANALYTICS.OPERATIONS.AGENT_MASTER_ROSTER r
    ON REGEXP_LIKE(ch.newvalue::STRING, '^[A-Za-z0-9]{15}([A-Za-z0-9]{3})?$')
   AND r.salesforce_id = ch.newvalue::STRING
  WHERE ch.field = 'Owner'
    AND ch.created_ts IS NOT NULL
),

filtered_agents AS (
  SELECT DISTINCT
      ec.case_number,
      oe.agent_name
  FROM owner_events oe
  JOIN email_cases ec
    ON ec.caseid = oe.caseid
  WHERE oe.agent_name IS NOT NULL
    AND oe.agent_name NOT LIKE '005%'
    AND oe.agent_name NOT LIKE '00G%'
    AND oe.agent_name NOT IN ('Admin User', 'Platform Integration User')
),

touches_per_case AS (
  SELECT
    case_number,
    COUNT(DISTINCT agent_name) AS touches
  FROM filtered_agents
  GROUP BY case_number
),

touch_bucketed AS (
  SELECT
    case_number,
    touches,
    CASE
      WHEN touches >= 4 THEN '4+'
      ELSE TO_VARCHAR(touches)
    END AS bucket
  FROM touches_per_case
), 

audit_log_email_handle_time AS (
    SELECT
        DATE(c.case_closed_est) AS closed_date,
        c.case_number                                                           AS case_number,
        c.agent_name                                                            AS agent,
        a.total_time_to_add_minutes                                             AS active_time
    FROM FBG_ANALYTICS.OPERATIONS.CS_CASES c
    LEFT JOIN fbg_analytics.operations.ops_audit_log_by_case a ON c.case_number = a.case_number
    WHERE c.case_closed_est IS NOT NULL
      -- AND DATE(c.case_closed_est) = :daterange
      AND c.case_source in ('Inbound: Email','Outbound: Email')
      -- and agent_name in (select agent_name from fbg_analytics.operations.agent_master_roster)
    GROUP BY
        all),

status_exit_events AS (
  SELECT
      caseid,
      case_number,
      created_ts AS status_exit_ts
  FROM case_hist
  WHERE field = 'Status'
    AND created_ts IS NOT NULL
    -- statuses considered ACTIVE: 'New','Open','In Progress'
    -- status_exit = when status changes to something NOT in the active set
    AND newvalue::STRING NOT IN ('New', 'Open', 'In Progress')
),

owner_stints AS (
  /* For each owner assignment (owner_events row) find:
     - the earliest status_exit_ts that occurs at/after the owner_start_ts (if any)
     - the next_owner_start_ts (if any)
     then choose the earliest of those two as the owner_end_ts, falling back to CURRENT_TIMESTAMP() for open stints.
  */
  SELECT
      o.caseid,
      o.case_number,
      o.agent_name,
          case_status,
      o.owner_start_ts,
      -- earliest status exit after or at owner start
      MIN(s.status_exit_ts) AS min_status_exit_ts,
      o.next_owner_start_ts,

      -- compute owner_end_ts as the earliest non-null of min_status_exit_ts and next_owner_start_ts,
      -- otherwise use current timestamp
      COALESCE(
        CASE
          WHEN MIN(s.status_exit_ts) IS NULL THEN o.next_owner_start_ts
          WHEN o.next_owner_start_ts IS NULL THEN MIN(s.status_exit_ts)
          ELSE LEAST(MIN(s.status_exit_ts), o.next_owner_start_ts)
        END,
        CURRENT_TIMESTAMP()::TIMESTAMP_TZ
      ) AS owner_end_ts

  FROM owner_events o
  LEFT JOIN status_exit_events s
    ON s.caseid = o.caseid
   AND s.status_exit_ts >= o.owner_start_ts  -- include status-exits that occur at the same timestamp
  GROUP BY
      1,2,3,4,5,7
),

email_case_agent_minutes AS (
  SELECT
      case_number,
        case_status,
      agent_name,
      SUM(DATEDIFF('minute', owner_start_ts, owner_end_ts)) AS active_time
  FROM owner_stints
  WHERE agent_name IS NOT NULL
    -- AND NOT REGEXP_LIKE(agent_name, '^00G')               -- filter out unresolved queue/group IDs
    AND agent_name <> 'Skill Based Routing Queue'         -- filter out queue 
    AND owner_end_ts > owner_start_ts                    -- avoid negative/zero stints 
  GROUP BY 1, 2,3
)
-- , 
-- final as (
SELECT
  t.case_number,
  -- case_status,
  touches,
  -- e.agent_name as case_hist_agent,
  a.agent as agent,
  a.active_time as handle_time,
  -- e.active_time as case_hist_active_time,
  -- case when e.agent_name = a.agent then 'included' else 'excluded' end as email_aht_impact
  -- case when 
  -- bucket
FROM touch_bucketed t 
join audit_log_email_handle_time a on t.case_number = a.case_number
where agent = 'Jose Migoya'
-- where touches = 1
-- join email_case_agent_minutes e on t.case_number = e.case_number 
ORDER BY touches DESC
-- )

-- select *  
-- -- case when audit_log_active_time > case_hist_active_time then 'possible negative imapct' else 'no or positive impact' end as aht_impact
-- from final
-- where case_owner_audit_log in (select distinct agent_name from FBG_ANALYTICS.OPERATIONS.AGENT_MASTER_ROSTER 
-- -- where "Active?" = 'Active'
-- )
