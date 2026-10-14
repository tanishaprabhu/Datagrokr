-- Convert clean staging values and resolve natural keys to dimension surrogate keys.
-- Duplicate order/date keys are ignored on reruns, making this load repeatable.
INSERT INTO fact_sales
    (order_id, order_date, customer_key, product_key, quantity, unit_price, status)
SELECT s.order_id::BIGINT,
       s.order_date::DATE,
       c.customer_key,
       p.product_key,
       s.quantity::INTEGER,
       s.unit_price::NUMERIC(10,2),
       upper(trim(s.status))
FROM stg_sales AS s
JOIN dim_customer AS c ON c.customer_id = s.customer_id::BIGINT
JOIN dim_product AS p ON p.product_id = s.product_id::BIGINT
WHERE s.order_id ~ '^[0-9]+$'
  AND s.customer_id ~ '^[0-9]+$'
  AND s.product_id ~ '^[0-9]+$'
  AND s.order_date ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
  AND s.quantity ~ '^[1-9][0-9]*$'
  AND s.unit_price ~ '^[0-9]+([.][0-9]{1,2})?$'
ON CONFLICT (order_id, order_date) DO NOTHING;

SELECT tableoid::regclass AS partition_name, count(*) AS row_count
FROM fact_sales
GROUP BY tableoid
ORDER BY partition_name::TEXT;
