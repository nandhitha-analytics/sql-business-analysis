-- Use the database
USE classicmodels;

-- 1. Sales Representatives reporting to a specific manager
SELECT employeenumber, firstname, lastname
FROM employees
WHERE jobtitle = 'Sales Rep'
AND reportsTo = 1102;

-- 2. Product lines ending with 'Cars'
SELECT DISTINCT productline
FROM products
WHERE productline LIKE '%Cars';

-- 3. Customer segmentation by region
SELECT customerNumber, customerName,
CASE 
    WHEN country IN ('USA','Canada') THEN 'North America'
    WHEN country IN ('UK','France','Germany') THEN 'Europe'
    ELSE 'Other'
END AS customer_segment
FROM customers;

-- 4. Top 10 products by quantity ordered
SELECT productCode, SUM(quantityOrdered) AS total_quantity
FROM orderdetails
GROUP BY productCode
ORDER BY total_quantity DESC
LIMIT 10;

-- 5. Monthly payment trends (correct chronological order)
SELECT MONTH(paymentDate) AS month_num,
       MONTHNAME(paymentDate) AS month_name,
       COUNT(*) AS num_payments
FROM payments
GROUP BY MONTH(paymentDate), MONTHNAME(paymentDate)
HAVING COUNT(*) > 20
ORDER BY month_num;

-- 6. Analyze number of orders per country (JOIN)
SELECT c.country, COUNT(o.orderNumber) AS order_count
FROM customers c
JOIN orders o
ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY order_count DESC;

-- 7. Rank customers based on order frequency (Window Function)
SELECT c.customerName,
COUNT(o.orderNumber) AS order_count,
DENSE_RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS customer_rank
FROM customers c
JOIN orders o
ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;

-- 8. High-value product lines (Subquery)
SELECT productLine, COUNT(*) AS total_products
FROM products
WHERE buyPrice > (
    SELECT AVG(buyPrice) FROM products
)
GROUP BY productLine;
