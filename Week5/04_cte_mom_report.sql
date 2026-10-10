-- Week 5: Month-over-Month and Year-over-Year report
USE sql_dimensional_report;

WITH monthly AS (
    SELECT d.yr_month, MIN(d.year_num) AS year_num, MIN(d.month_num) AS month_num,
           SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.yr_month
),
comparisons AS (
    SELECT monthly.*,
           LAG(revenue) OVER (ORDER BY yr_month) AS previous_revenue,
           LAG(revenue, 12) OVER (ORDER BY yr_month) AS revenue_last_year
    FROM monthly
)
SELECT yr_month, ROUND(revenue, 2) AS revenue,
       ROUND(previous_revenue, 2) AS previous_month_revenue,
       ROUND(revenue - previous_revenue, 2) AS mom_change,
       ROUND(100 * (revenue - previous_revenue) / NULLIF(previous_revenue, 0), 2) AS mom_percent,
       CASE WHEN previous_revenue IS NULL THEN 'N/A'
            WHEN revenue > previous_revenue THEN 'UP'
            WHEN revenue < previous_revenue THEN 'DOWN'
            ELSE 'FLAT' END AS trend,
       ROUND(revenue_last_year, 2) AS same_month_last_year_revenue,
       ROUND(100 * (revenue - revenue_last_year) / NULLIF(revenue_last_year, 0), 2) AS yoy_percent
FROM comparisons
ORDER BY yr_month;

-- Category-level month-over-month report.
WITH category_monthly AS (
    SELECT d.yr_month, p.category, SUM(f.net_amount) AS revenue
    FROM fact_sales f
    JOIN dim_date d ON d.date_key = f.date_key
    JOIN dim_product p ON p.product_key = f.product_key
    GROUP BY d.yr_month, p.category
),
category_comparisons AS (
    SELECT *,
           LAG(revenue) OVER (PARTITION BY category ORDER BY yr_month) AS previous_revenue
    FROM category_monthly
)
SELECT yr_month, category, ROUND(revenue, 2) AS revenue,
       ROUND(previous_revenue, 2) AS previous_revenue,
       ROUND(revenue - previous_revenue, 2) AS mom_change,
       ROUND(100 * (revenue - previous_revenue) / NULLIF(previous_revenue, 0), 2) AS mom_percent
FROM category_comparisons
ORDER BY category, yr_month;

-- Best and worst growth months (excluding the first month with no previous month).
WITH monthly AS (
    SELECT d.yr_month, SUM(f.net_amount) AS revenue
    FROM fact_sales f JOIN dim_date d ON d.date_key = f.date_key
    GROUP BY d.yr_month
),
growth AS (
    SELECT yr_month, revenue,
           revenue - LAG(revenue) OVER (ORDER BY yr_month) AS mom_change
    FROM monthly
)
(SELECT 'Best growth month' AS result_type, yr_month, ROUND(mom_change, 2) AS mom_change
 FROM growth WHERE mom_change IS NOT NULL ORDER BY mom_change DESC LIMIT 1)
UNION ALL
(SELECT 'Worst growth month' AS result_type, yr_month, ROUND(mom_change, 2) AS mom_change
 FROM growth WHERE mom_change IS NOT NULL ORDER BY mom_change ASC LIMIT 1);
