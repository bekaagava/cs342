This document explains how to use the scripts for the RFID database.
This database was created with Oracle SQL syntax.

- create.sql: In the correct path with your database files, run the command @create to create your database user, connect to the account and load the database. The load.sql is run by this script

- load.sql: This drops and reloads table declarations here, and also loads the table data, assuming that you are logged in as the database user, rfiddb. 

- schema.sql: defines the full schema of the database. This is run in the load.sql file.

- data.sql: loads the raw data using INSERT commands. This is run in the load.sql file.

- drop.sql: This drops the database tables and sequences. This is run in the load.sql file.

- procedures.sql: This can be run with the @procedures command after the database has been created. It performs a transaction that allows updates to the address columns of Fridge table.

- queries.sql: This runs some queries on the database. It can be run using @queries command. 

- triggers.sql: This contains two integrity constraints, one that checks whether a stock is already expired, and another that checks that an owner’s fridge id, matches the owner’s stock’s fridge id. It can be run with the @triggers command, after the database has been created.

- rfidDB.par: This creates a dump file and the logs for the dump. It can be run in the terminal following instructions from http://www.oracle.com/technetwork/issue-archive/2009/09-jul/datapump11g2009-quickstart-128718.pdf