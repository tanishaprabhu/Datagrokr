-- 02_seed_data.sql
-- Sample records for the e-commerce database (MySQL)

USE ecommerce_db;

INSERT INTO customers (first_name, last_name, email, city, signup_date) VALUES
('Aarav', 'Sharma', 'aarav@example.com', 'Bengaluru', '2025-01-10'),
('Diya', 'Patel', 'diya@example.com', 'Mumbai', '2025-02-14'),
('Rohan', 'Rao', 'rohan@example.com', 'Chennai', '2025-03-02'),
('Meera', 'Nair', 'meera@example.com', NULL, '2025-03-18'),
('Kabir', 'Singh', 'kabir@example.com', 'Delhi', '2025-04-05'),
('Ananya', 'Das', 'ananya@example.com', 'Kolkata', '2025-04-22');

INSERT INTO products (product_name, category, price, stock) VALUES
('Wireless Mouse', 'Electronics', 799.00, 45),
('Keyboard', 'Electronics', 1499.00, 30),
('Water Bottle', 'Lifestyle', 399.00, 80),
('Notebook Set', 'Stationery', 249.00, 100),
('USB-C Hub', 'Electronics', 2199.00, 20),
('Backpack', 'Lifestyle', 1299.00, 25),
('Desk Lamp', 'Home', 999.00, 18),
('Pen Pack', 'Stationery', 149.00, 120);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-05-01', 'Delivered'),
(2, '2025-05-03', 'Delivered'),
(1, '2025-05-12', 'Shipped'),
(3, '2025-05-15', 'Delivered'),
(4, '2025-05-20', 'Pending'),
(5, '2025-05-25', 'Delivered'),
(6, '2025-06-02', 'Cancelled'),
(2, '2025-06-08', 'Delivered');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 799.00),
(1, 4, 3, 249.00),
(2, 2, 1, 1499.00),
(2, 3, 2, 399.00),
(3, 5, 1, 2199.00),
(3, 1, 1, 799.00),
(4, 6, 1, 1299.00),
(4, 8, 2, 149.00),
(5, 7, 1, 999.00),
(6, 2, 1, 1499.00),
(6, 3, 1, 399.00),
(7, 4, 4, 249.00),
(8, 5, 1, 2199.00),
(8, 6, 1, 1299.00);
