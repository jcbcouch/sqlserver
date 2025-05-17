/*
======================================================================================================
      GROUP BY 
======================================================================================================
*/

SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
ORDER BY
    customer_id;
/*
In this example, we retrieve the customer id and the ordered year of the customers with customer id 1 and 2.
The output indicates that the customer with id 1 placed one order in 2016 and two orders in 2018. 
The customer id 2 placed two orders in 2017 and one order in 2018.
*/


SELECT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;
/*
The GROUP BY clause arranged the first three rows into two groups and the next three rows into the other two groups with the unique 
combinations of the customer id and order year. Functionally speaking, the GROUP BY clause in the above query produced the same result 
as the following query that uses the DISTINCT clause:
*/

SELECT DISTINCT
    customer_id,
    YEAR (order_date) order_year
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
ORDER BY
    customer_id;


/*
The GROUP BY clause arranges rows into groups and an aggregate function returns the summary (count, min, max, average, sum, etc.,) for each group.
For example, the following query returns the number of orders placed by the customer by year:
*/
SELECT
    customer_id,
    YEAR (order_date) order_year,
    COUNT (order_id) order_placed
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id; 

/*
If you want to reference a column or expression that is not listed in the GROUP BY clause, you must use that column 
as the input of an aggregate function. Otherwise, you will get an error because there is no guarantee that the column 
or expression will return a single value per group. For example, the following query will fail:
*/
SELECT
    customer_id,
    YEAR (order_date) order_year,
    order_status
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;



/*
The following query returns the number of customers in every city:
*/
SELECT
    city,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    city
ORDER BY
    city;


/*
The following query returns the number of customers by state and city.
*/
SELECT
    city,
    state,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    state,
    city
ORDER BY
    city,
    state;



/*
The following statement returns the minimum and maximum list prices of all products with the model 2018 by brand:
*/
SELECT
    brand_name,
    MIN (list_price) min_price,
    MAX (list_price) max_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;


/*
The following statement uses the AVG() function to return the average list price by brand for all products with the model year 2018:
*/
SELECT
    brand_name,
    AVG (list_price) avg_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;

/*
The following query uses the SUM() function to get the net value of every order:
*/
SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) net_value
FROM
    sales.order_items
GROUP BY
    order_id;


/*
======================================================================================================
      Having
======================================================================================================
*/

/*
The following statement uses the HAVING clause to find the customers who placed at least two orders per year:
*/
SELECT
    customer_id,
    YEAR (order_date),
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;


/*
The following statement finds the sales orders whose net values are greater than 20,000:
*/
SELECT
    order_id,
    SUM (
        quantity * list_price * (1 - discount)
    ) net_value
FROM
    sales.order_items
GROUP BY
    order_id
HAVING
    SUM (
        quantity * list_price * (1 - discount)
    ) > 20000
ORDER BY
    net_value;



/*
The following statement first finds the maximum and minimum list prices in each product category. 
Then, it filters out the category which has a maximum list price greater than 4,000 or a minimum list price less than 500:
*/
SELECT
    category_id,
    MAX (list_price) max_list_price,
    MIN (list_price) min_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    MAX (list_price) > 4000 OR MIN (list_price) < 500;


/*
The following statement finds product categories whose average list prices are between 500 and 1,000:
*/
SELECT
    category_id,
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    AVG (list_price) BETWEEN 500 AND 1000;


/*
======================================================================================================
      GROUPING SETS
======================================================================================================
*/

/*Let’s create a new table named sales.sales_summary for the demonstration.*/
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;



SELECT
	brand,
	category,
	SUM (sales) sales
FROM
	sales.sales_summary
GROUP BY
	GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
	)
ORDER BY
	brand,
	category;

/*
The GROUPING function indicates whether a specified column in a GROUP BY clause is aggregated or not. 
It returns 1 for aggregated or 0 for not aggregated in the result set.
*/
SELECT
    GROUPING(brand) grouping_brand,
    GROUPING(category) grouping_category,
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    GROUPING SETS (
        (brand, category),
        (brand),
        (category),
        ()
    )
ORDER BY
    brand,
    category;

/*
======================================================================================================
      CUBE
======================================================================================================
*/


/*
The following statement uses the CUBE to generate four grouping sets:

    (brand, category)
    (brand)
    (category)
    ()
*/

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    CUBE(brand, category);


/*
The following example illustrates how to perform a partial CUBE to reduce the number of grouping sets generated by the query:
*/
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    CUBE(category);

/*
======================================================================================================
      ROLLUP
======================================================================================================
*/

/*
The following query uses the ROLLUP to calculate the sales amount by brand (subtotal) and both brand and category (total).
*/
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP(brand, category);


/*
Note that if you change the order of brand and category, the result will be different as shown in the following query:
*/
SELECT
    category,
    brand,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP (category, brand);

/*
The following statement shows how to perform a partial roll-up:
*/
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    brand,
    ROLLUP (category);