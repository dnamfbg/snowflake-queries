-- Query ID: 01c39a14-0212-644a-24dd-07031939d173
-- Database: unknown
-- Schema: unknown
-- Warehouse: TRADING_L_WH
-- Last Executed: 2026-04-09T21:40:32.242000+00:00
-- Elapsed: 8848ms
-- Run Count: 3
-- Environment: FBG

WITH normalized_ AS (
    SELECT
      record_lsn AS message_id,
      replace(message, chr(1), '|') AS msg
    FROM fmx_analytics.staging.stg_fmx_mm_fix_messages_scd
    where abs(datediff('hour',current_timestamp(),dw_creation_date))<4
),
fields_ AS (
    SELECT message_id, f.value AS kv
    FROM normalized_,
    LATERAL FLATTEN(input => split(msg, '|')) f
),
parsed_ AS (
  SELECT
    message_id,
    split_part(kv, '=', 1) AS tag,
    split_part(kv, '=', 2) AS value
  FROM fields_
  WHERE kv LIKE '%=%'
)
,data_1 as(
SELECT
  message_id,
  max(case when tag = '8' then value end)   AS begin_string,
  max(case when tag = '9' then value end)   AS body_length,
  max(case when tag = '35' then value end)  AS msg_type,
  max(case when tag = '34' then value end)  AS msg_seq_num,
  max(case when tag = '49' then value end)  AS sender_comp_id,
  max(case when tag = '56' then value end)  AS target_comp_id,
  try_to_timestamp(max(case when tag = '52' then value end), 'YYYYMMDD-HH24:MI:SS.FF3') AS sending_time,
  max(case when tag = '55' then value end)  AS symbol,
  try_to_double(max(case when tag = '298' then value end)) AS quote_cancel_type,
  try_to_double(max(case when tag = '295' then value end)) AS number_of_quote_entries,
  try_to_number(max(case when tag = '453' then value end)) AS number_of_parties_contained,
  try_to_number(max(case when tag = '452' then value end)) AS party_role,
  max(case when tag = '10' then value end)  AS checksum,
  max(case when tag = '117' then value end) as qset_number,
  max(case when tag = '299' then value end) as quote_entry_number,
FROM parsed_
GROUP BY message_id
having symbol is not null)
,quote_cancels as(
select *
from data_1
where msg_type='Z'
order by sending_time desc) 

,normalized AS (
    SELECT
      concat(metadata_kafka_offset,'_',msgseqnum) AS message_id,
      replace(message, chr(1), '|') AS msg
    FROM fmx_analytics.staging.stg_fmx_mm_fix_messages_scd 
    where abs(datediff('hour',current_timestamp(),dw_creation_date))<4
),
fields AS (
    SELECT message_id, f.value AS kv
    FROM normalized,
    LATERAL FLATTEN(input => split(msg, '|')) f
),
parsed AS (
  SELECT
    message_id,
    split_part(kv, '=', 1) AS tag,
    split_part(kv, '=', 2) AS value
  FROM fields
  WHERE kv LIKE '%=%'
)
,data_ as(
SELECT
  message_id,
  max(case when tag = '8' then value end)   AS begin_string,
  max(case when tag = '9' then value end)   AS body_length,
  max(case when tag = '35' then value end)  AS msg_type,
  max(case when tag = '34' then value end)  AS msg_seq_num,
  max(case when tag = '49' then value end)  AS sender_comp_id,
  max(case when tag = '56' then value end)  AS target_comp_id,
  try_to_timestamp(max(case when tag = '52' then value end), 'YYYYMMDD-HH24:MI:SS.FF3') AS sending_time,
  max(case when tag = '55' then value end)  AS symbol,
  try_to_double(max(case when tag = '132' then value end)) AS bid_px,
  try_to_double(max(case when tag = '133' then value end)) AS ask_px,
  try_to_number(max(case when tag = '134' then value end)) AS bid_size,
  try_to_number(max(case when tag = '135' then value end)) AS ask_size,
  max(case when tag = '10' then value end)  AS checksum,
  max(case when tag = '117' then value end) as qset_number,
  max(case when tag = '299' then value end) as quote_entry_number,
FROM parsed
GROUP BY message_id
having symbol is not null
qualify row_number()over(partition by symbol order by sending_time desc)=1
)
select *
from data_ as d_
left join quote_cancels as qc
    on d_.qset_number=qc.qset_number
where d_.msg_type='i'
order by d_.sending_time desc;
