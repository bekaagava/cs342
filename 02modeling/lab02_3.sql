-- This command file loads a simple movies database, dropping any existing tables
-- with the same names, rebuilding the schema and loading the data fresh.
--
-- CS 342, Spring, 2017
-- kvlinden, baa8

-- Drop current database
DROP TABLE Casting;
DROP TABLE Movie;
DROP TABLE Performer;
DROP SEQUENCE seq_movie;

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
	
CREATE SEQUENCE seq_movie
MINVALUE 1
START WITH 1
INCREMENT BY 1
NOCACHE;

/* A. Yes, you would need an additional sequence for the performer relation primary key values because using the same 
sequence would result in skipping values for both tables which could lead to errors in the application that uses the database.

B. Using sequences in a DDL command file to construct the full movie database could result in errors with referencing the table with the 
sequence because if the sequence is not dropped, it keeps counting. Also, if the inserts into the table are rolled back, there could 
be errors with referencing the table as well.

*/

-- Load sample data
INSERT INTO Movie VALUES (seq_movie.nextval,'Star Wars',1977,8.9, 2000);
INSERT INTO Movie VALUES (seq_movie.nextval,'Blade Runner',1982,8.6, 1500);

INSERT INTO Performer VALUES (1,'Harrison Ford');
INSERT INTO Performer VALUES (2,'Rutger Hauer');
INSERT INTO Performer VALUES (3,'The Mighty Chewbacca');
INSERT INTO Performer VALUES (4,'Rachael');

INSERT INTO Casting VALUES (1,1,'star');
INSERT INTO Casting VALUES (1,3,'extra');
INSERT INTO Casting VALUES (2,1,'star');
INSERT INTO Casting VALUES (2,2,'costar');
INSERT INTO Casting VALUES (2,4,'costar');
