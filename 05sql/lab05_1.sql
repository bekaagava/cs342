@schema.sql
@data.sql

-- Exercise 5.1 a
SELECT * FROM Person, Household;
/* I get 128 records because the number of records for the cross-product is the number of rows in 
Person multipled by the number of rows in Household, which is 8*16 = 128.
*/

SELECT COUNT (*) FROM Person, Household; 
-- returns the record count for the cross-product of all person and all household records.


-- Exercise 5.1 b
SELECT firstName, lastName, birthdate
FROM Person
WHERE birthdate IS NOT NULL
ORDER BY TO_CHAR(birthdate, 'DDD');

@drop.sql