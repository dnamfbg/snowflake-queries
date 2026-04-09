-- Query ID: 01c39a39-0212-644a-24dd-07031941dc23
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:17:45.173000+00:00
-- Elapsed: 4971ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_competitive_exchange_mapping
    
    
    
    as (-- ─────────────────────────────────────────────────────────────────────────────
-- COMPETITIVE EXCHANGE MAPPING
-- Kalshi coverage vs FMX at sport × league × market_type grain.
-- One row per date × sport_category × league × market_type where Kalshi has volume.
--
-- Key output:
--   league            — unified league identifier: fmx_league_code for covered leagues
--                       (e.g. EPL, NBA, CBB), Kalshi asset_label for BREADTH gaps
--                       (e.g. EUROLEAGUE, LIGA_MX). Multiple Kalshi asset_labels that
--                       map to the same FMX code collapse into one row here
--                       (PREMIERLEAGUE + EPL + EPLTOP6 → EPL).
--   gap_type          — BREADTH / DEPTH / COVERED classification at league × market_type
--   coverage_gap_flag — true for BREADTH or DEPTH rows (FMX has a gap); false for COVERED
--   match_type        — DIRECT when FMX covers both league and market_type; KALSHI_ONLY otherwise
--
-- FMX and NADEX volume are populated at the fmx_league_code grain by extracting
-- the league code from FMX market symbols (NX.F.OPT.<CODE>-...). For BREADTH
-- gap rows (no FMX league), fmx_volume_usd and nadex_volume_usd are 0.
--
-- Gap classification:
--   BREADTH     — FMX does not offer this league/asset_label at all
--   DEPTH       — FMX offers the league but not this market_type (catalog-level)
--   COVERED — FMX offers both the league and market_type (competition row)
--
-- FMX league coverage is determined by two data-driven mechanisms:
--   1. seeds/kalshi_fmx_league_crosswalk.csv maps each Kalshi asset_label to the
--      FMX league code embedded in FMX market symbols (e.g. EPL, DEB, NBA, CBB).
--      Many Kalshi labels roll up to one FMX code (NCAAMBBIG10, MARMAD,
--      NCAAM_BASKETBALL all → CBB). Absence from the seed = automatic BREADTH gap.
--      Add new asset_labels by editing the CSV — no SQL changes needed.
--   2. fmx_active_leagues CTE reads distinct league codes actually present in
--      FMX's market catalog (parsed from stg_fmx_crypto_markets symbols). If
--      FMX drops a league, coverage auto-detects as a BREADTH gap.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Cross-walk: Kalshi sport → FMX sport ─────────────────────────────────────
with sport_crosswalk as (
    select
        kalshi_sport,
        fmx_sport
    from (
        values
        ('BASKETBALL', 'BASKETBALL'),
        ('FOOTBALL', 'FOOTBALL'),
        ('HOCKEY', 'HOCKEY'),
        ('BASEBALL', 'BASEBALL'),
        ('SOCCER', 'SOCCER'),
        ('MMA', 'MMA'),
        ('BOXING', 'BOXING'),
        ('TENNIS', 'TENNIS'),
        ('GOLF', 'GOLF'),
        ('MOTOR_RACING', 'MOTOR_RACING'),
        ('OLYMPICS', 'OLYMPICS'),
        -- Multi-sport combo products on Kalshi surface under FMX's COMBO_PARLAY bucket
        ('MULTI_SPORT', 'COMBO_PARLAY'),
        -- Kalshi-only sports (no FMX equivalent) — appear as KALSHI_ONLY rows
        ('CYCLING', null),          -- Tour de France; FMX has no cycling product
        ('ESPORTS', null),          -- CS2/Valorant/LoL; FMX has no esports product
        ('CRICKET', null),          -- T20/IPL; FMX has no cricket product
        ('TABLE_TENNIS', null),     -- FMX has no table tennis product
        ('DARTS', null),            -- FMX has no darts product
        ('CHESS', null),            -- FMX has no chess product
        ('VOLLEYBALL', null),       -- FMX has no volleyball product
        ('AUSTRALIAN_FOOTBALL', null) -- FMX has no AFL product
    ) as t (kalshi_sport, fmx_sport)
),

-- ── Normalize Kalshi market_type_label → unified market_type vocabulary ───────
kalshi_daily_normalized as (
    select
        activity_date,
        sport,
        asset_label,
        total_contracts,
        total_volume_usd,
        case
            when market_type_label = 'MONEYLINE' and sport in ('MMA', 'BOXING')
                then 'FIGHT_LINE'
            when market_type_label = 'MONEYLINE' then 'MONEYLINE'
            when market_type_label = 'SPREAD' then 'SPREAD'
            when market_type_label = 'OVER_UNDER' then 'OVER_UNDER'
            when market_type_label = '1H_SPREAD' then 'GAME_PROP'
            when market_type_label = '2H_SPREAD' then 'GAME_PROP'
            when market_type_label = '1H_OVER_UNDER' then 'GAME_PROP'
            when market_type_label = '2H_OVER_UNDER' then 'GAME_PROP'
            when market_type_label = 'SCORE_BY_QUARTER' then 'GAME_PROP'
            when market_type_label = 'BOTH_TEAMS_SCORE' then 'GAME_PROP'
            when market_type_label = 'FIRST_GOAL' then 'GAME_PROP'
            when market_type_label = 'HIGH_SCORE' then 'GAME_PROP'
            when market_type_label = 'GOES_THE_DISTANCE' then 'GAME_PROP'
            when market_type_label = 'FIGHT_ROUNDS' then 'GAME_PROP'
            when market_type_label = 'METHOD_OF_VICTORY' then 'GAME_PROP'
            when market_type_label = 'KNOCKOUT' then 'GAME_PROP'
            when market_type_label = 'GOALS' then 'GAME_PROP'
            when market_type_label = 'TOTAL_MAPS' then 'GAME_PROP'
            when market_type_label = 'PLAYER_POINTS' then 'PLAYER_PROP'
            when market_type_label = 'PLAYER_REBOUNDS' then 'PLAYER_PROP'
            when market_type_label = 'PLAYER_ASSISTS' then 'PLAYER_PROP'
            when market_type_label = 'PLAYER_3_POINTERS' then 'PLAYER_PROP'
            when market_type_label = 'PLAYER_BLOCKS' then 'PLAYER_PROP'
            when market_type_label = 'PLAYER_STEALS' then 'PLAYER_PROP'
            when market_type_label = 'PASSING_YARDS' then 'PLAYER_PROP'
            when market_type_label = 'PASSING_TDS' then 'PLAYER_PROP'
            when market_type_label = 'RECEIVING_YARDS' then 'PLAYER_PROP'
            when market_type_label = 'RUSHING_YARDS' then 'PLAYER_PROP'
            when market_type_label = 'SEASON_WINS' then 'TEAM_FUTURE'
            when market_type_label = 'TOURNAMENT' then 'TEAM_FUTURE'
            when market_type_label = 'PLAYOFFS' then 'TEAM_FUTURE'
            when market_type_label = 'ADVANCE_QUALIFY' then 'TEAM_FUTURE'
            when market_type_label = 'GROUP_STAGE_QUALIFY' then 'TEAM_FUTURE'
            when market_type_label = 'GROUP_WIN' then 'TEAM_FUTURE'
            when market_type_label = 'RELEGATION' then 'TEAM_FUTURE'
            when market_type_label = 'SEASON' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_2_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_3_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_4_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_5_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_10_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'TOP_20_FINISH' then 'TEAM_FUTURE'
            when market_type_label = 'MAKE_CUT' then 'PLAYER_FUTURE'
            when market_type_label = 'MVP' then 'PLAYER_FUTURE'
            when market_type_label = 'DEFENSIVE_POY' then 'PLAYER_FUTURE'
            when market_type_label = 'COACH_OF_YEAR' then 'COACH_FUTURE'
            when market_type_label = 'ROOKIE_OF_YEAR' then 'PLAYER_FUTURE'
            when market_type_label = 'MOST_IMPROVED' then 'PLAYER_FUTURE'
            when market_type_label = 'DRAFT_PICK' then 'PLAYER_FUTURE'
            when market_type_label = 'DRAFT_TOP' then 'PLAYER_FUTURE'
            when market_type_label = 'DRAFT_1_PICK' then 'PLAYER_FUTURE'
            when market_type_label in (
                'PLAYER_PROP_DOUBLE_DOUBLE',
                'PLAYER_PROP_TRIPLE_DOUBLE',
                'PLAYER_PROP_TD_SCORER',
                'PLAYER_PROP_FIRST_TD_SCORER',
                'PLAYER_PROP_MULTI_TD_SCORER',
                'PLAYER_PROP_RECEPTIONS'
            ) then 'PLAYER_PROP'
            when market_type_label in ('GAME_PROP_OTHER', 'GAME_PROP_H2H') then 'GAME_PROP'
            when market_type_label = 'TOURNAMENT_PROP' then 'TOURNAMENT_PROP'
            when market_type_label = 'TEAM_FUTURE_QUALIFY' then 'TEAM_FUTURE'
            when market_type_label = 'SINGLE_GAME_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = 'PRE_PACK_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = '2_LEG_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = '3_LEG_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = '4_LEG_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = '1H_FULL_TIME_PARLAY' then 'COMBO_PARLAY'
            when market_type_label = 'MULTI_GAME_EXTENDED' then 'COMBO_PARLAY'
            when market_type_label = 'CROSS_CATEGORY' then 'COMBO_PARLAY'
            -- Novelty/news markets — not comparable to FMX sports products
            when market_type_label = 'MENTIONED_IN' then null
            else market_type_label
        end as market_type_normalized
    from FMX_ANALYTICS.CUSTOMER.fct_kalshi_daily_metrics
),

-- ── Kalshi asset_label → FMX league code crosswalk ───────────────────────────
-- Source of truth: seeds/kalshi_fmx_league_crosswalk.csv
-- Each row maps one Kalshi asset_label to an FMX league code.
-- Absence from the seed = no FMX equivalent = automatic BREADTH gap.
-- To add a new league: edit the CSV (no SQL changes needed).
kalshi_to_fmx_league as (
    select
        kalshi_asset_label,
        fmx_league_code
    from FMX_ANALYTICS.CUSTOMER.kalshi_fmx_league_crosswalk
),

-- ── Kalshi asset_label → FMX sub-league crosswalk ────────────────────────────
-- Source of truth: seeds/kalshi_sub_league_crosswalk.csv
-- Provides sub-league granularity for sports where the FMX symbol does not
-- encode the league (e.g. all tennis markets share the TENNIS code). Each row
-- maps a Kalshi asset_label to an fmx_sub_league value aligned with the
-- fmx_venue_sub_league_crosswalk used on the FMX side.
kalshi_to_sub_league as (
    select
        kalshi_asset_label,
        sport,
        fmx_sub_league
    from FMX_ANALYTICS.CUSTOMER.kalshi_sub_league_crosswalk
),

-- ── FMX active league codes ───────────────────────────────────────────────────
-- Distinct league codes present in FMX's product catalog. For most sports,
-- league is extracted from the symbol (NX.F.OPT.<CODE>-...). For sports with
-- sub-league granularity (e.g. tennis), sub_league from fct_fmx_market_labels
-- takes precedence when available so the full sub-league taxonomy is recognised
-- (e.g. AUSTRALIAN_OPEN, FRENCH_OPEN, WIMBLEDON, US_OPEN, ATP_MASTERS,
-- ATP_TOUR, WTA_TOUR, ATP_CHALLENGER), while unmapped venues may still fall
-- back to the catch-all TENNIS code extracted from the symbol.
fmx_active_leagues as (
    select distinct a.fmx_league_code
    from (
        select
            coalesce(
                sub_league,
                nullif(
                    upper(split_part(split_part(split_part(symbol, 'NX.F.OPT.', 2), '.', 1), '-', 1)),
                    ''
                )
            ) as fmx_league_code
        from FMX_ANALYTICS.CUSTOMER.fct_fmx_market_labels
        where symbol like 'NX.F.OPT.%'
    ) as a
    where a.fmx_league_code is not null
),

-- ── Aggregate Kalshi to sport × league × market_type per day ──────────────────
-- Crosswalk join happens here (before GROUP BY) so multiple Kalshi asset_labels
-- that share an FMX league code collapse into one row.
-- e.g. PREMIERLEAGUE + EPL + EPLTOP6 all → fmx_league_code EPL → one EPL row.
-- For asset_labels absent from the crosswalk (BREADTH gaps like EUROLEAGUE),
-- coalesce falls back to the Kalshi asset_label itself.
--
-- For sports with sub-league granularity (e.g. tennis), the sub-league crosswalk
-- takes precedence over the generic fmx_league_code, giving us
-- AUSTRALIAN_OPEN / FRENCH_OPEN / WIMBLEDON / US_OPEN / ATP_MASTERS /
-- ATP_TOUR / WTA_TOUR / ATP_CHALLENGER etc. instead of collapsing to TENNIS.
--
-- Note: `where k.sport is not null` excludes ~16.8% of Kalshi volume (non-sport
-- markets: crypto, politics, economics, entertainment) that have no FMX equivalent.
-- market_type_normalized is not null excludes a small set of sport rows where the
-- market_type_label passes through the normalization CASE as null.
kalshi_by_league as (
    select
        k.activity_date,
        k.market_type_normalized as market_type,
        coalesce(sl.fmx_sub_league, xw.fmx_league_code, k.asset_label) as league,
        coalesce(x.fmx_sport, k.sport) as sport_category,
        -- seed_mapped: true only when every Kalshi asset_label that collapses into
        -- this league group has an explicit row in either mapping seed
        -- (kalshi_fmx_league_crosswalk or kalshi_sub_league_crosswalk). MIN ensures a
        -- single unmapped label cannot piggyback onto a covered group and be falsely
        -- marked as covered (e.g. an unmapped label whose string equals an FMX code).
        min(xw.fmx_league_code is not null or sl.fmx_sub_league is not null) as seed_mapped,
        sum(k.total_contracts) as kalshi_contracts,
        sum(k.total_volume_usd) as kalshi_volume_usd
    from kalshi_daily_normalized as k
    left join sport_crosswalk as x
        on k.sport = x.kalshi_sport
    left join kalshi_to_fmx_league as xw
        on k.asset_label = xw.kalshi_asset_label
    left join kalshi_to_sub_league as sl
        on
            k.asset_label = sl.kalshi_asset_label
            and k.sport = sl.sport
    where
        k.sport is not null
        and k.market_type_normalized is not null
    group by k.activity_date, league, sport_category, k.market_type_normalized
),

-- ── FMX market_type coverage (catalog-level) ─────────────────────────────────
-- Uses fct_fmx_market_labels to check whether FMX offers this sport × league ×
-- market_type in its product catalog, independent of daily trading activity.
-- A market type is "covered" if it exists in the catalog — a slow trading day
-- should not flip a row from COVERED to DEPTH.
-- For most sports, league is extracted from the symbol (NX.F.OPT.<CODE>-...).
-- For sports with sub-league granularity (e.g. tennis), sub_league from
-- fct_fmx_market_labels takes precedence, giving coverage at the tour grain
-- (GRAND_SLAM, ATP_MASTERS, ATP_TOUR, WTA_TOUR, ATP_CHALLENGER).
fmx_market_type_coverage as (
    select distinct
        m.sport_category,
        m.market_type,
        m.league
    from (
        select
            sport as sport_category,
            market_type,
            coalesce(
                sub_league,
                nullif(
                    upper(split_part(split_part(split_part(symbol, 'NX.F.OPT.', 2), '.', 1), '-', 1)),
                    ''
                )
            ) as league
        from FMX_ANALYTICS.CUSTOMER.fct_fmx_market_labels
        where
            sport is not null
            and symbol like 'NX.F.OPT.%'
    ) as m
    where m.league is not null
),

-- ── FMX daily volume at league × market_type grain ───────────────────────────
-- For most sports, league is extracted from the symbol (NX.F.OPT.<CODE>-...).
-- For sports with sub-league granularity (e.g. tennis), sub_league from
-- fct_fmx_daily_metrics (sourced from fct_fmx_market_labels via venue crosswalk)
-- takes precedence, giving volume at GRAND_SLAM / ATP_MASTERS / ATP_TOUR grain.
-- NON_SPORT_MARKET rows are excluded — they would never join to Kalshi rows.
fmx_by_league as (
    select
        f.activity_date,
        f.market_type,
        f.league,
        sum(f.total_volume_usd) as fmx_volume_usd,
        sum(f.total_trades) as fmx_trades
    from (
        select
            activity_date,
            market_type,
            total_volume_usd,
            total_trades,
            coalesce(
                sub_league,
                nullif(
                    upper(split_part(split_part(split_part(market_symbol, 'NX.F.OPT.', 2), '.', 1), '-', 1)),
                    ''
                )
            ) as league
        from FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_metrics
        where
            market_symbol like 'NX.F.OPT.%'
            and market_type is not null
            and market_type != 'NON_SPORT_MARKET'
    ) as f
    where f.league is not null
    group by f.activity_date, f.market_type, f.league
),

-- ── NADEX reliable symbol-level records ──────────────────────────────────────
-- Filter out known NADEX feed-drop cases where NADEX volume < FMX volume for
-- the same activity_date × market_symbol. Keep rows with no FMX
-- counterpart (BREADTH gaps) and rows where NADEX >= FMX.
nadex_reliable as (
    select
        n.activity_date,
        n.market_symbol,
        n.market_type,
        n.sub_league,
        n.total_volume_usd,
        n.total_trades
    from FMX_ANALYTICS.CUSTOMER.fct_nadex_daily_metrics as n
    left join FMX_ANALYTICS.CUSTOMER.fct_fmx_daily_metrics as f
        on
            n.activity_date = f.activity_date
            and n.market_symbol = f.market_symbol
    where
        f.market_symbol is null
        or coalesce(n.total_volume_usd, 0) >= coalesce(f.total_volume_usd, 0)
),

-- ── NADEX daily volume at league × market_type grain ─────────────────────────
-- Same sub_league-aware league logic as fmx_by_league.
-- Built from nadex_reliable to exclude feed-drop records where NADEX volume <
-- FMX volume, which would otherwise understate NADEX's true market share.
nadex_by_league as (
    select
        nr.activity_date,
        nr.market_type,
        nr.league,
        sum(nr.total_volume_usd) as nadex_volume_usd,
        sum(nr.total_trades) as nadex_trades
    from (
        select
            activity_date,
            market_type,
            total_volume_usd,
            total_trades,
            coalesce(
                sub_league,
                nullif(
                    upper(split_part(split_part(split_part(market_symbol, 'NX.F.OPT.', 2), '.', 1), '-', 1)),
                    ''
                )
            ) as league
        from nadex_reliable
        where
            market_symbol like 'NX.F.OPT.%'
            and market_type is not null
            and market_type != 'NON_SPORT_MARKET'
    ) as nr
    where nr.league is not null
    group by nr.activity_date, nr.market_type, nr.league
),

-- ── Join Kalshi with FMX coverage flags and volume ───────────────────────────
-- fmx_covers_league: true only when BOTH conditions hold:
--   1. seed_mapped = true (crosswalk has an explicit row for this asset_label)
--   2. The mapped fmx_league_code exists in FMX's live catalog (fmx_active_leagues)
-- Requiring seed presence prevents an unmapped Kalshi label that coincidentally
-- equals an FMX code (e.g. "NBA") from being falsely marked as covered.
-- fmx_volume_usd / nadex_volume_usd: populated for covered leagues via league
--   code join; coalesce to 0 for BREADTH gap rows (no FMX/NADEX equivalent).
joined as (
    select
        k.activity_date,
        k.sport_category,
        k.league,
        k.market_type,
        k.kalshi_contracts,
        k.kalshi_volume_usd,
        coalesce(f.fmx_volume_usd, 0) as fmx_volume_usd,
        coalesce(f.fmx_trades, 0) as fmx_trades,
        coalesce(n.nadex_volume_usd, 0) as nadex_volume_usd,
        coalesce(n.nadex_trades, 0) as nadex_trades,
        -- fmx_covers_league requires seed match AND active catalog presence
        (k.seed_mapped and al.fmx_league_code is not null) as fmx_covers_league,
        -- fmx_covers_market_type: FMX offers this sport × league × market_type in catalog
        mt.sport_category is not null as fmx_covers_market_type
    from kalshi_by_league as k
    left join fmx_active_leagues as al
        on
            k.seed_mapped = true
            and k.league = al.fmx_league_code
    left join fmx_market_type_coverage as mt
        on
            k.seed_mapped = true
            and k.sport_category = mt.sport_category
            and k.league = mt.league
            and k.market_type = mt.market_type
    left join fmx_by_league as f
        on
            k.seed_mapped = true
            and k.activity_date = f.activity_date
            and k.league = f.league
            and k.market_type = f.market_type
    left join nadex_by_league as n
        on
            k.seed_mapped = true
            and k.activity_date = n.activity_date
            and k.league = n.league
            and k.market_type = n.market_type
)

select
    activity_date,
    sport_category,
    league,
    market_type,
    kalshi_volume_usd,
    kalshi_contracts,
    fmx_volume_usd,
    fmx_trades,
    nadex_volume_usd,
    nadex_trades,
    -- Match type: DIRECT when FMX covers both the league and market_type.
    -- KALSHI_ONLY otherwise (breadth gap, depth gap, or sport not offered by FMX).
    case
        when fmx_covers_league and fmx_covers_market_type then 'DIRECT'
        else 'KALSHI_ONLY'
    end as match_type,
    -- Coverage gap flag: true whenever FMX is missing either the league or market_type
    not(fmx_covers_league and fmx_covers_market_type) as coverage_gap_flag,
    -- Gap type classification:
    --   BREADTH     — FMX does not offer this league/asset_label at all
    --   DEPTH       — FMX offers the league but not this market_type (catalog-level)
    --   COVERED — FMX offers both; Kalshi still has volume (competition rows)
    case
        when not fmx_covers_league then 'BREADTH'
        when fmx_covers_league and not fmx_covers_market_type then 'DEPTH'
        when fmx_covers_league and fmx_covers_market_type then 'COVERED'
    end as gap_type
from joined
where kalshi_volume_usd > 0
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_competitive_exchange_mapping", "profile_name": "user", "target_name": "default"} */
