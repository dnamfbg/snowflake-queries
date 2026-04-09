#!/usr/bin/env python3
"""
Export query history from Snowflake environments (FBG and FES).
Pulls from SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY, filters out junk,
and saves meaningful queries as .sql files organized by environment.
"""

import snowflake.connector
import os
import re
import hashlib
from datetime import datetime

ENVIRONMENTS = {
    "fbg": {
        "account": "NODXDTL-FBG_PROD",
        "host": "tvb59484.us-east-1.privatelink.snowflakecomputing.com",
        "user": "DAVID.NAM@BETFANATICS.COM",
    },
    "fes": {
        "account": "REA28857-FAN_DATA_EXCHANGE_PROD",
        "host": "vyb11067.us-east-1.privatelink.snowflakecomputing.com",
        "user": "DAVID.NAM@BETFANATICS.COM",
    },
}

QUERY_HISTORY_SQL = """
SELECT
    QUERY_ID,
    QUERY_TEXT,
    DATABASE_NAME,
    SCHEMA_NAME,
    WAREHOUSE_NAME,
    START_TIME,
    EXECUTION_STATUS,
    TOTAL_ELAPSED_TIME
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY(
    RESULT_LIMIT => 10000
))
WHERE EXECUTION_STATUS = 'SUCCESS'
  AND QUERY_TYPE IN ('SELECT', 'CREATE_TABLE_AS_SELECT', 'INSERT', 'MERGE', 'UPDATE', 'DELETE', 'CREATE_TABLE', 'CREATE_VIEW')
ORDER BY START_TIME DESC
"""

# Skip trivial queries
SKIP_PATTERNS = [
    r'^\s*SELECT\s+1\s*;?\s*$',
    r'^\s*SELECT\s+CURRENT_',
    r'^\s*SHOW\s+',
    r'^\s*DESC(RIBE)?\s+',
    r'^\s*USE\s+',
    r'^\s*ALTER\s+SESSION',
    r'^\s*SET\s+',
    r'^\s*LIST\s+',
]


def is_junk_query(query_text):
    """Filter out trivial/boilerplate queries."""
    text = query_text.strip()
    if len(text) < 20:
        return True
    for pattern in SKIP_PATTERNS:
        if re.match(pattern, text, re.IGNORECASE):
            return True
    return False


def sanitize_filename(name):
    """Make a string safe for use as a filename."""
    if not name:
        return "unknown"
    return re.sub(r'[^\w\-]', '_', name.lower()).strip('_')[:50]


def export_environment(env_name, config):
    """Connect to a Snowflake environment and export query history."""
    print(f"\n{'='*60}")
    print(f"Connecting to {env_name.upper()}...")
    print(f"{'='*60}")

    try:
        conn = snowflake.connector.connect(
            account=config["account"],
            host=config["host"],
            user=config["user"],
            authenticator="externalbrowser",
        )
    except Exception as e:
        print(f"Failed to connect to {env_name.upper()}: {e}")
        return

    cursor = conn.cursor()

    try:
        # Need a database context for INFORMATION_SCHEMA
        cursor.execute("SHOW DATABASES")
        dbs = cursor.fetchall()
        if dbs:
            first_db = dbs[0][1]  # name column
            cursor.execute(f'USE DATABASE "{first_db}"')
            print(f"Using database: {first_db}")

        print("Querying history (this may take a moment)...")
        cursor.execute(QUERY_HISTORY_SQL)
        rows = cursor.fetchall()
        print(f"Found {len(rows)} successful queries.")
    except Exception as e:
        print(f"Error querying history: {e}")
        conn.close()
        return

    # Deduplicate by query text hash
    seen_hashes = set()
    unique_queries = []

    for row in rows:
        query_id, query_text, db_name, schema_name, warehouse, start_time, status, elapsed = row
        if is_junk_query(query_text):
            continue
        query_hash = hashlib.md5(query_text.strip().encode()).hexdigest()
        if query_hash in seen_hashes:
            continue
        seen_hashes.add(query_hash)
        unique_queries.append({
            "query_id": query_id,
            "query_text": query_text.strip(),
            "database": db_name or "unknown",
            "schema": schema_name or "unknown",
            "warehouse": warehouse,
            "start_time": start_time,
            "elapsed_ms": elapsed,
        })

    print(f"After dedup and filtering: {len(unique_queries)} unique queries.")

    # Save queries organized by database
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    env_dir = os.path.join(repo_root, env_name)

    for q in unique_queries:
        db_dir = os.path.join(env_dir, sanitize_filename(q["database"]))
        os.makedirs(db_dir, exist_ok=True)

        timestamp = q["start_time"].strftime("%Y%m%d_%H%M%S")
        filename = f"{timestamp}_{q['query_id'][:8]}.sql"
        filepath = os.path.join(db_dir, filename)

        header = f"""-- Query ID: {q['query_id']}
-- Database: {q['database']}
-- Schema: {q['schema']}
-- Warehouse: {q['warehouse']}
-- Executed: {q['start_time'].isoformat()}
-- Elapsed: {q['elapsed_ms']}ms
-- Environment: {env_name.upper()}

"""
        with open(filepath, "w") as f:
            f.write(header + q["query_text"] + "\n")

    print(f"Saved {len(unique_queries)} queries to {env_dir}/")
    conn.close()


def main():
    print("Snowflake Query History Exporter")
    print("================================")
    print("This will open browser windows for SSO authentication.")
    print("You'll need to approve login for each environment.\n")

    for env_name, config in ENVIRONMENTS.items():
        export_environment(env_name, config)

    print("\nDone! Queries saved to fbg/ and fes/ directories.")


if __name__ == "__main__":
    main()
