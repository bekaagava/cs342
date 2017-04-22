-- Triggers for the RFID database
-- 04/21/2017

/* This checks to see make sure the new stock for the fridge is not expired. Since check constraints 
have to be deterministic and sysdate is non-deterministic, the isExpired trigger is used to check inserts.
*/

SET SERVEROUTPUT ON;

DROP TRIGGER ingredientExistsTrigger;

CREATE OR REPLACE TRIGGER isExpiredTrigger BEFORE INSERT ON Stock FOR EACH ROW
DECLARE

isExpired_exception EXCEPTION;

BEGIN
	
	IF :new.expirationDate < SYSDATE THEN
		RAISE isExpired_exception;
	END IF;
	
EXCEPTION
	WHEN isExpired_exception THEN
	RAISE_APPLICATION_ERROR(-20001, 'This stock is expired!');
END;
/

/* This trigger checks to make sure that the stock is being put in the correct 
fridge, that is the fridge assigned to the owner matches the fridge assigned to 
the stock
*/

CREATE OR REPLACE TRIGGER wrongFridgeTrigger BEFORE INSERT ON OwnerStock FOR EACH ROW
DECLARE

counter INTEGER;
invalid_exception EXCEPTION;

BEGIN
	
	SELECT COUNT(*) INTO counter
	FROM Stock s, Owner o
	WHERE :new.ownerID = o.id
	AND :new.stockID = s.RFID
	AND s.fridgeID = o.fridgeID;

	IF counter < 1 THEN
		RAISE invalid_exception;
	END IF;
	
EXCEPTION
	WHEN invalid_exception THEN
	RAISE_APPLICATION_ERROR(-20001, 'This stock is being placed in the wrong fridge!');
END;
/


-- Test: This should fail because the stock is already expired
BEGIN 
	INSERT INTO Stock VALUES(500, '03-Mar-2017', 107, 112);
END;
/

-- This should work because the fridge and the owner match
BEGIN 
	INSERT INTO OwnerStock VALUES(100, 104);
END;
/

-- This should not work because the fridge and the owner do not match
BEGIN 
	INSERT INTO OwnerStock VALUES(100, 130);
END;
/