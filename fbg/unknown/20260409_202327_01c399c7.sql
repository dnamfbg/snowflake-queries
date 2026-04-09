-- Query ID: 01c399c7-0212-67a8-24dd-07031927d7ff
-- Database: unknown
-- Schema: unknown
-- Warehouse: BI_SER_XL_WH_PROD
-- Executed: 2026-04-09T20:23:27.379000+00:00
-- Elapsed: 1237ms
-- Environment: FBG

with 
appsflyer_versions as 
(
select 
customer_user_id
,platform
,app_id
,appsflyer_id
,idfa
,idfv
,ip
,user_agent
,state
,country_code
,city
,advertising_id
,event_time
,ROW_NUMBER() OVER (
   PARTITION BY customer_user_id
   ORDER BY event_time DESC
) AS rn

FROM fde_fbg_info.fde_fbg_info.appsflyer_inapps_v

where app_name ilike '%shop%'
AND customer_user_id IS NOT NULL 
and event_time>dateadd('day',-7,current_date())

QUALIFY rn=1
)
,fanapp_new as 
(
SELECT
  f.value::string AS fanapp_tenant_fan_id
  ,fanapp_account_creation_timestamp AS EVENT_TIME
,CASE WHEN commerce_customer_indicator =0 THEN 1 ELSE 0 END AS NEW_TO_COMMERCE
,CASE WHEN fbg_customer_indicator =0 THEN 1 ELSE 0 END AS NEW_TO_FBG
,CASE WHEN live_fan_indicator+topps_com_fan_indicator+collect_fan_indicator =0 THEN 1 ELSE 0 END AS NEW_TO_COLLECTIBLES

,CASE WHEN commerce_customer_indicator+fbg_customer_indicator+live_fan_indicator+topps_com_fan_indicator+collect_fan_indicator=0 THEN 1 ELSE 0 END AS NEW_TO_FILE

FROM fde_fbg_info.fde_fbg_info.fangraph_non_pii_v t,
LATERAL FLATTEN(input => t.fanapp_tenant_fan_ids) f
where fanapp_tenant_fan_id is not null 
and date(fanapp_account_creation_timestamp)= dateadd('day',-1,current_Date)
)
,fanapp_FINAL AS 
(
select fanapp_tenant_fan_id,event_time,'new_commerce' as event_name from fanapp_new where NEW_TO_COMMERCE=1 union all 
select fanapp_tenant_fan_id,event_time,'new_fbg' as event_name from fanapp_new where NEW_TO_FBG=1 union all 
select fanapp_tenant_fan_id,event_time,'new_collectibles' as event_name from fanapp_new where NEW_TO_COLLECTIBLES=1 union all 
select fanapp_tenant_fan_id,event_time,'new_fanatics' as event_name from fanapp_new where NEW_TO_FILE=1 
)

SELECT 
a.fanapp_tenant_fan_id AS id,
a.event_time,
appsflyer_id,
ip AS ip_address,
user_agent,
state,
country_code as country,
city,
platform,
idfa,
idfv,
advertising_id AS adid,
CASE WHEN b.platform = 'ios' THEN idfa WHEN b.platform = 'android' THEN advertising_id ELSE NULL END AS adv_device_id,
app_id,
event_name,
a.event_time as event_timestamp_utc

FROM fanapp_FINAL A 
INNER JOIN appsflyer_versions B 
ON A.FANAPP_TENANT_FAN_ID = B.CUSTOMER_USER_ID
;
