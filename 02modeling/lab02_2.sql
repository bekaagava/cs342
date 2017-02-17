-- This command file loads a simple movies database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2017
-- kvlinden, baa8

-- Drop current database
DROP TABLE Casting;
DROP TABLE Movie;
DROP TABLE Performer;
DROP TABLE Status;

-- Create database schema
CREATE TABLE Movie (
	id integer,
	title varchar(70) NOT NULL, 
	year decimal(4), 
	score float,
	votes integer,
	PRIMARY KEY (id),
	CHECK (year > 1900)
	);

CREATE TABLE Performer (
	id integer,
	name varchar(35),
	PRIMARY KEY (id)
	);

/* The movies database can be modified to support the enumerated status type using the relational model
by creating a "status" table and adding a foreign key to the Casting table that references the Status table 
primary key. 
Benefits: 
- The status types are not hard-coded so the list of types can be long and easily updated since they are stored in a table. This improves 
readability compared to hard-coding a long list with the creation of the Casting table. 
- Constraints on the status can be placed on the Status table. 

Costs:
- Referencing the table takes more computational time and space
- The user always has to check the status information from the status table because the foreign keys are not descriptive

*/
	
CREATE TABLE Status (
	id integer,
	castingStatus varchar(6),
	PRIMARY KEY (id)
	);

CREATE TABLE Casting (
	movieId integer,
	performerId integer,
	statusId integer,
	--status varchar(6),
	FOREIGN KEY (movieId) REFERENCES Movie(Id) ON DELETE CASCADE,
	FOREIGN KEY (performerId) REFERENCES Performer(Id) ON DELETE SET NULL,
	FOREIGN KEY (statusId) REFERENCES Status(Id) ON DELETE SET NULL
	--CHECK (status in ('star', 'costar', 'extra'))
	);
	

-- Load sample data
INSERT INTO Movie VALUES (1,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (2,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison Ford');
INSERT INTO Performer VALUES (2,'Rutger Hauer');
INSERT INTO Performer VALUES (3,'The Mighty Chewbacca');
INSERT INTO Performer VALUES (4,'Rachael');

INSERT INTO Status VALUES (1, 'star');
INSERT INTO Status VALUES (2, 'costar');
INSERT INTO Status VALUES (3, 'extra');

-- Examples:
INSERT INTO Casting VALUES (2,3, 7) /* violation of referential integrity */ ; 
INSERT INTO Casting VALUES (2, 2, 2);

--INSERT INTO Casting VALUES (1,1,'star');
--INSERT INTO Casting VALUES (1,3,'extra');
--INSERT INTO Casting VALUES (2,1,'star');
--INSERT INTO Casting VALUES (2,2,'costar');
--INSERT INTO Casting VALUES (2,4,'costar');
