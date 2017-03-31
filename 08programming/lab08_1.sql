-- CS 342
-- Beka Agava
-- Lab 08_1

drop procedure castActor;
CREATE PROCEDURE castActor(actorId IN Actor.id%type, movieId IN Movie.id%type, role IN string) 
IS 
BEGIN
INSERT INTO Role Values (actorId, movieId, role);
END;
/

drop trigger castingTrigger;
CREATE TRIGGER castingTrigger BEFORE INSERT ON Role FOR each row
DECLARE
counter INTEGER;
counter1 INTEGER;
castExists EXCEPTION;
sectionTooBig EXCEPTION;
BEGIN
	SELECT COUNT(*) INTO counter FROM Role
	WHERE actorId = :new.actorId
	AND movieId = :new.movieId;
	IF counter >= 1 THEN 
		raise castExists;
	END IF;
	SELECT COUNT(*) INTO counter1 FROM Role
	WHERE movieId = :new.movieId;
	IF counter1 >= 230 THEN
		raise sectionTooBig;
	END IF;
EXCEPTION
	WHEN castExists THEN
	RAISE_APPLICATION_ERROR(-20001, 'This actor is already cast for this movie');
	WHEN sectionTooBig THEN
	RAISE_APPLICATION_ERROR(-20002, 'This movie already has 230 castings');
END;
/

-- a. Cast George Clooney (# 89558) as “Danny Ocean” in Oceans Eleven (#238072). N.b., he’s already cast in this movie.
BEGIN
castActor(89558, 238072, 'Danny Ocean');
END;
/

-- b. Cast George Clooney as “Danny Ocean” in Oceans Twelve (#238073). N.b., he’s not currently cast in this movie.
BEGIN
castActor(89558, 238073, 'Danny Ocean');
END;
/

-- c. Cast George Clooney as “Danny Ocean” in JFK (#167324). N.b., this movie already has 230 castings.
BEGIN
castActor(89558, 167324, 'Danny Ocean');
END;
/