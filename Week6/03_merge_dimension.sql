-- PostgreSQL 15+: idempotent customer dimension upsert.
MERGE INTO dim_customer AS d
USING (
    SELECT DISTINCT ON (customer_id::BIGINT)
           customer_id::BIGINT AS customer_id,
           NULLIF(trim(first_name), '') AS first_name,
           NULLIF(trim(last_name), '') AS last_name,
           NULLIF(lower(trim(email)), '') AS email,
           NULLIF(trim(city), '') AS city,
           CASE WHEN lower(trim(is_active)) IN ('true','t','1','yes','y') THEN TRUE
                WHEN lower(trim(is_active)) IN ('false','f','0','no','n') THEN FALSE
                ELSE TRUE END AS is_active
    FROM stg_customers
    WHERE customer_id ~ '^[0-9]+$'
    ORDER BY customer_id::BIGINT, email
) AS s
ON d.customer_id = s.customer_id
WHEN MATCHED AND (
       d.first_name IS DISTINCT FROM s.first_name
    OR d.last_name  IS DISTINCT FROM s.last_name
    OR d.email      IS DISTINCT FROM s.email
    OR d.city       IS DISTINCT FROM s.city
    OR d.is_active  IS DISTINCT FROM s.is_active
) THEN UPDATE SET
    first_name = s.first_name,
    last_name = s.last_name,
    email = s.email,
    city = s.city,
    is_active = s.is_active,
    updated_at = clock_timestamp()
WHEN NOT MATCHED THEN INSERT
    (customer_id, first_name, last_name, email, city, is_active)
VALUES
    (s.customer_id, s.first_name, s.last_name, s.email, s.city, s.is_active);
