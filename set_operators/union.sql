/*
======================================================================================================
      UNION
======================================================================================================
*/

/*The following example combines names of staff and customers into a single list:*/
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;

/*To include the duplicate row, you use the UNION ALL as shown in the following query:*/
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers;


/*To sort the result set returned by the UNION operator, you place the ORDER BY clause in the last query. 
For example, to sort the first names and last names of customers and staff, you use the following query:*/
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers
ORDER BY
    first_name,
    last_name;


