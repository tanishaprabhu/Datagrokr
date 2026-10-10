-- Week 5: SQL Dimensional Report
-- MySQL 8.0+
DROP DATABASE IF EXISTS sql_dimensional_report;
CREATE DATABASE sql_dimensional_report;
USE sql_dimensional_report;

CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_num TINYINT NOT NULL,
    month_num TINYINT NOT NULL,
    month_name VARCHAR(12) NOT NULL,
    quarter_num TINYINT NOT NULL,
    year_num SMALLINT NOT NULL,
    yr_month CHAR(7) NOT NULL,
    day_name VARCHAR(12) NOT NULL,
    is_weekend BOOLEAN NOT NULL DEFAULT FALSE,
    INDEX idx_date_year_month (year_num, month_num)
);

CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(12) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(30) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state VARCHAR(60) NOT NULL,
    region VARCHAR(30) NOT NULL
);

CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(12) NOT NULL UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    subcategory VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE dim_store (
    store_key INT AUTO_INCREMENT PRIMARY KEY,
    store_id VARCHAR(12) NOT NULL UNIQUE,
    store_name VARCHAR(100) NOT NULL,
    channel VARCHAR(30) NOT NULL,
    city VARCHAR(60) NOT NULL,
    state VARCHAR(60) NOT NULL,
    region VARCHAR(30) NOT NULL
);

CREATE TABLE fact_sales (
    sales_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    store_key INT NOT NULL,
    order_id VARCHAR(20) NOT NULL,
    line_number TINYINT NOT NULL,
    quantity INT NOT NULL,
    gross_amount DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    net_amount DECIMAL(12,2) NOT NULL,
    INDEX idx_sales_date (date_key),
    INDEX idx_sales_product (product_key),
    INDEX idx_sales_customer (customer_key),
    INDEX idx_sales_store (store_key),
    CONSTRAINT fk_sales_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_sales_product FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    CONSTRAINT fk_sales_store FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    CONSTRAINT chk_sales_quantity CHECK (quantity > 0),
    CONSTRAINT chk_sales_amounts CHECK (gross_amount >= 0 AND discount_amount >= 0 AND net_amount >= 0)
);
