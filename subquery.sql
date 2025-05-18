/*
======================================================================================================
      Subquery
======================================================================================================
*/
/*
The following statement shows how to use a subquery in the WHERE clause of a 
SELECT statement to find the sales orders of the customers located in New York:
*/
SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;


/*
A subquery can be nested within another subquery. SQL Server supports up to 32 levels of nesting. Consider the following example:
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price;



/*
You can use a subquery in many places:

    In place of an expression
    With IN or NOT IN
    With ANY or ALL
    With EXISTS or NOT EXISTS
    In UPDATE, DELETE, orINSERT statement
    In the FROM clause
*/

/*
SQL Server subquery is used in place of an expression
If a subquery returns a single value, it can be used anywhere an expression is used.
In the following example, a subquery is used as a column expression named max_list_price in a SELECT statement.
*/
SELECT
    order_id,
    order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
FROM
    sales.orders o
order by order_date desc;


/*
SQL Server subquery is used with IN operator
A subquery that is used with the IN operator returns a set of zero or more values. After the subquery returns values, the outer query makes use of them.
The following query finds the names of all mountain bikes and road bikes products that the Bike Stores sell.
*/
SELECT
    product_id,
    product_name
FROM
    production.products
WHERE
    category_id IN (
        SELECT
            category_id
        FROM
            production.categories
        WHERE
            category_name = 'Mountain Bikes'
        OR category_name = 'Road Bikes'
    );



/*
Assuming that the subquery returns a list of value v1, v2, … vn. The ANY operator returns TRUE if one of a 
comparison pair (scalar_expression, vi) evaluates to TRUE;otherwise, it returns FALSE.
For example, the following query finds the products whose list prices are greater than or equal to the average list price of any product brand.
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ANY (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )


/*
The ALL operator returns TRUE if all comparison pairs (scalar_expression, vi) evaluate to TRUE; otherwise, it returns FALSE.
The following query finds the products whose list price is greater than or equal to the average list price returned by the subquery:
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ALL (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )


/*
The following query finds the customers who bought products in 2017:
*/
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;


/*
If you use the NOT EXISTS instead of EXISTS, you can find the customers who did not buy any products in 2017.
*/
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    NOT EXISTS (
        SELECT
            customer_id
        FROM
            sales.orders o
        WHERE
            o.customer_id = c.customer_id
        AND YEAR (order_date) = 2017
    )
ORDER BY
    first_name,
    last_name;



/*
Suppose that you want to find the average of the sum of orders of all sales staff. To do this, you can first find the number of orders by staff:
*/
SELECT 
   staff_id, 
   COUNT(order_id) order_count
FROM 
   sales.orders
GROUP BY 
   staff_id;

/*
Then, you can apply the AVG() function to this result set. Since a query returns a result set that looks 
like a virtual table, you can place the whole query in the FROM clause of another query like this:
*/
SELECT 
   AVG(order_count) average_order_count_by_staff
FROM
(
    SELECT 
	staff_id, 
        COUNT(order_id) order_count
    FROM 
	sales.orders
    GROUP BY 
	staff_id
) t;

/*
======================================================================================================
      Correlated Subquery
======================================================================================================
*/

/*
A correlated subquery is a subquery that uses the values of the outer query. In other words, 
the correlated subquery depends on the outer query for its values.
Because of this dependency, a correlated subquery cannot be executed independently as a simple subquery.
Moreover, a correlated subquery is executed repeatedly, once for each row evaluated by the outer query.
The correlated subquery is also known as a repeating subquery.
*/
/*The following example finds the products whose list price is equal to the highest list price of the products within the same category:*/
SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;
/*
In this example, for each product evaluated by the outer query, the subquery finds the highest price of all products in its category.
If the price of the current product is equal to the highest price of all products in its category, the product is included in the result set. 
This process continues for the next product and so on.
As you can see, the correlated subquery is executed once for each product evaluated by the outer query.
*/

/*
======================================================================================================
      EXISTS
======================================================================================================
*/
/*The following example returns all rows from the  customers table:*/
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    EXISTS (SELECT NULL)
ORDER BY
    first_name,
    last_name;
/*
In this example, the subquery returned a result set that contains NULL which causes the EXISTS operator to evaluate to TRUE. 
Therefore, the whole query returns all rows from the customers table.
*/

/*
The following example finds all customers who have placed more than two orders:
*/
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;

/*
EXISTS vs. IN example
The following statement uses the IN operator to find the orders of the customers from San Jose:
*/
SELECT
    *
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'San Jose'
    )
ORDER BY
    customer_id,
    order_date;

/*The following statement uses the EXISTS operator that returns the same result:*/
SELECT
    *
FROM
    sales.orders o
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sales.customers c
        WHERE
            o.customer_id = c.customer_id
        AND city = 'San Jose'
    )
ORDER BY
    o.customer_id,
    order_date;

/*
The EXISTS operator returns TRUE or FALSE while the JOIN clause returns rows from another table.
You use the EXISTS operator to test if a subquery returns any row and short circuits as soon as it does. 
On the other hand, you use JOIN to extend the result set by combining it with the columns from related tables.
In practice, you use the EXISTS when you need to check the existence of rows from related tables without returning data from them.
In this tutorial, you have learned how to use the SQL Server EXISTS operator to test if a subquery returns rows.
*/

/*
======================================================================================================
      ANY
======================================================================================================
*/
/*
The following example finds the products that were sold with more than two units in a sales order:
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;

/*
======================================================================================================
      ALL
======================================================================================================
*/
/*
The following query finds the products whose list prices are bigger than the average list price of products of all brands:
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;

/*
The following example finds the products whose list price is less than the smallest price in the average price list by brand:
*/
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price < ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price DESC;

/*
======================================================================================================
      CROSS APPLY
======================================================================================================
*/



