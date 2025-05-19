/*
======================================================================================================
      INTERSECT
======================================================================================================
*/
SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;

/*
The first query finds all cities of the customers and the second query finds the cities of the stores. 
The whole query, which uses INTERSECT, returns the common cities of customers and stores, which are the cities output by both input queries.
Notice that we added the ORDER BY clause to the last query to sort the result set.
*/