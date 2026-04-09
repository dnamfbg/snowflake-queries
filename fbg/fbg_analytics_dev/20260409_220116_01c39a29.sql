-- Query ID: 01c39a29-0212-6dbe-24dd-0703193e2437
-- Database: FBG_ANALYTICS_DEV
-- Schema: PUBLIC
-- Warehouse: TABLEAU_XL_PROD
-- Executed: 2026-04-09T22:01:16.413000+00:00
-- Elapsed: 50192ms
-- Environment: FBG

SELECT "Custom SQL Query"."CXVIP" AS "CXVIP",
  "Custom SQL Query"."DAYVIPCR" AS "DAYVIPCR",
  "Custom SQL Query"."TOTAL_UNIQUEVIP" AS "TOTAL_UNIQUEVIP",
  "Custom SQL Query"."VIPCONTACTRATE" AS "VIPCONTACTRATE"
FROM (
  -- Generate date spine for last 15 days excluding today
  WITH date_index AS (
      SELECT ROW_NUMBER() OVER (ORDER BY SEQ4()) AS rn
      FROM TABLE(GENERATOR(ROWCOUNT => 15))
  ),
  date_spine AS (
      SELECT DATEADD(DAY, -rn, CURRENT_DATE) AS day
      FROM date_index
  ),
  
  -- Contacts CTE
  contacts AS (
      SELECT
          TO_DATE(DATE_TRUNC('day', CONVERT_TIMEZONE('UTC', 'America/New_York',
              TO_TIMESTAMP(CONCAT(
                  LEFT(createddate, 4), '-', 
                  SUBSTR(createddate, 6, 2), '-', 
                  SUBSTR(createddate, 9, 2), ' ', 
                  SUBSTR(createddate, 12, 2), ':', 
                  SUBSTR(createddate, 15, 2), ':', 
                  SUBSTR(createddate, 18, 2)
              ), 'YYYY-MM-DD HH24:MI:SS')
          ))) AS day,
          COUNT(DISTINCT a.id) AS Cx,
          COUNT(DISTINCT c.casenumber) AS Cases,
          SUM(g.casheggrpredictions) AS eGGR,
          AVG(u.first_deposit_amount) AS FTD
      FROM FBG_SOURCE.SALESFORCE.O_CASE c
      LEFT JOIN FBG_SOURCE.OSB_SOURCE.ACCOUNTS a ON a.email = c.contactemail
      LEFT JOIN fbg_analytics_engineering.customers.customer_mart u ON a.id = u.acco_id
      LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VIP_TIERS v ON v.acco_id = a.id 
      LEFT JOIN FBG_ANALYTICS.PRODUCT_AND_CUSTOMER.CASHEGGR_28D_PREDICTIONS g ON g.acco_id = u.acco_id
      WHERE 
          createddate IS NOT NULL
          AND createddate != 'None'
          AND c.type IN ('Deposit', 'Withdrawal', 'Fraud')
          AND origin != 'Manual'
          AND v.coded_total_tier IN ('Tier 4', 'Tier 5')
      GROUP BY 1
  ),
  
  -- Join spine to contacts
  joined AS (
      SELECT
          d.day AS dayVIPCR,
          COALESCE(c.Cx, 0) AS cxvip,
          COALESCE(c.Cases, 0) AS cases,
          COALESCE(c.eGGR, 0) AS "28D eGGR",
          COALESCE(c.FTD, 0) AS "Avg FTD",
          CASE WHEN COALESCE(c.Cx, 0) = 0 THEN 0
               ELSE COALESCE(c.eGGR, 0) / COALESCE(c.Cx, 1)
          END AS "28D eGGR / Cx"
      FROM date_spine d
      LEFT JOIN contacts c ON d.day = c.day
  ),
  
  final1 as (
  SELECT dayVIPCR, CXVIP
  FROM joined
  ORDER BY dayVIPCR ASC
  ),
  
  depositors as(
  select date(date_trunc('day', created)) as date,
  a.acco_id as dep, 
  v.coded_total_tier,
  ---trans_ref,
  status
  from fbg_source.osb_source.deposits a
  left join FBG_ANALYTICS.TRADING.FCT_VIP_TIERS v on v.acco_id = a.acco_id
  where created >= '2024-08-01' and v.coded_total_tier IN ('Tier 4', 'Tier 5') and status != 'DEPOSIT_ABANDONED' and payment_brand not in ('CASHATCAGE','PAYSAFECASH','TERMINAL')
  ORDER BY date DESC),
  
  withdrawers as (
  select date(date_trunc('day', initiated_at)) as dayz,
  a.account_id as withd, 
  --v.coded_total_tier
  --transaction_ref,
  --status
  from fbg_source.osb_source.withdrawals a
  LEFT JOIN FBG_ANALYTICS.TRADING.FCT_VIP_TIERS v on v.acco_id = a.account_id
  where dayz > DATEADD(DAY,-15,current_date) and dayz <> current_date
  --and dayz < '2024-12-03'
  and v.coded_total_tier IN ('Tier 4', 'Tier 5')
  --AND account_id not in (select dep from depositors)
  group by all
  ORDER BY dayz desc),
  
  both as (select dayz,
  count(DISTINCT dep) as dep_withd,
  from withdrawers w 
  INNER JOIN depositors d on d.date = w.dayz and d.dep = w.withd
  group by all),
  
  dep_only as (
  select date, count(distinct dep) as only_dep
  from depositors d
  left outer join withdrawers w on w.dayz = d.date and d.dep = w.withd where w.withd is null
  group by all),
  
  with_only as(
  select dayz, count(distinct withd) as only_with
  from withdrawers w
  left outer join depositors d on d.date = w.dayz and d.dep = w.withd where d.dep is null
  group by all),
  
  final as(
  select d.date,
  dep_withd,
  only_dep,
  only_with
  from both b
  left join dep_only d on d.date = b.dayz
  left join with_only w on w.dayz = d.date
  group by all
  ),
  
  final2 as (
  SELECT 
  date as datepavip,
  --dep_withd,
  --only_dep,
  --only_with,
  dep_withd + only_dep + only_with as total_uniqueVIP
  FROM final
  ORDER BY datepavip asc)
  
  select
  dayvipcr, cxvip, total_uniqueVIP,
  cxvip/total_uniqueVIP as VIPcontactrate
  from final1 f
  left join final2 g
  on f.dayvipcr = g.datepavip
  where dayvipcr > DATEADD(DAY,-15,current_date)
  order by dayvipcr asc
) "Custom SQL Query"
