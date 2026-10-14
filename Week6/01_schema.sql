-- PostgreSQL 15+. Run from the project root.
DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS stg_sales CASCADE;
DROP TABLE IF EXISTS stg_customers CASCADE;
DROP TABLE IF EXISTS stg_products CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;

CREATE TABLE dim_customer (
    customer_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id  BIGINT NOT NULL UNIQUE, -- business key from source
    first_name   TEXT NOT NULL,
    last_name    TEXT NOT NULL,
    email        TEXT,
    city         TEXT,
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp()
);

CREATE TABLE dim_product (
    product_key BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id  BIGINT NOT NULL UNIQUE,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

-- Deliberately permissive staging tables: raw CSV values land here first.
CREATE TABLE stg_customers (
    customer_id TEXT, first_name TEXT, last_name TEXT, email TEXT,
    city TEXT, is_active TEXT
);
CREATE TABLE stg_products (
    product_id TEXT, product_name TEXT, category TEXT, unit_price TEXT
);
CREATE TABLE stg_sales (
    order_id TEXT, customer_id TEXT, product_id TEXT, order_date TEXT,
    quantity TEXT, unit_price TEXT, status TEXT
);

CREATE TABLE fact_sales (
    order_id BIGINT NOT NULL,
    order_date DATE NOT NULL,
    customer_key BIGINT NOT NULL REFERENCES dim_customer(customer_key),
    product_key BIGINT NOT NULL REFERENCES dim_product(product_key),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    status TEXT NOT NULL,
    revenue NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
    PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE fact_sales_2026_07 PARTITION OF fact_sales
    FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');
CREATE TABLE fact_sales_2026_08 PARTITION OF fact_sales
    FOR VALUES FROM ('2026-08-01') TO ('2026-09-01');
CREATE TABLE fact_sales_2026_09 PARTITION OF fact_sales
    FOR VALUES FROM ('2026-09-01') TO ('2026-10-01');
CREATE TABLE fact_sales_2026_10 PARTITION OF fact_sales
    FOR VALUES FROM ('2026-10-01') TO ('2026-11-01');
CREATE TABLE fact_sales_default PARTITION OF fact_sales DEFAULT;
