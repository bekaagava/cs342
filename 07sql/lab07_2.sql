-- CS 342
-- Beka Agava
-- lab 07_2

CREATE MATERIALIZED VIEW Mat_Birthday
AS SELECT firstName, lastName, TRUNC(MONTHS_BETWEEN(SYSDATE, birthdate)/12) Age, birthdate
FROM Person;

-- Exercise 7.2.a
SELECT firstName || ' ' || lastName Full_Name, Age, birthdate
FROM Mat_Birthday
WHERE birthdate >= '01-JAN-1961' AND birthdate <= '31-DEC-1975';

-- Exercise 7.2.b
UPDATE Person SET birthdate = '03-MAR-1962' 
WHERE ID = 7;

SELECT firstName || ' ' || lastName Full_Name, Age, birthdate
FROM Mat_Birthday
WHERE birthdate >= '01-JAN-1961' AND birthdate <= '31-DEC-1975';
/*
The results of the materialized view, Mat_Birthday, are not updated because 
it is not created to refresh and update with changes made to the base table.
It is currently just a "snapshot" of what the table was when it was created.
*/ 

-- Exercise 7.2.c
INSERT INTO Mat_Birthday VALUES ('Beka', 'Agava', 20, '01-OCT-1996');
/*  This does not work because the materialized view, Mat_Birthday, is read-only and cannot 
be inserted into directly.
*/

-- Exercise 7.2.d
/*
Dropping the view does not affect the base table in any way because the view was a select query 
query on the base table, which is not reversed when the view is dropped.
*/