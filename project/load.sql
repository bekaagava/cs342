-- Load the RFID fridge database. 

-- Drop the previous table declarations.
@&rfidDB\drop         
commit;
-- Reload the table declarations.
@&rfidDB\schema
commit;
-- Load the table data.
@&rfidDB\data
commit;
