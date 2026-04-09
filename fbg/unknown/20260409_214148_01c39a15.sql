-- Query ID: 01c39a15-0212-6b00-24dd-07031939ccdb
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_L_WH
-- Executed: 2026-04-09T21:41:48.578000+00:00
-- Elapsed: 3440ms
-- Environment: FBG

WITH normalized AS (
    SELECT
      id AS message_id,
      replace(raw_message, chr(1), '|') AS msg,
    FROM fmx_analytics.staging.stg_fmx_mm_fix_inbound_messages_scd
    where msg_type='8'
),
fields AS (
    SELECT message_id, f.value AS kv
    FROM normalized,
    LATERAL FLATTEN(input => split(msg, '|')) f
)
,parsed AS (
  SELECT
    message_id,
    split_part(kv, '=', 1) AS tag,
    split_part(kv, '=', 2) AS value
  FROM fields
  WHERE kv LIKE '%=%'
    and message_id is not null
)
,data_ as(
SELECT
  message_id,
  max(case when tag = '8' then value end)   AS begin_string,
  max(case when tag = '9' then value end)   AS body_length,
  max(case when tag = '34' then value end)  AS msg_seq_num,
  max(case when tag = '49' then value end)  AS sender_comp_id,
  max(case when tag = '56' then value end)  AS target_comp_id,
  max(case when tag = '6' then value end)  AS avg_px,
  max(case when tag = '31' then value end)  AS last_px,
  to_double(max(case when tag = '44' then value end))  AS price,  
  to_double(max(case when tag = '32' then value end))  AS quantity,
  max(case when tag = '14' then value end)  AS last_qty,
  max(case when tag = '151' then value end)  AS leaves_qty,
  max(case when tag = '54' then value end)  AS side,
  max(case when tag = '55' then value end)  AS symbol,
  max(case when tag = '59' then value end)  AS time_in_force,
  max(case when tag = '39' then value end)  AS order_status,
  try_to_timestamp(max(case when tag = '60' then value end), 'YYYYMMDD-HH24:MI:SS.FF3') AS sending_time,
  max(case when tag = '11' then value end) as qset_number,
  max(case when tag = '10' then value end)  AS checksum,
  max(case when tag = '150' then value end)  AS exec_type,
  
FROM parsed
GROUP BY message_id
    )


,trade_data as(select * from data_ where exec_type='F' order by sending_time desc)
--select * from trade_data where symbol like '%ARP%';
,matched_trades as(
select 
1/selec.selection_decimal_odds as marginated_prob,
td.price,
td.quantity,
td.side,
case when td.side='1' then selec.selection_probability-td.price 
    when td.side='2' then td.price-selec.selection_probability
    end as margin_on_trade,
case when td.side='2' then (1-td.price)*quantity
    when td.side='1' then td.price*quantity
        end as liability,

case when selec.selection_status='SUSPENDED' or selec.market_status='SUSPENDED' or selec.event_status='SUSPENDED' then 'SUSPENDED' else 'OPEN' 
    end as is_suspended,
case when selec.selection_displayed=FALSE or selec.market_displayed=FALSE or selec.event_displayed=FALSE then 'NOT DISPLAYED' else 'OPEN' 
    end as is_displayed,
sending_time as trade_time,
mm.exchange_market_id,
concat('OF:',mm.fixture_id,':',mm.market_id,':',mm.selection_id) as joiner,
--selec.market_id,selec.selection_id,
td.message_id,
td.qset_number,
--td.*,
selec.*
from trade_data as td
left join  fmx_analytics.staging.stg_fmx_mm_matched_markets as mm
    on td.symbol=mm.exchange_market_id
left join fbg_source.osb_source.instruments as instr
    on joiner=instr.sys_ref
left join fbg_unity_catalog.market.selections as selec
    on instr.mark_id=selec.market_id
    and instr.id=selec.selection_id
    and td.sending_time>selec.timestamp
where selec.timestamp is not null
    and trade_time>'2026-4-8 00:00:000'

qualify row_number()over(partition by td.message_id order by selec.timestamp desc)=1
order by timestamp desc
)
,agg_trades as(
select 
mt.price*mt.quantity as handle,
mt.* ,
margin_on_trade,
price-selec.selection_probability as margin_5_sec,
price-selec2.selection_probability as margin_15_sec,
selec.selection_probability as pure_prob_5sec,
selec.selection_source_percentage/100 as marginated_prob_5sec,
selec2.selection_probability as pure_prob_15sec,
selec2.selection_source_percentage/100 as marginated_prob_15sec,

from matched_trades as mt
left join fbg_unity_catalog.market.selections as selec
    on dateadd('second',5,mt.trade_time) >=  selec.timestamp
    and mt.market_id = selec.market_id
    and mt.selection_id = selec.selection_id
left join fbg_unity_catalog.market.selections as selec2
    on dateadd('second',15,mt.trade_time) >=   selec2.timestamp
    and mt.market_id = selec2.market_id
    and mt.selection_id = selec2.selection_id
qualify row_number()over(partition by mt.message_id order by selec.timestamp desc,selec2.timestamp desc)=1
order by trade_time desc)
select *
from agg_trades
order by trade_time desc
;
