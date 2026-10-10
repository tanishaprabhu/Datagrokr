-- Week 5: EXPLAIN and index optimization examples
USE sql_dimensional_report;

-- Step 1: Non-sargable predicate (often prevents efficient use of date_key index).
EXPLAIN
SELECT SUM(net_amount)
FROM fact_sales
WHERE YEAR(STR_TO_DATE(CAST(date_key AS CHAR), '%Y%m%d')) = 2026;

-- Step 2: Sargable date_key range predicate.
EXPLAIN
SELECT SUM(net_amount)
FROM fact_sales
WHERE date_key >= 20260101 AND date_key < 20270101;

-- Step 3: Compare an unindexed predicate and an indexed predicate.
EXPLAIN
SELECT * FROM dim_customer WHERE city = 'Bengaluru';

CREATE INDEX idx_customer_city ON dim_customer(city);

EXPLAIN
SELECT * FROM dim_customer WHERE city = 'Bengaluru';

-- Step 4: Covering composite index for a common store/date aggregation.
CREATE INDEX idx_sales_store_date_net ON fact_sales(store_key, date_key, net_amount);

EXPLAIN
SELECT date_key, SUM(net_amount)
FROM fact_sales
WHERE store_key = 1 AND date_key >= 20260101 AND date_key < 20260701
GROUP BY date_key;

-- Step 5: Actual execution timing and row counts (MySQL 8.0.18+).
EXPLAIN ANALYZE
SELECT product_key, SUM(net_amount) AS revenue
FROM fact_sales
WHERE date_key >= 20260101 AND date_key < 20270101
GROUP BY product_key;

EXPLAIN FORMAT=TREE
SELECT product_key, SUM(net_amount) AS revenue
FROM fact_sales
WHERE date_key >= 20260101 AND date_key < 20270101
GROUP BY product_key;

-- Step 6: Pre-aggregated summary table for dashboards.
DROP TABLE IF EXISTS monthly_store_summary;
CREATE TABLE monthly_store_summary AS
SELECT d.yr_month, f.store_key, SUM(f.net_amount) AS net_revenue,
       COUNT(*) AS sales_lines
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
GROUP BY d.yr_month, f.store_key;

ALTER TABLE monthly_store_summary
ADD INDEX idx_summary_month_store (yr_month, store_key);

EXPLAIN
SELECT yr_month, store_key, net_revenue
FROM monthly_store_summary
WHERE yr_month = '2026-06';
