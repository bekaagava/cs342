-- CS 342
-- Beka Agava
-- RFID database queries
-- 03/31/2017

@create

/*
Creating Recipes View. 
- Function: This view provides information such as name, description, recipe duration, required ingredients
and ingredient quantity on all of the recipes in the database, regardless of owner.
- Users: There are three user types in the database: lab, restaurant or domestic; restaurant or domestic users 
will use the view to stock their fridges based on the ingredients listed in the recipes, because it only provides food recipes.
- Type of View: I chose a MATERIALIZED VIEW because it is read-only, and I do not want the user to be able to modify the 
base tables through the view.
*/
DROP MATERIALIZED VIEW Recipes;

CREATE MATERIALIZED VIEW Recipes
	AS
	(
		SELECT r.ID recipeID, r.name recipeName, r.description recipeDescription, r.durationUnit recipeDurationUnit, r.durationNumber recipeDurationNumber, i.ID ingredientID, i.name ingredientName, ri.unit recipeIngredientUnit, ri.quantity recipeIngredientQuantity
		FROM Recipe r 
		JOIN RecipeIngredient ri ON r.ID = ri.recipeID
		JOIN Ingredient i ON ri.ingredientID = i.ID AND i.kind = 'food'
	);

/*
Significant Query #1
- Function: Returns the number of users of the refrigerator app, categorized by the type of user
- User: The creator of the application would care about the number of people using the app, and what types of
		users they are.
- Demonstrates ability to use aggregate statistics on grouped data.
- I could have designed this query using the "WHERE" clause instead of the "JOIN" but I chose the "JOIN"
  for better readability.
*/
SELECT u.name User_Type, COUNT(o.ID) User_Number 
FROM UserType u
JOIN Owner o ON u.ID = o.userTypeID
GROUP BY u.name
ORDER BY COUNT(o.ID) DESC;

/*
Significant Query #2
- Function: Returns the users who have NULL values for their phone numbers.
- User: The database administrator would care about this for security purposes and can send
        messages to the users through the app to include their phone numbers, as phone numbers 
		can be used to improve information security.
- Demonstrates ability to do proper NULL comparisons
*/
SELECT ID, userName, fridgeID 
FROM Owner
WHERE phoneNumber IS NULL
ORDER BY fridgeID;

/*
Significant Query #3
- Function: Returns the three oldest items in the fridge with ID '119' and what recipes they are used in. 
- User: The users of the fridge with the ID '119' can be notified of the items that might need 
        to be replaced soon.
- Demonstrates ability to join at least four tables and combine inner joins with outer joins.
- I could have designed this query using the "WHERE" clause for the join instead of the "JOIN" clause but I chose the "JOIN"
  for better readability.
*/
SELECT * FROM 
(SELECT s.RFID Item_ID, s.expirationDate Expiration_Date, i.name Item_Name, r.name Recipe_Name
FROM Fridge f 
INNER JOIN Stock s ON f.ID = s.fridgeID AND s.fridgeID = 119 
INNER JOIN Ingredient i ON s.ingredientID = i.ID
LEFT OUTER JOIN RecipeIngredient ri ON i.ID = ri.ingredientID
LEFT OUTER JOIN Recipe r ON ri.recipeID = r.ID
ORDER BY s.expirationDate)
WHERE ROWNUM <= 3;

/*
Significant Query #4
- Function: Returns the users of the fridge with ID = 119 who do not currently have items in it.
- User: The users of the fridge might like to know who is not currently using it
- Demonstrates ability to use nested select statement.
*/
SELECT o.firstName|| ' ' || o.lastName Name
FROM Owner o
WHERE o.fridgeID = 119
AND NOT EXISTS (SELECT * FROM OwnerStock os WHERE o.ID = os.ownerID);

/*
Significant Query #5
- Function: Returns the owners of the items in the fridge with ID = 119
- User: The users of the fridge can find out who owns an item in the fridge, and records with matching RFIDs indicate
		that the item is being shared amongst those users.
- Demostrates ability to use self-join using tuple variables and join of at least four tables 
- I could have designed this query using the "WHERE" clause for the join instead of the "JOIN" clause but I chose the "JOIN"
  for better readability.
*/
SELECT o.firstName|| ' ' || o.lastName fullName, s.RFID Item_RFID, i.name Item_Name
FROM OwnerStock os
JOIN OwnerStock os1 ON os.ownerID = os1.ownerID AND os.stockID = os1.stockID
JOIN Owner o ON os.ownerID = o.ID
JOIN Stock s ON os.stockID = s.RFID
JOIN Ingredient i ON s.ingredientID = i.ID
WHERE s.fridgeID = 119
ORDER BY Item_RFID;
