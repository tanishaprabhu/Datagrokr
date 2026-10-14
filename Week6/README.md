# SQL DE Pipeline — Week 6 Mini Project

A hands-on PostgreSQL retail warehouse covering `COPY`/`\copy`, `MERGE`, monthly range partitioning, and composite/partial indexes.

## Requirements
- PostgreSQL 15 or newer
- `psql`
- Run commands from the project root because `\copy` reads `data/...` relative to the client working directory.

## Quick start

```bash
createdb de_pipeline
psql -v ON_ERROR_STOP=1 -d de_pipeline -f run_all.sql
```

The day-1 run loads 8 products, 20 customers, and 400 sales rows. It creates monthly partitions for July–October 2026 plus a default partition for out-of-range dates.

Run the incremental customer feed separately:

```bash
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/07_day2_incremental.sql
```

The day-2 feed contains 8 changed customers and 5 new customers; after it runs, the customer dimension should contain 25 rows.

## Run step by step

```bash
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/01_schema.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/02_bulk_load.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/03_merge_dimension.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/04_load_fact.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/05_indexes.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/06_queries_explain.sql
psql -v ON_ERROR_STOP=1 -d de_pipeline -f sql/07_day2_incremental.sql
```

## Project layout

```text
sql-de-pipeline/
├── README.md
├── run_all.sql
├── data/
│   ├── products.csv
│   ├── customers_day1.csv
│   ├── customers_day2.csv
│   └── sales.csv
└── sql/
    ├── 01_schema.sql
    ├── 02_bulk_load.sql
    ├── 03_merge_dimension.sql
    ├── 04_load_fact.sql
    ├── 05_indexes.sql
    ├── 06_queries_explain.sql
    └── 07_day2_incremental.sql
```

## Concepts practised

### 1. Bulk loading
`\copy` reads CSV files from the client machine into permissive staging tables. Staging is intentionally text-based so raw values can be checked before conversion. Server-side `COPY` reads from the database server filesystem and has different permission requirements.

### 2. Dimension `MERGE`
The merge matches on the source business key (`customer_id`), not the generated surrogate key. `IS DISTINCT FROM` safely compares nullable fields and avoids updating unchanged rows. `DISTINCT ON` deduplicates source business keys before the merge.

### 3. Range partitioning
`fact_sales` is partitioned by `order_date`. Monthly partitions cover July–October 2026. Five January 2027 rows route to the default partition. The primary key includes the partition key: `(order_id, order_date)`.

### 4. Indexing
- `(customer_key, order_date DESC)` supports customer order history queries.
- `order_date WHERE status = 'RETURNED'` supports return analysis.
- `customer_key WHERE status = 'PENDING'` supports pending-order follow-ups.
- `UNIQUE (email) WHERE is_active AND email IS NOT NULL` enforces one active customer per non-null email.

A partial index can be used only when the planner can establish that the query predicate implies the index predicate. `EXPLAIN` plans depend on statistics, PostgreSQL version, and table size; a tiny demo dataset may prefer sequential scans.

## Expected checks

- Day 1: 8 products, 20 customers, 400 facts.
- Partition distribution: July 95, August 102, September 95, October 103, default 5.
- Day 2: 8 updates + 5 inserts; 25 customers total.

Useful manual checks:

```sql
SELECT count(*) FROM dim_customer;
SELECT count(*) FROM dim_product;
SELECT count(*) FROM fact_sales;
SELECT tableoid::regclass AS partition_name, count(*)
FROM fact_sales GROUP BY tableoid ORDER BY 1;
```

## Extensions
1. Add Type-2 SCD columns (`valid_from`, `valid_to`, `is_current`) to preserve history.
2. On PostgreSQL 17+, experiment with `WHEN NOT MATCHED BY SOURCE THEN UPDATE SET is_active = false`.
3. Create a December 2026 partition, then detach and archive July.
4. Compare `EXPLAIN ANALYZE` before and after indexes; use `\timing` to compare bulk load with row-by-row inserts.
5. Add a monthly revenue view and a `CHECK` constraint on status.
