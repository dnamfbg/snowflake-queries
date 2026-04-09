-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe2af
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:21.057000+00:00
-- Elapsed: 191494ms
-- Environment: FBG

create or replace  table FMX_ANALYTICS.CUSTOMER.fct_kalshi_market_labels
    
    
    
    as (-- ─────────────────────────────────────────────────────────────────────────────
-- KALSHI MARKET LABELS
-- One row per (report_ticker, ticker_name) — all distinct contracts seen in
-- the last 90 days of KALSHI_PUBLIC_MARKET.
--
-- Outputs a label lookup table for use in market comparison joins with FMX.
--
-- Key output columns:
--   report_ticker      — event-level ticker     e.g. KXNBAGAME
--   ticker_name        — contract-level ticker   e.g. KXNBAGAME-26MAR08CHAPHX-CHA
--   category           — Kalshi category         e.g. SPORTS
--   sport              — sport sub-category      e.g. BASKETBALL
--   is_combo           — true for combo/parlay products (SGP, prepack, multi-game)
--   asset_label        — subject label           e.g. NBA
--   market_type_label  — bet type                e.g. MONEYLINE
--   market_name        — combined market label   e.g. NBA - MONEYLINE
--   variant_detail     — contract detail         e.g. CHA vs PHX
--   variant_full_label — full display label      e.g. NBA - MONEYLINE: CHA vs PHX
-- ─────────────────────────────────────────────────────────────────────────────

-- ── STEP 1: All distinct contracts seen in last 90 days ──────────────────────
with all_variants as (
    select distinct
        report_ticker,
        ticker_name
    from FMX_ANALYTICS.STAGING.stg_kalshi_public_market
    where
        date >= dateadd(day, -90, current_date())
        
),

-- ── STEP 2: Category per report_ticker — from tickers catalog ────────────────
market_category as (
    select
        m.report_ticker,
        nullif(trim(max(t.category)), '') as category
    from all_variants as m
    left join FMX_ANALYTICS.STAGING.stg_kalshi_public_tickers as t
        on m.ticker_name = t.market_ticker
    group by m.report_ticker
),

-- ── STEP 3: Stripped asset body per report_ticker ────────────────────────────
market_body as (
    select
        mc.report_ticker,
        mc.category,
        regexp_replace(
            regexp_replace(
                regexp_replace(mc.report_ticker, '^KX', ''),
                'CHALLENGERMATCH$|MULTIGAMEEXTENDED$|CROSSCATEGORY$|GRANDSLAM$|WORLDCUP$|GROUPQUAL$|GROUPWIN$|FIRSTGOAL$|RELEGATION$|1HSPREAD$|1HTOTAL$|1HWINNER$|2HSPREAD$|2HTOTAL$|2HWINNER$|PLAYOFFS$|PLAYOFF$|ADVANCE$|SPECIAL$|PRIMARY$|RUNOFF$|MENTION$|DECISION$|DRAFTPICK$|DRAFTTOP$|DRAFT1$|BTTS$|TOTALMAPS$|TOTALSETS$|HIGHSCORE$|SCOREQ$|CHAMPION$|DISTANCE$|KNOCKOUT$|MAKECUT$|PASSYDS$|PASSTDS$|RECYDS$|RSHYDS$|SPREAD$|TOTAL$|GAME$|MATCH$|FIGHT$|TOUR$|GOAL$|CHAMP$|WINNER$|RACE$|MAP$|WINS$|ROUNDS$|MOV$|TOP20$|TOP10$|TOP5$|TOP4$|TOP3$|TOP2$|PTS$|REB$|AST$|3PT$|BLK$|STL$|SEATS$|NOM$|MVP$|DPOY$|COTY$|ROTY$|ROY$|MOTY$|15M$|1H$|5M$|MAXMON|MINMON|MAXY$|MINY$|MON$|BTCD$|BTCW$|BTCY$|ETHD$|ETHW$|ETHY$|SOLD$|SOLW$|SOLY$|XRPD$|XRPW$|XRPY$|DOGED$|DOGEW$|DOGEY$|SHIBAD$|SHIBAW$|SHIBAY$|INXUD$|INXUW$|INXUY$|NASDAQ100D$|NASDAQ100W$|NASDAQ100Y$|ANYTD$|FIRSTTD$|2TD$|NEXTTD$|GAMETD$|DSTTD$|4DCONV$|WINMARGIN$|R1LEAD$|R2LEAD$|R3LEAD$|R4LEAD$|H2H$|REC$|2D$|3D$', --noqa: LT05
                ''
            ),
            '[-_]', ' '
        ) as asset_body
    from market_category as mc
),

-- ── STEP 4: Market-level labels (one row per report_ticker) ──────────────────
market_labels as (
    select
        mb.report_ticker,
        mb.category,
        mb.asset_body,
        -- Human-friendly asset name
        -- Explicit report_ticker overrides first: tickers where suffix stripping
        -- consumes the full body (e.g. KXBTCD → '' after stripping BTCD$)
        case
            -- Challenger tickers: suffix strip eats 'CHALLENGERMATCH' → body = 'ATP'/'WTA'
            -- which would incorrectly map to ATP_TENNIS/WTA_TENNIS. Override explicitly.
            when mb.report_ticker = 'KXATPCHALLENGERMATCH' then 'ATP_CHALLENGER'
            when mb.report_ticker = 'KXWTACHALLENGERMATCH' then 'WTA_CHALLENGER'
            when mb.report_ticker in ('KXBTCD', 'KXBTCW', 'KXBTCY') then 'BITCOIN'
            when mb.report_ticker in ('KXETHD', 'KXETHW', 'KXETHY') then 'ETHEREUM'
            when mb.report_ticker in ('KXSOLD', 'KXSOLW', 'KXSOLY') then 'SOLANA'
            when mb.report_ticker in ('KXXRPD', 'KXXRPW', 'KXXRPY') then 'XRP'
            when mb.report_ticker in ('KXDOGED', 'KXDOGEW', 'KXDOGEY') then 'DOGECOIN'
            when mb.report_ticker in ('KXSHIBAD', 'KXSHIBAW', 'KXSHIBAY') then 'SHIBA_INU'
            when mb.report_ticker in ('KXINXUD', 'KXINXUW', 'KXINXUY') then 'SP_500'
            when mb.report_ticker in ('KXNASDAQ100D', 'KXNASDAQ100W', 'KXNASDAQ100Y') then 'NASDAQ_100'
            -- Asset body → human label
            when mb.asset_body = 'BTC' then 'BITCOIN'
            when mb.asset_body = 'ETH' then 'ETHEREUM'
            when mb.asset_body = 'SOL' then 'SOLANA'
            when mb.asset_body = 'SOLE' then 'SOLANA'
            when mb.asset_body = 'XRP' then 'XRP'
            when mb.asset_body = 'DOGE' then 'DOGECOIN'
            when mb.asset_body = 'SHIBA' then 'SHIBA_INU'
            when mb.asset_body = 'NBA' then 'NBA'
            when mb.asset_body = 'NCAAMB' then 'NCAAM_BASKETBALL'
            when mb.asset_body = 'NCAAWB' then 'NCAAW_BASKETBALL'
            when mb.asset_body = 'NCAAF' then 'COLLEGE_FOOTBALL'
            when mb.asset_body = 'NFL' then 'NFL'
            when mb.asset_body = 'NHL' then 'NHL'
            when mb.asset_body = 'MLB' then 'MLB'
            when mb.asset_body = 'MLBST' then 'MLB_SPRING_TRAINING'
            when mb.asset_body = 'MLS' then 'MLS'
            when mb.asset_body = 'SB' then 'SUPER_BOWL'
            when mb.asset_body = 'UFC' then 'UFC'
            when mb.asset_body = 'BOXING' then 'BOXING'
            when mb.asset_body = 'NASCAR' then 'NASCAR'
            when mb.asset_body = 'INDYCAR' then 'INDYCAR'
            when mb.asset_body = 'EPL' then 'EPL'
            when mb.asset_body = 'LALIGA' then 'LA_LIGA'
            when mb.asset_body = 'BUNDESLIGA' then 'BUNDESLIGA'
            when mb.asset_body = 'SERIEA' then 'SERIE_A'
            when mb.asset_body = 'LIGUE1' then 'LIGUE_1'
            when mb.asset_body = 'LIGAMX' then 'LIGA_MX'
            when mb.asset_body = 'UCL' then 'CHAMPIONS_LEAGUE'
            when mb.asset_body = 'UEL' then 'EUROPA_LEAGUE'
            when mb.asset_body = 'UECL' then 'EUROPA_CONFERENCE'
            when mb.asset_body = 'COPADELREY' then 'COPA_DEL_REY'
            when mb.asset_body = 'FACUP' then 'FA_CUP'
            when mb.asset_body = 'COPPAITALIA' then 'COPPA_ITALIA'
            when mb.asset_body = 'COUPEDEFRANCE' then 'COUPE_DE_FRANCE'
            when mb.asset_body = 'WC' then 'FIFA_WORLD_CUP'
            when mb.asset_body = 'WBC' then 'WBC_BASEBALL'
            when mb.asset_body = 'ATP' then 'ATP_TENNIS'
            when mb.asset_body = 'ATPCHALLENGER' then 'ATP_CHALLENGER'
            when mb.asset_body = 'WTA' then 'WTA_TENNIS'
            when mb.asset_body = 'WTACHALLENGER' then 'WTA_CHALLENGER'
            when mb.asset_body = 'T20' then 'CRICKET_T20'
            when mb.asset_body = 'PGATOUR' then 'PGA_TOUR'
            when mb.asset_body = 'DPWORLDTOUR' then 'DP_WORLD_TOUR'
            when mb.asset_body = 'F1' then 'FORMULA_1'
            when mb.asset_body = 'WO' then 'WINTER_OLYMPICS'
            when mb.asset_body = 'CS2' then 'CS2'
            when mb.asset_body = 'VALORANT' then 'VALORANT'
            when mb.asset_body = 'LOL' then 'LEAGUE_OF_LEGENDS'
            when mb.asset_body = 'DOTA2' then 'DOTA_2'
            when mb.asset_body = 'R6' then 'RAINBOW_SIX'
            when mb.asset_body = 'FED' then 'FEDERAL_RESERVE'
            when mb.asset_body = 'CPI' then 'CPI'
            when mb.asset_body = 'GDP' then 'GDP'
            when mb.asset_body = 'NASDAQ100' then 'NASDAQ_100'
            when mb.asset_body = 'NASDAQ100U' then 'NASDAQ_100'
            when mb.asset_body = 'INXU' then 'SP_500'
            when mb.asset_body = 'USDJPYH' then 'USD_JPY'
            when mb.asset_body = 'EURUSDH' then 'EUR_USD'
            when mb.asset_body = 'MVENFLSINGLE' then 'MVE_NFL'
            when mb.asset_body = 'MVENBASINGLE' then 'MVE_NBA'
            when mb.asset_body = 'MVEOSCARS' then 'MVE_OSCARS'
            when mb.asset_body = 'MVEGRAMMYS' then 'MVE_GRAMMYS'
            when mb.asset_body = 'OSCARWINNERS' then 'OSCAR_WINNERS'
            when mb.asset_body = 'MVE' then 'MVE_EXOTIC'
            when mb.asset_body = 'MVESPORTS' then 'MVE_SPORTS'
            -- March Madness (men's vs women's split for breadth gap analysis)
            when mb.asset_body = 'MARMAD' then 'NCAA_MARCH_MADNESS'
            when mb.asset_body = 'WMARMAD' then 'NCAAW_MARCH_MADNESS'
            when mb.asset_body = 'MAKEMARMAD' then 'NCAA_MARCH_MADNESS'
            -- PGA short prefix (e.g. KXPGAH2H → strips H2H$ → body = PGA)
            when mb.asset_body = 'PGA' then 'PGA_TOUR'
            -- Australian Open (strips suffix to AO* body)
            when mb.asset_body = 'AOMEN' then 'AUSTRALIAN_OPEN_MEN'
            when mb.asset_body = 'AOWOMEN' then 'AUSTRALIAN_OPEN_WOMEN'
            -- CFB Championship Series
            when mb.asset_body = 'NCAAFCS' then 'CFB_CHAMPIONSHIP'
            -- Pattern fallbacks for compound bodies where suffix stripping left a residual prefix
            -- (e.g. KXNCAAMBBIG10 → strips nothing → body = NCAAMBBIG10; no exact-match entry above)
            when regexp_like(mb.asset_body, '^NCAAMB[A-Z0-9]+$') then 'NCAAM_BASKETBALL'
            when regexp_like(mb.asset_body, '^NFL.+$') then 'NFL'
            when regexp_like(mb.asset_body, '^NBA.+$') then 'NBA'
            when mb.asset_body = 'MLBWORLD' then 'MLB'
            when regexp_like(mb.asset_body, '^F1.+$') then 'FORMULA_1'
        end as asset_label_mapped,
        -- Bet type derived from the report_ticker suffix
        case
            when mb.report_ticker = 'KXSB' then 'MONEYLINE'
            when mb.report_ticker = 'KXBTC' then 'PRICE_RANGE'
            when mb.report_ticker = 'KXETH' then 'PRICE_RANGE'
            when mb.report_ticker in (
                'KXSOL', 'KXXRP', 'KXDOGE', 'KXSHIBA',
                'KXSOLE', 'KXINXU', 'KXNASDAQ100U'
            ) then 'PRICE_RANGE'
            when mb.report_ticker = 'KXNBA' then 'SEASON'
            when mb.report_ticker = 'KXNFL' then 'SEASON'
            when mb.report_ticker = 'KXNHL' then 'SEASON'
            when mb.report_ticker = 'KXMLB' then 'SEASON'
            when mb.report_ticker = 'KXBOXING' then 'MONEYLINE'
            when mb.report_ticker = 'KXUSDJPYH' then 'HOURLY_PRICE'
            when mb.report_ticker = 'KXEURUSDH' then 'HOURLY_PRICE'
            when mb.report_ticker in (
                'KXMVEOSCARS', 'KXMVEGRAMMYS', 'KXOSCARWINNERS'
            ) then 'TOURNAMENT'
            -- NBA double/triple-double props (2D/3D suffixes stripped; specific overrides needed)
            when mb.report_ticker = 'KXNBA2D' then 'PLAYER_PROP_DOUBLE_DOUBLE'
            when mb.report_ticker = 'KXNBA3D' then 'PLAYER_PROP_TRIPLE_DOUBLE'
            -- CFB root season ticker (no suffix)
            when mb.report_ticker = 'KXNCAAF' then 'SEASON'
            -- March Madness root and qualify tickers
            when mb.report_ticker = 'KXMARMAD' then 'TOURNAMENT'
            when mb.report_ticker = 'KXWMARMAD' then 'TOURNAMENT'
            when mb.report_ticker = 'KXMAKEMARMAD' then 'TEAM_FUTURE_QUALIFY'
            -- Soccer league/cup root tickers (futures: who wins the competition)
            when mb.report_ticker in ( --noqa: LT05
                'KXPREMIERLEAGUE', 'KXLALIGA', 'KXBUNDESLIGA', 'KXSERIEA',
                'KXLIGUE1', 'KXLIGAMX', 'KXUCL', 'KXUEL', 'KXUECL',
                'KXMLS', 'KXWC', 'KXMENWORLDCUP', 'KXCLUBWC', 'KXAFCON',
                'KXFACUP', 'KXCOPADELREY', 'KXCOPPAITALIA', 'KXCOUPEDEFRANCE'
            ) then 'TOURNAMENT'
            -- Australian Open outright winner (pre-tournament future)
            when mb.report_ticker in ('KXAOMEN', 'KXAOWOMEN') then 'TOURNAMENT'
            -- CFB championship series
            when mb.report_ticker = 'KXNCAAFCS' then 'TOURNAMENT'
            -- Super Bowl entertainment/situational props
            when mb.report_ticker in ('KXSBGUESTS', 'KXSBSETLISTS', 'KXTEAMSINSB') then 'GAME_PROP_OTHER'
            -- NFL coaching hire futures
            when mb.report_ticker = 'KXNEXTNFLCOACH' then 'COACH_FUTURE'
            -- NBA All-Star weekend events
            when mb.report_ticker in ('KXNBA3PTCONTEST', 'KXNBASLAMDUNK', 'KXNBARISINGSTARS') then 'ALL_STAR_CONTEST'
            -- NBA player movement future (non-standard ticker)
            when mb.report_ticker = 'KXNBATRADE' then 'PLAYER_FUTURE_TEAM_MOVE'
            -- March Madness round winner (within-tournament prop)
            when mb.report_ticker = 'KXMARMADROUND' then 'TOURNAMENT_PROP'
            -- NCAA Men's Basketball conference tournament winners (root ticker = no suffix)
            -- e.g. KXNCAAMBBIG10, KXNCAAMBACC, KXNCAAMBSEC, KXNCAAMBBIG12, etc.
            when regexp_like(mb.report_ticker, '^KXNCAAMB[A-Z0-9]+$') then 'TOURNAMENT'
            -- Winter Olympics medal-count tables (not event winner)
            when mb.report_ticker in ('KXWO-GOLD', 'KXWO-MEDALS') then 'TOURNAMENT_PROP'
            -- Boxing round-of-victory prop (ROUND vs ROUNDS suffix)
            when mb.report_ticker = 'KXBOXINGVICROUND' then 'FIGHT_ROUNDS'
            -- NBA player free-agency futures (player-specific)
            when mb.report_ticker = 'KXNEXTTEAMGIANNIS' then 'PLAYER_FUTURE_TEAM_MOVE'
            -- NFL player/team movement futures
            when mb.report_ticker = 'KXNEXTTEAMNFL' then 'PLAYER_FUTURE_TEAM_MOVE'
            -- NFL/NBA conference and division winners
            when regexp_like(mb.report_ticker, '^KXNFL(NFC|AFC)(NORTH|SOUTH|EAST|WEST)$') then 'TOURNAMENT'
            when mb.report_ticker = 'KXNBAWEST' then 'TOURNAMENT'
            -- MLB World Series winner
            when mb.report_ticker = 'KXMLBWORLD' then 'TOURNAMENT'
            -- Player of the Year awards (non-standard suffixes)
            when mb.report_ticker in ('KXNFLOPOTY', 'KXNFLCPOTY') then 'PLAYER_FUTURE_POY'
            when mb.report_ticker in ('KXNBAMIMP') then 'MOST_IMPROVED'
            when mb.report_ticker = 'KXNBACOY' then 'COACH_OF_YEAR'
            when mb.report_ticker = 'KXNBASIXTH' then 'SIXTH_MAN_OF_YEAR'
            -- ATP Doubles tournament winner
            when mb.report_ticker = 'KXATPDOUBLES' then 'TOURNAMENT'
            -- F1 season and event markets
            when mb.report_ticker in ('KXF1', 'KXF1CONSTRUCTORS') then 'TOURNAMENT'
            when mb.report_ticker in ('KXF1RACEPODIUM', 'KXF1POLE') then 'GAME_PROP_OTHER'
            -- WBC round and first-5-innings markets
            when mb.report_ticker = 'KXWBCROUND' then 'TOURNAMENT_PROP'
            when mb.report_ticker = 'KXWBCF5' then 'GAME_PROP_OTHER'
            -- MLB player movement
            when mb.report_ticker = 'KXNEXTTEAMMLB' then 'PLAYER_FUTURE_TEAM_MOVE'
            -- Additional All-Star / award / misc sports props
            when mb.report_ticker in ('KXNBAALLSTARS', 'KXNBASHOOTINGSTARS', 'KXNFLPROBOWL') then 'ALL_STAR_CONTEST'
            when mb.report_ticker = 'KXMARMAD1SEED' then 'TOURNAMENT_PROP'
            when mb.report_ticker = 'KXNCAAFFINALIST' then 'ADVANCE_QUALIFY'
            -- NFL game props with non-standard suffixes
            when mb.report_ticker in (
                'KXNFLSBMVPPOS', 'KXSBADAPPEARANCES', 'KXNFLFIRSTTDTIME',
                'KXNFLNONQBPASS', 'KXNFL2PTCONV', 'KXNFLOT', 'KXNFLGAMESACK',
                'KXNFLLEADCHANGE', 'KXSBVIEWER', 'KXNFLDRAFT1ST'
            ) then 'GAME_PROP_OTHER'
            when regexp_like(mb.report_ticker, '.*CHALLENGERMATCH$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*MULTIGAMEEXTENDED$') then 'MULTI_GAME_EXTENDED'
            when regexp_like(mb.report_ticker, '.*CROSSCATEGORY$') then 'CROSS_CATEGORY'
            when regexp_like(mb.report_ticker, '.*GRANDSLAM$') then 'TOURNAMENT'
            when regexp_like(mb.report_ticker, '.*WORLDCUP$') then 'TOURNAMENT'
            when regexp_like(mb.report_ticker, '.*GROUPQUAL$') then 'GROUP_STAGE_QUALIFY'
            when regexp_like(mb.report_ticker, '.*GROUPWIN$') then 'GROUP_WIN'
            when regexp_like(mb.report_ticker, '.*FIRSTGOAL$') then 'FIRST_GOAL'
            when regexp_like(mb.report_ticker, '.*RELEGATION$') then 'RELEGATION'
            when regexp_like(mb.report_ticker, '.*1HSPREAD$') then '1H_SPREAD'
            when regexp_like(mb.report_ticker, '.*1HTOTAL$') then '1H_OVER_UNDER'
            when regexp_like(mb.report_ticker, '.*1HWINNER$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*2HSPREAD$') then '2H_SPREAD'
            when regexp_like(mb.report_ticker, '.*2HTOTAL$') then '2H_OVER_UNDER'
            when regexp_like(mb.report_ticker, '.*2HWINNER$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*PLAYOFFS$') then 'PLAYOFFS'
            when regexp_like(mb.report_ticker, '.*PLAYOFF$') then 'PLAYOFFS'
            when regexp_like(mb.report_ticker, '.*ADVANCE$') then 'ADVANCE_QUALIFY'
            when regexp_like(mb.report_ticker, '.*SPECIAL$') then 'SPECIAL_ELECTION'
            when regexp_like(mb.report_ticker, '.*PRIMARY$') then 'PRIMARY_ELECTION'
            when regexp_like(mb.report_ticker, '.*RUNOFF$') then 'RUNOFF_ELECTION'
            when regexp_like(mb.report_ticker, '.*MENTION$') then 'MENTIONED_IN'
            when regexp_like(mb.report_ticker, '.*DECISION$') then 'POLICY_DECISION'
            when regexp_like(mb.report_ticker, '.*DRAFTPICK$') then 'DRAFT_PICK'
            when regexp_like(mb.report_ticker, '.*DRAFTTOP$') then 'DRAFT_TOP'
            when regexp_like(mb.report_ticker, '.*DRAFT1$') then 'DRAFT_1_PICK'
            when regexp_like(mb.report_ticker, '.*BTTS$') then 'BOTH_TEAMS_SCORE'
            when regexp_like(mb.report_ticker, '.*TOTALMAPS$') then 'TOTAL_MAPS'
            when regexp_like(mb.report_ticker, '.*HIGHSCORE$') then 'HIGH_SCORE'
            when regexp_like(mb.report_ticker, '.*SCOREQ$') then 'SCORE_BY_QUARTER'
            when regexp_like(mb.report_ticker, '.*CHAMPION$') then 'TOURNAMENT'
            when regexp_like(mb.report_ticker, '.*DISTANCE$') then 'GOES_THE_DISTANCE'
            when regexp_like(mb.report_ticker, '.*KNOCKOUT$') then 'KNOCKOUT'
            when regexp_like(mb.report_ticker, '.*MAKECUT$') then 'MAKE_CUT'
            when regexp_like(mb.report_ticker, '.*PASSYDS$') then 'PASSING_YARDS'
            when regexp_like(mb.report_ticker, '.*PASSTDS$') then 'PASSING_TDS'
            when regexp_like(mb.report_ticker, '.*RECYDS$') then 'RECEIVING_YARDS'
            when regexp_like(mb.report_ticker, '.*RSHYDS$') then 'RUSHING_YARDS'
            when regexp_like(mb.report_ticker, '.*SPREAD$') then 'SPREAD'
            when regexp_like(mb.report_ticker, '.*TOTAL$') then 'OVER_UNDER'
            when regexp_like(mb.report_ticker, '.*TOTALSETS$') then 'OVER_UNDER'
            -- Combo/parlay suffixes — must precede .*GAME$ to avoid false MONEYLINE match
            when regexp_like(mb.report_ticker, '.*SINGLEGAME$') then 'SINGLE_GAME_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACKSGP$') then 'SINGLE_GAME_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACK1HFT$') then '1H_FULL_TIME_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACK2ML$') then '2_LEG_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACK3ML$') then '3_LEG_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACK4ML$') then '4_LEG_PARLAY'
            when regexp_like(mb.report_ticker, '.*PREPACK.*') then 'PRE_PACK_PARLAY'
            when regexp_like(mb.report_ticker, '.*GAME$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*MATCH$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*FIGHT$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*TOUR$') then 'TOURNAMENT'
            when regexp_like(mb.report_ticker, '.*GOAL$') then 'GOALS'
            when regexp_like(mb.report_ticker, '.*CHAMP$') then 'TOURNAMENT'
            when regexp_like(mb.report_ticker, '.*WINNER$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*RACE$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*MAP$') then 'MONEYLINE'
            when regexp_like(mb.report_ticker, '.*WINS$') then 'SEASON_WINS'
            when regexp_like(mb.report_ticker, '.*ROUNDS$') then 'FIGHT_ROUNDS'
            when regexp_like(mb.report_ticker, '.*MOV$') then 'METHOD_OF_VICTORY'
            when regexp_like(mb.report_ticker, '.*TOP20$') then 'TOP_20_FINISH'
            when regexp_like(mb.report_ticker, '.*TOP10$') then 'TOP_10_FINISH'
            when regexp_like(mb.report_ticker, '.*TOP5$') then 'TOP_5_FINISH'
            when regexp_like(mb.report_ticker, '.*TOP4$') then 'TOP_4_FINISH'
            when regexp_like(mb.report_ticker, '.*TOP3$') then 'TOP_3_FINISH'
            when regexp_like(mb.report_ticker, '.*TOP2$') then 'TOP_2_FINISH'
            when regexp_like(mb.report_ticker, '.*PTS$') then 'PLAYER_POINTS'
            when regexp_like(mb.report_ticker, '.*REB$') then 'PLAYER_REBOUNDS'
            when regexp_like(mb.report_ticker, '.*AST$') then 'PLAYER_ASSISTS'
            when regexp_like(mb.report_ticker, '.*3PT$') then 'PLAYER_3_POINTERS'
            when regexp_like(mb.report_ticker, '.*BLK$') then 'PLAYER_BLOCKS'
            when regexp_like(mb.report_ticker, '.*STL$') then 'PLAYER_STEALS'
            -- NFL player props (individual scoring)
            when regexp_like(mb.report_ticker, '.*ANYTD$') then 'PLAYER_PROP_TD_SCORER'
            when regexp_like(mb.report_ticker, '.*FIRSTTD$') then 'PLAYER_PROP_FIRST_TD_SCORER'
            when regexp_like(mb.report_ticker, '.*2TD$') then 'PLAYER_PROP_MULTI_TD_SCORER'
            when regexp_like(mb.report_ticker, '.*REC$') then 'PLAYER_PROP_RECEPTIONS'
            -- Game props (game-level outcomes, not player-specific)
            when regexp_like(mb.report_ticker, '.*NEXTTD$') then 'GAME_PROP_OTHER'
            when regexp_like(mb.report_ticker, '.*GAMETD$') then 'GAME_PROP_OTHER'
            when regexp_like(mb.report_ticker, '.*DSTTD$') then 'GAME_PROP_OTHER'
            when regexp_like(mb.report_ticker, '.*4DCONV$') then 'GAME_PROP_OTHER'
            when regexp_like(mb.report_ticker, '.*WINMARGIN$') then 'GAME_PROP_OTHER'
            -- Golf round-leader props (within-tournament, not pre-tournament futures)
            when regexp_like(mb.report_ticker, '.*R[1-4]LEAD$') then 'GAME_PROP_OTHER'
            -- Head-to-head matchup props
            when regexp_like(mb.report_ticker, '.*H2H$') then 'GAME_PROP_H2H'
            when regexp_like(mb.report_ticker, '.*SEATS$') then 'SEAT_COUNT'
            when regexp_like(mb.report_ticker, '.*NOM$') then 'NOMINATION'
            when regexp_like(mb.report_ticker, '.*MVP$') then 'MVP'
            when regexp_like(mb.report_ticker, '.*DPOY$') then 'DEFENSIVE_POY'
            when regexp_like(mb.report_ticker, '.*COTY$') then 'COACH_OF_YEAR'
            when regexp_like(mb.report_ticker, '.*ROTY$') then 'ROOKIE_OF_YEAR'
            when regexp_like(mb.report_ticker, '.*ROY$') then 'ROOKIE_OF_YEAR'
            when regexp_like(mb.report_ticker, '.*MOTY$') then 'MOST_IMPROVED'
            when regexp_like(mb.report_ticker, '.*15M$') then '15_MIN_PRICE'
            when regexp_like(mb.report_ticker, '.*1H$') then '1_HOUR_PRICE'
            when regexp_like(mb.report_ticker, '.*5M$') then '5_MIN_PRICE'
            when regexp_like(mb.report_ticker, '.*MAXMON.*') then 'MONTHLY_MAX'
            when regexp_like(mb.report_ticker, '.*MINMON.*') then 'MONTHLY_MIN'
            when regexp_like(mb.report_ticker, '.*MAXY$') then 'YEARLY_MAX'
            when regexp_like(mb.report_ticker, '.*MINY$') then 'YEARLY_MIN'
            when regexp_like(mb.report_ticker, '.*MON$') then 'MONTHLY'
            when regexp_like(mb.report_ticker, '^KX(BTC|ETH|SOL|XRP|DOGE|SHIBA|INXU|NASDAQ100)D$') then 'DAILY'
            when regexp_like(mb.report_ticker, '^KX(BTC|ETH|SOL|XRP|DOGE|SHIBA|INXU|NASDAQ100)Y$') then 'YEARLY'
            when regexp_like(mb.report_ticker, '^KX(BTC|ETH|SOL|XRP|DOGE|SHIBA|INXU|NASDAQ100)W$') then 'WEEKLY'
            -- Winter Olympics event winner catch-all (specific WO overrides above take precedence)
            when regexp_like(mb.report_ticker, '^KXWO.*') then 'MONEYLINE'
        end as market_type_label,
        -- Pattern-based category for unmapped/new markets — catches future variants automatically
        -- regexp_like requires full-string match in Snowflake; .* suffix matches any ticker starting with prefix
        case
            when regexp_like(mb.report_ticker, '^KX(NBA|WNBA|NCAAMB|NCAAWB|NCAAB|NCAAF|NCAAHOCKEY|NFL|NHL|MLB|MLBST|MLS|SB|UFC|BOXING|NASCAR|INDYCAR|INDY500|EPL|PREMIERLEAGUE|LALIGA|BUNDESLIGA|SERIEA|LIGUE1|LIGAMX|LIGAPORTUGAL|EFLCHAMPIONSHIP|MENWORLDCUP|UCL|UEL|UECL|COPADELREY|FACUP|COPPAITALIA|COUPEDEFRANCE|WC|WBC|CLUBWC|FINALISSIMA|AFCON|ATP|ATPCHALLENGER|WTA|WTACHALLENGER|PGATOUR|DPWORLDTOUR|LPGA|PGA|MASTERS|THEOPEN|USOPEN|LIVTOUR|GENESISINVITATIONAL|FOMENSINGLES|FOWOMENSINGLES|FOMEN|FOWOMEN|WMENSINGLES|WWOMENSINGLES|USOMENSINGLES|USOWOMENSINGLES|ROMENSSINGLES|QEMOMENSSINGLES|F1|WO|CS2|CSGO|VALORANT|LOL|DOTA2|R6|EWC|INTERNETINVITATIONAL|T20|IPL|AHL|AFL|IIHF|FIBA|EUROLEAGUE|EUROPACUP|EUROCUP|TABLETENNIS|TOURDEFRANCE|VCCHAMPIONS|BBSERIEA|BRASILEIRO|EREDIVISIE|EKSTRAKLASA|DENSUPERLIGA|BELGIANPL|JLEAGUE|KLEAGUE|ALEAGUE|MIDSEASONINVITATIONAL|LNBELITE|DDF|DARTS|CHESS|CRICKET|MVESPORTS|MVENFLSINGLE|MVENFLMULTI|MVECROSS|MVENBASINGLE|MULTIPREPACK|MARMAD|WMARMAD|MAKEMARMAD|FANATICSGAMES|SUPERBOWLHEADLINE|NEXTTEAMNFL|NEXTTEAMMLB|NEXTNFLCOACH|NEXTCOACHOUTNFL|NEXTCOACHOUTNBA|TEAMSINSB|TEAMSINSC|HEISMAN|SAUDIPL|KHL|SUPERLIG|CBAGAME|PFAPOY|ARGPREMDIV|UEFACL|STARLADDER|ESPY|AOMEN|AOWOMEN|NCAAFCS|NEXTTEAMGIANNIS).*') then 'SPORTS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(BTC|ETH|SOL|XRP|DOGE|SHIBA|AVAX|ADA|MATIC|DOT|LINK|UNI|LTC|BCH|BNB|TRX|ATOM|NEAR|ALGO|VET|ICP|FIL|ETC|CRYPTO).*') then 'CRYPTO' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KXGOLDEN.*') then 'ENTERTAINMENT'
            when regexp_like(mb.report_ticker, '^KX(INXU|INX|NASDAQ100|USDJPY|EURUSD|SP500|DJIA|NYSE|VIX|GOLD|SILVER|OIL|BOND|TREASURY|YIELD).*') then 'FINANCIALS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(FED|CPI|GDP|PCE|PPI|NONFARM|UNEMPLOY|INFLATION|FOMC|JOBS|JOBLESS|TARIFF|DEBT|DEFICIT|TRADE|RATES|EARNINGS|IPO|MERGER|EFFR|MORTGAGE|ISMPMI|ECON).*') then 'ECONOMICS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(PRES|SENATE|HOUSE|GOV|ELECTION|CONGRESS|POTUS|SPEAKER|BALLOT|VOTE|REFERENDUM|IMPEACH|MIDTERM|CAUCUS|MAYOR|GOVERNOR|PARTY|DEM|REP|ATTYG|CABINET|DNC|RNC).*') then 'POLITICS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(GRAMMY|GRAMB|GRAM|OSCAR|EMMY|GOLDEN|GG|BAFTA|TONY|BILLBOARD|MTV|VMA|AMA|SAG|MVEOSCARS|MVEGRAMMYS|OSCARWIN|CRITICS|CANNES|DGA|ACM|AWARD|BET|IHEART|LATINGRAMMY|GAMEAWARDS).*') then 'ENTERTAINMENT' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(SNOW|WEATHER|HURRICANE|TROPICAL|TORNADO|STORM|FLOOD|WILDFIRE|RAINFALL|PRECIP|TEMP|DROUGHT|BLIZZARD|HEAT|EARTHQUAKE|ERUPT|VOLCANO).*') then 'WEATHER' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(NASA|SPACEX|SPACE|LAUNCH|ASTEROID|MOON|MARS|SATELLITE|ROCKET|FUSION|NUCLEAR).*') then 'SCIENCE' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(COVID|PANDEMIC|VACCINE|VIRUS|FDA|CDC|HEALTH|MEASLES|MPOX|H5N1|FLU|OUTBREAK).*') then 'HEALTH' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(AI|OPENAI|CHATGPT|NVIDIA|TECH|DEEPSEEK|CLAUDE|GEMINI|LLAMA|LLM|GPT|GROK).*') then 'TECHNOLOGY' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(RUSSIA|UKRAINE|ISRAEL|CHINA|NATO|WAR|CONFLICT|PEACE|TREATY|SANCTION|TAIWAN|KOREA|IRAN|IRAQ|AFGHAN|GAZA|GREENLAND|CANAL|BRICS).*') then 'GEOPOLITICS' --noqa: LT05
        end as category_body,
        -- Pattern-based sport sub-category — mirrors category_body logic for sports tickers
        case
            -- Multi-sport combo products — not attributable to a single sport
            when mb.report_ticker in ('KXMVESPORTSMULTIGAMEEXTENDED', 'KXMULTIPREPACK') then 'MULTI_SPORT'
            when mb.report_ticker = 'KXNEXTTEAMGIANNIS' then 'BASKETBALL'
            when regexp_like(mb.report_ticker, '^KX(NBA|WNBA|NCAAMB|NCAAWB|NCAAB|MARMAD|WMARMAD|MAKEMARMAD|FIBA|EUROLEAGUE|EUROPACUP|EUROCUP|BBSERIEA|CBAGAME|LNBELITE|NEXTCOACHOUTNBA|MVENBASINGLE).*') then 'BASKETBALL' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(NFL|NCAAF|SB|MVENFLSINGLE|MVENFLMULTI|NEXTTEAMNFL|NEXTNFLCOACH|NEXTCOACHOUTNFL|SUPERBOWLHEADLINE|TEAMSINSB|HEISMAN).*') then 'FOOTBALL' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(NHL|AHL|IIHF|KHL|NCAAHOCKEY|TEAMSINSC).*') then 'HOCKEY'
            when regexp_like(mb.report_ticker, '^KX(MLB|MLBST|WBC|NEXTTEAMMLB).*') then 'BASEBALL'
            when regexp_like(mb.report_ticker, '^KX(EPL|PREMIERLEAGUE|LALIGA|BUNDESLIGA|SERIEA|LIGUE1|LIGAMX|LIGAPORTUGAL|EFLCHAMPIONSHIP|MLS|UCL|UEL|UECL|COPADELREY|FACUP|COPPAITALIA|COUPEDEFRANCE|WC|CLUBWC|FINALISSIMA|AFCON|MENWORLDCUP|EREDIVISIE|EKSTRAKLASA|DENSUPERLIGA|BELGIANPL|JLEAGUE|KLEAGUE|ALEAGUE|BRASILEIRO|SAUDIPL|ARGPREMDIV|SUPERLIG|PFAPOY|UEFACL).*') then 'SOCCER' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(ATP|ATPCHALLENGER|WTA|WTACHALLENGER|AOMEN|AOWOMEN|FOMENSINGLES|FOWOMENSINGLES|FOMEN|FOWOMEN|WMENSINGLES|WWOMENSINGLES|USOMENSINGLES|USOWOMENSINGLES|ROMENSSINGLES|QEMOMENSSINGLES).*') then 'TENNIS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(PGATOUR|DPWORLDTOUR|LPGA|PGA|MASTERS|THEOPEN|USOPEN|LIVTOUR|GENESISINVITATIONAL).*') then 'GOLF' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(F1|NASCAR|INDYCAR|INDY500).*') then 'MOTOR_RACING'
            when regexp_like(mb.report_ticker, '^KX(TOURDEFRANCE).*') then 'CYCLING'
            when regexp_like(mb.report_ticker, '^KX(UFC).*') then 'MMA'
            when regexp_like(mb.report_ticker, '^KX(BOXING).*') then 'BOXING'
            when regexp_like(mb.report_ticker, '^KX(T20|IPL|CRICKET).*') then 'CRICKET'
            when regexp_like(mb.report_ticker, '^KX(CS2|CSGO|VALORANT|LOL|DOTA2|R6|EWC|INTERNETINVITATIONAL|STARLADDER|MIDSEASONINVITATIONAL).*') then 'ESPORTS' --noqa: LT05
            when regexp_like(mb.report_ticker, '^KX(WO).*') then 'OLYMPICS'
            when regexp_like(mb.report_ticker, '^KX(TABLETENNIS).*') then 'TABLE_TENNIS'
            when regexp_like(mb.report_ticker, '^KX(DARTS|DDF).*') then 'DARTS'
            when regexp_like(mb.report_ticker, '^KX(CHESS).*') then 'CHESS'
            when regexp_like(mb.report_ticker, '^KX(VCCHAMPIONS).*') then 'VOLLEYBALL'
            when regexp_like(mb.report_ticker, '^KX(AFL).*') then 'AUSTRALIAN_FOOTBALL'
        end as sport_body,
        -- Combo/parlay flag — matches SGP, prepack, multi-game, and cross-category products
        coalesce(
            regexp_like(mb.report_ticker, '.*(PREPACK|MULTIGAMEEXTENDED|SINGLEGAME|CROSSCATEGORY).*'), --noqa: LT05
            false
        ) as is_combo
    from market_body as mb
),

-- ── STEP 5: Variant detail — strips event+date prefix, parses contract detail ─
-- Date pattern \d{2}[A-Z]{3}\d{2,4} handles both 2-digit (26MAR08) and
-- 4-digit (25DEC0600) time suffixes so crypto price range contracts parse cleanly
variant_labels as (
    select
        av.report_ticker,
        av.ticker_name,
        case
            -- Spread: -TEAM1-TEAM2-B{line}  →  "TEAM1 vs TEAM2 (line: n)"
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-([A-Z]+)-([A-Z]+)-B(-?[\\d.]+)$'
                )
                then
                    regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z]+)-([A-Z]+)-B(-?[\\d.]+)$',
                        1,
                        1,
                        'e',
                        1
                    )
                    || ' vs '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z]+)-([A-Z]+)-B(-?[\\d.]+)$',
                        1,
                        1,
                        'e',
                        2
                    )
                    || ' (line: '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z]+)-([A-Z]+)-B(-?[\\d.]+)$',
                        1,
                        1,
                        'e',
                        3
                    )
                    || ')'
            -- Moneyline: -TEAM1-TEAM2  →  "TEAM1 vs TEAM2"
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-([A-Z]+)-([A-Z]+)$'
                )
                then
                    regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z]+)-([A-Z]+)$',
                        1,
                        1,
                        'e',
                        1
                    )
                    || ' vs '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z]+)-([A-Z]+)$',
                        1,
                        1,
                        'e',
                        2
                    )
            -- Price range above: -B{number}  →  "Above {number}"
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-B([\\d.]+)$'
                )
                then
                    'Above '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-B([\\d.]+)$',
                        1,
                        1,
                        'e',
                        1
                    )
            -- Price target: -T{number}  →  "Above {number}"
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-T([\\d.]+)$'
                )
                then
                    'Above '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-T([\\d.]+)$',
                        1,
                        1,
                        'e',
                        1
                    )
            -- Short-window intraday: -{time}-{level}  →  "Time {t} lvl {l}"
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-(\\d{4,6})-(\\d+)$'
                )
                then
                    'Time '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-(\\d{4,6})-(\\d+)$',
                        1,
                        1,
                        'e',
                        1
                    )
                    || ' lvl '
                    || regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-(\\d{4,6})-(\\d+)$',
                        1,
                        1,
                        'e',
                        2
                    )
            -- Single token: -{TOKEN}
            when
                regexp_like(
                    regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                    '^-([A-Z0-9]+)$'
                )
                then
                    regexp_substr(
                        regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                        '^-([A-Z0-9]+)$',
                        1,
                        1,
                        'e',
                        1
                    )
            -- Fallback: clean up the raw suffix
            else regexp_replace(
                regexp_replace(av.ticker_name, '^' || av.report_ticker || '-\\d{2}[A-Z]{3}\\d{2,4}', ''),
                '^-', ''
            )
        end as variant_detail
    from all_variants as av
)

-- ── FINAL OUTPUT ──────────────────────────────────────────────────────────────
select
    av.report_ticker,
    av.ticker_name,
    lbl.market_type_label,
    vl.variant_detail,
    lbl.is_combo,
    coalesce(lbl.category, case coalesce(lbl.asset_label_mapped, lbl.asset_body)
        when 'BITCOIN' then 'CRYPTO'
        when 'ETHEREUM' then 'CRYPTO'
        when 'SOLANA' then 'CRYPTO'
        when 'XRP' then 'CRYPTO'
        when 'DOGECOIN' then 'CRYPTO'
        when 'SHIBA_INU' then 'CRYPTO'
        when 'SP_500' then 'FINANCIALS'
        when 'NASDAQ_100' then 'FINANCIALS'
        when 'USD_JPY' then 'FINANCIALS'
        when 'EUR_USD' then 'FINANCIALS'
        when 'FEDERAL_RESERVE' then 'ECONOMICS'
        when 'CPI' then 'ECONOMICS'
        when 'GDP' then 'ECONOMICS'
        when 'NBA' then 'SPORTS'
        when 'MVE_NBA' then 'SPORTS'
        when 'NCAAM_BASKETBALL' then 'SPORTS'
        when 'NCAAW_BASKETBALL' then 'SPORTS'
        when 'NFL' then 'SPORTS'
        when 'MVE_NFL' then 'SPORTS'
        when 'COLLEGE_FOOTBALL' then 'SPORTS'
        when 'SUPER_BOWL' then 'SPORTS'
        when 'NHL' then 'SPORTS'
        when 'MLB' then 'SPORTS'
        when 'MLB_SPRING_TRAINING' then 'SPORTS'
        when 'WBC_BASEBALL' then 'SPORTS'
        when 'EPL' then 'SPORTS'
        when 'LA_LIGA' then 'SPORTS'
        when 'BUNDESLIGA' then 'SPORTS'
        when 'SERIE_A' then 'SPORTS'
        when 'LIGUE_1' then 'SPORTS'
        when 'LIGA_MX' then 'SPORTS'
        when 'CHAMPIONS_LEAGUE' then 'SPORTS'
        when 'EUROPA_LEAGUE' then 'SPORTS'
        when 'EUROPA_CONFERENCE' then 'SPORTS'
        when 'COPA_DEL_REY' then 'SPORTS'
        when 'FA_CUP' then 'SPORTS'
        when 'COPPA_ITALIA' then 'SPORTS'
        when 'COUPE_DE_FRANCE' then 'SPORTS'
        when 'FIFA_WORLD_CUP' then 'SPORTS'
        when 'MLS' then 'SPORTS'
        when 'ATP_TENNIS' then 'SPORTS'
        when 'ATP_CHALLENGER' then 'SPORTS'
        when 'WTA_TENNIS' then 'SPORTS'
        when 'WTA_CHALLENGER' then 'SPORTS'
        when 'PGA_TOUR' then 'SPORTS'
        when 'DP_WORLD_TOUR' then 'SPORTS'
        when 'FORMULA_1' then 'SPORTS'
        when 'BOXING' then 'SPORTS'
        when 'UFC' then 'SPORTS'
        when 'NASCAR' then 'SPORTS'
        when 'INDYCAR' then 'SPORTS'
        when 'WINTER_OLYMPICS' then 'SPORTS'
        when 'CRICKET_T20' then 'SPORTS'
        when 'CS2' then 'SPORTS'
        when 'VALORANT' then 'SPORTS'
        when 'LEAGUE_OF_LEGENDS' then 'SPORTS'
        when 'DOTA_2' then 'SPORTS'
        when 'RAINBOW_SIX' then 'SPORTS'
        when 'MVE_OSCARS' then 'ENTERTAINMENT'
        when 'MVE_GRAMMYS' then 'ENTERTAINMENT'
        when 'OSCAR_WINNERS' then 'ENTERTAINMENT'
        when 'NCAA_MARCH_MADNESS' then 'SPORTS'
        when 'NCAAW_MARCH_MADNESS' then 'SPORTS'
        when 'AUSTRALIAN_OPEN_MEN' then 'SPORTS'
        when 'AUSTRALIAN_OPEN_WOMEN' then 'SPORTS'
        when 'CFB_CHAMPIONSHIP' then 'SPORTS'
        when 'MVE_SPORTS' then 'SPORTS'
    end, lbl.category_body) as category,
    coalesce(
        case coalesce(lbl.asset_label_mapped, lbl.asset_body)
            when 'NBA' then 'BASKETBALL'
            when 'MVE_NBA' then 'BASKETBALL'
            when 'NCAAM_BASKETBALL' then 'BASKETBALL'
            when 'NCAAW_BASKETBALL' then 'BASKETBALL'
            when 'NFL' then 'FOOTBALL'
            when 'MVE_NFL' then 'FOOTBALL'
            when 'COLLEGE_FOOTBALL' then 'FOOTBALL'
            when 'SUPER_BOWL' then 'FOOTBALL'
            when 'NHL' then 'HOCKEY'
            when 'MLB' then 'BASEBALL'
            when 'MLB_SPRING_TRAINING' then 'BASEBALL'
            when 'WBC_BASEBALL' then 'BASEBALL'
            when 'EPL' then 'SOCCER'
            when 'LA_LIGA' then 'SOCCER'
            when 'BUNDESLIGA' then 'SOCCER'
            when 'SERIE_A' then 'SOCCER'
            when 'LIGUE_1' then 'SOCCER'
            when 'LIGA_MX' then 'SOCCER'
            when 'CHAMPIONS_LEAGUE' then 'SOCCER'
            when 'EUROPA_LEAGUE' then 'SOCCER'
            when 'EUROPA_CONFERENCE' then 'SOCCER'
            when 'COPA_DEL_REY' then 'SOCCER'
            when 'FA_CUP' then 'SOCCER'
            when 'COPPA_ITALIA' then 'SOCCER'
            when 'COUPE_DE_FRANCE' then 'SOCCER'
            when 'FIFA_WORLD_CUP' then 'SOCCER'
            when 'MLS' then 'SOCCER'
            when 'ATP_TENNIS' then 'TENNIS'
            when 'ATP_CHALLENGER' then 'TENNIS'
            when 'WTA_TENNIS' then 'TENNIS'
            when 'WTA_CHALLENGER' then 'TENNIS'
            when 'PGA_TOUR' then 'GOLF'
            when 'DP_WORLD_TOUR' then 'GOLF'
            when 'FORMULA_1' then 'MOTOR_RACING'
            when 'NASCAR' then 'MOTOR_RACING'
            when 'INDYCAR' then 'MOTOR_RACING'
            when 'UFC' then 'MMA'
            when 'BOXING' then 'BOXING'
            when 'CRICKET_T20' then 'CRICKET'
            when 'WINTER_OLYMPICS' then 'OLYMPICS'
            when 'CS2' then 'ESPORTS'
            when 'VALORANT' then 'ESPORTS'
            when 'LEAGUE_OF_LEGENDS' then 'ESPORTS'
            when 'DOTA_2' then 'ESPORTS'
            when 'RAINBOW_SIX' then 'ESPORTS'
            when 'NCAA_MARCH_MADNESS' then 'BASKETBALL'
            when 'NCAAW_MARCH_MADNESS' then 'BASKETBALL'
            when 'AUSTRALIAN_OPEN_MEN' then 'TENNIS'
            when 'AUSTRALIAN_OPEN_WOMEN' then 'TENNIS'
            when 'CFB_CHAMPIONSHIP' then 'FOOTBALL'
            when 'MVE_SPORTS' then 'MULTI_SPORT'
        end,
        lbl.sport_body
    ) as sport,
    coalesce(lbl.asset_label_mapped, lbl.asset_body) as asset_label,
    case
        when lbl.market_type_label is not null
            then coalesce(lbl.asset_label_mapped, lbl.asset_body) || ' - ' || lbl.market_type_label
        else coalesce(lbl.asset_label_mapped, lbl.asset_body)
    end as market_name,
    case
        when vl.variant_detail is not null and vl.variant_detail != ''
            then case
                when lbl.market_type_label is not null
                    then coalesce(lbl.asset_label_mapped, lbl.asset_body) || ' - ' || lbl.market_type_label
                else coalesce(lbl.asset_label_mapped, lbl.asset_body)
            end || ': ' || vl.variant_detail
        when lbl.market_type_label is not null
            then coalesce(lbl.asset_label_mapped, lbl.asset_body) || ' - ' || lbl.market_type_label
        else coalesce(lbl.asset_label_mapped, lbl.asset_body)
    end as variant_full_label
from all_variants as av
left join market_labels as lbl
    on av.report_ticker = lbl.report_ticker
left join variant_labels as vl
    on
        av.report_ticker = vl.report_ticker
        and av.ticker_name = vl.ticker_name
    )

/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.fct_kalshi_market_labels", "profile_name": "user", "target_name": "default"} */
