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

Cursor c1 
IS
	SELECT street, city, state, zipcode
	FROM Fridge
	WHERE id = fridgeIdIn
	FOR UPDATE; 

v1 Fridge.street%type;
v2 Fridge.city%type;
v3 Fridge.state%type;
v4 Fridge.zipcode%type;

incorrectStreet_exception EXCEPTION;
incorrectCity_exception EXCEPTION;
incorrectState_exception EXCEPTION;
incorrectZipcode_exception EXCEPTION;

BEGIN

	SAVEPOINT startpoint;
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
-- the a single update statement is issued against the table. In order to ensure isolation for 
-- the multiple update statements, this row share table lock is applied so that the updates are done one 
-- at a time and if something goes wrong, everything is rolled back to before any of the update statements.

	OPEN c1;
	
	LOOP
		FETCH c1 into v1, v2, v3, v4;
		EXIT WHEN c1%NOTFOUND;
		UPDATE Fridge SET street = streetIn WHERE CURRENT OF c1;
		UPDATE Fridge SET city = cityIn WHERE CURRENT OF c1;
		UPDATE Fridge SET state = stateIn WHERE CURRENT OF c1;
		UPDATE Fridge SET zipcode = zipcodeIn WHERE CURRENT OF c1;
	END LOOP;
	
	CLOSE c1;

	COMMIT;	
EXCEPTION
	WHEN incorrectStreet_exception THEN
		RAISE_APPLICATION_ERROR(-20001, 'Please provide a non-NULL and accurate value for the street');
		ROLLBACK TO startpoint;
	
	WHEN incorrectCity_exception THEN
		RAISE_APPLICATION_ERROR(-20002, 'Please provide a non-NULL and accurate value for the city');
		ROLLBACK TO startpoint;
	
	WHEN incorrectState_exception THEN
		RAISE_APPLICATION_ERROR(-20003, 'Please provide a non-NULL and accurate value for the state');
		ROLLBACK TO startpoint;
	
	WHEN incorrectZipcode_exception THEN
		RAISE_APPLICATION_ERROR(-20004, 'Please provide a non-NULL and accurate value for the zipcode');
		ROLLBACK TO startpoint;
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
