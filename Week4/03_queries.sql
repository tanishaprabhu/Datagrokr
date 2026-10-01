-- 03_queries.sql
-- E-commerce SQL analysis: 35+ practice queries (MySQL)

USE ecommerce_db;

-- 1. Display all customers
SELECT * FROM customers;

-- 2. Display products from highest to lowest price
SELECT * FROM products ORDER BY price DESC;

-- 3. Find products priced above 1000
SELECT product_name, price FROM products WHERE price > 1000;

-- 4. Count customers
SELECT COUNT(*) AS total_customers FROM customers;

-- 5. Count products in each category
SELECT category, COUNT(*) AS product_count
FROM products GROUP BY category;

-- 6. Average product price by category
SELECT category, ROUND(AVG(price), 2) AS average_price
FROM products GROUP BY category;

-- 7. Find the most expensive product
SELECT product_name, price FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- 8. Find the least expensive product
SELECT product_name, price FROM products
WHERE price = (SELECT MIN(price) FROM products);

-- 9. List customers from Bengaluru
SELECT * FROM customers WHERE city = 'Bengaluru';

-- 10. Find customers whose city is missing
SELECT * FROM customers WHERE city IS NULL;

-- 11. Replace missing city values in query output
SELECT customer_id, first_name, COALESCE(city, 'Not provided') AS city
FROM customers;

-- 12. Show orders with customer names
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.status
FROM orders o JOIN customers c ON o.customer_id = c.customer_id;

-- 13. Show order items with product names
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price
FROM order_items oi JOIN products p ON oi.product_id = p.product_id;

-- 14. Calculate each order's total
SELECT order_id, SUM(quantity * unit_price) AS order_total
FROM order_items GROUP BY order_id;

-- 15. Calculate total revenue from non-cancelled orders
SELECT SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled';

-- 16. Find total spending by each customer
SELECT c.customer_id, c.first_name, c.last_name,
       COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status IS NULL OR o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 17. Find the top-selling products by quantity
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC;

-- 18. Find revenue by product
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS product_revenue
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC;

-- 19. Find revenue by category
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.category ORDER BY category_revenue DESC;

-- 20. Count orders by status
SELECT status, COUNT(*) AS order_count FROM orders GROUP BY status;

-- 21. Find customers with more than one order
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1;

-- 22. Find products with stock below 30
SELECT product_name, stock FROM products WHERE stock < 30;

-- 23. Find orders placed in May 2025
SELECT * FROM orders
WHERE order_date >= '2025-05-01' AND order_date < '2025-06-01';

-- 24. Find the latest order date
SELECT MAX(order_date) AS latest_order FROM orders;

-- 25. Find orders with a total above 1500
SELECT order_id, SUM(quantity * unit_price) AS order_total
FROM order_items GROUP BY order_id
HAVING SUM(quantity * unit_price) > 1500;

-- 26. Use a subquery to find products above average price
SELECT product_name, price FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 27. Find products that have never been ordered
SELECT p.product_id, p.product_name
FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 28. Find customers who have not placed any orders
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 29. Show each customer's number of orders
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS order_count
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 30. Find the total quantity sold per category
SELECT p.category, SUM(oi.quantity) AS units_sold
FROM products p JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.category;

-- 31. Find customers who spent more than 2000
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.unit_price) > 2000;

-- 32. Use CASE to label product price ranges
SELECT product_name, price,
       CASE WHEN price >= 1500 THEN 'High'
            WHEN price >= 500 THEN 'Medium'
            ELSE 'Low' END AS price_range
FROM products;

-- 33. Find the number of distinct cities provided
SELECT COUNT(DISTINCT city) AS distinct_cities FROM customers;

-- 34. Show order items with extended line totals
SELECT order_id, product_id, quantity, unit_price,
       quantity * unit_price AS line_total
FROM order_items;

-- 35. Find the second-highest product price
SELECT MAX(price) AS second_highest_price
FROM products WHERE price < (SELECT MAX(price) FROM products);

-- 36. Find average order value for non-cancelled orders
SELECT AVG(order_total) AS average_order_value
FROM (
    SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status <> 'Cancelled'
    GROUP BY o.order_id
) totals;

-- 37. Update a product's stock (example; run only if desired)
-- UPDATE products SET stock = stock - 1 WHERE product_id = 1;

-- 38. Demonstrate a safe delete preview (no rows are deleted)
SELECT * FROM orders WHERE status = 'Cancelled';

-- 39. Create a view for product sales
CREATE OR REPLACE VIEW product_sales AS
SELECT p.product_id, p.product_name,
       COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                         THEN oi.quantity ELSE 0 END), 0) AS units_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.product_id, p.product_name;

-- 40. Read the product sales view
SELECT * FROM product_sales ORDER BY units_sold DESC;
