-- CS 342
-- Homework 10
-- 04/20/2017

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE transferRank (sourceIdIn IN Movie.id%type, destinationIdIn IN Movie.id%type,
	 deltaIn IN FLOAT
    ) AS
	x Movie.rank%type;
	tooLow_exception EXCEPTION;
	negativeDelta_exception EXCEPTION;
BEGIN
	SELECT rank INTO x FROM Movie WHERE id=sourceIdIn FOR UPDATE OF rank;
	
	IF x < deltaIn THEN
		RAISE tooLow_exception;
    END IF;
	IF deltaIn < 0 THEN
		RAISE negativeDelta_exception;
    END IF;
	
	UPDATE Movie SET rank=(rank-deltaIn) WHERE id=sourceIdIn;
	COMMIT;
	UPDATE Movie SET rank=(rank+deltaIn) WHERE id=destinationIdIn;
	COMMIT;
EXCEPTION
	WHEN tooLow_exception THEN
		RAISE_APPLICATION_ERROR(-20001, 'This Movie rank is too low to take from');
	WHEN negativeDelta_exception THEN
		RAISE_APPLICATION_ERROR(-20002, 'Negative deltas are not allowed');
END;
/

COMMIT;

/*
BEGIN
	FOR i IN 1..10000 LOOP
		transferRank(176712, 176711, 0.1);
		COMMIT;
		transferRank(176711, 176712, 0.1);
		COMMIT;
	END LOOP;
END;
/

select rank from Movie where id = 176712;
select rank from Movie where id = 176711;
*/

