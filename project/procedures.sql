-- Stored procedures for the RFID database
-- 04/21/2017

SET SERVEROUTPUT ON;

/* multistepTransact is stored procedure that implements a multi-step transaction.
This transaction has all the ACID properties, atomicity is manually applied, and 
isolation, durability and preservation of consistency are provided by the system and
the database design.
Function: Update the address for an already existing fridge that has been moved to a 
new location.
This is relevant for servicing and business recording and decison-making purposes.
*/


CREATE OR REPLACE PROCEDURE  multiStepTransact(fridgeIdIn IN Fridge.id%type, streetIn IN Fridge.street%type,
cityIn IN Fridge.city%type, stateIn IN Fridge.state%type, zipcodeIn IN Fridge.zipcode%type)
AS

incorrectStreet_exception EXCEPTION;
incorrectCity_exception EXCEPTION;
incorrectState_exception EXCEPTION;
incorrectZipcode_exception EXCEPTION;

BEGIN
-- Throw an exception if the input does not contain the full new address for the fridge
	IF streetIn IS NULL THEN
		RAISE incorrectStreet_exception;
	ELSIF cityIn IS NULL THEN 
		RAISE incorrectCity_exception;
	ELSIF stateIn IS NULL THEN
		RAISE incorrectState_exception;
	ELSIF zipcodeIn IS NULL THEN
		RAISE incorrectZipcode_exception;
	END IF;

-- The Row Exclusive Table Lock is issued automatically against the Fridge Table when 
-- the update statements are issued against the table. So it ensures isolation.

	UPDATE Fridge
	SET street = streetIn
	WHERE Fridge.id = fridgeIdIn;
	
	UPDATE Fridge
	SET city = cityIn
	WHERE Fridge.id = fridgeIdIn;
	
	UPDATE Fridge
	SET state = stateIn
	WHERE Fridge.id = fridgeIdIn;
	
	UPDATE Fridge
	SET zipcode = zipcodeIn
	WHERE Fridge.id = fridgeIdIn;
	
-- Commiting at the end and using these exceptions ensures the atomicity of this transaction, because we only want to
-- commit the updates after the entire new address info has been updated
	COMMIT;	
EXCEPTION
	WHEN incorrectStreet_exception THEN
	RAISE_APPLICATION_ERROR(-20001, 'Please provide a non-NULL and accurate value for the street');
	WHEN incorrectCity_exception THEN
	RAISE_APPLICATION_ERROR(-20002, 'Please provide a non-NULL and accurate value for the city');
	WHEN incorrectState_exception THEN
	RAISE_APPLICATION_ERROR(-20003, 'Please provide a non-NULL and accurate value for the state');
	WHEN incorrectZipcode_exception THEN
	RAISE_APPLICATION_ERROR(-20004, 'Please provide a non-NULL and accurate value for the zipcode');

END;
/



-- Tests
-- This should update the address information for the fridge with id = 100
BEGIN 
	multistepTransact(100, '3201 Burton St SE', 'Grand Rapids', 'MI', '49546');
END;
/

SELECT * FROM Fridge WHERE id = 100;

-- This should throw incorrectStreet_exception
BEGIN 
	multistepTransact(101, NULL, 'Grand Rapids', 'MI', '49546');
END;
/

SELECT * FROM Fridge WHERE id = 101;

-- This should throw incorrectCity_exception
BEGIN 
	multistepTransact(102, '3201 Burton St SE', NULL, 'MI', '49546');
END;
/

SELECT * FROM Fridge WHERE id = 102;

-- This should throw incorrectState_exception
BEGIN 
	multistepTransact(103, '3201 Burton St SE', 'Grand Rapids', NULL, '49546');
END;
/

SELECT * FROM Fridge WHERE id = 103;

-- This shold throw incorrectZipcode_exception
BEGIN 
	multistepTransact(104, '3201 Burton St SE', 'Grand Rapids', 'MI', NULL);
END;
/

SELECT * FROM Fridge WHERE id = 104;
