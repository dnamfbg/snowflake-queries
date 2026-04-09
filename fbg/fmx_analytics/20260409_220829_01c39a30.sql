-- Query ID: 01c39a30-0212-6cb9-24dd-0703193fb5f3
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Last Executed: 2026-04-09T22:08:29.014000+00:00
-- Elapsed: 24156ms
-- Run Count: 2
-- Environment: FBG

create or replace  table FMX_ANALYTICS.STAGING.markets_quoted_today
    
    
    
    as (with today_alk as (
    select
        to_date(
            convert_timezone('UTC', 'America/Anchorage', current_timestamp())
        ) as as_of_date_alk
),

normalized as (
    select
        record_lsn as message_id,
        message as message_pipe_delimited,
        coalesce(dw_source_timestamp, dw_creation_date) as source_timestamp_utc
    from FMX_ANALYTICS.STAGING.stg_fmx_mm_fix_messages
    where
        coalesce(is_deleted, false) = false
        
),

fields as (
    select
        n.message_id,
        n.source_timestamp_utc,
        f.value::string as kv
    from normalized as n,
        lateral flatten(input => split(n.message_pipe_delimited, '|')) as f
),

parsed as (
    select
        message_id,
        source_timestamp_utc,
        split_part(kv, '=', 1) as tag,
        split_part(kv, '=', 2) as value
    from fields
    where kv like '%=%'
),

fix_quotes as (
    select
        message_id,
        source_timestamp_utc,
        max(case when tag = '35' then value end) as msg_type,
        try_to_timestamp(
            max(case when tag = '52' then value end),
            'YYYYMMDD-HH24:MI:SS.FF3'
        ) as sending_time,
        max(case when tag = '55' then value end) as quote_symbol
    from parsed
    group by message_id, source_timestamp_utc
    having max(case when tag = '55' then value end) is not null
),

quote_updates as (
    select
        f.quote_symbol,
        coalesce(f.sending_time, f.source_timestamp_utc) as most_recent_quote
    from fix_quotes as f
    cross join today_alk as t
    where
        f.msg_type = 'i'
        and to_date(
            convert_timezone('UTC', 'America/Anchorage', coalesce(f.sending_time, f.source_timestamp_utc))
        ) = t.as_of_date_alk
    qualify row_number() over (
        partition by f.quote_symbol
        order by coalesce(f.sending_time, f.source_timestamp_utc) desc
    ) = 1
)

select
    t.as_of_date_alk as quote_date_alk,
    q.quote_symbol,
    cm.title,
    q.most_recent_quote
from quote_updates as q
cross join today_alk as t
left join FMX_ANALYTICS.STAGING.stg_fmx_crypto_markets as cm
    on q.quote_symbol = cm.symbol
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.markets_quoted_today", "profile_name": "user", "target_name": "default"} */
