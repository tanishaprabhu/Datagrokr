-- Seed data for the E-Commerce Sales Analytics project
USE ecommerce_analytics;

INSERT INTO dim_date
(date_key, full_date, day_of_month, month_number, month_name, quarter_number, year_number)
VALUES
(20260105,'2026-01-05',5,1,'January',1,2026),
(20260112,'2026-01-12',12,1,'January',1,2026),
(20260120,'2026-01-20',20,1,'January',1,2026),
(20260203,'2026-02-03',3,2,'February',1,2026),
(20260214,'2026-02-14',14,2,'February',1,2026),
(20260225,'2026-02-25',25,2,'February',1,2026),
(20260304,'2026-03-04',4,3,'March',1,2026),
(20260316,'2026-03-16',16,3,'March',1,2026),
(20260328,'2026-03-28',28,3,'March',1,2026),
(20260406,'2026-04-06',6,4,'April',2,2026),
(20260419,'2026-04-19',19,4,'April',2,2026);

INSERT INTO dim_customer
(customer_id, customer_name, city, state_name, customer_segment)
VALUES
('C001','Aarav Rao','Bengaluru','Karnataka','Regular'),
('C002','Meera Nair','Mangaluru','Karnataka','Premium'),
('C003','Ishaan Shah','Mumbai','Maharashtra','Regular'),
('C004','Ananya Das','Kolkata','West Bengal','Premium'),
('C005','Kabir Singh','Pune','Maharashtra','New');

INSERT INTO dim_product
(product_id, product_name, category, brand, unit_price)
VALUES
('P001','Wireless Mouse','Accessories','LogiTech',799.00),
('P002','Mechanical Keyboard','Accessories','KeyPro',2499.00),
('P003','USB-C Hub','Accessories','ConnectX',1499.00),
('P004','Laptop Stand','Office','ErgoDesk',1199.00),
('P005','27-inch Monitor','Electronics','ViewMax',14999.00),
('P006','Noise-Cancelling Headphones','Electronics','SoundWave',5999.00);

INSERT INTO fact_sales
(order_id, date_key, customer_key, product_key, quantity, unit_price, discount_amount)
VALUES
('ORD1001',20260105,1,1,2,799.00,100.00),
('ORD1002',20260112,2,2,1,2499.00,0.00),
('ORD1003',20260120,3,5,1,14999.00,500.00),
('ORD1004',20260203,1,3,2,1499.00,100.00),
('ORD1005',20260214,4,6,1,5999.00,300.00),
('ORD1006',20260225,5,1,3,799.00,0.00),
('ORD1007',20260304,2,5,2,14999.00,1000.00),
('ORD1008',20260316,3,4,2,1199.00,100.00),
('ORD1009',20260328,4,2,2,2499.00,200.00),
('ORD1010',20260406,1,6,1,5999.00,0.00),
('ORD1011',20260419,5,3,3,1499.00,150.00),
('ORD1012',20260419,2,1,1,799.00,0.00);
