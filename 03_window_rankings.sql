-- Window function examples: product/category rankings and running revenue
USE ecommerce_analytics;

-- Rank products by total revenue within each category.
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(f.quantity) AS units_sold,
        SUM(f.total_amount) AS revenue
    FROM fact_sales f
    JOIN dim_product p ON p.product_key = f.product_key
    GROUP BY p.category, p.product_key, p.product_name
)
SELECT
    category,
    product_name,
    units_sold,
    revenue,
    RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY revenue DESC) AS overall_revenue_rank
FROM product_sales
ORDER BY category, revenue_rank;

-- Running revenue over time.
SELECT
    d.full_date,
    f.order_id,
    f.total_amount,
    SUM(f.total_amount) OVER (
        ORDER BY d.full_date, f.sales_key
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
ORDER BY d.full_date, f.sales_key;
