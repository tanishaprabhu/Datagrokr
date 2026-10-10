-- Sample data: 638 dates, 20 customers, 12 products, 5 stores, 5,000 sales rows
USE sql_dimensional_report;

INSERT INTO dim_date
(date_key, full_date, day_num, month_num, month_name, quarter_num, year_num, yr_month, day_name, is_weekend)
WITH RECURSIVE dates AS (
    SELECT DATE('2025-01-01') AS d
    UNION ALL
    SELECT DATE_ADD(d, INTERVAL 1 DAY) FROM dates WHERE d < DATE('2026-09-30')
)
SELECT
    CAST(DATE_FORMAT(d, '%Y%m%d') AS UNSIGNED),
    d, DAY(d), MONTH(d), MONTHNAME(d), QUARTER(d), YEAR(d),
    DATE_FORMAT(d, '%Y-%m'), DAYNAME(d),
    CASE WHEN DAYOFWEEK(d) IN (1, 7) THEN TRUE ELSE FALSE END
FROM dates;

INSERT INTO dim_customer (customer_id, customer_name, segment, city, state, region) VALUES
('C001','Aarav Sharma','Consumer','Bengaluru','Karnataka','South'),
('C002','Diya Patel','Consumer','Ahmedabad','Gujarat','West'),
('C003','Rohan Verma','Corporate','Delhi','Delhi','North'),
('C004','Ananya Iyer','Small Business','Chennai','Tamil Nadu','South'),
('C005','Ishaan Reddy','Consumer','Hyderabad','Telangana','South'),
('C006','Meera Nair','Corporate','Kochi','Kerala','South'),
('C007','Kabir Singh','Consumer','Jaipur','Rajasthan','North'),
('C008','Saanvi Gupta','Small Business','Lucknow','Uttar Pradesh','North'),
('C009','Arjun Das','Corporate','Kolkata','West Bengal','East'),
('C010','Ira Joshi','Consumer','Pune','Maharashtra','West'),
('C011','Vivaan Rao','Small Business','Mysuru','Karnataka','South'),
('C012','Aditi Kulkarni','Corporate','Mumbai','Maharashtra','West'),
('C013','Reyansh Mehta','Consumer','Surat','Gujarat','West'),
('C014','Myra Chatterjee','Consumer','Bhubaneswar','Odisha','East'),
('C015','Advait Kumar','Corporate','Patna','Bihar','East'),
('C016','Kiara Thomas','Small Business','Thiruvananthapuram','Kerala','South'),
('C017','Dhruv Jain','Consumer','Chandigarh','Chandigarh','North'),
('C018','Pari Banerjee','Corporate','Guwahati','Assam','East'),
('C019','Atharv Shah','Consumer','Vadodara','Gujarat','West'),
('C020','Navya Menon','Small Business','Coimbatore','Tamil Nadu','South');

INSERT INTO dim_product (product_id, product_name, category, subcategory, brand, unit_price) VALUES
('P001','Standing Desk','Furniture','Desks','WorkWell',450.00),
('P002','Ergonomic Office Chair','Furniture','Chairs','ComfortPro',320.00),
('P003','Monitor 27-inch','Electronics','Monitors','ViewMax',240.00),
('P004','USB-C Dock','Electronics','Accessories','ConnectIT',125.00),
('P005','Mechanical Keyboard','Electronics','Accessories','KeyWorks',95.00),
('P006','Wireless Mouse','Electronics','Accessories','KeyWorks',35.00),
('P007','Desk Lamp','Furniture','Lighting','BrightSpace',48.00),
('P008','Filing Cabinet','Furniture','Storage','WorkWell',180.00),
('P009','Noise-Cancelling Headset','Electronics','Audio','SoundNest',150.00),
('P010','Webcam HD','Electronics','Cameras','ViewMax',72.00),
('P011','Laptop Stand','Accessories','Ergonomics','ComfortPro',42.00),
('P012','Notebook Pack','Office Supplies','Paper','WriteRight',18.00);

INSERT INTO dim_store (store_id, store_name, channel, city, state, region) VALUES
('S001','Bengaluru Flagship','Retail','Bengaluru','Karnataka','South'),
('S002','Mumbai Online Hub','Online','Mumbai','Maharashtra','West'),
('S003','Delhi Business Store','Retail','Delhi','Delhi','North'),
('S004','Hyderabad Partner','Partner','Hyderabad','Telangana','South'),
('S005','Kolkata Online Hub','Online','Kolkata','West Bengal','East');

-- Deterministic sample sales generated from cross-joined number sequences.
-- Price and discount rules are deterministic; Standing Desk has the highest total revenue.
INSERT INTO fact_sales
(date_key, customer_key, product_key, store_key, order_id, line_number,
 quantity, gross_amount, discount_amount, net_amount)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL SELECT n + 1 FROM seq WHERE n < 5000
),
sales_source AS (
    SELECT
        n,
        DATE_ADD('2025-01-01', INTERVAL MOD(n * 37, 638) DAY) AS sale_date,
        CASE
            WHEN MOD(n, 5) = 0 THEN 1
            WHEN MOD(n, 5) = 1 THEN 2
            ELSE 3 + MOD(n * 7, 10)
        END AS product_key,
        1 + MOD(n * 13, 20) AS customer_key,
        1 + MOD(n * 3, 5) AS store_key,
        1 + MOD(n, 4) AS quantity
    FROM seq
),
priced AS (
    SELECT ss.*,
        p.unit_price,
        ROUND(ss.quantity * p.unit_price, 2) AS gross
    FROM sales_source ss
    JOIN dim_product p ON p.product_key = ss.product_key
)
SELECT
    CAST(DATE_FORMAT(sale_date, '%Y%m%d') AS UNSIGNED),
    customer_key, product_key, store_key,
    CONCAT('ORD', LPAD(FLOOR((n - 1) / 2) + 1, 6, '0')),
    MOD(n - 1, 2) + 1,
    quantity,
    gross,
    ROUND(gross * CASE WHEN MOD(n, 5) = 0 THEN 0.05 WHEN MOD(n, 7) = 0 THEN 0.10 ELSE 0 END, 2),
    ROUND(gross - gross * CASE WHEN MOD(n, 5) = 0 THEN 0.05 WHEN MOD(n, 7) = 0 THEN 0.10 ELSE 0 END, 2)
FROM priced;
