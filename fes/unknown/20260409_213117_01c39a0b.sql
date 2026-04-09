-- Query ID: 01c39a0b-0112-6029-0000-e307218b8466
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Last Executed: 2026-04-09T21:31:17.353000+00:00
-- Elapsed: 1775ms
-- Run Count: 2
-- Environment: FES

WITH last_success AS (                                                                                                  
  SELECT account_id, updated_at                                                                                       
  FROM LOYALTY.SOURCE.program_account_balance                                                                         
  AT(OFFSET => -1800)                                                       
),                                                                                                                      
current_failure AS (                                                                                                    
  SELECT account_id, updated_at                                                                                       
  FROM LOYALTY.SOURCE.program_account_balance                                                                         
)                                                                                                                       
SELECT                                                                                                                  
  COALESCE(s.account_id, f.account_id) AS account_id,                                                                 
  s.updated_at AS updated_at_last_success,                                                                            
  f.updated_at AS updated_at_now_failure,                                                                             
  CASE                                                                                                                
      WHEN s.account_id IS NULL THEN 'NEW (added since last success)'                                                 
      WHEN f.account_id IS NULL THEN 'DELETED'                                                                        
      WHEN s.updated_at != f.updated_at THEN 'UPDATED (timestamp changed)'                                            
      ELSE 'UNCHANGED'                                                                                                
  END AS status                                                                                                       
FROM last_success s                                                                                                     
FULL OUTER JOIN current_failure f USING (account_id)                                                                    
WHERE s.updated_at IS DISTINCT FROM f.updated_at                                                                        
 OR s.account_id IS NULL                                                                                              
 OR f.account_id IS NULL                                                                                              
ORDER BY status, account_id;
