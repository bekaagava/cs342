-- This command file loads an experimental person relation.
-- The data conforms to the following assumptions:
--     * Person IDs and team names are unique for people and teams respectively.
--     * People can have at most one mentor.
--     * People can be on many teams, but only have one role per team.
--     * Teams meet at only one time.
--
-- CS 342
-- Spring, 2017
-- kvlinden, baa8

drop table Person_Team;
drop table Team;
drop table Person;
drop table AltPerson;

CREATE TABLE AltPerson (
	personId integer,
	name varchar(10),
	status char(1),
	mentorId integer,
	mentorName varchar(10),
	mentorStatus char(1),
    teamName varchar(10),
    teamRole varchar(10),
    teamTime varchar(10)
	);

INSERT INTO AltPerson VALUES (0, 'Ramez', 'v', 1, 'Shamkant', 'm', 'elders', 'trainee', 'Monday');
INSERT INTO AltPerson VALUES (1, 'Shamkant', 'm', NULL, NULL, NULL, 'elders', 'chair', 'Monday');
INSERT INTO AltPerson VALUES (1, 'Shamkant', 'm', NULL, NULL, NULL, 'executive', 'protem', 'Wednesday');
INSERT INTO AltPerson VALUES (2, 'Jennifer', 'v', 3, 'Jeff', 'm', 'deacons', 'treasurer', 'Tuesday');
INSERT INTO AltPerson VALUES (3, 'Jeff', 'm', NULL, NULL, NULL, 'deacons', 'chair', 'Tuesday');

/*
Exercise 4.1 
a. The relation is not well designed because:
	i. Its attributes are not semantically clear in the schema. It is combining attributes for multiple entity types - person and team. 
	ii. There are redundant entries for the same person. This could cause insertion, deletion and modification anomalies. 
		For example, if Shamkant gets a mentor, the mentor information would have to be updated in the two entries for Shamkant and it 
		takes a large set of attributes to make the entries unique, so this could be easily done wrong. This could also pose a problem for deletion
		as the wrong entry could be deleted. 
	iii. There are many NULL values in the tuples because many of the attributes do not apply to all tuples in the relation. Since the mentor information 
		 will generate a lot of NULLs, it might be better to include it in a different relation. 
	iv. It allows the possibility of generating suprious tables. For example, if the person is separated from the team and the name is used to join the tables, then
		Shamkant will link to both the elders and the executive teams because their is no attribute unique enough to link the tables.
		
	Formal Proof:
	BCNF: using the combination of personId and teamName as the primary key:
	Functional Dependencies:
	{teamName} -> teamTime
	{personId} -> status, name, mentorId, mentorName, mentorStatus
	{mentorId} -> mentorName, mentorStatus
	{personId, teamName} -> teamRole
	
	Candidate Key:
	personId, teamName
	
	Because there are non-trivial functional dependencies with sub keys, BCNF does not hold true for the schema. Therefore there is increased chance of repeated information.
	
	Multi-Valued Dependencies:
	There are no non-trivial MVDs, so this is trivially in 4NF.

b. Properly Normalized Schema for Database:
   Person(personId, name, status, mentorId) - mentorId is a foreign key that refers to personId (the primary key)
   Team(teamName, time)
   Person_Team(personId, teamName, role)
   
*/

-- Homework Exercise 4.1 c
create table Person (
	ID integer PRIMARY KEY,
	name varchar(10),
	status char(1),
	mentorId integer,
	foreign key (mentorId) references Person(ID) ON DELETE SET NULL,
	check (mentorId != ID)
	);
	
create table Team (
	teamName varchar(10) PRIMARY KEY,
    teamTime varchar(10)
	);
	
create table Person_Team (
	personId integer,
	teamName varchar(10),
	role varchar(10),
	foreign key (personId) references Person(ID) ON DELETE SET NULL,
	foreign key (teamName) references Team(teamName) ON DELETE SET NULL
	);
	
insert into Person select distinct personId, name, status, mentorId FROM AltPerson;
insert into Team select distinct teamName, teamTime FROM AltPerson;
insert into Person_Team select distinct personId, teamName, teamRole FROM AltPerson;

select * from Person;
select * from Team;
select * from Person_Team;
