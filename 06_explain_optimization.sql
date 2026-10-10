-- EXPLAIN and query optimization examples
USE ecommerce_analytics;

-- 1. Inspect the execution plan for a date-filtered sales report.
EXPLAIN
SELECT
    d.year_number,
    d.month_number,
    SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
WHERE f.date_key BETWEEN 20260201 AND 20260331
GROUP BY d.year_number, d.month_number;

-- 2. Compare the plan for a product/date filter.
EXPLAIN
SELECT
    p.product_name,
    SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
WHERE f.product_key = 1
  AND f.date_key BETWEEN 20260101 AND 20260430
GROUP BY p.product_name;

-- Optimization notes:
-- * Keep indexes on commonly filtered/joined columns (date_key, product_key).
-- * Avoid wrapping indexed filter columns in functions in WHERE clauses.
-- * Select only required columns rather than SELECT *.
-- * Use EXPLAIN ANALYZE in MySQL 8.0.18+ to inspect actual execution details:
--   EXPLAIN ANALYZE SELECT ...;
-- * For a tiny teaching dataset, a full table scan may still be chosen; this is normal.
