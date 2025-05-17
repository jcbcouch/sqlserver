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
