-- Query ID: 01c39a29-0212-6e7d-24dd-0703193dfdfb
-- Database: FBG_SOURCE
-- Schema: unknown
-- Warehouse: BI_SM_WH
-- Executed: 2026-04-09T22:01:05.055000+00:00
-- Elapsed: 57247ms
-- Environment: FBG

SELECT "Custom SQL Query"."ACCOUNT_ID" AS "ACCOUNT_ID",
  "Custom SQL Query"."AMOUNT" AS "AMOUNT",
  "Custom SQL Query"."DESCRIPTION" AS "DESCRIPTION",
  "Custom SQL Query"."EMAIL" AS "EMAIL",
  "Custom SQL Query"."JURISDICTION_NAME" AS "JURISDICTION_NAME",
  "Custom SQL Query"."NAME" AS "NAME",
  "Custom SQL Query"."PAYMENT_METHOD" AS "PAYMENT_METHOD",
  "Custom SQL Query"."PEND_ID" AS "PEND_ID",
  "Custom SQL Query"."STATUS" AS "STATUS",
  "Custom SQL Query"."TOKEN" AS "TOKEN",
  "Custom SQL Query"."TRANSACTION_NUMBER" AS "TRANSACTION_NUMBER",
  "Custom SQL Query"."TRANSACTION_REF" AS "TRANSACTION_REF",
  "Custom SQL Query"."TRANS_DATE" AS "TRANS_DATE",
  "Custom SQL Query"."VENUE_NAME" AS "VENUE_NAME",
  "Custom SQL Query"."VIP" AS "VIP",
  "Custom SQL Query"."Withdrawal Initiation Date" AS "Withdrawal Initiation Date",
  "Custom SQL Query"."Withdrawal Submitted Date" AS "Withdrawal Submitted Date"
FROM (
  with Pends AS
  (SELECT LINK_TRANS_REF, CONVERT_TIMEZONE('UTC','America/New_York',Trans_Date) AS Trans_Date
  FROM FBG_SOURCE_DEV.OSB_SOURCE_DEV.Account_Statements
  WHERE Trans = 'WITHDRAWAL_PENDING' AND 
  payment_brand = 'CASHATCAGE' 
  AND DESCRIPTION = 'Cash At Cage Withdrawal Request Received.')
  
  
  
  
  SELECT 
      ACCOUNT_ID,
      TOKEN,
      STATUS,
      DESCRIPTION,
      jurisdiction_name,
      "Withdrawal Initiation Date",
      "Withdrawal Submitted Date",
      TRANSACTION_NUMBER,
      TRANSACTION_REF,
      PAYMENT_METHOD,
      name,
      EMAIL,
      vip,
      Pend_ID,
      Trans_Date,
      venue_name,
      AMOUNT
  FROM (
      SELECT 
          W.ACCOUNT_ID,
          W.TOKEN,
          W.STATUS,
          W.DESCRIPTION,
          J.jurisdiction_name,
          CONVERT_TIMEZONE('UTC','America/New_York',W.initiated_at) AS "Withdrawal Initiation Date",
          CONVERT_TIMEZONE('UTC','America/New_York',W.SUBMITTED_AT) AS "Withdrawal Submitted Date",
          W.LINK_TRANS_REF AS TRANSACTION_NUMBER,
          W.TRANSACTION_REF,
          W.PAYMENT_BRAND AS PAYMENT_METHOD,
          A.name,
          A.EMAIL,
          A.vip,
          P.Link_Trans_Ref AS Pend_ID,
          P.Trans_Date,
          (CASE 
              WHEN trans IN ('DEPOSIT_ABANDONED','DEPOSIT_PENDING','DEPOSIT_FAILED','RETAIL_CASH_AT_CAGE_IN','RETAIL_CASH_AT_CAGE_OUT') THEN parse_json(additional_info):retailVenueName
              WHEN trans = 'DEPOSIT' THEN parse_json(parse_json(additional_info):DepositAdditionalInfo):retailVenueName
              WHEN trans IN ('WITHDRAWAL_COMPLETED','WITHDRAWAL_PENDING','WITHDRAWAL_PRE_APPROVED','WITHDRAWAL_APPROVED','WITHDRAWAL_EXPIRED','WITHDRAWAL_CANCELLED') THEN parse_json(additional_info):WithdrawAdditionalInfo:retailVenueName
          END)::varchar AS venue_name,
          W.AMOUNT AS AMOUNT,
          ROW_NUMBER() OVER(PARTITION BY W.LINK_TRANS_REF ORDER BY W.LINK_TRANS_REF) AS rn
      FROM 
          FBG_SOURCE.OSB_SOURCE.WITHDRAWALS W
      LEFT JOIN 
          FBG_SOURCE.OSB_SOURCE.ACCOUNTS A ON W.ACCOUNT_ID = A.ID
      LEFT JOIN 
          FBG_SOURCE.OSB_SOURCE.ACCOUNT_STATEMENTS AST ON AST.ACCO_ID = A.ID
      LEFT JOIN 
          FBG_SOURCE.OSB_SOURCE.JURISDICTIONS J ON W.JURISDICTIONS_ID = J.ID
      LEFT JOIN 
          PENDS P ON W.LINK_TRANS_REF = P.LINK_TRANS_REF
      WHERE 
          A.STATUS = 'ACTIVE' 
          AND A.TEST = '0' 
          AND W.Completed_AT IS NULL 
          AND W.Payment_Brand IN ('CASHATCAGE') 
          AND venue_name IS NOT NULL
  ) AS sub
  WHERE 
      rn = 1
  GROUP BY 
      ACCOUNT_ID,
      TOKEN,
      STATUS,
      DESCRIPTION,
      jurisdiction_name,
      "Withdrawal Initiation Date",
      "Withdrawal Submitted Date",
      TRANSACTION_NUMBER,
      TRANSACTION_REF,
      PAYMENT_METHOD,
      name,
      EMAIL,
      vip,
      Pend_ID,
      Trans_Date,
      venue_name,
      AMOUNT
) "Custom SQL Query"
