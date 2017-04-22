-- Triggers for the RFID database
-- 04/21/2017

/* This checks to see make sure the new ingredient does not already exist in the 
table. This is hard to check with a regular table constraint
*/

SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER ingredientExistsTrigger BEFORE INSERT ON Ingredient FOR EACH ROW
DECLARE
counter INTEGER;
alreadyExists_exception EXCEPTION;

BEGIN
	SELECT COUNT(*) INTO counter
	FROM Ingredient i
	WHERE i.name = :new.name;
	
	IF counter > 0 THEN
		RAISE alreadyExists_exception;
	END IF;
	
EXCEPTION
	WHEN alreadyExists_exception THEN
	RAISE_APPLICATION_ERROR(-20001, 'This ingredient already exists!');
END;
/

-- Test: This should fail
BEGIN 
	INSERT INTO Ingredient VALUES(500, 'chicken', 'food');
END;
/
