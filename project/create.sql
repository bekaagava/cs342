-- Create the RFID Fridge user and database. 
-- See ../README.txt for details.

-- Create the user. 
DROP USER baa8 CASCADE;
CREATE USER baa8 
	IDENTIFIED BY seven
	QUOTA 5M ON System;
GRANT 
	CONNECT,
	CREATE TABLE,
	CREATE SESSION,
	CREATE SEQUENCE,
	CREATE VIEW,
	CREATE MATERIALIZED VIEW,
	CREATE PROCEDURE,
	CREATE TRIGGER,
	UNLIMITED TABLESPACE
	TO baa8;

-- Connect to the user's account/schema.
CONNECT baa8/seven;

-- Create the database.
DEFINE baa8=S:\cs342\project
@&baa8\load