# E-Commerce Sales Analytics Using SQL

## Overview
A mini project demonstrating dimensional modelling and analytical SQL for e-commerce sales. It includes a Star Schema, seed data, window-function rankings, a CTE-based Month-over-Month (MoM) report, `ROLLUP`, and query-plan inspection with `EXPLAIN`.

## Requirements
- MySQL 8.0+ (window functions and CTEs require MySQL 8.0+)
- MySQL Workbench or another MySQL client

## Project files
| File | Purpose |
|---|---|
| `01_schema.sql` | Creates the database, dimension tables, sales fact table, constraints, and indexes |
| `02_seed_data.sql` | Inserts sample customers, products, dates, and orders |
| `03_window_rankings.sql` | Uses `RANK()`, `DENSE_RANK()`, and a running total |
| `04_cte_mom_report.sql` | Uses CTEs and `LAG()` to compare monthly revenue |
| `05_rollup.sql` | Produces product/category subtotals and a grand total |
| `06_explain_optimization.sql` | Inspects query plans and documents optimization practices |

## Star Schema
- **Fact table:** `fact_sales` — one row per order line, with quantity, price, discount, and calculated total.
- **Dimensions:** `dim_date`, `dim_customer`, `dim_product`.
- **Relationships:** the fact table references each dimension using foreign keys.

## How to run
Run the scripts in this order in MySQL Workbench:
1. `01_schema.sql`
2. `02_seed_data.sql`
3. `03_window_rankings.sql`
4. `04_cte_mom_report.sql`
5. `05_rollup.sql`
6. `06_explain_optimization.sql`

Open each SQL file and execute it, or use the MySQL command line from this folder:
```bash
mysql -u your_username -p < 01_schema.sql
mysql -u your_username -p < 02_seed_data.sql
mysql -u your_username -p < 03_window_rankings.sql
mysql -u your_username -p < 04_cte_mom_report.sql
mysql -u your_username -p < 05_rollup.sql
mysql -u your_username -p < 06_explain_optimization.sql
```

## Main analyses
1. Rank products by revenue within their categories.
2. Calculate cumulative revenue across orders.
3. Compare revenue with the previous month and calculate percentage growth.
4. Summarize revenue at product, category, and overall levels.
5. Review query plans and indexes using `EXPLAIN`.

## Notes
- The dataset is small and fictional, intended for learning and demonstration.
- A query optimizer may choose a table scan for a small dataset even when indexes exist.
- `total_amount` is a generated column calculated as `(quantity * unit_price) - discount_amount`.
