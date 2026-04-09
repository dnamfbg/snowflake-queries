# Snowflake Queries

Historical queries from Snowflake environments, organized by environment and database.

## Structure

```
fbg/          # FBG Production queries, organized by database
fes/          # FES (Fan Data Exchange) Production queries, organized by database
scripts/      # Export and utility scripts
```

## Exporting Query History

```bash
python scripts/export_query_history.py
```

This pulls the last 12 months of query history from both environments via
`SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY`, deduplicates, filters out trivial queries,
and saves them as `.sql` files organized by database name.

Requires: `snowflake-connector-python` and SSO (externalbrowser) authentication.
