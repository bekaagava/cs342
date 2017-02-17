-- This command file loads a simple order-processing database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2017
-- baa8

/* Exercise 5.14 
- For all the ON DELETES, the database specifies to set the foreign keys to NULL because there are instances where for example a customer
no longer exists, but the customer's order will still be factored into a yearly summation of the dollar amounts for all orders. Similar 
situations exists for all the other foreign keys. 
- Primary key values are set to "NOT NULL" to make it impossible to have foreign key values that are NULL because that would cause problems 
with obtaining and delivering the correct shipments.
- In order for the shipping processes to function properly, the city fields can never be NULL, otherwise the shipment might not be retrievable from a
warehouse or the order cannot be shipped to the customer.
- The customer name should also not be NULL because there is already limited information for identifying the customer and 
where the order needs to go to. I would suggest adding a more specific address to the CUSTOMER table.
- The quatity of the ORDER_ITEM should not be zero because if it is, then that row in the table is unnecessary.
*/


-- Drop current database
DROP TABLE SHIPMENT;
DROP TABLE WAREHOUSE;
DROP TABLE ORDER_ITEM;
DROP TABLE ITEM;
DROP TABLE CUSTOMER_ORDER;
DROP TABLE CUSTOMER;


-- Create database schema
CREATE TABLE CUSTOMER (
	id integer NOT NULL,
	customer_name varchar(50) NOT NULL, 
	city varchar(30) NOT NULL, 
	PRIMARY KEY (id)
	);
	
CREATE TABLE CUSTOMER_ORDER (
	id integer NOT NULL,
	order_date DATE,
	customer_Id integer,
	order_amount NUMBER,
	PRIMARY KEY (id),
	FOREIGN KEY (customer_Id) REFERENCES CUSTOMER(Id) ON DELETE SET NULL
	);
	
CREATE TABLE ITEM (
	id integer NOT NULL,
	item_name varchar(70),
	unit_price NUMBER,
	PRIMARY KEY (id)
	);
	
CREATE TABLE ORDER_ITEM (
	order_Id integer,
	item_Id integer,
	quantity integer,
	FOREIGN KEY (order_Id) REFERENCES CUSTOMER_ORDER(Id) ON DELETE SET NULL,
	FOREIGN KEY (item_Id) REFERENCES ITEM(Id) ON DELETE SET NULL,
	CHECK (quantity > 0)
	);

CREATE TABLE WAREHOUSE (
	id integer NOT NULL,
	city varchar(30) NOT NULL,
	PRIMARY KEY (id)
	);
	
CREATE TABLE SHIPMENT (
	order_Id integer,
	warehouse_Id integer,
	ship_date DATE,
	FOREIGN KEY (order_Id) REFERENCES CUSTOMER_ORDER(Id) ON DELETE SET NULL,
	FOREIGN KEY (warehouse_Id) REFERENCES WAREHOUSE(Id) ON DELETE SET NULL
	);
	
-- Load sample data
INSERT INTO CUSTOMER VALUES (1,'Samuel Jackson', 'San Jose');
INSERT INTO CUSTOMER VALUES (2, 'Ben Brown', 'Grand Rapids');
INSERT INTO CUSTOMER VALUES (3, 'Sophia VerBeek', 'Detroit');
INSERT INTO CUSTOMER VALUES (4, 'Frankie Vargas', 'Washington DC');
INSERT INTO CUSTOMER VALUES (5, 'Kanye West', 'New York');

INSERT INTO CUSTOMER_ORDER VALUES (1, '01-JAN-2014', 2, 279.15);
INSERT INTO CUSTOMER_ORDER VALUES (2, '20-NOV-2014', 2, 500);
INSERT INTO CUSTOMER_ORDER VALUES (3, '12-DEC-2012', 1, 32);
INSERT INTO CUSTOMER_ORDER VALUES (4, '03-APR-2017', 5, 10000);
INSERT INTO CUSTOMER_ORDER VALUES (5, '02-MAR-2004', 4, 10);

INSERT INTO ITEM VALUES (1, 'colgate toothbrush', 2.99);
INSERT INTO ITEM VALUES (2, 'bicycle', 500);
INSERT INTO ITEM VALUES (3, 'secret la la lavendar deodorant', 5);
INSERT INTO ITEM VALUES (4, 'crest toothpaste', 4);
INSERT INTO ITEM VALUES (5, 'olay body lotion', 7.99);

INSERT INTO ORDER_ITEM VALUES (1, 5, 5);
INSERT INTO ORDER_ITEM VALUES (1, 1, 80);
INSERT INTO ORDER_ITEM VALUES (2, 2, 1);
INSERT INTO ORDER_ITEM VALUES (3, 4, 8);
INSERT INTO ORDER_ITEM VALUES (4, 3, 100);
INSERT INTO ORDER_ITEM VALUES (4, 2, 19);
INSERT INTO ORDER_ITEM VALUES (5, 3, 2);

INSERT INTO WAREHOUSE VALUES (1, 'New Orleans');
INSERT INTO WAREHOUSE VALUES (2, 'Houston');
INSERT INTO WAREHOUSE VALUES (3, 'Dallas');
INSERT INTO WAREHOUSE VALUES (4, 'Austin');
INSERT INTO WAREHOUSE VALUES (5, 'Lansing');

INSERT INTO SHIPMENT VALUES (1, 1, '03-JAN-2014');
INSERT INTO SHIPMENT VALUES (1, 5, '02-JAN-2014');
INSERT INTO SHIPMENT VALUES (2, 4, '23-NOV-2014');
INSERT INTO SHIPMENT VALUES (3, 5, '13-DEC-2012');
INSERT INTO SHIPMENT VALUES (5, 3, '03-MAR-2004');

/* 2. I would suggest that CIT sticks to using surrogate keys because for natural keys, the definition of that 'real-world' attribute
that provides the natural key could change, meaning that CIT would have to rework its keys and change foreign keys in all referencing
tables as well. Basically, since natural keys are unique to the business concept for the data (information related to a student), 
and business concepts are susceptible to change it would better to use surrogate keys. 

/* 3a. all the order dates and amounts for orders made by a customer with a particular name, 
ordered chronologically by date
*/
SELECT order_date, order_amount FROM CUSTOMER_ORDER 
JOIN CUSTOMER ON CUSTOMER_ORDER.customer_Id = CUSTOMER.id
WHERE CUSTOMER.customer_name = 'Ben Brown'
ORDER BY order_date ASC;

-- 3b. all the customer ID numbers for customers who have at least one order in the database 
SELECT DISTINCT customer_Id FROM CUSTOMER_ORDER;

-- 3c. the customer IDs and names of the people who have ordered an item with a particular name
SELECT CUSTOMER.id, CUSTOMER.customer_name FROM CUSTOMER
JOIN CUSTOMER_ORDER ON CUSTOMER.id = CUSTOMER_ORDER.customer_Id
JOIN ORDER_ITEM ON CUSTOMER_ORDER.id = ORDER_ITEM.order_Id
JOIN ITEM ON ITEM.id = ORDER_ITEM.item_Id
WHERE ITEM.item_name = 'secret la la lavendar deodorant';

-- Find solutions to No. 4 in lab02_2.sql and lab02_3.sql

