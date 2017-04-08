-- CS 342
-- Question 2 of Homework 08
-- Beka Agava

SET SERVEROUTPUT ON;

-- Insert results into this table.
CREATE TABLE BaconTable (
  actorId INTEGER,
  baconNumber INTEGER,
  PRIMARY KEY (actorId)
 );

CREATE OR REPLACE PROCEDURE getBaconNumber (actorIdIn IN Actor.id%type, bNum IN INTEGER) IS
	counter INTEGER default 0;
	CURSOR actorsOut IS
	SELECT DISTINCT r1.actorId FROM Role r1
	WHERE r1.movieId IN
	(
	SELECT r.movieId FROM ROLE r
	WHERE actorIdIn = r.actorId
	);

BEGIN
	INSERT INTO BaconTable VALUES (actorIdIn, bNum);
	
	FOR actor IN actorsOut LOOP
		SELECT COUNT (*) 
		INTO counter 
		FROM BaconTable
		WHERE actor.actorId = BaconTable.actorId;
		
		-- setting cursor limit
		IF counter = 0 AND bNum < 41 THEN
			getBaconNumber(actor.actorId, (bNum+1));
		ELSE
			UPDATE BaconTable
				SET baconNumber = (bNum+1)
				WHERE actor.actorId = BaconTable.actorId
				AND BaconTable.baconNumber > (bNum+1);
		END IF;
	END LOOP;
END;
/

-- 	Get the Bacon Table with Kevin Bacon as the base 
BEGIN getBaconNumber(22591, 0); END;
/

select * from BaconTable
order by baconNumber;

/*
-- Testing Bacon Number with different base
--Kevin Bacon is one step away from this actor
BEGIN getBaconNumber(841405, 0); END;
/
*/

-- Check which actors don't have baconNumbers 
/*
select bt.actorId, a.id from BaconTable bt
RIGHT JOIN Actor a 
ON bt.actorId = a.id;
*/
-- Should be step 0 since this is Kevin Bacon
SELECT * FROM BaconTable WHERE actorId = 22591;

-- Should be one step away from Kevin Bacon
SELECT * FROM BaconTable WHERE actorId = 841405;

-- should not be in the Bacon Table 
SELECT * FROM BaconTable WHERE actorId = 621545;

-- should be 4 steps away from Kevin Bacon
SELECT * FROM BaconTable WHERE actorId = 25743;

DROP TABLE BaconTable;

