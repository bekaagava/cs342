-- This command file loads a simple movies database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2017
-- kvlinden, baa8

-- Drop current database
DROP TABLE Casting;
DROP TABLE Movie;
DROP TABLE Performer;

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

CREATE TABLE Casting (
	movieId integer,
	performerId integer,
	status varchar(6),
	FOREIGN KEY (movieId) REFERENCES Movie(Id) ON DELETE CASCADE,
	FOREIGN KEY (performerId) REFERENCES Performer(Id) ON DELETE SET NULL,
	CHECK (status in ('star', 'costar', 'extra'))
	);

-- Load sample data
INSERT INTO Movie VALUES (1,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (2,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison Ford');
INSERT INTO Performer VALUES (2,'Rutger Hauer');
INSERT INTO Performer VALUES (3,'The Mighty Chewbacca');
INSERT INTO Performer VALUES (4,'Rachael');

INSERT INTO Casting VALUES (1,1,'star');
INSERT INTO Casting VALUES (1,3,'extra');
INSERT INTO Casting VALUES (2,1,'star');
INSERT INTO Casting VALUES (2,2,'costar');
INSERT INTO Casting VALUES (2,4,'costar');

-- EXERCISE 2.1
-- A
INSERT INTO Movie VALUES (1, 'Eve', 2015, 8.7);
/* This command violates entity integrity so it throws an error saying 
"unique constraint violated" */

INSERT INTO Movie VALUES (NULL, 'Eve', 2015, 8.7);
/* This violates domain integrity because NULL is not a valid data typr for the primary key
so it throws an error saying "cannot insert NULL into ID column of Movie table"*/

INSERT INTO Movie VALUES (3, 'Great Escape', 1860, 8.5);
/* The domain integrity is violated because '1860' is not a legal date. It throws an
error saying "check constraint violated" */

INSERT INTO Movie VALUES (3, 'Great Escape', 1970, 'goat', 4000);
/* This violates domain integrity because 'goat' is not of type float. It throws an
error saying "invalid number" */

INSERT INTO Movie VALUES (3, 'Great Escape', 1970, -8.5, 4000);
/* The score data type specification does not specify whether a float can be positive or 
negative so even though it does not make sense for the score to be negative, it is still 
a valid entry for the database*/


--Exercise 2.2
--B
/* If a table already exists without a constraint and it needs one, instead of recreating the 
table, you create a constraint on the existing table. This would help with data cleansing processes*/

