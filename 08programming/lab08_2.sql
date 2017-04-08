-- CS 342
-- Question 3 of Homework 08
-- Lab Excercise 08.2
-- Beka Agava

SET SERVEROUTPUT ON;

-- Exercise 8.2
-- Insert your results into this table.
CREATE TABLE SequelsTemp (
  id INTEGER,
  name varchar2(100),
  PRIMARY KEY (id)
 );
 
CREATE OR REPLACE PROCEDURE getSequels (movieIdIn IN Movie.id%type) AS
	-- Fill this in based on:
	-- the cursor example in class exercise 8.2.b.
	CURSOR sequelsOut IS
	SELECT s.id, s.name
	FROM Movie m, Movie s
	WHERE m.id = movieIdIn
	AND m.sequelId = s.id;
	
BEGIN
	-- the recursive procedure example in class exercise 8.3.b.
	FOR sequel in sequelsOut LOOP
		IF sequel.id IS NOT NULL THEN
			INSERT INTO SequelsTemp VALUES (sequel.id, sequel.name);
			getSequels(sequel.id);
		END IF;
	END LOOP;
END;
/

-- Get the sequels for Ocean's 11, i.e., 4 of them.
BEGIN  getSequels(238071);  END;
/
SELECT * FROM SequelsTemp;

-- Get the sequels for Ocean's Fourteen, i.e., none.
BEGIN  getSequels(238075);  END;
/
SELECT * FROM SequelsTemp;

-- Clean up.
DROP TABLE SequelsTemp;
