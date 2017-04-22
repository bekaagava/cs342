-- Load the RFID fridge database. 
-- See ../README.md for details.

-- Drop the previous table declarations.
@&rfidDB\drop         
commit;
-- Reload the table declarations.
@&rfidDB\schema
commit;
-- Load the table data.
@&rfidDB\data
commit;