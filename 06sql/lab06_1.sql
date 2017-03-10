@drop.sql
@schema.sql
@data.sql

-- Exercise 6.1
-- a
SELECT t.name, t.mandate, pt.personID, pt.role
FROM Team t 
LEFT JOIN PersonTeam pt ON t.name = pt.teamName AND pt.role = 'chair';

