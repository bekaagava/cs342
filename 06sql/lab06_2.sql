@drop.sql
@schema.sql
@data.sql

--Exercise 6.2
--a
SELECT TRUNC(AVG(MONTHS_BETWEEN(SYSDATE, p.birthdate)/12)) AS Average_Age
FROM Person p;
/*
This query uses an aggregate function and is using the default group, therefore it is doing grouping. 
*/

-- b
SELECT h.ID, COUNT(*)
FROM HouseHold h JOIN Person p ON h.ID = p.householdID
GROUP BY h.ID
HAVING COUNT (*) > 1
ORDER BY COUNT (*) DESC;


-- c
SELECT h.ID, h.phoneNumber, COUNT(*)
FROM HouseHold h JOIN Person p ON h.ID = p.householdID
GROUP BY h.ID, h.phoneNumber
HAVING COUNT (*) > 1
ORDER BY COUNT (*) DESC;