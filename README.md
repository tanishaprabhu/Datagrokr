# 05 · SQL Dimensional Report (SQL — Week 5)

A mini data-warehouse project using **MySQL 8.0+**, demonstrating dimensional modelling, analytical SQL queries, and query optimization.

## Project Files

| Topic | File |
|---|---|
| Star schema (1 fact + 4 dimensions) | `01_schema.sql` |
| Sample data (5,000 sales rows) | `02_seed_data.sql` |
| Window function rankings | `03_window_rankings.sql` |
| CTE-based Month-over-Month report | `04_cte_mom_report.sql` |
| ROLLUP subtotals and grand totals | `05_rollup.sql` |
| EXPLAIN query optimization | `06_explain_optimization.sql` |
| Execute all scripts in order | `run_all.sql` |

## Star Schema

**Fact table grain:** One product line on one order.

**Measures:** `quantity`, `gross_amount`, `discount_amount`, `net_amount`.

**Design choices:** Integer surrogate keys; `date_key` stored as `YYYYMMDD`; `order_id` maintained as a degenerate dimension; descriptive attributes denormalized into dimension tables.

The month label column is named `yr_month`.

## How to Run

From a terminal in this folder:

```bash
mysql -u root -p < run_all.sql
```

Alternatively, execute `01_schema.sql` through `06_explain_optimization.sql` in order in MySQL Workbench or DBeaver. For `run_all.sql`, use the MySQL command-line client because it uses `SOURCE` commands.

## Concepts Demonstrated

### Window Functions
`RANK`, `DENSE_RANK`, `ROW_NUMBER`, `NTILE`, `PARTITION BY`, running totals, moving averages, `LAG`, `LEAD`, and named `WINDOW` clauses.

### CTE Month-over-Month Report
Chained CTEs, MoM change and percentage, UP/DOWN/FLAT trend labels, category-level MoM analysis, YoY comparison, and best/worst growth months.

### ROLLUP
Hierarchical subtotals and grand totals across year/quarter/category, region/state, and channel/store. `GROUPING()` distinguishes subtotal NULLs from real NULL values.

### EXPLAIN Optimization
Sargable date filters, index lookups, covering composite indexes, `EXPLAIN ANALYZE`, tree-format plans, and a pre-aggregated dashboard summary table.

## Expected Checks

- `dim_date`: 638 rows
- `dim_customer`: 20 rows
- `dim_product`: 12 rows
- `dim_store`: 5 rows
- `fact_sales`: 5,000 rows
- January 2025 has NULL MoM growth because there is no previous month.
- The ROLLUP grand total should match `SELECT SUM(net_amount) FROM fact_sales`.

## PostgreSQL Compatibility

This project is written for MySQL 8.0+. For PostgreSQL, adapt `WITH ROLLUP` to `GROUP BY ROLLUP(...)`, date formatting functions to `TO_CHAR`, `AUTO_INCREMENT` to identity columns, and `ENUM` types if used.

## Future Enhancements

1. Add fiscal-calendar and holiday attributes to `dim_date`.
2. Implement a Type-2 Slowly Changing Dimension for customers.
3. Build cohort and retention reports using window functions.
4. Create a view for the MoM report for BI tools.

## Technologies Used

MySQL 8.0+, SQL, dimensional data modelling, window functions, CTEs, indexing, and query optimization.
