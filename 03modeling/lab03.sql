-- Exercise 3.1 & 3.2 for lab 3.
--
-- CS 342, Spring, 2017
-- kvlinden, baa8

drop table Person_Team;
drop table Team;
drop table Person;
drop table Homegroup;
drop table HouseHold;

create table HouseHold(
	ID integer PRIMARY KEY,
	street varchar(30),
	city varchar(30),
	state varchar(2),
	zipcode char(5),
	phoneNumber char(12)
	);

create table Homegroup (
	ID integer PRIMARY KEY,
	group_name varchar (20)
	);
	
create table Person (
	ID integer PRIMARY KEY,
	title varchar(4),
	firstName varchar(15),
	lastName varchar(15),
	householdId integer NOT NULL,
	mentorId integer,
	homegroupId integer,
	membershipStatus char(1) CHECK (membershipStatus IN ('m', 'a', 'c')),
	role varchar(20),
	FOREIGN KEY (householdId) REFERENCES HouseHold(ID) ON DELETE CASCADE,
	FOREIGN KEY (mentorId) REFERENCES Person(ID) ON DELETE SET NULL,
	FOREIGN KEY (homegroupId) REFERENCES Homegroup(ID) ON DELETE SET NULL
	);
	
create table Team (
	ID integer PRIMARY KEY,
	team_name varchar (20),
	team_mandate varchar (70)
	);
	
create table Person_Team (
	personId integer,
	teamID integer,
	role varchar (20),
	startDate DATE,
	endDate DATE,
	FOREIGN KEY (personId) REFERENCES Person(ID) ON DELETE SET NULL,
	FOREIGN KEY (teamId) REFERENCES Team(ID) ON DELETE SET NULL,
	CHECK (endDate > startDate)
	);

INSERT INTO Household VALUES (0,'2347 Oxford Dr. SE','Grand Rapids','MI','49506','616-243-5680');

INSERT INTO Homegroup VALUES (0, 'Bible Studies');
INSERT INTO Homegroup VALUES (1, 'Worship Studies');

INSERT INTO Person VALUES (0,'mr.','Keith','VanderLinden', 0, NULL, 0, 'm', 'father');
INSERT INTO Person VALUES (1,'ms.','Brenda','VanderLinden', 0, NULL, 0, 'm', 'mother');
INSERT INTO Person VALUES (2,'ms.','Lydia','VanderLinden', 0, 0, NULL, 'm', 'daughter');
INSERT INTO Person VALUES (3,'ms.','Paige','VanderLinden', 0, 1, 1, 'm','daughter');
INSERT INTO Person VALUES (4,'ms.','Joel','VanderLinden', 0, 0, NULL,'m', 'son');

INSERT INTO Team VALUES (0, 'Elders', 'We will lead the church with strong hands!');
INSERT INTO Team VALUES (1, 'Music', 'Praising the Lord all our lives');
INSERT INTO Team VALUES (2, 'Planning Committee', 'He who fails to plan plans to fail!');

INSERT INTO Person_Team VALUES (0, 0, 'Chairman', '01-Jan-2010', '02-Feb-2017');
INSERT INTO Person_Team VALUES (0, 2, 'Secretary', '04-May-2012', '20-Jun-2016');
INSERT INTO Person_Team VALUES (3, 1, 'Member', '13-Jul-2009', '23-Dec-2015');
