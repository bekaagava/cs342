-- CS 342 Homework 9
-- Beka Agava

CLEAR SCREEN;
SET AUTOTRACE ON;
SET SERVEROUTPUT ON;
SET TIMING ON;
SET WRAP OFF;

-- Exercise 1 - Get the movies directed by Clint Eastwood 
select * from Movie m, MovieDirector md, Director d
where m.id = md.movieId
and md.directorId = d.id
and d.firstName = 'Clint'
and d.lastName = 'Eastwood';

/*
Elapsed: 00:00:00.00

Execution Plan
----------------------------------------------------------
Plan hash value: 3145408575

--------------------------------------------------------------------------------
| Id  | Operation                    | Name          | Rows  | Bytes | Cost (%CP
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |               |     1 |    59 |     6  (1
|   1 |  NESTED LOOPS                |               |       |       |
|   2 |   NESTED LOOPS               |               |     1 |    59 |     6  (1
|*  3 |    HASH JOIN                 |               |     1 |    30 |     5  (2
|*  4 |     TABLE ACCESS FULL        | DIRECTOR      |     1 |    20 |     2   (
|   5 |     TABLE ACCESS FULL        | MOVIEDIRECTOR |    41 |   410 |     2   (
|*  6 |    INDEX UNIQUE SCAN         | SYS_C007371   |     1 |       |     0   (
|   7 |   TABLE ACCESS BY INDEX ROWID| MOVIE         |     1 |    29 |     1   (
--------------------------------------------------------------------------------
*/

--Using physical database and SQL Tuning
create index mdIndex
on MovieDirector(directorId, movieId);

create index dIndex
on Director(lastName, firstName);

-- Exercise 1 - Get the movies directed by Clint Eastwood 
select name from Movie m, MovieDirector md, Director d
where d.id = md.directorId
and md.movieId = m.id
and d.firstName = 'Clint'
and d.lastName = 'Eastwood';

/*
Elapsed: 00:00:00.00

Execution Plan
----------------------------------------------------------
Plan hash value: 3800426079

--------------------------------------------------------------------------------
| Id  | Operation                      | Name        | Rows  | Bytes | Cost (%CP
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |             |     1 |    59 |     4   (
|   1 |  NESTED LOOPS                  |             |       |       |
|   2 |   NESTED LOOPS                 |             |     1 |    59 |     4   (
|   3 |    NESTED LOOPS                |             |     1 |    30 |     3   (
|   4 |     TABLE ACCESS BY INDEX ROWID| DIRECTOR    |     1 |    20 |     2   (
|*  5 |      INDEX RANGE SCAN          | DINDEX      |     1 |       |     1   (
|*  6 |     INDEX RANGE SCAN           | MDINDEX     |     1 |    10 |     1   (
|*  7 |    INDEX UNIQUE SCAN           | SYS_C007371 |     1 |       |     0   (
|   8 |   TABLE ACCESS BY INDEX ROWID  | MOVIE       |     1 |    29 |     1   (
--------------------------------------------------------------------------------
*/

/*
- I could have created an index on the id in the director table as well, but it is
a key in the table and oracle automatically builds indexes on keys. 

- The query uses:
* INDEX RANGE SCAN
* INDEX UNIQUE SCAN
* TABLE ACCESS BY INDEX ROWID
These indexes help because instead of doing a TABLE ACCESS FULL on the DIRECTOR and MOVIEDIRECTOR tables, 
as was the case in the query without the indexes, an INDEX RANGE SCAN is done which does not read
the whole table.
Also, the arrangement of the statements allows oracle to use a rowid
from the preceding index lookup (which happens because of the already indexed keys used in the join condition)

- SQL Tuning Heuristics Deployed:
* Reviewing the execution plan
	- letting the potentially smallest table, Director, be the driving table
	- join order means that the fewest number of rows are being returned to the next step
* Restructuring the indexes
*select from only required attributes

- Accomplishment: Optimized the query (evidence can be seen in the execution plan)
*/
drop index mdIndex;
drop index dIndex;

-- Exercise 2 - Get the number of movies directed by each director who's directed more than 200 movies
select d.firstName, d.lastName, count(movieId) from MovieDirector md
Join Director d
on md.directorId = d.id
Group By d.firstName, d.lastName
Having count(movieId) > 200;

/*
Elapsed: 00:00:00.01

Execution Plan
----------------------------------------------------------
Plan hash value: 2646178372

--------------------------------------------------------------------------------
| Id  | Operation            | Name          | Rows  | Bytes | Cost (%CPU)| Time
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |               |     3 |    90 |     6  (34)| 00:0
|*  1 |  FILTER              |               |       |       |            |
|   2 |   HASH GROUP BY      |               |     3 |    90 |     6  (34)| 00:0
|*  3 |    HASH JOIN         |               |    41 |  1230 |     5  (20)| 00:0
|   4 |     TABLE ACCESS FULL| DIRECTOR      |    34 |   680 |     2   (0)| 00:0
|   5 |     TABLE ACCESS FULL| MOVIEDIRECTOR |    41 |   410 |     2   (0)| 00:0
--------------------------------------------------------------------------------
*/

create index movieDirectorIdIndex 
on MovieDirector(directorId);

create index directorIndex
on Director(id, firstName, lastName);

select d.firstName, d.lastName, count(1) from Director d
Join MovieDirector md
on d.id = md.directorId
Group By d.firstName, d.lastName
Having count(1) > 200;

/*
Elapsed: 00:00:00.00

Execution Plan
----------------------------------------------------------
Plan hash value: 35191116

--------------------------------------------------------------------------------
| Id  | Operation           | Name                 | Rows  | Bytes | Cost (%CPU)
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |                      |     2 |    50 |     2  (50)
|*  1 |  FILTER             |                      |       |       |
|   2 |   HASH GROUP BY     |                      |     2 |    50 |     2  (50)
|   3 |    NESTED LOOPS     |                      |    41 |  1025 |     1   (0)
|   4 |     INDEX FULL SCAN | DIRECTORINDEX        |    34 |   680 |     1   (0)
|*  5 |     INDEX RANGE SCAN| MOVIEDIRECTORIDINDEX |     1 |     5 |     0   (0)
--------------------------------------------------------------------------------
*/

drop index movieDirectorIdIndex;
drop index directorIndex;

/*
- I could have left out the index on the first name and last name columns of the director
table, but it reads the entire index as compared to a TABLE ACCESS FULL that would read the entire table.

- The Indexes my query uses:
* INDEX RANGE SCAN - since a composite index is created for the join, MovieDirector, 
it no longer has to do a TABLE ACCESS FULL on the MovieDirector table.
* INDEX FULL SCAN - since an composite index has been created for id, first name and last name of the director table, it
just reads the index entire index.

- General SQL Tuning Heuristics Deployed:
* Reviewing the execution plan
	- letting the potentially smallest table, Director, be the driving table
	- join order means that the fewest number of rows are being returned to the next step
* Restructuring the indexes
* Using Count(1) instead of Count(movieId)
*select from only required attributes

- Accomplishment: Optimized the query (evidence can be seen in the execution plan)
*/

-- Exercise 3 - Get the most popular actors, where actors are designated as popular if their movies have an average 
--rank greater than 8.5 with a movie count of at least 10 movies.

select a.firstName, a.lastName, avg(m.rank)
from Actor a 
join Role r on a.id = r.actorId
join Movie m on r.movieId = m.id
group by a.firstName, a.lastName
having avg(m.rank) > 8.5
and count(m.id) >= 10;

/*
Elapsed: 00:00:00.01

Execution Plan
----------------------------------------------------------
Plan hash value: 3470073944

--------------------------------------------------------------------------------
| Id  | Operation                | Name        | Rows  | Bytes | Cost (%CPU)| Ti
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |             |     5 |   200 |    14  (15)| 00
|*  1 |  FILTER                  |             |       |       |            |
|   2 |   HASH GROUP BY          |             |     5 |   200 |    14  (15)| 00
|*  3 |    HASH JOIN             |             |  1993 | 79720 |    13   (8)| 00
|*  4 |     HASH JOIN            |             |  1993 | 37867 |     8  (13)| 00
|   5 |      TABLE ACCESS FULL   | MOVIE       |    40 |   360 |     2   (0)| 00
|   6 |      INDEX FAST FULL SCAN| SYS_C007377 |  1993 | 19930 |     5   (0)| 00
|   7 |     TABLE ACCESS FULL    | ACTOR       |  1910 | 40110 |     5   (0)| 00
--------------------------------------------------------------------------------
*/

create index movieIndex
on Movie(id, rank);

create index roleIndex
on Role (movieId, actorId);

create index actorIndex
on Actor(id, firstName, lastName);

select a.firstName, a.lastName, avg(m.rank)
from Actor a 
join Role r on a.id = r.actorId
join Movie m on r.movieId = m.id
group by a.firstName, a.lastName
having avg(m.rank) > 8.5
and count(1) >= 10;

/*
Elapsed: 00:00:00.03

Execution Plan
----------------------------------------------------------
Plan hash value: 2967775691

--------------------------------------------------------------------------------
| Id  | Operation                | Name       | Rows  | Bytes | Cost (%CPU)| Tim
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |            |     5 |   200 |    10  (20)| 00:
|*  1 |  FILTER                  |            |       |       |            |
|   2 |   HASH GROUP BY          |            |     5 |   200 |    10  (20)| 00:
|*  3 |    HASH JOIN             |            |  1993 | 79720 |     9  (12)| 00:
|*  4 |     HASH JOIN            |            |  1993 | 37867 |     5  (20)| 00:
|   5 |      INDEX FULL SCAN     | MOVIEINDEX |    40 |   360 |     1   (0)| 00:
|   6 |      INDEX FAST FULL SCAN| ROLEINDEX  |  1993 | 19930 |     3   (0)| 00:
|   7 |     INDEX FAST FULL SCAN | ACTORINDEX |  1910 | 40110 |     4   (0)| 00:
--------------------------------------------------------------------------------
*/

drop index movieIndex;

drop index roleIndex;

drop index actorIndex;

/*
- I could have left out the index on the first name and last name columns of the actor
table, but it reads the entire index and performs an additional sorting operation
as compared to a TABLE ACCESS FULL that would read the entire table.

- The Indexes my query uses:
* INDEX FAST FULL SCAN - since a composite index is created for all the required columns, 
it no longer has to do a TABLE ACCESS FULL on the Actor or Movie table.
* INDEX FULL SCAN - since an composite index has been created for id, first name and last name of the actor table, it
just reads the index entire index.

- General SQL Tuning Heuristics Deployed:
* Reviewing the execution plan
	- letting the potentially smallest table, Director, be the driving table
	- join order means that the fewest number of rows are being returned to the next step
* Restructuring the indexes
* Using Count(1) instead of Count(movieId)
*select from only required attributes

- Accomplishment: Optimized the query (evidence can be seen in the execution plan)
*/