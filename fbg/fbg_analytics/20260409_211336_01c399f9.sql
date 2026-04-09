-- Query ID: 01c399f9-0212-6cb9-24dd-0703193313db
-- Database: FBG_ANALYTICS
-- Schema: unknown
-- Warehouse: BI_L_WH
-- Executed: 2026-04-09T21:13:36.812000+00:00
-- Elapsed: 1721ms
-- Environment: FBG

select date(date_trunc('month', date)) as month,
    consolidated_state as state,
    channel,
    first_product,
    category,
    sum(ftus),
    sum(media_spend),
    sum(acq_cost)
from fbg_analytics.product_and_customer.acquisition_summary_new
    where month >= '2025-01-01'
group by
    month, state, channel, first_product, category
