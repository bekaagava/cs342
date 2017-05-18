-- This file drops all the tables and sequences in the RFID database

drop table OwnerStock;
drop table RecipeIngredient;
drop table OwnerRecipe;
drop table Stock;
drop table Ingredient;
drop table Recipe;
drop table Owner;
drop table UserType;
drop table Fridge;

drop sequence fridge_sequence;
drop sequence userType_sequence;
drop sequence owner_sequence;
drop sequence recipe_sequence;
drop sequence ingredient_sequence;
drop sequence stock_sequence;
