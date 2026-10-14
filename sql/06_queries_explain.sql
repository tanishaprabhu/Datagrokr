-- Business query: recent orders for a customer, newest first.
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT order_id, order_date, quantity, unit_price, status, revenue
FROM fact_sales
WHERE customer_key = (SELECT customer_key FROM dim_customer WHERE customer_id = 1001)
  AND order_date >= DATE '2026-09-01'
ORDER BY order_date DESC
LIMIT 20;

-- Partition pruning proof: only September 2026 should be scanned.
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*), sum(revenue)
FROM fact_sales
WHERE order_date >= DATE '2026-09-01'
  AND order_date < DATE '2026-10-01';

-- Partial-index candidate. Planner choice depends on data volume/statistics.
EXPLAIN (ANALYZE, BUFFERS)
SELECT order_date, count(*)
FROM fact_sales
WHERE status = 'RETURNED'
GROUP BY order_date
ORDER BY order_date;

-- Pending follow-up candidate.
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_key, count(*)
FROM fact_sales
WHERE status = 'PENDING'
GROUP BY customer_key;

-- Monthly revenue summary.
SELECT date_trunc('month', order_date)::DATE AS month,
       count(*) AS orders,
       sum(revenue)::NUMERIC(14,2) AS revenue
FROM fact_sales
GROUP BY 1
ORDER BY 1;
