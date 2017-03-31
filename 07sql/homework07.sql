-- CS 342 
-- Beka Agava
-- Homework 07

--Exercise 1
DROP VIEW EMP_DEPT;

CREATE VIEW EMP_DEPT 
AS SELECT e.employee_id, e.first_name, e.last_name, e.email, e.hire_date, d.department_name
FROM EMPLOYEES e 
JOIN DEPARTMENTS d ON e.department_id = d.department_id;

-- Exercise 1.a
SELECT * FROM
(
SELECT first_name, last_name, employee_id
FROM EMP_DEPT
WHERE department_name = 'Executive'
ORDER BY hire_date DESC
)
WHERE ROWNUM = 1;

-- Exercise 1.b
UPDATE EMP_DEPT
SET department_name = 'Bean Counting'
WHERE department_name = 'Administration';

/* This query does not work because we cannot modify a column which 
maps to a non key-preserved table - departments is not key preserved in the emp_dept view*/

-- Exercise 1.c
UPDATE EMP_DEPT
SET first_name = 'Manuel'
WHERE first_name = 'Jose Manuel';

-- Exercise 1.d
INSERT INTO EMP_DEPT VALUES(207, 'Paige', 'Brinks', 'pbrinks', '08-MAR-09', 'Shipping');
/* 
This does not work because the modification affects multiple base tables
*/

-- Exercise 2
DROP MATERIALIZED VIEW MAT_EMP_DEPT;

CREATE MATERIALIZED VIEW MAT_EMP_DEPT 
AS SELECT e.employee_id, e.first_name, e.last_name, e.email, e.hire_date, d.department_name
FROM EMPLOYEES e 
JOIN DEPARTMENTS d ON e.department_id = d.department_id;

-- Exercise 2.a
SELECT * FROM
(
SELECT first_name, last_name, employee_id
FROM MAT_EMP_DEPT
WHERE department_name = 'Executive'
ORDER BY hire_date DESC
)
WHERE ROWNUM = 1;

-- Exercise 2.b
UPDATE MAT_EMP_DEPT
SET department_name = 'Bean Counting'
WHERE department_name = 'Administration';
/* This does not work because the materialized view, MAT_EMP_DEPT, is read-only and cannot 
be updated directly.
*/

-- Exercise 2.c
UPDATE MAT_EMP_DEPT
SET first_name = 'Manuel'
WHERE first_name = 'Jose Manuel';
/* This does not work because the materialized view, MAT_EMP_DEPT, is read-only and cannot 
be updated directly.
*/

-- Exercise 2.d
INSERT INTO MAT_EMP_DEPT VALUES(207, 'Paige', 'Brinks', 'pbrinks', '08-MAR-09', 'Shipping');
/* This does not work because the materialized view, MAT_EMP_DEPT is read-only and cannot 
be inserted into directly.
*/

/*
-- Exercise 3.a
- view, Relational Algebra
EMP_DEPT <- π<e.employee_id, e.first_name, e.last_name, e.email, e.hire_date, d.department_name>(ρ<e>(EMPLOYEES)⋈<e.department_id=d.department_id>ρ<d>(DEPARTMENTS))
*where <> indicates a subscript

- view, Relational Calculus
EMP_DEPT <- {e.employee_id, e.first_name, e.last_name, e.email, e.hire_date, d.department_name | EMPLOYEES(e) ^ DEPARTMENTS(d) ^ e.department_id=d.department_id}

-- Exercise 3.b
- Relational Calculus
{e.first_name, e.last_name, e.employee_id | EMP_DEP(e) ^ e.department_name='Executive' ^ ¬(EMP_DEPT(e1) (e1.hire_date > e.hire_date))}

*/