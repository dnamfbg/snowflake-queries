-- Query ID: 01c39a33-0212-67a9-24dd-07031940e4a3
-- Database: FBG_ANALYTICS_DEV
-- Schema: unknown
-- Warehouse: BI_XL_WH
-- Executed: 2026-04-09T22:11:55.678000+00:00
-- Elapsed: 17856ms
-- Environment: FBG

SELECT "Custom SQL Query"."ANY_OUTREACH" AS "ANY_OUTREACH",
  "Custom SQL Query"."AS_OF_DATE" AS "AS_OF_DATE",
  "Custom SQL Query"."ATTRIBUTION" AS "ATTRIBUTION",
  "Custom SQL Query"."CUMULATIVE_REVENUE_ALL_LEADS" AS "CUMULATIVE_REVENUE_ALL_LEADS",
  "Custom SQL Query"."LEAD_OWNER" AS "LEAD_OWNER",
  "Custom SQL Query"."NUM_LEADS" AS "NUM_LEADS",
  "Custom SQL Query"."PRE_LEAD_ACCOUNT_STATUS" AS "PRE_LEAD_ACCOUNT_STATUS"
FROM (
  with selected_owners as (
      select column1 as owner from values
            ('Taylor OBrien')
          , ('Darren OBrien')
          , ('Chris Bukowski')
          , ('Michael Del Zotto')
          , ('Will Rolapp')
          , ('Jamie Fitzsimmons')
          , ('Matthew Fleisher')
          , ('Michael Hermalyn')
          , ('Robert Ferrara')
          , ('Pete Donahue')
          , ('Gregg Hiller')
          , ('Dan Barzottini')
          , ('Tim Riley')
          , ('Dana White')
          , ('Michael Bernstein')
          , ('Kyle McQuillan')
  )
  , leads_daily as (
      select
            as_of_date
          , lead_owner
          , attribution
          , lead_id
          , pre_lead_account_status
          , sum(coalesce(osb_engr, 0) + coalesce(oc_engr, 0))
                over (
                      partition by lead_id
                      order by as_of_date
                      rows between unbounded preceding and current row
                ) as cumulative_revenue
      --from FBG_ANALYTICS_DEV.MATT_CHERNIS.LEADS_DAILY
        from fbg_analytics.vip.leads_daily
  )
  , contact_owner_outreach as (
      select
            lead_id
          , fbg_name
          , min(to_date(message_date)) as first_outreach_date
      from fbg_analytics.vip.lead_contact_history
      where fbg_name is not null
        and outbound > 0
      group by
            lead_id
          , fbg_name
  )
  , joined as (
      select
            d.as_of_date
          , d.lead_owner
          , d.attribution
          , d.lead_id
          , d.pre_lead_account_status
          , d.cumulative_revenue
          , case
              when c.first_outreach_date is not null
               and c.first_outreach_date <= d.as_of_date
              then 'Yes'
              else 'No'
            end as any_outreach
      from leads_daily d
      left join contact_owner_outreach c
          on  d.lead_owner is not null
          and c.lead_id  = d.lead_id
          and c.fbg_name = d.lead_owner
  )
  , agg as (
      select
            as_of_date
          , lead_owner
          , attribution
          , pre_lead_account_status
          , any_outreach
          , count(distinct lead_id)  as num_leads
          , sum(cumulative_revenue)  as cumulative_revenue_all_leads
      from joined
      group by
            as_of_date
          , lead_owner
          , attribution
          , pre_lead_account_status
          , any_outreach
  )
  , agg_selected_and_other as (
      select
            as_of_date
          , case
                when lead_owner in (select owner from selected_owners) then lead_owner
                else 'Other'
            end as lead_owner
          , attribution
          , pre_lead_account_status
          , any_outreach
          , sum(num_leads)                    as num_leads
          , sum(cumulative_revenue_all_leads) as cumulative_revenue_all_leads
      from agg
      group by
            as_of_date
          , case
                when lead_owner in (select owner from selected_owners) then lead_owner
                else 'Other'
            end
          , attribution
          , pre_lead_account_status
          , any_outreach
  )
  , agg_cde_team as (
      select
            as_of_date
          , 'CDE Team' as lead_owner
          , attribution
          , pre_lead_account_status
          , any_outreach
          , sum(num_leads)                    as num_leads
          , sum(cumulative_revenue_all_leads) as cumulative_revenue_all_leads
      from agg
      where lead_owner in (select owner from selected_owners)
      group by
            as_of_date
          , attribution
          , pre_lead_account_status
          , any_outreach
  )
  , agg_all as (
      select * from agg_selected_and_other
      union all
      select * from agg_cde_team
  )
  , base_dim as (
      select distinct
            as_of_date
          , lead_owner
          , attribution
          , pre_lead_account_status
      from agg_all
  )
  , outreach_flags as (
      select 'Yes' as any_outreach
      union all
      select 'No'  as any_outreach
  )
  select
        b.as_of_date
      , b.lead_owner
      , b.attribution
      , b.pre_lead_account_status
      , f.any_outreach
      , coalesce(a.num_leads, 0)                    as num_leads
      , coalesce(a.cumulative_revenue_all_leads, 0) as cumulative_revenue_all_leads
  from base_dim b
  cross join outreach_flags f
  left join agg_all a
      on  a.as_of_date              = b.as_of_date
      and a.lead_owner              = b.lead_owner
      and a.attribution             = b.attribution
      and a.pre_lead_account_status = b.pre_lead_account_status
      and a.any_outreach            = f.any_outreach
  order by
        as_of_date desc
      , case
            when b.lead_owner = 'CDE Team' then 2
            when b.lead_owner = 'Other'    then 3
            else 1
        end
      , b.lead_owner
      , f.any_outreach desc
      , b.attribution
      , b.pre_lead_account_status
) "Custom SQL Query"
