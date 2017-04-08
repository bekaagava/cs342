-- CS 342
-- Lab 09
-- Exercise 9.1
-- Beka Agava

CLEAR SCREEN;
SET AUTOTRACE TRACEONLY;
SET SERVEROUTPUT ON;
SET TIMING ON;
SET WRAP OFF;

-- Exercise 9.1.a 
SELECT COUNT(*) FROM Director;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT COUNT(*)
		INTO nameOut
		FROM Director;
END LOOP;
END;
/

SELECT COUNT(1) FROM Director;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT COUNT(1) 
		INTO nameOut
		FROM Director;
END LOOP;
END;
/

SELECT SUM(1) FROM Director;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT SUM(1) 
		INTO nameOut
		FROM Director;
END LOOP;
END;
/
/* COUNT(1) and COUNT(*) when ran 1000 times take the same time, 1.23 seconds, 
while SUM(1) when ran 1000 times takes longer, 2.54 seconds. Since they use the same
execution plan - INDEX FAST FULL SCAN - the difference in time elapsed could be a result of 
the way they are implemented.
*/

-- Exercise 9.1.b
-- i
SELECT * FROM Role r, MovieGenre g
WHERE r.movieId = g.movieId;

SELECT * FROM MovieGenre g, Role r
WHERE g.movieId = r.movieId;

-- ii 
SELECT * FROM Movie m, MovieDirector d
WHERE m.id = d.movieId;

SELECT * FROM MovieDirector d, Movie m
WHERE d.movieId = m.id;

/* The order of the tables listed in the FROM clause does not affect the way oracle executes a join query.
For the (i) queries, the execution plan outputs match. This is also the case for the (ii) queries.
A TABLE ACCESS FULL is executed on the tables in the order that oracle has chosen.
For the above statements, oracle determines a join order and then uses it regardless of how the tables are 
listed in the FROM clause of the join query. 
*/

-- Exercise 9.1.c
-- i
SELECT * FROM Role r
JOIN MovieGenre g ON r.movieId = g.movieId;

SELECT * FROM Role r
JOIN MovieGenre g ON r.movieId+1 = g.movieId+1;

-- ii
SELECT * FROM Movie m
JOIN MovieDirector d ON m.id = d.movieId;

SELECT * FROM Movie m
JOIN MovieDirector d ON m.id+1 = d.movieId+1;

/* The use of arithmetic expressions in join conditions in both cases (i and ii) increases the time elapsed by a few milliseconds, even though
the queries have the same operation (TABLE ACCESS FULL) being used on the tables .
Therefore, I conclude that the use of arithmetic operations in join conditions affects a query's efficiency in that it increases the 
time elapsed, when compared to the join conditions without the arithmetic expressions. The SELECT STATEMENT and the HASH JOIN operations 
involve many more rows in the join condition with the arithmetic expression.
*/

-- Exercise 9.1.d
-- i
SELECT COUNT(*) FROM Role;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..100 LOOP
	SELECT COUNT(*)
		INTO nameOut
		FROM Role;
END LOOP;
END;
/

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT COUNT(*)
		INTO nameOut
		FROM Role;
END LOOP;
END;
/


-- ii
SELECT SUM(1) FROM Actor;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..100 LOOP
	SELECT SUM(1)
		INTO nameOut
		FROM Actor;
END LOOP;
END;
/

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT SUM(1)
		INTO nameOut
		FROM Actor;
END LOOP;
END;
/


/* Running the same query more than once does not affect its performance, and it still maintains 
the same execution plan. In my tests the time elapsed per query is approximately the same in the cases 
on running the query once, 100 times or 1000 times. The (i) tests had time elapsed of about 0.03 seconds
per query, so did the (ii) tests, regardless of how many times the query was run.
*/

-- Exercise 9.1.e
CREATE INDEX ConcatIndex 
ON MovieDirector (movieId, directorId);


SELECT COUNT (*) FROM MovieDirector md, Movie m, Director d
WHERE md.movieId = m.id
AND md.directorId = d.id
AND m.id = 4860
AND d.id = 8;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT COUNT (*)
		INTO nameOut
		FROM MovieDirector md, Movie m, Director d
		WHERE md.movieId = m.id
		AND md.directorId = d.id
		AND m.id = 4860
		AND d.id = 8;
END LOOP;
END;
/

DROP INDEX ConcatIndex; 


SELECT COUNT (*) FROM MovieDirector md, Movie m, Director d
WHERE md.movieId = m.id
AND md.directorId = d.id
AND m.id = 4860
AND d.id = 8;

DECLARE
  nameOut varchar(200);
BEGIN
FOR i IN 1..1000 LOOP
	SELECT COUNT (*)
		INTO nameOut
		FROM MovieDirector md, Movie m, Director d
		WHERE md.movieId = m.id
		AND md.directorId = d.id
		AND m.id = 4860
		AND d.Id = 8;
END LOOP;
END;
/

/* Adding a concatenated index on a join table greatly improves performance because an INDEX RANGE SCAN is used with
the created index (ConcatIndex) on the table, making the time elapsed considerably shorter. 
With the concatenated index, the query when run 1000 times took about 0.01 seconds whereas without the index, the same query took
about 3.53 seconds. 
*/
