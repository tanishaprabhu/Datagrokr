-- Composite index: equality predicate first, then date range/order.
CREATE INDEX IF NOT EXISTS ix_fact_customer_date
    ON fact_sales (customer_key, order_date DESC);

-- Partial indexes stay small when the indexed status is uncommon.
CREATE INDEX IF NOT EXISTS ix_fact_returned_date
    ON fact_sales (order_date)
    WHERE status = 'RETURNED';

CREATE INDEX IF NOT EXISTS ix_fact_pending_customer
    ON fact_sales (customer_key)
    WHERE status = 'PENDING';

-- One active customer per email; inactive rows may reuse an email.
CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_customer_active_email
    ON dim_customer (email)
    WHERE is_active AND email IS NOT NULL;

ANALYZE dim_customer;
ANALYZE dim_product;
ANALYZE fact_sales;
