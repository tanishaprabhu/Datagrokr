-- CTE-based Month-over-Month (MoM) revenue report
USE ecommerce_analytics;

WITH monthly_sales AS (
    SELECT
        d.year_number,
        d.month_number,
        d.month_name,
        SUM(f.total_amount) AS monthly_revenue
    FROM fact_sales f
    JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.year_number, d.month_number, d.month_name
),
sales_with_previous_month AS (
    SELECT
        year_number,
        month_number,
        month_name,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY year_number, month_number
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    year_number,
    month_number,
    month_name,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS revenue_change,
    ROUND(
        100.0 * (monthly_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0), 2
    ) AS mom_growth_percent
FROM sales_with_previous_month
ORDER BY year_number, month_number;
