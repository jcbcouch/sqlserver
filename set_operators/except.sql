/*
======================================================================================================
      EXCEPT
======================================================================================================
*/
/*The following example uses the EXCEPT operator to find the products that have no sales:*/
SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;

/*
To sort the result set created by the EXCEPT operator, you add the ORDER BY clause in the last query. 
For example, the following example finds the products that had no sales and sorts the products by their id in ascending order:
*/
SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items
ORDER BY 
	product_id;