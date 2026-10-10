-- Week 5: ROLLUP subtotals and grand totals
USE sql_dimensional_report;

-- Year > Quarter > Category totals.
SELECT d.year_num, d.quarter_num, p.category,
       ROUND(SUM(f.net_amount), 2) AS net_revenue,
       GROUPING(d.year_num) AS is_grand_total,
       GROUPING(d.quarter_num) AS is_year_subtotal,
       GROUPING(p.category) AS is_quarter_subtotal
FROM fact_sales f
JOIN dim_date d ON d.date_key = f.date_key
JOIN dim_product p ON p.product_key = f.product_key
GROUP BY d.year_num, d.quarter_num, p.category WITH ROLLUP
ORDER BY GROUPING(d.year_num), d.year_num,
         GROUPING(d.quarter_num), d.quarter_num,
         GROUPING(p.category), p.category;

-- Region > State totals.
SELECT c.region, c.state, ROUND(SUM(f.net_amount), 2) AS net_revenue,
       CASE WHEN GROUPING(c.region) = 1 THEN 'GRAND TOTAL'
            WHEN GROUPING(c.state) = 1 THEN CONCAT(c.region, ' SUBTOTAL')
            ELSE c.state END AS total_level
FROM fact_sales f
JOIN dim_customer c ON c.customer_key = f.customer_key
GROUP BY c.region, c.state WITH ROLLUP
ORDER BY GROUPING(c.region), c.region, GROUPING(c.state), c.state;

-- Channel > Store totals.
SELECT s.channel, s.store_name, ROUND(SUM(f.net_amount), 2) AS net_revenue,
       CASE WHEN GROUPING(s.channel) = 1 THEN 'GRAND TOTAL'
            WHEN GROUPING(s.store_name) = 1 THEN CONCAT(s.channel, ' SUBTOTAL')
            ELSE s.store_name END AS total_level
FROM fact_sales f
JOIN dim_store s ON s.store_key = f.store_key
GROUP BY s.channel, s.store_name WITH ROLLUP
ORDER BY GROUPING(s.channel), s.channel, GROUPING(s.store_name), s.store_name;

-- Sanity check: this total should equal the grand total above.
SELECT ROUND(SUM(net_amount), 2) AS expected_grand_total FROM fact_sales;
