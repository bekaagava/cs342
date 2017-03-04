-- Load the RFID fridge database. 
-- See ../README.md for details.

-- Drop the previous table declarations.
@&baa8\drop         
commit;
-- Reload the table declarations.
@&baa8\schema
commit;
-- Load the table data.
@&baa8\data
commit;