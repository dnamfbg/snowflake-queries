-- Query ID: 01c39a30-0212-67a9-24dd-0703193fe11b
-- Database: FMX_ANALYTICS
-- Schema: STAGING
-- Warehouse: BI_M_WH
-- Executed: 2026-04-09T22:08:12.014000+00:00
-- Elapsed: 472ms
-- Environment: FBG

create or replace   view FMX_ANALYTICS.STAGING.stg_salesforce_user
  
  
  
  
  as (
    select
    ID,
    ABOUTME,
    ACCOUNTID,
    ADDRESS,
    ALIAS,
    BADGETEXT,
    BANNERPHOTOURL,
    CALLCENTERID,
    CITY,
    COMMUNITYNICKNAME,
    COMPANYNAME,
    CONTACTID,
    COUNTRY,
    CREATEDDATE,
    CREATEDBYID,
    DEPARTMENT,
    DIGESTFREQUENCY,
    DIVISION,
    EMAIL,
    EMPLOYEENUMBER,
    FIRSTNAME,
    INDIVIDUALID,
    ISACTIVE,
    LASTLOGINDATE,
    LASTMODIFIEDDATE,
    LASTMODIFIEDBYID,
    LASTNAME,
    LASTREFERENCEDDATE,
    LASTVIEWEDDATE,
    LATITUDE,
    LONGITUDE,
    MIDDLENAME,
    MOBILEPHONE,
    NAME,
    OFFLINETRIALEXPIRATIONDATE,
    PHONE,
    POSTALCODE,
    PROFILEID,
    SENDEREMAIL,
    SENDERNAME,
    SIGNATURE,
    STATE,
    STREET,
    SUFFIX,
    TITLE,
    USERNAME,
    USERROLEID,
    USERTYPE,
    DW_LAST_UPDATED,
    VIP_APPROVAL_GROUP__C
from FBG_SOURCE.SALESFORCE.O_USER
  )
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "model.dbt_fmx.stg_salesforce_user", "profile_name": "user", "target_name": "default"} */
