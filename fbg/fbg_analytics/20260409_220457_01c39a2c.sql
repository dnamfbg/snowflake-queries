-- Query ID: 01c39a2c-0212-67a9-24dd-0703193edaef
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T22:04:57.617000+00:00
-- Elapsed: 38229ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCO_ID" AS "ACCO_ID (Custom SQL Query)",
  "Custom SQL Query"."BONUS_ID" AS "BONUS_ID",
  "Custom SQL Query"."BONUS_NAME" AS "BONUS_NAME",
  "Custom SQL Query"."BONUS_STATUS" AS "BONUS_STATUS",
  "Custom SQL Query"."BONUS_STATUS_UPDATED" AS "BONUS_STATUS_UPDATED",
  "Custom SQL Query"."DQ_REASON" AS "DQ_REASON",
  "Custom SQL Query"."ENGAGED" AS "ENGAGED (Custom SQL Query)",
  "Custom SQL Query"."EXPECTED_CATEGORY" AS "EXPECTED_CATEGORY",
  "Custom SQL Query"."FAST_TRACK_START_DATE" AS "FAST_TRACK_START_DATE (Custom SQL Query)",
  "Custom SQL Query"."IS_CURRENTLY_FAST_TRACK" AS "IS_CURRENTLY_FAST_TRACK (Custom SQL Query)",
  "Custom SQL Query"."NAME" AS "NAME (Custom SQL Query)",
  "Custom SQL Query"."OFFER_DATE" AS "OFFER_DATE",
  "Custom SQL Query"."OVERRIDES" AS "OVERRIDES",
  "Custom SQL Query"."PICK_RN" AS "PICK_RN",
  "Custom SQL Query"."PRODUCT_PREFERENCE" AS "PRODUCT_PREFERENCE (Custom SQL Query)",
  "Custom SQL Query"."RN" AS "RN",
  "Custom SQL Query"."SEGMENT_DATE" AS "SEGMENT_DATE",
  "Custom SQL Query"."SEGMENT_ID" AS "SEGMENT_ID",
  "Custom SQL Query"."SEGMENT_NAME" AS "SEGMENT_NAME",
  "Custom SQL Query"."SF_ENGAGEMENT" AS "SF_ENGAGEMENT (Custom SQL Query)",
  "Custom SQL Query"."STAGENAME" AS "STAGENAME (Custom SQL Query)",
  "Custom SQL Query"."TYPE" AS "TYPE (Custom SQL Query)",
  "Custom SQL Query"."WAC" AS "WAC",
  "Custom SQL Query"."WEEK_NUMBER" AS "WEEK_NUMBER"
FROM (
  -- === CALENDAR OF THURSDAYS WITH 3-WEEK CYCLE ===
  WITH seq AS (
    SELECT SEQ4() AS n
    FROM TABLE(GENERATOR(ROWCOUNT => (52 * 3)))
  ),
  all_thursdays AS (
    SELECT DATEADD('week', n, '2025-10-30'::DATE) AS cohort_thursday
    FROM seq
  ),
  
  -- Expand each cohort_thursday into its Week1/2/3 Thursdays
  weeks AS (
    SELECT 1 AS week_in_cycle 
    UNION ALL
    SELECT 2 
    UNION ALL
    SELECT 3
  ),
  
  cohorts as (
  SELECT
    t.cohort_thursday,
    w.week_in_cycle,
    /* The Thursday for that week in the cohort */
    DATEADD('week', w.week_in_cycle - 1, t.cohort_thursday) AS thursday_dt,
  FROM all_thursdays t
  CROSS JOIN weeks w),
  
  -- Example segment list (replace with your source table)
  segments AS (
  SELECT * FROM VALUES
    (142210, 'Week1_Fast_Track_DM'),
    (142211, 'Week2_Fast_Track_BG_Opt-In'),
    (142212, 'Week2_Fast_Track_BG_FanCash'),
    (142213, 'Week3_Fast_Track_LB_Opt-In'),
    (142214, 'Week3_Fast_Track_LB_FanCash'),
    (444444, 'Week2_FastTrack_11-18_cas'),
    (555555, 'Week2_FastTrack_11-18_sbk'),
    (222222, 'Week2_FastTrack_11-25'),
    (333333, 'Week3_FastTrack_11-25'),
    (666666, 'Week2_FastTrack_12-02'),
    (777777, 'Week3_FastTrack_12-02')
    v(segment_id, segment_name)),
  
  -- Extract week number: handles Week1 / Week_1 / WK1 etc.
  segments_with_week AS (
  SELECT
    segment_id,
    segment_name,
    TRY_TO_NUMBER(
      COALESCE(
        REGEXP_SUBSTR(segment_name, 'WK[ ]*([0-9]+)', 1, 1, 'e', 1),
        REGEXP_SUBSTR(segment_name, 'Week[_ ]*([0-9]+)', 1, 1, 'e', 1)
      )
    ) AS week_in_cycle
  FROM segments),
  
  segment_calendar AS (
  SELECT
    s.segment_id,
    s.segment_name,
    c.week_in_cycle,
    c.thursday_dt,       -- the actual Thursday this segment maps to
    c.cohort_thursday,   -- the cohort’s Week1 Thursday
  FROM segments_with_week s
  JOIN cohorts c
    ON c.week_in_cycle = s.week_in_cycle),
    
  base AS (
      SELECT
          id AS segment_id,
          deleted,
          PARSE_JSON(data):CustomerSegment.name::string AS segment_name
      FROM FBG_SOURCE.OSB_SOURCE.CUSTOMER_SEGMENTS
      WHERE segment_name ILIKE '%gauntlet%'
         OR segment_name ILIKE '%VIPA_SC_WK%'
         OR segment_name ILIKE '%FASTTRACK_WEEK%'
         OR segment_name ILIKE '%_Fast_Track_%'
  
  union
      SELECT
          222222 AS segment_id,
          0 as deleted,
          'Week2_FastTrack_11-25' AS segment_name
      FROM segments
  
  union
      SELECT
          333333 AS segment_id,
          0 as deleted,
          'Week3_FastTrack_11-25' AS segment_name
      FROM segments
  
  union
      SELECT
          444444 AS segment_id, --212054
          0 as deleted,
          'Week2_FastTrack_11-18_cas' AS segment_name
      FROM segments
  
  union
      SELECT
          555555 AS segment_id,
          0 as deleted,
          'Week2_FastTrack_11-18_sbk' AS segment_name
      FROM segments
  
  union
      SELECT
          666666 AS segment_id, --212054
          0 as deleted,
          'Week2_FastTrack_12-02' AS segment_name
      FROM segments
  
  union
      SELECT
          777777 AS segment_id,
          0 as deleted,
          'Week3_FastTrack_12-02' AS segment_name
      FROM segments
  ),
  
  extracted AS (
      SELECT
          segment_id,
          deleted,
          segment_name,
          CASE 
              WHEN segment_name LIKE '%.%' THEN
                  LPAD(SPLIT_PART(segment_name, '.', 1), 2, '0') || 
                  LPAD(SPLIT_PART(segment_name, '.', 2), 2, '0') || 
                  LPAD(SPLIT_PART(SPLIT_PART(segment_name, '.', 3), '_', 1), 2, '0')
              when segment_name like '010%'
                  then REGEXP_SUBSTR(segment_name, '^0[0-9]{6}')
              ELSE 
                  REGEXP_SUBSTR(segment_name, '^[0-9]{6}')
          END AS final_string,
          COALESCE(
              REGEXP_SUBSTR(segment_name, 'WK[0-9]+'),
              REGEXP_SUBSTR(segment_name, 'Week[_]?[0-9]+')
          ) AS raw_week,
          CASE 
              WHEN REGEXP_SUBSTR(segment_name, 'WK[0-9]+|Week[_]?[0-9]+') IN ('WK1','Week1','Week_1') THEN 'Both'
              WHEN LOWER(segment_name) LIKE '%gauntlet%' THEN 'Sportsbook'
              WHEN UPPER(segment_name) LIKE '%BBCC%'     THEN 'Casino'
              ELSE 'Other'
          END AS category
      FROM base
  ),
  
  final_segments_pre_auto AS (
      SELECT
          segment_id,
          segment_name,
          deleted,
          CASE 
              WHEN REGEXP_LIKE(final_string, '^[0-9]{6}$') 
              THEN TRY_TO_DATE(final_string, 'MMDDYY')
              ELSE NULL
          END AS segment_date,
          TRY_TO_NUMBER(REGEXP_SUBSTR(raw_week, '[0-9]+')) AS week_number,
          category
      FROM extracted
  ),
  
  final_segments_post_auto AS (
      SELECT
        segment_id,
        segment_name,
        thursday_dt AS segment_date,
        week_in_cycle AS week_number,
        cohort_thursday as week_one_offer_date
    FROM segment_calendar
  ),
  
  bonus AS (
      SELECT
          b.id AS bonus_id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          seg.value::string AS segment_id
      FROM FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b,
           LATERAL FLATTEN(input => PARSE_JSON(b.data):Bonus:segmentIds) seg
  
      union 
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '222222' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 216524
  
      union 
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '333333' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 216471
  
      union
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '555555' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 212051
  
      union
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '444444' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 212054
  
      union
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '666666' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 220971
  
      union
      select 
          b.id,
          PARSE_JSON(b.data):Bonus:name::string AS bonus_name,
          '777777' as segment_id
      from FBG_SOURCE.OSB_SOURCE.BONUS_CAMPAIGNS b
      where b.id = 220972
  ),
  --select * from bonus; --11/25 - Week 2: 216524, Week 3: 216471 | 11/18 - Week 2 SBK: 212051, Week 2 CAS: 212054
   
  fast_track_weeks AS (
      SELECT
          acco_id,
          type,
          fast_track_start_date,
          product_preference,
          disqualified_reason__c as dq_reason,
          is_currently_fast_track,
          stagename,
          engaged,
          sf_engagement,
          name,
          1 AS week_number,
          NEXT_DAY(fast_track_start_date, 'THU') AS offer_date
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FAST_TRACK_ATTRIBUTE
      WHERE type = 'Fast Track'
        AND (disqualified_reason__c IS NULL OR disqualified_reason__c = 'Low WAC')
  
      UNION ALL
      SELECT
          acco_id,
          type,
          fast_track_start_date,
          product_preference,
          disqualified_reason__c as dq_reason,
          is_currently_fast_track,
          stagename,
          engaged,
          sf_engagement,
          name,
          2,
          DATEADD(WEEK, 1, NEXT_DAY(fast_track_start_date, 'THU'))
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FAST_TRACK_ATTRIBUTE
      WHERE type = 'Fast Track'
        AND (disqualified_reason__c IS NULL OR disqualified_reason__c = 'Low WAC')
  
      UNION ALL
      SELECT
          acco_id,
          type,
          fast_track_start_date,
          product_preference,
          disqualified_reason__c as dq_reason,
          is_currently_fast_track,
          stagename,
          engaged,
          sf_engagement,
          name,
          3,
          DATEADD(WEEK, 2, NEXT_DAY(fast_track_start_date, 'THU'))
      FROM FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.FAST_TRACK_ATTRIBUTE
      WHERE type = 'Fast Track'
        AND (disqualified_reason__c IS NULL OR disqualified_reason__c = 'Low WAC')
  ),
  
  joined AS (
      SELECT
          ft.acco_id,
          ft.type,
          ft.fast_track_start_date,
          ft.product_preference,
          ft.dq_reason,
          ft.is_currently_fast_track,
          ft.stagename,
          ft.engaged,
          ft.sf_engagement,
          ft.name,
          ft.week_number,
          ft.offer_date,
          fs.segment_id,
          fs.segment_name,
          fs.segment_date,
          --fs.category AS segment_category,
          b.bonus_id,
          b.bonus_name,
          CASE 
              WHEN ft.week_number = 1 THEN 'Both'
              WHEN ft.week_number IN (2,3) 
                   AND (LOWER(ft.product_preference) LIKE '%dual%' 
                        OR  LOWER(ft.product_preference) LIKE '%casino%') THEN 'Casino'
              WHEN ft.week_number IN (2,3) THEN 'Sportsbook'
              ELSE 'Other'
          END AS expected_category,
          ROW_NUMBER() OVER (
              PARTITION BY ft.acco_id, ft.week_number
              ORDER BY ABS(DATEDIFF(DAY, ft.offer_date, fs.segment_date))
          ) AS rn
      FROM fast_track_weeks ft
      LEFT JOIN final_segments_pre_auto fs 
        ON ft.week_number = fs.week_number
       AND ABS(DATEDIFF(DAY, ft.offer_date, fs.segment_date)) <= 1
       and segment_id not in ('142214','142213','142212')
      LEFT JOIN bonus b
        ON fs.segment_id = b.segment_id
      where ft.fast_track_start_date < '2025-10-27'
      
  union
  
  SELECT
          ft.acco_id,
          ft.type,
          ft.fast_track_start_date,
          ft.product_preference,
          ft.dq_reason,
          ft.is_currently_fast_track,
          ft.stagename,
          ft.engaged,
          ft.sf_engagement,
          ft.name,
          ft.week_number,
          ft.offer_date,
          fs.segment_id,
          fs.segment_name,
          fs.segment_date,
          --fs.category AS segment_category,
          b.bonus_id,
          b.bonus_name,
          CASE 
              WHEN ft.week_number = 1 THEN 'Both'
              WHEN ft.week_number IN (2,3) 
                   AND (LOWER(ft.product_preference) LIKE '%dual%' 
                        OR  LOWER(ft.product_preference) LIKE '%casino%') THEN 'Casino'
              WHEN ft.week_number IN (2,3) THEN 'Sportsbook'
              ELSE 'Other'
          END AS expected_category,
          ROW_NUMBER() OVER (
              PARTITION BY ft.acco_id, ft.week_number
              ORDER BY ABS(DATEDIFF(DAY, ft.offer_date, fs.segment_date))
          ) AS rn
      FROM fast_track_weeks ft
      LEFT JOIN final_segments_post_auto fs 
        ON ft.week_number = fs.week_number
      AND ABS(DATEDIFF(DAY, ft.offer_date, fs.segment_date)) <= 1
          
      LEFT JOIN bonus b
        ON fs.segment_id = b.segment_id
      where ft.fast_track_start_date >= '2025-10-27'
  ),
  
  with_bonus_status AS (
    SELECT
        j.*,
        ab.state AS bonus_status,
        ab.overrides,   -- keep if you want to see why a row lost priority
        ROW_NUMBER() OVER (
          PARTITION BY j.acco_id, j.week_number
          ORDER BY
            /* Priority only applies post-10/27 for week 2/3 */
            CASE 
              WHEN j.fast_track_start_date >= '2025-10-27' AND j.week_number IN (2,3) THEN
                CASE 
                  /* Executed with NON-zero FanCash => highest priority */
                  WHEN LOWER(COALESCE(ab.state,'')) = 'executed'
                       AND COALESCE(ab.overrides,'') NOT LIKE '%fanCashAmount=0.00%'
                       AND ab.state is not null THEN 0
                  /* Opt-In/Available next */
                  WHEN LOWER(COALESCE(ab.state,'')) IN ('opt in','opt-in','opt_in', 'available') THEN 1
                  /* Executed but zero FanCash => demote below Opt-In */
                  ELSE 3
                END
              ELSE 0
            END,
            /* Tie-breaker: closest segment/offer date */
            ABS(DATEDIFF(DAY, j.offer_date, j.segment_date))
        ) AS pick_rn
    FROM joined j
    LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNT_BONUSES ab
      ON j.acco_id = ab.acco_id
     AND j.bonus_id = ab.bonus_campaign_id
  ),
  
  
  wac_all as (
  select
      acco_id,
      weekstart,
      wac,
      rank() over (partition by acco_id order by weekstart desc) as week_rank
    FROM FBG_ANALYTICS.VIP.VIP_WAC_HISTORICAL wc
  ),
  
  final_wac as (
  select *
  from wac_all
  where week_rank = 1
  )
  
  SELECT b.*,
  f.wac,
  case
      when b.bonus_status = 'EXECUTED' and b.overrides like '%fanCashAmount=0.00;%' then 'Inactive'
          else b.bonus_status
  end as bonus_status_updated
  FROM with_bonus_status b
  left join final_wac f on b.acco_id = f.acco_id
  QUALIFY pick_rn = 1
) "Custom SQL Query"
