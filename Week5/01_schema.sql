-- E-Commerce Sales Analytics: Star Schema
-- Target database: MySQL 8.0+

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;

DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;

CREATE TABLE dim_date (
    date_key       INT PRIMARY KEY,          -- YYYYMMDD
    full_date      DATE NOT NULL UNIQUE,
    day_of_month   TINYINT NOT NULL,
    month_number   TINYINT NOT NULL,
    month_name     VARCHAR(15) NOT NULL,
    quarter_number TINYINT NOT NULL,
    year_number    SMALLINT NOT NULL
);

CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(60),
    state_name    VARCHAR(60),
    customer_segment VARCHAR(30)
);

CREATE TABLE dim_product (
    product_key  INT AUTO_INCREMENT PRIMARY KEY,
    product_id   VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(120) NOT NULL,
    category     VARCHAR(60) NOT NULL,
    brand        VARCHAR(60),
    unit_price   DECIMAL(10,2) NOT NULL,
    CHECK (unit_price >= 0)
);

CREATE TABLE fact_sales (
    sales_key    BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id     VARCHAR(30) NOT NULL,
    date_key     INT NOT NULL,
    customer_key INT NOT NULL,
    product_key  INT NOT NULL,
    quantity     INT NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) GENERATED ALWAYS AS
                  ((quantity * unit_price) - discount_amount) STORED,
    CONSTRAINT fk_sales_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    CHECK (quantity > 0),
    CHECK (discount_amount >= 0)
);

-- Indexes used by reporting queries.
CREATE INDEX idx_fact_sales_date ON fact_sales(date_key);
CREATE INDEX idx_fact_sales_product_date ON fact_sales(product_key, date_key);
CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_key);
