CREATE VIEW Birthday 
AS SELECT firstName, lastName, TRUNC(MONTHS_BETWEEN(SYSDATE, birthdate)/12) Age, birthdate
FROM Person;

-- Exercise 7.1.a
SELECT firstName || ' ' || lastName Full_Name, Age, birthdate
FROM Birthday
WHERE birthdate >= '01-JAN-1961' AND birthdate <= '31-DEC-1975';

-- Exercise 7.1.b

UPDATE Person SET birthdate = '03-MAR-1962' 
WHERE ID = 7;

SELECT firstName || ' ' || lastName Full_Name, Age, birthdate
FROM Birthday
WHERE birthdate >= '01-JAN-1961' AND birthdate <= '31-DEC-1975';

/* Yes, the results of the view query change because the view "Birthday" is a non-materialized view
so everytime a query selects from the view, it re-runs the create view select query and 
selects the information from the Person table. This is called query modification
*/

-- Exercise 7.1.c
INSERT INTO Birthday VALUES ('Beka', 'Agava', 20, '01-OCT-1996');
/* I would have to modify the view to select the ID from the Person table, and not select the age when
creating the view. For a view to be updateable the relationship between the view and the table has to be,
key-preserved, which this view is not because we cannot uniquely link records from this view to the base table. 
The fields of the inserted record in the base table not included in the views are just filled with NULLs.
*/

-- Exercise 7.1.d
/*
Dropping the view does not affect the base table in any way because the view was a modifying 
query on the table, which is not reversed when th view is dropped.
*/