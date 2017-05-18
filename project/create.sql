-- Create the RFID Fridge user and database. 

-- Create the user. 
DROP USER rfidDB CASCADE;
CREATE USER rfidDB
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
	TO rfidDB;

-- Connect to the user's account/schema.
CONNECT rfidDB/seven;

-- Set up the Oracle directory for the dump database feature.
-- Use Oracle directories for input/output files to avoid permissions problems. (?)
-- This is needed both to create and to load the *.dmp files.

DROP DIRECTORY exp_dir;
CREATE DIRECTORY exp_dir AS 'C:\Users\baa8\Documents\project';
GRANT READ, WRITE ON DIRECTORY exp_dir TO rfidDB;

-- Load the database from the dump file using:
--impdp rfidDB/seven parfile=rfidDB.par

-- Create the database.
DEFINE rfidDB=C:\Users\baa8\Documents\project
@&rfidDB\load

