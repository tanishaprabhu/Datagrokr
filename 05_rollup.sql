-- ROLLUP: category subtotals and grand total
USE ecommerce_analytics;

SELECT
    CASE WHEN p.category IS NULL THEN 'ALL CATEGORIES' ELSE p.category END AS category,
    CASE WHEN p.product_name IS NULL THEN 'CATEGORY / GRAND TOTAL' ELSE p.product_name END AS product_name,
    SUM(f.quantity) AS units_sold,
    SUM(f.total_amount) AS revenue
FROM fact_sales f
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY p.category, p.product_name WITH ROLLUP
ORDER BY
    (p.category IS NULL),
    p.category,
    (p.product_name IS NULL),
    p.product_name;
