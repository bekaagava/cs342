-- Sample version of the Movies database for guide 7 (copied from unit 6)
--
-- CS 342, Spring, 2017
-- kvlinden

-- Drop current database
DROP TABLE Casting;
DROP TABLE Movie;
DROP TABLE Performer;
DROP VIEW Viewer;

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
	firstName varchar(20),
	lastName varchar(25),
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

INSERT INTO Performer VALUES (1,'Harrison', 'Ford');
INSERT INTO Performer VALUES (2,'Rutger', 'Hauer');
INSERT INTO Performer VALUES (3,'Chewbacca', NULL);
INSERT INTO Performer VALUES (4,'Rachael', NULL);
INSERT INTO Performer VALUES (5,'Rex', 'Harrison');

INSERT INTO Casting VALUES (1,1,'star');
INSERT INTO Casting VALUES (1,3,'extra');
INSERT INTO Casting VALUES (2,1,'star');
INSERT INTO Casting VALUES (2,2,'costar');
INSERT INTO Casting VALUES (2,4,'costar');


—- 1a
CREATE VIEW Viewer
AS SELECT title, score, year
FROM Movie
ORDER BY year DESC;

— Test
SELECT * From Viewer;

— 1b
/*
i. Base Tables: These are tables whose tuples are always physically stored in the database.

ii. Join Views: These are views that specify more than one base table or view in the “FROM” clause.

iii. Updateable Join Views: This is a join view where “UPDATE”, “INSERT” and “DELETE” operations are allowed.

iv. Key-Preserved Tables: These are tables for which every key of the table can also be a key of the result of the join. 


v. Views that are implemented via query modification vs materialization:

- Query modification involves modifying or transforming the view query (submitted by the user) into a query on the underlying base tables.
- View materialization involves physically creating a temporary or permanent view table when the view is first queried or created and keeping that table on the assumption that other queries on the view will follow. 

*/

