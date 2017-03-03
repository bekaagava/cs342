@schema.sql
@data.sql

-- Exercise 5.2 a
-- The nested select is not correlated
SELECT * FROM 
(SELECT * FROM Person 
WHERE birthdate IS NOT NULL 
ORDER BY birthdate DESC)
WHERE ROWNUM = 1;

-- Exercise 5.2 b
SELECT P1.ID , P2.ID, P1.firstName, P1.lastName FROM Person P1, Person P2
WHERE P1.ID <> P2.ID 
AND P1.firstName = P2.firstName;
/* Joining on the name creates multiple records when there are three or more 
people who share the same name because each record is mapped to the other people 
who share the name. In the case where a third Ralph is added to the table, instead of producing
5 records, 8 records get produced. This can be resolved by using a correlated subquery.
*/

 -- Exercise 5.2 c
 -- The first nested select is correlated while the second one is not
SELECT firstName || ' ' || lastName AS fullName FROM Person p
WhERE EXISTS (SELECT * FROM PersonTeam pt WHERE p.ID = pt.personID
AND teamName = 'Music')
MINUS
SELECT firstName || ' ' || lastName AS fullName FROM 
(SELECT * FROM Person p1
WHERE p1.homegroupID = 0);

@drop.sql