create table Fridge(
	ID integer PRIMARY KEY,
	brand varchar (50),
	model varchar (20),
	street varchar(50),
	city varchar(30),
	state varchar(2),
	zipcode char(5)
	);
	
create table UserType(
	ID integer PRIMARY KEY,
	name varchar (25)
	);
	
create table Owner(
	ID integer PRIMARY KEY,
	userName varchar(50),
	password varchar(35),
	firstName varchar(20),
	lastName varchar(20),
	phoneNumber char(12),
	userTypeID integer REFERENCES UserType(ID),
	fridgeID integer REFERENCES Fridge(ID),
	check (length(password) >= 8),
	check (length(phoneNumber) = 12)
	);

create table Recipe(
	ID integer PRIMARY KEY,
	name varchar (40),
	description varchar (800),
	durationUnit varchar (20) NOT NULL,
	durationNumber Number, 
	check (durationNumber > 0)
	);
	
create table Ingredient(
	ID integer PRIMARY KEY,
	name varchar (20) NOT NULL
	);
	
create table Stock(
	RFID integer PRIMARY KEY,
	expirationDate DATE,
	ingredientID integer REFERENCES Ingredient(ID),
	fridgeID integer REFERENCES Fridge(ID)
	);
	
create table OwnerRecipe(
	ownerID integer NOT NULL,
	recipeID integer NOT NULL
	);

create table RecipeIngredient(
	recipeID integer NOT NULL,
	ingredientID integer NOT NULL,
	unit varchar (20) NOT NULL,
	quantity Number NOT NULL
	);
	
create table OwnerStock(
	ownerID integer NOT NULL,
	stockID integer NOT NULL
	);
	
create sequence fridge_sequence
	start with 100
	increment by 1;
	
create sequence userType_sequence
	start with 100
	increment by 1;
	
create sequence owner_sequence
	start with 100
	increment by 1;
	
create sequence recipe_sequence
	start with 100
	increment by 1;
	
create sequence ingredient_sequence
	start with 100
	increment by 1;
	
create sequence stock_sequence
	start with 100
	increment by 1;


