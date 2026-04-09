-- Query ID: 01c39a3f-0212-6dbe-24dd-07031943265f
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:23:49.096000+00:00
-- Elapsed: 3256ms
-- Environment: FBG

with tables as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",
        case
            when is_dynamic = 'YES' and table_type = 'BASE TABLE' THEN 'DYNAMIC TABLE'
            else table_type
        end as "table_type",
        comment as "table_comment",

        -- note: this is the _role_ that owns the table
        table_owner as "table_owner",

        'Clustering Key' as "stats:clustering_key:label",
        clustering_key as "stats:clustering_key:value",
        'The key used to cluster this table' as "stats:clustering_key:description",
        (clustering_key is not null) as "stats:clustering_key:include",

        'Row Count' as "stats:row_count:label",
        row_count as "stats:row_count:value",
        'An approximate count of rows in this table' as "stats:row_count:description",
        (row_count is not null) as "stats:row_count:include",

        'Approximate Size' as "stats:bytes:label",
        bytes as "stats:bytes:value",
        'Approximate size of the table as reported by Snowflake' as "stats:bytes:description",
        (bytes is not null) as "stats:bytes:include",

        'Last Modified' as "stats:last_modified:label",
        to_varchar(convert_timezone('UTC', last_altered), 'yyyy-mm-dd HH24:MI'||'UTC') as "stats:last_modified:value",
        'The timestamp for last update/change' as "stats:last_modified:description",
        (last_altered is not null and table_type='BASE TABLE') as "stats:last_modified:include"
    from FBG_ANALYTICS_ENGINEERING.INFORMATION_SCHEMA.tables 
            where (
                (
                    
    "table_schema" ilike 'APPLICATION' and upper("table_schema") = upper('APPLICATION')

                    and 
    "table_name" ilike 'GEOLOCATION_PINGS_FANGEO' and upper("table_name") = upper('GEOLOCATION_PINGS_FANGEO')

                )
            )
        ),
        columns as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",

        column_name as "column_name",
        ordinal_position as "column_index",
        data_type as "column_type",
        comment as "column_comment"
    from FBG_ANALYTICS_ENGINEERING.INFORMATION_SCHEMA.columns 
            where (
                (
                    
    "table_schema" ilike 'APPLICATION' and upper("table_schema") = upper('APPLICATION')

                    and 
    "table_name" ilike 'GEOLOCATION_PINGS_FANGEO' and upper("table_name") = upper('GEOLOCATION_PINGS_FANGEO')

                )
            )
        )
        select *
    from tables
    join columns using ("table_database", "table_schema", "table_name")
    order by "column_index"
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "user", "target_name": "default"} */
