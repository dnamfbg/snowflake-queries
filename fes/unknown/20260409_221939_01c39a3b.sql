-- Query ID: 01c39a3b-0112-6806-0000-e307218d322a
-- Database: unknown
-- Schema: unknown
-- Warehouse: FDE_DEVELOPER_XL_WH
-- Executed: 2026-04-09T22:19:39.867000+00:00
-- Elapsed: 18858ms
-- Environment: FES

SELECT 
    $1:loyalty_account_id::STRING AS loyalty_account_id,
    $1:loyalty_txn_id::STRING AS loyalty_txn_id,
    $1:txn_status::STRING AS txn_status,
    $1:loyalty_txn_type::INT AS loyalty_txn_type,
    $1:loyalty_txn_add_type::INT AS loyalty_txn_add_type,
    $1:creation_time::TIMESTAMP AS creation_time,
    $1:loyalty_expiration::TIMESTAMP AS loyalty_expiration,
    $1:txn_amount::DECIMAL(38, 7) AS txn_amount,
    $1:pending_redeem_amt::DECIMAL(38, 7) AS pending_redeem_amt,
    $1:redeem_id::STRING AS redeem_id,
    $1:order_id::STRING AS order_id,
    $1:site_id::INT AS site_id,
    $1:tenant_id::INT AS tenant_id,
    $1:loyalty_txn_ref_data::STRING AS loyalty_txn_ref_data,
    $1:batch_id::STRING AS batch_id,
    $1:redeem_cnt::INT AS redeem_cnt,
    $1:connected_status::INT AS connected_status,
    $1:modified_time::TIMESTAMP AS modified_time
FROM @fde.fde_stage.fanatics_prod_internal_regulated/fdsloyalty/unconnected_earn/
(FILE_FORMAT => fde.fde_stage.parquet_ff, PATTERN => $ts_pattern)
WHERE order_id = '3acafd60-02d4-11f1-bd95-8def29e5c141';
