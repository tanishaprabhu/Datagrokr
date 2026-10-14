-- Run from the project root so data/ paths resolve.
TRUNCATE stg_products, stg_customers, stg_sales;

\copy stg_products(product_id, product_name, category, unit_price) FROM 'data/products.csv' WITH (FORMAT csv, HEADER true)
\copy stg_customers(customer_id, first_name, last_name, email, city, is_active) FROM 'data/customers_day1.csv' WITH (FORMAT csv, HEADER true)
\copy stg_sales(order_id, customer_id, product_id, order_date, quantity, unit_price, status) FROM 'data/sales.csv' WITH (FORMAT csv, HEADER true)

-- Validate counts before promoting staging data.
SELECT 'stg_products' AS table_name, count(*) AS rows FROM stg_products
UNION ALL SELECT 'stg_customers', count(*) FROM stg_customers
UNION ALL SELECT 'stg_sales', count(*) FROM stg_sales;

INSERT INTO dim_product(product_id, product_name, category, unit_price)
SELECT DISTINCT ON (product_id::BIGINT)
       product_id::BIGINT, product_name, category, unit_price::NUMERIC(10,2)
FROM stg_products
WHERE product_id ~ '^[0-9]+$'
  AND unit_price ~ '^[0-9]+(\.[0-9]{1,2})?$'
ORDER BY product_id::BIGINT;
