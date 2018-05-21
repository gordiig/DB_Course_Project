-- Drop all tables
DROP TABLE IF EXISTS Item_User;
DROP TABLE IF EXISTS Item_Subcategory;
DROP TABLE IF EXISTS Subcategory_Category;
DROP TABLE IF EXISTS User_University;
DROP TABLE IF EXISTS Item_University;
DROP TABLE IF EXISTS Items;
DROP TABLE IF EXISTS Subcategories;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Universities;

-- Creating
CREATE TABLE Items
(
  ID SERIAL PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Date_added DATE DEFAULT current_date NOT NULL,
  Price INTEGER CONSTRAINT positive_price CHECK (Price > 0),
  About VARCHAR(1023),
  Image VARCHAR(100000),
  Is_Sold BOOLEAN NOT NULL DEFAULT FALSE,
  Is_Exchangeable BOOLEAN NOT NULL DEFAULT FALSE,

  CONSTRAINT with_price_or_exchangeable CHECK ((Price IS NOT NULL) OR Is_Exchangeable)
);

CREATE TABLE Subcategories
(
  ID SERIAL PRIMARY KEY,
  Name VARCHAR(255) NOT NULL
);

CREATE TABLE Categories
(
  Name VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Users
(
  User_Name VARCHAR(31) DEFAULT CONCAT('USER', cast(random()*10000 AS TEXT)) PRIMARY KEY,
  First_Name VARCHAR(63),
  Last_Name VARCHAR(63),
  Date_Of_Registration DATE DEFAULT current_date NOT NULL,
  Password VARCHAR(127) NOT NULL CONSTRAINT password_len CHECK (length(Password) >= 6),
  Image VARCHAR(100000),
  Phone_Number VARCHAR(63) NOT NULL,
  EMAIL VARCHAR(127) NOT NULL CONSTRAINT contains_email_characters CHECK(EMAIL LIKE '%@%.%'),
  City VARCHAR(63) NOT NULL
);

CREATE TABLE Universities
(
  ID SERIAL PRIMARY KEY,
  Full_Name VARCHAR(127) NOT NULL,
  Small_Name VARCHAR(32)
);

  -- Connections
CREATE TABLE Item_User
(
  Item_ID INT PRIMARY KEY REFERENCES Items(ID),
  User_Name VARCHAR(31) REFERENCES Users(User_Name)
);

CREATE TABLE Item_Subcategory
(
  Item_ID INT PRIMARY KEY REFERENCES Items(ID),
  Subcategory_ID INT[]
);

CREATE TABLE Subcategory_Category
(
  Subcategory_ID INT PRIMARY KEY REFERENCES Subcategories(ID),
  Category_Name VARCHAR(255) REFERENCES Categories(Name)
);

CREATE TABLE User_University
(
  User_Name VARCHAR(31) REFERENCES Users(User_Name),
  University_ID INT REFERENCES Universities(ID)
);

CREATE TABLE Item_University
(
  Item_ID INT PRIMARY KEY REFERENCES Items(ID),
  University_ID INT REFERENCES Universities(ID)
);
