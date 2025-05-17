/*
======================================================================================================
      Inner Join  
======================================================================================================
*/

SELECT product_name, category_name, list_price FROM production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
ORDER BY product_name DESC;

SELECT product_name, category_name, brand_name, list_price
FROM production.products p INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id ORDER BY product_name DESC;

/*
======================================================================================================
      Left Join  
======================================================================================================
*/
SELECT product_name, order_id FROM production.products p LEFT JOIN 
sales.order_items o ON o.product_id = p.product_id ORDER BY order_id;

SELECT product_name, order_id FROM production.products p LEFT JOIN 
sales.order_items o ON o.product_id = p.product_id WHERE order_id IS NULL

SELECT p.product_name, o.order_id, i.item_id, o.order_date
FROM production.products p LEFT JOIN sales.order_items i ON i.product_id = p.product_id
LEFT JOIN sales.orders o ON o.order_id = i.order_id ORDER BY order_id;

SELECT product_name, order_id FROM production.products p LEFT JOIN sales.order_items o 
ON o.product_id = p.product_id WHERE order_id = 100 ORDER BY order_id;

SELECT p.product_id, product_name, order_id FROM production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id AND o.order_id = 100
ORDER BY order_id DESC;

/*
======================================================================================================
      Right Join  
======================================================================================================
*/
SELECT product_name, order_id FROM sales.order_items o RIGHT JOIN production.products p 
ON o.product_id = p.product_id ORDER BY order_id;

SELECT product_name, order_id FROM sales.order_items o RIGHT JOIN production.products p 
ON o.product_id = p.product_id WHERE order_id IS NULL ORDER BY product_name;

/*
======================================================================================================
      Full Outer Join  
======================================================================================================
*/
CREATE SCHEMA pm;
GO

CREATE TABLE pm.projects(
    id INT PRIMARY KEY IDENTITY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE pm.members(
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(120) NOT NULL,
    project_id INT,
    FOREIGN KEY (project_id) 
        REFERENCES pm.projects(id)
);

INSERT INTO 
    pm.projects(title)
VALUES
    ('New CRM for Project Sales'),
    ('ERP Implementation'),
    ('Develop Mobile Sales Platform');


INSERT INTO
    pm.members(name, project_id)
VALUES
    ('John Doe', 1),
    ('Lily Bush', 1),
    ('Jane Doe', 2),
    ('Jack Daniel', null);

SELECT m.name member, p.title project FROM pm.members m
FULL OUTER JOIN pm.projects p ON p.id = m.project_id;

SELECT m.name member, p.title project FROM pm.members m FULL OUTER JOIN pm.projects p 
ON p.id = m.project_id WHERE m.id IS NULL OR P.id IS NULL;

/*
======================================================================================================
      Cross Join  
======================================================================================================
*/
SELECT product_id, product_name, store_id, 0 AS quantity FROM production.products
CROSS JOIN sales.stores ORDER BY product_name, store_id;

/*
======================================================================================================
      Self Join  
======================================================================================================
*/
SELECT e.first_name + ' ' + e.last_name employee, m.first_name + ' ' + m.last_name manager
FROM sales.staffs e INNER JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY manager;

SELECT e.first_name + ' ' + e.last_name employee, m.first_name + ' ' + m.last_name manager
FROM sales.staffs e LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY manager;