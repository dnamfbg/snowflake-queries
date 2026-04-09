-- Query ID: 01c39a1d-0212-67a9-24dd-0703193b9383
-- Database: FBG_ANALYTICS_ENGINEERING
-- Schema: TRADING
-- Warehouse: BI_SER_XL_WH
-- Executed: 2026-04-09T21:49:40.725000+00:00
-- Elapsed: 3944ms
-- Environment: FBG

SELECT
--leg_market_group,
--leg_market_sub_type,
    --event_league,
    --event_sport_name,
    --account_id,
    --wager_id,
    --trading_win,
    leg_market_type,
    --leg_market_sub_type,
    --REGEXP_SUBSTR(leg_market, '\\d+') as Drive_Num,
    --event_name,
    --DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)),
    --case when DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)) < '2025-10-22'
    --then 'pre'
    --else 'post' end as model_version,
    --case when total_cash_stake_by_legs < 1000 then '<1k' else '>=1k' end as wager_band,
    --case when leg_odds >= 3.5 then 'low prob' else 'high prob' end as model_prob,
    --leg_odds,
    --leg_selection,
    --account_value_band_as_of_placement,
    --leg_market,
    --avg(leg_odds),
    --EXP(AVG(LN(LEG_ODDS))),
    --leg_selection,
    --leg_odds,
    --leg_selection_type,
    --SELECTION_ID,
    --event_name,
    --leg_market,
    --leg_selection,
    --leg_result_type,
    --case when account_id = '1076752' then 'AR'
    --else 'other' end as which_client,
    --CASE WHEN
    --event_start_time_est < '2025-09-22' THEN 'Radar/Mixed'
    --ELSE 'TX'
    --end as before_after,
    --account_value_band_as_of_placement,
    --CASE 
    --    WHEN ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT IN ('VIP', 'Top VIP') THEN 'VIP'
    --   WHEN ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT IN ('Superfan', 'Existing Casual', 'New Casual', 'No Cash Bet', '', NULL) THEN 'Casual'
    --    WHEN ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT = 'Negative' THEN 'Negative'
    --    ELSE 'Other'
    --END AS ACCOUNT_GROUP,
    --Date(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)),
    --CASE 
    --    WHEN DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)) >= '2025-11-14' THEN 'After'
    --    ELSE 'Before'
    --END AS date_group,
    --is_live_bet_leg,
    --CASE WHEN leg_market ILIKE '%Quarter%' then 'Quarter' WHEN leg_market ILIKE '%Half%' then 'Half' end as selection,
    --CASE WHEN leg_selection ILIKE '%Over%' then 'Over' WHEN leg_selection ILIKE '%Under%' then 'Under' end as selection,
    case when leg_selection ILIKE '%Over%' then 'Over'
    when leg_selection ILIKE '%Under%' then 'Under'
    when leg_selection ILIKE '%Yes%' then 'Yes'
    when leg_selection ILIKE '%No%' then 'No'
    else 'other' end as selection,
    --case when
    --leg_market ILIKE '%2nd Half%' then '2nd half'
    --when leg_market ILIKE '%1st Half%' then '1st half'
    --when leg_market ILIKE '%1st Quarter%' then '1st Quarter'
    --when leg_market ILIKE '%2nd Quarter%' then '2nd Quarter'
    --when leg_market ILIKE '%3rd Quarter%' then '3rd Quarter'
    --when leg_market ILIKE '%4th Quarter%' then '4th Quarter'
    --else 'other' end as quarter_bet_on,
    --CASE WHEN leg_selection ILIKE '%Yes%' then 'Yes' WHEN leg_selection ILIKE '%No%' then 'No' end as selection2,
    --CASE
    --    WHEN leg_odds IS NULL THEN '0'
    --    WHEN leg_odds < 1.86 THEN 'Fav'
    --    WHEN leg_odds > 1.88 THEN 'Dog'
    --    ELSE 'Evens'
    --END AS Fav_Dog,
    --account_value_band_as_of_placement,
    --wager_bet_type,
    --CASE 
    --    WHEN DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)) BETWEEN '2025-10-22' AND '2026-01-20' 
    --    THEN TO_CHAR(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc), 'YYYY-MM')
    --    ELSE 'Other'
    --END AS month_bin,
    --CASE 
    --  WHEN leg_odds >= 0 AND leg_odds < 4 THEN '0–3.99'
    --  WHEN leg_odds >= 4 THEN '4+'
    -- ELSE 'Unknown'
    --END AS odds_bucket,
    --CASE 
    --  WHEN leg_odds >= 0 AND leg_odds < 1.25 THEN '0–1.25'
    --  WHEN leg_odds >= 1.25 AND leg_odds < 1.5 THEN '1.25–1.5'
    --  WHEN leg_odds >= 1.5 AND leg_odds < 2 THEN '1.5–2'
    --  WHEN leg_odds >= 2 AND leg_odds < 3 THEN '2–3'
    --  WHEN leg_odds >= 3 AND leg_odds < 6 THEN '3–6'
    --  WHEN leg_odds >= 6 AND leg_odds < 10 THEN '6–10'
    --  WHEN leg_odds >= 10 THEN '10+'
    --  ELSE 'Unknown'
    --END AS odds_bucket,
    --CASE 
    --  WHEN leg_odds >= 1.8 AND leg_odds <= 2.25 THEN 'core'
    --  ELSE 'Unknown'
    --END AS odds_bucket,
    --is_live_bet_leg,
    --CASE 
    --  WHEN leg_odds >= 0 AND leg_odds < 2 THEN '0–2'
    --  WHEN leg_odds >= 2 THEN '2+'
    --  ELSE 'Unknown'
    --END AS odds_bucket,
    --CASE 
    --    WHEN account_value_band_as_of_placement IN ('VIP', 'Top VIP') THEN 'VIP'
    --   ELSE 'Other'
    --END AS account_type,
--CASE 
    --total_non_cash_stake_by_legs,--
    --wager_rejection_details,
    SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END) AS Turnover,
    COUNT(DISTINCT CASE WHEN wager_status = 'SETTLED' THEN wager_id END) AS Bet_Count,
    SUM(CASE WHEN wager_status = 'SETTLED' THEN trading_win ELSE 0 END)/NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END), 0) AS TR_Margin,
    SUM(CASE WHEN wager_status = 'SETTLED' THEN trading_win ELSE 0 END) AS TR_Win,
    SUM(CASE WHEN wager_status = 'SETTLED' THEN expected_trading_win_by_legs ELSE 0 END) AS X_TW,
    SUM(CASE WHEN wager_status = 'SETTLED' THEN expected_trading_win_by_legs ELSE 0 END) 
    / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END), 0) AS X_Hold,
    SUM(CASE WHEN wager_status = 'SETTLED' AND ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT = 'Restricted' THEN total_cash_stake_by_legs ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN wager_status = 'SETTLED' THEN total_cash_stake_by_legs ELSE 0 END), 0) AS Restricted_Handle_Percentage,
    SUM(CASE WHEN wager_status = 'REJECTED' 
                AND ACCOUNT_VALUE_BAND_AS_OF_PLACEMENT != 'Restricted'
                AND wager_rejection_details NOT IN (
                    'INSUFFICIENT_FUNDS', 'OVERASK_UNEXPECTED_ERROR', 'WALLET_ERROR', 
                    'SELF_STAKE_LIMIT', 'GEOLOCATION_VALIDATION_FAILED', 'BONUS_VALIDATION', 
                    'MINIMUM_ACCOUNT_STATUS', 'TERMS_AND_CONDITIONS_NOT_ACCEPTED', 
                    'MIN_STAKE', 'OVERASK_EXPIRED', 'LIFETIME_DEPOSIT_LIMIT_EXCEEDED'
                ) THEN total_cash_stake_by_legs END) 
        / NULLIF(SUM(CASE WHEN wager_status IN ('SETTLED', 'REJECTED') THEN total_cash_stake_by_legs END), 0) AS Rejection_Rate
FROM
    trading_sportsbook_mart
WHERE
    leg_market_type IN ('BASEBALL:P:RUNYN', 'BASEBALL:P:OU') AND
    --market_tier_two_group IN ('PLAYER MILESTONES', 'PLAYER PROP O/U') AND
    --leg_market_type IN ('AMERICAN_FOOTBALL:FTOT:CDR') AND
    --market_grouping IN ('PLAYER - PLAYER MILESTONES', 'PLAYER - PLAYER PROP O/U') AND
    --leg_market_type not ilike ('%SW%') and
    --leg_market_type not ILIKE ('%NXTTD%') AND
    --leg_market NOT ILIKE '%Yankees%' AND
    --leg_selection NOT ILIKE '%Bucc%' AND
    --leg_market ILIKE '%3rd Period%' AND
    --WAGER_STATUS = 'SETTLED' AND
    --account_value_band_as_of_placement IN ('VIP', 'Top VIP') AND
    --account_id <> '1399848' and
    --wager_result != 'CASHOUT' and
    --account_id NOT IN (2026159, 1076752) and
    --wager_id = 25400412000039909 AND
    --event_league ILIKE ('%NFL%') AND
    event_league in ('MLB') AND
    event_sport_name = 'BASEBALL' and
    --leg_market ILIKE '%Tyler Herro%' AND
    --leg_market_type ILIKE '%SW%' and
    --event_name ILIKE '%Texans%' and
    is_live_bet_leg = TRUE AND
    is_wager_single_or_parlay = 'SINGLE' AND
    --wager_result = 'CASHOUT' and
    --event_league = 'NCAA' AND
    --event_sport_name ILIKE '%AMERICAN_FOOTBALL%' AND
    DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', leg_event_time_utc)) BETWEEN '2025-03-18' AND '2025-10-31'
    --AND TIMEDIFF(MINUTE, wager_placed_time_utc, wager_settlement_time_utc) < 8)
    AND total_cash_stake_by_legs < 1000
    --and leg_result_type != 'PUSH'
    and total_non_cash_stake_by_legs = 0
    and is_test_wager = 0
    --AND leg_market_type IN ('AMERICAN_FOOTBALL:FTOT:PSYDSCD')
    --AND wager_result = 'CASHOUT'
    --and leg_odds > 10.0
    --and leg_result_type = 'WIN'
    --AND ACCOUNT_ID != '2026159'
GROUP BY ALL
    --leg_market_type,
    --account_tier,
    --bet_period
    --account_type
    --leg_selection
    --selection
    --selection2
    --Fav_Dog
    --event_league
