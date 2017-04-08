-- CS 342
-- Questions 1 of Homework 08
-- Beka Agava

SET SERVEROUTPUT ON;

-- Insert results into this table.
CREATE TABLE RankLog (
  id INTEGER,
  movieId INTEGER,
  movieName VARCHAR(100),
  userId VARCHAR(20),
  updateDate DATE,
  originalRank NUMBER(10,2), 
  modifiedRank NUMBER(10,2),
  PRIMARY KEY (id)
 );

-- log sequence
CREATE SEQUENCE log_seq
START WITH 1 
INCREMENT BY 1;

-- Rank update trigger
CREATE OR REPLACE TRIGGER rankUpdate AFTER UPDATE OF rank ON Movie FOR EACH ROW
BEGIN
	INSERT INTO RankLog VALUES (log_seq.nextval, :OLD.id, :OLD.name, user, sysdate, :OLD.rank, :NEW.rank);
END;
/

-- Testing Shadow Log
UPDATE Movie
SET rank = 3.4
WHERE id = 116907;

UPDATE Movie
SET rank = 4
WHERE id IN (238071, 238072, 238073, 238074, 238075);

SELECT * FROM RankLog;

DROP SEQUENCE log_seq;
DROP TABLE RankLog;