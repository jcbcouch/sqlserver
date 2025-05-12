SELECT first_name, last_name, email FROM sales.customers;

SELECT * FROM sales.customers;

SELECT city, COUNT (*) FROM sales.customers WHERE state = 'CA' GROUP BY city ORDER BY city;

SELECT city, COUNT (*) FROM sales.customers WHERE state = 'CA' GROUP BY city HAVING COUNT (*) > 10 ORDER BY city;

/* ORDER BY  */
SELECT first_name, last_name FROM sales.customers ORDER BY first_name;

SELECT first_name, last_name FROM sales.customers ORDER BY first_name ASC;

SELECT first_name, last_name FROM sales.customers ORDER BY first_name DESC;

SELECT city, first_name, last_name FROM sales.customers ORDER BY city, first_name;

SELECT city, first_name, last_name FROM sales.customers ORDER BY city DESC, first_name ASC;

SELECT city, first_name, last_name FROM sales.customers ORDER BY state;

SELECT first_name, last_name FROM sales.customers ORDER BY LEN(first_name) DESC;

SELECT first_name, last_name FROM sales.customers ORDER BY 1, 2;

/* Limiting rows  */
/* OFFSET FETCH  */
SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS;

SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

SELECT product_name, list_price FROM production.products ORDER BY list_price, product_name OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
/* SELECT TOP  */
SELECT TOP 10 product_name, list_price FROM production.products ORDER BY list_price DESC;

SELECT TOP 1 PERCENT product_name, list_price FROM production.products ORDER BY list_price DESC;

SELECT TOP 3 WITH TIES product_name, list_price FROM production.products ORDER BY list_price DESC;

/* Filtering data  */
/* DISTINCT  */
SELECT DISTINCT city FROM sales.customers ORDER BY city;

SELECT DISTINCT city, state FROM sales.customers;

SELECT DISTINCT phone FROM sales.customers ORDER BY phone;

SELECT city, state, zip_code FROM sales.customers GROUP BY city, state, zip_code ORDER BY city, state, zip_code;

SELECT DISTINCT city, state, zip_code FROM sales.customers;
/* WHERE Clause  */
SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE category_id = 1 ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE category_id = 1 AND model_year = 2018
ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price > 300 AND model_year = 2018
ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price > 3000 OR model_year = 2018
ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price BETWEEN 1899.00 AND 1999.99
ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE list_price IN (299.99, 369.99, 489.99)
ORDER BY list_price DESC;

SELECT product_id, product_name, category_id, model_year, list_price FROM production.products WHERE product_name LIKE '%Cruiser%'
ORDER BY list_price;
/* AND Operator  */
SELECT * FROM production.products WHERE category_id = 1 AND list_price > 400 ORDER BY list_price DESC;

SELECT * FROM production.products WHERE category_id = 1 AND list_price > 400 AND brand_id = 1 ORDER BY list_price DESC;

SELECT * FROM production.products WHERE brand_id = 1 OR brand_id = 2 AND list_price > 1000 ORDER BY brand_id DESC;

SELECT * FROM production.products WHERE (brand_id = 1 OR brand_id = 2) AND list_price > 1000 ORDER BY brand_id;
/* OR Operator  */
SELECT product_name, list_price FROM production.products WHERE list_price < 200 OR list_price > 6000 ORDER BY list_price;

SELECT product_name, brand_id FROM production.products WHERE brand_id = 1 OR brand_id = 2 OR brand_id = 4 ORDER BY brand_id DESC;

SELECT product_name, brand_id FROM production.products WHERE brand_id IN (1, 2, 3) ORDER BY brand_id DESC;

SELECT product_name, brand_id, list_price FROM production.products WHERE brand_id = 1 OR brand_id = 2 AND list_price > 500
ORDER BY brand_id DESC, list_price;

SELECT product_name, brand_id, list_price FROM production.products WHERE (brand_id = 1 OR brand_id = 2) AND list_price > 500
ORDER BY brand_id;
/* IN Operator  */
SELECT product_name, list_price FROM production.products WHERE list_price IN (89.99, 109.99, 159.99)
ORDER BY list_price;

SELECT product_name, list_price FROM production.products WHERE list_price NOT IN (89.99, 109.99, 159.99)
ORDER BY list_price;

SELECT product_name, list_price FROM production.products WHERE product_id IN (
SELECT product_id FROM production.stocks WHERE store_id = 1 AND quantity >= 30) ORDER BY product_name;

/* BETWEEN Operator  */
SELECT product_id, product_name, list_price FROM production.products WHERE
list_price BETWEEN 149.99 AND 199.99 ORDER BY list_price;

SELECT product_id, product_name, list_price FROM production.products WHERE
list_price NOT BETWEEN 149.99 AND 199.99 ORDER BY list_price;

SELECT order_id, customer_id, order_date, order_status FROM sales.orders 
WHERE order_date BETWEEN '20170115' AND '20170117' ORDER BY order_date;

/* LIKE Operator  */
SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE 'z%'
ORDER BY first_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE '%er'
ORDER BY first_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE 't%s'
ORDER BY first_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE '_u%'
ORDER BY first_name; 

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE '[YZ]%'
ORDER BY last_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE '[A-C]%'
ORDER BY first_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE last_name LIKE '[^A-X]%'
ORDER BY last_name;

SELECT customer_id, first_name, last_name FROM sales.customers WHERE first_name NOT LIKE 'A%'
ORDER BY first_name;

/* Alias  */

