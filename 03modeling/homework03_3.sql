-- Exercise 9.11 for Homework03.
--
-- CS 342, Spring, 2017
-- baa8

drop table Part_Order;
drop table Part;
drop table Customer_Order;
drop table Customer;
drop table Employee;

create table Employee(
	employee_number integer PRIMARY KEY,
	firstName varchar(20),
	lastName varchar(20),
	zipcode char(5)
	);

create table Customer(
	customer_number integer PRIMARY KEY,
	firstName varchar(20),
	lastName varchar(20),
	zipcode char(5)
	);
	
create table Customer_Order(
	order_number integer PRIMARY KEY,
	receipt_date date,
	expected_ship date NOT NULL,
	actual_ship date,
	employeeId integer,
	customerId integer,
	check (expected_ship > receipt_date),
	foreign key (employeeId) references Employee(employee_number) on delete set NULL,
	foreign key (customerId) references Customer(customer_number) on delete set NULL
	);
	
create table Part(
	part_number integer PRIMARY KEY,
	part_name varchar(30),
	price number,
	quantity integer
	);
	
create table Part_Order(
	partId integer,
	customer_orderId integer,
	quantity integer,
	check (quantity > 0)
	);

insert into Employee values (0, 'Molly', 'Hans', '45678');
insert into Employee values (1, 'George', 'Clooney', '49546');
insert into Employee values (2, 'Ruth', 'Chris', '49501');
insert into Employee values (3, 'Adam', 'Smith', '49001');


insert into Customer values (0, 'Bob', 'Marshall', '45678');
insert into Customer values (1, 'George', 'Malthus', '49546');
insert into Customer values (2, 'Richard', 'Smith', '49001');
insert into Customer values (3, 'Ruth', 'Chris', '49803');

insert into Customer_Order values (0, '26-Feb-2017', '01-Mar-2017', NULL, 1, 0);
insert into Customer_Order values (1, '05-Nov-2014', '14-Nov-2014', '13-Nov-2014', 3, 0);
insert into Customer_Order values (2, '15-Apr-2004', '20-Apr-2004', '21-Apr-2004', 2, 2);
insert into Customer_Order values (3, '07-Mar-2008', '09-Mar-2008', '09-Mar-2008', 0, 1);

insert into Part values (0, 'mirror', 20, 200);
insert into Part values (1, 'knob', 12, 300);
insert into Part values (2, 'surge strip', 15, 350);
insert into Part values (3, 'bulb', 10, 500);

insert into Part_Order values (0, 1, 2);
insert into Part_Order values (1, 1, 1);
insert into Part_Order values (3, 0, 5);
insert into Part_Order values (2, 2, 3);

	