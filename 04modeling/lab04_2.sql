-- This command file loads an experimental person database.
-- The data conforms to the following assumptions:
--     * People can have 0 or many team assignments.
--     * People can have 0 or many visit dates.
--     * Teams and visits don't affect one another.
--
-- CS 342, Spring, 2017
-- kvlinden, baa8

DROP TABLE PersonTeam;
DROP TABLE PersonVisit;

CREATE TABLE PersonTeam (
	personName varchar(10),
    teamName varchar(10)
	);

CREATE TABLE PersonVisit (
	personName varchar(10),
    personVisit date
	);

-- Load records for two team memberships and two visits for Shamkant.
INSERT INTO PersonTeam VALUES ('Shamkant', 'elders');
INSERT INTO PersonTeam VALUES ('Shamkant', 'executive');
INSERT INTO PersonVisit VALUES ('Shamkant', '22-FEB-2015');
INSERT INTO PersonVisit VALUES ('Shamkant', '1-MAR-2015');

-- Query a combined "view" of the data of the form View(name, team, visit).
SELECT pt.personName, pt.teamName, pv.personVisit
FROM PersonTeam pt, PersonVisit pv
WHERE pt.personName = pv.personName;

/* Exercise 4.2 
a. PersonTeam:
	Checking for BCNF:
	
	{personName} -> personName
	{teamName} -> teamName
	
	There are no non-trivial functional dependencies where the left-hand side is not a superkey, therefore the 
	PersonTeam table is in BCNF.
	
	Checking for 4NF:
	
	{personName} ->> teamName
	
	There are no non-trivial multi-valued dependencies where the left-hand side is not a superkey, therefore the PersonTeam
	table is in 4NF.
	
	PersonVisit:
	Checking for BCNF:
	
	{personName} -> personName
	{personVisit} -> personVisit
	
	There are no non-trivial functional dependencies where the left-hand side is not a superkey, therefore the 
	PersonVisit table is in BCNF.
	
	Checking for 4NF:
	
	{personName} ->> personVisit
	
	There are no non-trivial multi-valued dependencies where the left-hand side is not a superkey, therefore the PersonVisit
	table is in 4NF.
	
	
b. 	View(name, team, visit)
	Checking for BCNF:
	There are no non-trivial functional dependencies where the left-hand side is not a superkey, therefore the 
	View relation is in BCNF
	
	Checking for 4NF:
	{personName} ->> teamName | teamVisit
	
	There is a multi-valued dependency where the left-hand side is a subkey, therefore the View relation is not in 4NF
	
c. No, the derived "view" schema and the original schema are not equally appropriate. My choice of which schema is better depends on the context. If it is the case that 
   the church just wants to figure out how many people are on the teams and how many people have visited, without caring about the names of the people then the original schema is better.
   The "view" schema does not work as well in this case because it is not easy to count for example, the number of Shamkants on a team because if one Shamkant visits multiple times, there will
   be multiple records for the smae team with Shamkant as personName.
   If on the other hand the church needs to figure out how many visits a team has had, the derived "view" schema is better. 
*/