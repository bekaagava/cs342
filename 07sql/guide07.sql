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


—- 2
Formal languages for the relational model (Chapter 8, for Wednesday)

—- a
Relational Algebra (read Sections 8.1–8.3 & 8.5) — Write a simple query on the movies database using SELECT (σcondition), PROJECT (πfieldlist), RENAME (ρnewName) and JOIN (⋈condition) (see example queries 1 & 2 in Section 8.5).

TEMP <- σstatus=‘costar’(Casting)
PERFORMER_STATUS <- (TEMP ⋈ performerId=idPerformer)
ρ(First_name, Last_name) <- πfirstName, lastName(PERFORMER_STATUS)

—- b
Tuple Relational Calculus (read Sections 8.6.1–8.6.3 & 8.6.8) — Write a simple query on the movies database using the tuple relational calculus queries (see example queries 0 & 1 in Section 8.6.4).

{p.firstName, p.lastName | Performer(p) AND (∃c)(Casting(c)
AND c.status=‘costar’AND c.performerId=p.id)}

—- c
Define the following terms):

Existential (∃) and universal (∀) quantifiers (see Section 8.6.3).
- Existential (∃) quantifiers - the statements within the scope are true for at least one tuple
- universal (∀) quantifiers - every tuple in the universe of tuples must make the formula, F, TRUE to make the quantified formula TRUE

Safe expressions (see Section 8.6.8).
This is an expression in relational calculus that is guaranteed to yield a finite number of tuples as its result. 

*/
