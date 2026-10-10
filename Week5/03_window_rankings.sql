-- Week 5: Window function examples
USE sql_dimensional_report;

-- 1. Rank products by revenue.
SELECT p.product_name, ROUND(SUM(f.net_amount), 2) AS revenue,
       RANK() OVER (ORDER BY SUM(f.net_amount) DESC) AS revenue_rank,
       DENSE_RANK() OVER (ORDER BY SUM(f.net_amount) DESC) AS dense_rank
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY p.product_key, p.product_name
ORDER BY revenue_rank;

-- 2. Top 3 products in each category using ROW_NUMBER and PARTITION BY.
WITH product_revenue AS (
    SELECT p.category, p.product_name, SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_product p ON p.product_key = f.product_key
    GROUP BY p.category, p.product_key, p.product_name
),
ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM product_revenue
)
SELECT category, product_name, ROUND(revenue, 2) AS revenue, rn
FROM ranked WHERE rn <= 3 ORDER BY category, rn;

-- 3. NTILE divides customers into four revenue groups.
WITH customer_revenue AS (
    SELECT c.customer_name, SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_customer c ON c.customer_key = f.customer_key
    GROUP BY c.customer_key, c.customer_name
)
SELECT customer_name, ROUND(revenue, 2) AS revenue,
       NTILE(4) OVER (ORDER BY revenue DESC) AS revenue_quartile
FROM customer_revenue ORDER BY revenue_quartile, revenue DESC;

-- 4. Monthly running total and three-month moving average.
WITH monthly AS (
    SELECT d.yr_month, SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.yr_month
)
SELECT yr_month, ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY yr_month), 2) AS running_total,
       ROUND(AVG(revenue) OVER (ORDER BY yr_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3_month
FROM monthly ORDER BY yr_month;

-- 5. LAG and LEAD compare monthly revenue with adjacent months.
WITH monthly AS (
    SELECT d.yr_month, SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.yr_month
)
SELECT yr_month, ROUND(revenue, 2) AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY yr_month), 2) AS previous_month,
       ROUND(LEAD(revenue) OVER (ORDER BY yr_month), 2) AS next_month
FROM monthly ORDER BY yr_month;

-- 6. Named WINDOW clause: rank stores by sales within each region.
SELECT s.region, s.store_name, SUM(f.net_amount) AS revenue,
       DENSE_RANK() OVER w AS region_rank
FROM fact_sales f JOIN dim_store s ON s.store_key = f.store_key
GROUP BY s.region, s.store_key, s.store_name
WINDOW w AS (PARTITION BY s.region ORDER BY SUM(f.net_amount) DESC)
ORDER BY s.region, region_rank;
