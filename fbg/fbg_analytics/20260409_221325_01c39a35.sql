-- Query ID: 01c39a35-0212-6cb9-24dd-0703194106eb
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: TABLEAU_L_PROD
-- Executed: 2026-04-09T22:13:25.294000+00:00
-- Elapsed: 27756ms
-- Environment: FBG

SELECT "Custom SQL Query1"."ACCO_ID" AS "ACCO_ID (Custom SQL Query1)",
  "Custom SQL Query1"."CAMPAIGN_NAME" AS "CAMPAIGN_NAME (Custom SQL Query1)",
  "Custom SQL Query1"."METRIC" AS "METRIC",
  "Custom SQL Query1"."VAL" AS "VAL",
  "Custom SQL Query1"."WINDOW_LABEL" AS "WINDOW_LABEL",
  "Custom SQL Query1"."WINDOW_SORT" AS "WINDOW_SORT"
FROM (
  WITH base AS (
  SELECT *
  FROM fbg_analytics.vip.project_250_campaigns
  )
  
  
  , account_bonus_extracts as (
      select
          a.acco_id,
          a.created,
          -- bc.bonus_campaign_id,
          -- bc.bonus_campaign_name,
          b.campaign_name,
          b.qual_bonus_pct,
          concat(round(b.qual_bonus_pct),'% Offer')::string as offer_selected,
          b.bonus_stakes_amount,
          b.bonus_stakes_amount / b.qual_bonus_pct * 100 as max_qual_deposit_amount,   
  
          CASE 
            WHEN regexp_substr(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              TO_NUMBER(CAST(REGEXP_SUBSTR(overrides, 'fanCashAmount=([0-9]+)', 1, 1, 'e', 1) AS NUMBER(12,2)))
            ELSE NULL
          END as fancash_amount, 
          fancash_amount / bonus_stakes_amount as perc_max_deposit,
          fancash_amount / b.qual_bonus_pct * 100 as perc_max_deposit_1,
      
          a.state as account_bonus_state,
          a.modified as last_modified_time,
          
          CASE 
            WHEN regexp_substr(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) IS NOT NULL THEN
              -- convert_timezone(
              TO_TIMESTAMP_NTZ(CAST(REGEXP_SUBSTR(overrides, 'optInTime=([0-9]+)', 1, 1, 'e', 1) AS NUMBER) / 1000)
            ELSE NULL
          END as opt_in_time
      from fbg_source.osb_source.account_bonuses a
      inner join base b 
          on a.bonus_campaign_id = b.bonus_campaign_id
          and a.acco_id = b.acco_id
  )
  
  
  , base_2 as (
    select
        d.acco_id,
        b.campaign_name,
        b.campaign_start_date,
  
        /* how many days since offer start (cohort availability driver) */
        datediff(day, b.campaign_start_date, current_date) as days_since_start,
  
        /* cash handle sums */
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 0 and 3
                          then coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0) end), 0) as cash_handle_0_3,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 4 and 7
                          then coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0) end), 0) as cash_handle_4_7,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 8 and 14
                          then coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0) end), 0) as cash_handle_8_14,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 15 and 30
                          then coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0) end), 0) as cash_handle_15_30,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) > 30
                          then coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0) end), 0) as cash_handle_30_plus,
  
        /* APD numerators */
        count(distinct case when datediff(day, b.campaign_start_date, t.calendar_date) between 0 and 3
                             and (coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0)) > 0
                            then a.date end) as apd_n_0_3,
        count(distinct case when datediff(day, b.campaign_start_date, t.calendar_date) between 4 and 7
                             and (coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0)) > 0
                            then a.date end) as apd_n_4_7,
        count(distinct case when datediff(day, b.campaign_start_date, t.calendar_date) between 8 and 14
                             and (coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0)) > 0
                            then a.date end) as apd_n_8_14,
        count(distinct case when datediff(day, b.campaign_start_date, t.calendar_date) between 15 and 30
                             and (coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0)) > 0
                            then a.date end) as apd_n_15_30,
        count(distinct case when datediff(day, b.campaign_start_date, t.calendar_date) > 30
                             and (coalesce(a.osb_cash_handle, 0) + coalesce(a.oc_cash_handle, 0)) > 0
                            then a.date end) as apd_n_30_plus,
  
        /* CVP sums */
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 0 and 3
                          then coalesce(a.osb_cvp, 0) + coalesce(a.oc_cvp, 0) end), 0) as cvp_sum_0_3,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 4 and 7
                          then coalesce(a.osb_cvp, 0) + coalesce(a.oc_cvp, 0) end), 0) as cvp_sum_4_7,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 8 and 14
                          then coalesce(a.osb_cvp, 0) + coalesce(a.oc_cvp, 0) end), 0) as cvp_sum_8_14,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 15 and 30
                          then coalesce(a.osb_cvp, 0) + coalesce(a.oc_cvp, 0) end), 0) as cvp_sum_15_30,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) > 30
                          then coalesce(a.osb_cvp, 0) + coalesce(a.oc_cvp, 0) end), 0) as cvp_sum_30_plus,
  
        /* eCVP sums */
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 0 and 3
                          then coalesce(a.osb_ecvp, 0) + coalesce(a.oc_ecvp, 0) end), 0) as ecvp_sum_0_3,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 4 and 7
                          then coalesce(a.osb_ecvp, 0) + coalesce(a.oc_ecvp, 0) end), 0) as ecvp_sum_4_7,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 8 and 14
                          then coalesce(a.osb_ecvp, 0) + coalesce(a.oc_ecvp, 0) end), 0) as ecvp_sum_8_14,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) between 15 and 30
                          then coalesce(a.osb_ecvp, 0) + coalesce(a.oc_ecvp, 0) end), 0) as ecvp_sum_15_30,
        coalesce(sum(case when datediff(day, b.campaign_start_date, t.calendar_date) > 30
                          then coalesce(a.osb_ecvp, 0) + coalesce(a.oc_ecvp, 0) end), 0) as ecvp_sum_30_plus
  
    from account_bonus_extracts d
    inner join fbg_analytics.vip.lead_machine lm 
        on d.acco_id = lm.acco_id 
    inner join base b 
        on lm.acco_id = b.acco_id
        and d.campaign_name = b.campaign_name
    inner join fbg_analytics.product_and_customer.t_calendar t
        on t.calendar_date >= b.campaign_start_date
       and t.calendar_date <= current_date
    left join fbg_analytics.product_and_customer.customer_variable_profit a
        on d.acco_id = a.acco_id
       and a.date = t.calendar_date
    where d.account_bonus_state = 'EXECUTED'
    group by d.acco_id, b.campaign_name, b.campaign_start_date
  )
  
  , denoms as (
    select
      *,
      /* overlap day-counts for fixed windows */
      greatest(least(days_since_start,  3) -  0 + 1, 0) as denom_0_3,
      greatest(least(days_since_start,  7) -  4 + 1, 0) as denom_4_7,
      greatest(least(days_since_start, 14) -  8 + 1, 0) as denom_8_14,
      greatest(least(days_since_start, 30) - 15 + 1, 0) as denom_15_30,
  
      /* 30+ window starts at day 31 and runs through "today" */
      greatest(days_since_start - 30, 0) as denom_30_plus
    from base_2
  )
  
  , final as (
    select
      acco_id,
      campaign_name,
  
      /* raw sums */
      cash_handle_0_3,
      cash_handle_4_7,
      cash_handle_8_14,
      cash_handle_15_30,
      cash_handle_30_plus,
  
      /* dynamic avg cash handle */
      coalesce(cash_handle_0_3   / nullif(denom_0_3, 0), 0) as avg_cash_handle_0_3,
      coalesce(cash_handle_4_7   / nullif(denom_4_7, 0), 0) as avg_cash_handle_4_7,
      coalesce(cash_handle_8_14  / nullif(denom_8_14, 0), 0) as avg_cash_handle_8_14,
      coalesce(cash_handle_15_30 / nullif(denom_15_30, 0), 0) as avg_cash_handle_15_30,
      coalesce(cash_handle_30_plus / nullif(denom_30_plus, 0), 0) as avg_cash_handle_30_plus,
  
      /* dynamic APD rates */
      coalesce(apd_n_0_3     / nullif(denom_0_3, 0), 0) as apd_rate_0_3,
      coalesce(apd_n_4_7     / nullif(denom_4_7, 0), 0) as apd_rate_4_7,
      coalesce(apd_n_8_14    / nullif(denom_8_14, 0), 0) as apd_rate_8_14,
      coalesce(apd_n_15_30   / nullif(denom_15_30, 0), 0) as apd_rate_15_30,
      coalesce(apd_n_30_plus / nullif(denom_30_plus, 0), 0) as apd_rate_30_plus,
  
      /* dynamic avg CVP / eCVP */
      coalesce(cvp_sum_0_3   / nullif(denom_0_3, 0), 0) as avg_cvp_0_3,
      coalesce(cvp_sum_4_7   / nullif(denom_4_7, 0), 0) as avg_cvp_4_7,
      coalesce(cvp_sum_8_14  / nullif(denom_8_14, 0), 0) as avg_cvp_8_14,
      coalesce(cvp_sum_15_30 / nullif(denom_15_30, 0), 0) as avg_cvp_15_30,
      coalesce(cvp_sum_30_plus / nullif(denom_30_plus, 0), 0) as avg_cvp_30_plus,
  
      coalesce(ecvp_sum_0_3   / nullif(denom_0_3, 0), 0) as avg_ecvp_0_3,
      coalesce(ecvp_sum_4_7   / nullif(denom_4_7, 0), 0) as avg_ecvp_4_7,
      coalesce(ecvp_sum_8_14  / nullif(denom_8_14, 0), 0) as avg_ecvp_8_14,
      coalesce(ecvp_sum_15_30 / nullif(denom_15_30, 0), 0) as avg_ecvp_15_30,
      coalesce(ecvp_sum_30_plus / nullif(denom_30_plus, 0), 0) as avg_ecvp_30_plus
  
    from denoms
  )
  
  , typed as (
    select
      acco_id,
      campaign_name,
  
      cast(cash_handle_0_3        as double) cash_handle_0_3,
      cast(cash_handle_4_7        as double) cash_handle_4_7,
      cast(cash_handle_8_14       as double) cash_handle_8_14,
      cast(cash_handle_15_30      as double) cash_handle_15_30,
      cast(cash_handle_30_plus    as double) cash_handle_30_plus,
  
      cast(avg_cash_handle_0_3    as double) avg_cash_handle_0_3,
      cast(avg_cash_handle_4_7    as double) avg_cash_handle_4_7,
      cast(avg_cash_handle_8_14   as double) avg_cash_handle_8_14,
      cast(avg_cash_handle_15_30  as double) avg_cash_handle_15_30,
      cast(avg_cash_handle_30_plus as double) avg_cash_handle_30_plus,
  
      cast(apd_rate_0_3           as double) apd_rate_0_3,
      cast(apd_rate_4_7           as double) apd_rate_4_7,
      cast(apd_rate_8_14          as double) apd_rate_8_14,
      cast(apd_rate_15_30         as double) apd_rate_15_30,
      cast(apd_rate_30_plus       as double) apd_rate_30_plus,
  
      cast(avg_cvp_0_3            as double) avg_cvp_0_3,
      cast(avg_cvp_4_7            as double) avg_cvp_4_7,
      cast(avg_cvp_8_14           as double) avg_cvp_8_14,
      cast(avg_cvp_15_30          as double) avg_cvp_15_30,
      cast(avg_cvp_30_plus        as double) avg_cvp_30_plus,
  
      cast(avg_ecvp_0_3           as double) avg_ecvp_0_3,
      cast(avg_ecvp_4_7           as double) avg_ecvp_4_7,
      cast(avg_ecvp_8_14          as double) avg_ecvp_8_14,
      cast(avg_ecvp_15_30         as double) avg_ecvp_15_30,
      cast(avg_ecvp_30_plus       as double) avg_ecvp_30_plus
    from final
  )
  
  select
    acco_id,
    campaign_name,
  
    /* label: handles both "0_3" and "30_plus" */
    case
      when series ilike '%_plus' then split_part(series,'_',-2) || '+'
      else split_part(series,'_',-2) || '-' || split_part(series,'_',-1)
    end as window_label,
  
    case
      when series ilike 'cash_handle_%'       then 'Cash Handle'
      when series ilike 'avg_cash_handle_%'   then 'Avg Cash Handle'
      when series ilike 'apd_rate_%'          then 'APD Rate'
      when series ilike 'avg_cvp_%'           then 'Avg CVP'
      when series ilike 'avg_ecvp_%'          then 'Avg eCVP'
    end as metric,
  
    value as val,
  
    case
      when window_label = '0-3' then 1
      when window_label = '4-7' then 2
      when window_label = '8-14' then 3
      when window_label = '15-30' then 4
      when window_label = '30+' then 5
    end as window_sort
  
  from typed
  unpivot include nulls ( value for series in (
    cash_handle_0_3,  cash_handle_4_7,  cash_handle_8_14,  cash_handle_15_30, cash_handle_30_plus,
    avg_cash_handle_0_3, avg_cash_handle_4_7, avg_cash_handle_8_14, avg_cash_handle_15_30, avg_cash_handle_30_plus,
    apd_rate_0_3,  apd_rate_4_7,  apd_rate_8_14,  apd_rate_15_30, apd_rate_30_plus,
    avg_cvp_0_3,   avg_cvp_4_7,   avg_cvp_8_14,   avg_cvp_15_30, avg_cvp_30_plus,
    avg_ecvp_0_3,  avg_ecvp_4_7,  avg_ecvp_8_14,  avg_ecvp_15_30, avg_ecvp_30_plus
  ))
) "Custom SQL Query1"
