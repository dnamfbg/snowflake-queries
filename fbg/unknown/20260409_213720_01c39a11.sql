-- Query ID: 01c39a11-0212-6dbe-24dd-07031938d133
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:37:20.278000+00:00
-- Elapsed: 1035434ms
-- Environment: FBG

with changed_accounts AS (
    SELECT DISTINCT
        transaction_account_id

    FROM FBG_REPORTS.REGULATORY.fct_regulatory_metrics AS m
    LEFT JOIN FBG_ANALYTICS_ENGINEERING.REGULATORY.STG_ACCOUNT_INFO AS acct
      ON m.transaction_account_id = acct.id::varchar
    WHERE m.finance_transaction_source in ('OSB', 'CORPORATE')
           AND m.record_last_updated >= (SELECT MAX(DATEADD('hour', -24, "Gaming Date"::TIMESTAMP_NTZ(9))) FROM fbg_reports.regulatory.sportsbook_pasr)
    
),

metrics AS (
  select  
      date(trans_date_local_w_offset) AS gaming_date,
      m.transaction_account_id,
      transaction_location_name,
      transaction_location_initials,
      abs(sum(case when metric_name = 'CORE_OSB_CASH_WAGERS_STAKED' then transaction_amount end)) AS "Total Sportsbook Cash Transfer to Games",
      sum(case when metric_name = 'CORE_OSB_CASH_INITIAL_PAYOUTS' then transaction_amount end) AS "Total Sportsbook Cash Transfer from Games",
      sum(case when metric_name = 'CORE_OSB_CASH_VOIDS' then transaction_amount end) AS "Sportsbook Cash Voids",
      sum(case when metric_name = 'CORE_OSB_CASH_CANCELS' then transaction_amount end) AS "Sportsbook Cash Cancels",
      sum(case when metric_name = 'CORE_OSB_CASH_RESETTLEMENTS' then transaction_amount end) AS "Sportsbook Cash Net Resettlements",
      abs(sum(case when metric_name = 'CORE_OSB_BONUS_WAGERS_STAKED' then transaction_amount end)) AS "Sportsbook Non-cash Money Transfer to Games",
      sum(case when metric_name in ('CORE_OSB_BONUS_INITIAL_PAYOUTS', 'CORE_OSB_FREEBET_AWARDS_BET_SETTLEMENT_ALL', 'CORE_OSB_FANCASH_CASHOUT_PAYOUTS') then transaction_amount end) AS "Total Sportsbook Non-cash Transfer from Games",
      sum(case when metric_name in ('CORE_OSB_BONUS_VOIDS', 'CORE_OSB_CASH_VOIDS', 'CORE_OSB_FANCASH_CASHOUT_VOIDS')  then transaction_amount end) AS "Total Sportsbook Voids",
      sum(case when metric_name in ('CORE_OSB_BONUS_CANCELS','CORE_OSB_CASH_CANCELS')  then transaction_amount end) AS "Total Sportsbook Cancels",
      sum(case when metric_name = 'CORE_OSB_BONUS_RESETTLEMENTS' then transaction_amount end) AS "Sportsbook Bonus Net Resettlements",
      sum(case when metric_name = 'CORE_DEPOSITS_COMPLETED' then transaction_amount end) AS "Deposits",
      sum(case when metric_name = 'CORE_WITHDRAWS_COMPLETED' then transaction_amount end) AS "Withdrawals",
      sum(case when metric_name = 'CORE_CASH_ADJUSTMENTS' then transaction_amount end) AS "Cash Adjustments",
      sum(case when metric_name = 'CORE_BONUS_ADJUSTMENTS' then transaction_amount end) AS "Bonus Adjustments"
  FROM FBG_REPORTS.REGULATORY.fct_regulatory_metrics AS m
  INNER JOIN changed_accounts AS ca
    ON ca.transaction_account_id = m.transaction_account_id
  LEFT JOIN FBG_ANALYTICS_ENGINEERING.REGULATORY.STG_ACCOUNT_INFO AS acct
      ON m.transaction_account_id = acct.id::varchar
  WHERE m.finance_transaction_source in ('OSB', 'CORPORATE')
  GROUP BY ALL
),

unsettled_sportsbook AS (
SELECT
    "Gaming Date",
    "Bettor ID",
    jurisdiction_name,
    sum("Total Wager Amount Staked") AS "Total Wager Amount Pending"
    FROM FBG_REPORTS.REGULATORY.unsettled_bets_report AS uns
    INNER JOIN changed_accounts AS ca
        ON ca.transaction_account_id = uns."Bettor ID"
GROUP BY ALL
)

select 
    convert_timezone('UTC', 'America/New_York', current_timestamp()) AS "Report Generation",
    d.date_value AS "Gaming Date",
    d.transaction_account_id AS acco_id,
    a.first_name,
    a.last_name,
    a.username,
    d.transaction_location_name AS jurisdiction_name,
    d.transaction_location_initials AS jurisdiction_code,
    a.account_type AS "Account Type",
    w.STATE_OPENING_CASH_BALANCE AS "State Opening Cash Balance",
    coalesce(m."Deposits", 0) AS "Deposits",
    coalesce(m."Withdrawals", 0) AS "Withdrawals",
    round(coalesce(lead(u."Total Wager Amount Pending") OVER (PARTITION BY d.transaction_account_id, d.transaction_location_name ORDER BY d.date_value DESC), 0), 2)
    AS "Beginning Sportsbook Open Liabilities Balance",
    round(coalesce(u."Total Wager Amount Pending", 0), 2) AS "Ending Sportsbook Open Liabilities Balance",
    coalesce(m."Total Sportsbook Cash Transfer to Games", 0) AS "Total Sportsbook Cash Transfer to Games",
    coalesce(m."Sportsbook Non-cash Money Transfer to Games", 0) AS "Sportsbook Non-cash Money Transfer to Games",
    coalesce(m."Total Sportsbook Cash Transfer from Games", 0) AS "Total Sportsbook Cash Transfer from Games",
    coalesce(m."Total Sportsbook Non-cash Transfer from Games", 0) AS "Total Sportsbook Non-cash Transfer from Games",
    coalesce(m."Total Sportsbook Voids", 0) AS "Total Sportsbook Voids",
    coalesce(m."Total Sportsbook Cancels", 0) AS "Total Sportsbook Cancels",
    coalesce(m."Sportsbook Cash Voids", 0) AS "Sportsbook Cash Voids",
    coalesce(m."Sportsbook Cash Cancels", 0) AS "Sportsbook Cash Cancels",
    coalesce(m."Sportsbook Cash Net Resettlements", 0) AS "Sportsbook Cash Net Resettlements",
    coalesce(m."Sportsbook Bonus Net Resettlements", 0) AS "Sportsbook Bonus Net Resettlements",
    coalesce(m."Cash Adjustments", 0) AS "Cash Adjustments",
    coalesce(m."Bonus Adjustments", 0) AS "Bonus Adjustments",
    coalesce(w.STATE_CLOSING_CASH_BALANCE,0) - 
            ((coalesce(w.STATE_OPENING_CASH_BALANCE, 0) + coalesce(m."Deposits", 0) 
            + coalesce(m."Cash Adjustments", 0) + coalesce(m."Total Sportsbook Cash Transfer from Games", 0)
            + coalesce(m."Sportsbook Cash Net Resettlements", 0)
            + coalesce(m."Sportsbook Cash Voids", 0) + coalesce(m."Sportsbook Cash Cancels", 0))
            -
            (coalesce(m."Withdrawals", 0) 
            + coalesce(m."Total Sportsbook Cash Transfer to Games", 0) 
            )) AS "Cash Balance Transferred",
    w.STATE_CLOSING_CASH_BALANCE AS "State Closing Cash Balance"
FROM FBG_REPORTS.REGULATORY.stg_gaming_day_accounts AS d
INNER JOIN FBG_ANALYTICS_ENGINEERING.REGULATORY.STG_ACCOUNT_INFO AS a
    ON d.transaction_account_id = a.id::varchar
LEFT JOIN metrics AS m
    ON d.date_value = m.gaming_date
    AND d.transaction_account_id = m.transaction_account_id
    AND d.transaction_location_name = m.transaction_location_name
LEFT JOIN unsettled_sportsbook AS u
    ON u."Bettor ID"::varchar = d.transaction_account_id
    AND u."Gaming Date" = d.date_value
    AND u.jurisdiction_name = d.transaction_location_name
LEFT JOIN FBG_REPORTS.REGULATORY.stg_traveling_account_balances AS w
    ON w.acco_id = d.transaction_account_id
    AND w.gaming_date = d.date_value
    AND w.state_code = d.transaction_location_initials
