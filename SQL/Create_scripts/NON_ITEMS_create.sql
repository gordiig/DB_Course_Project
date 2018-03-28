-- Drop all tables
DROP TABLE IF EXISTS Item_User;
DROP TABLE IF EXISTS Item_Subcategory;
DROP TABLE IF EXISTS Subcategory_Category;
DROP TABLE IF EXISTS Items;
DROP TABLE IF EXISTS Subcategories;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Users;

-- Creating
CREATE TABLE Items
(
  ID SERIAL PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Date_added DATE DEFAULT current_date NOT NULL,
  Price MONEY,
  Imgs_Url VARCHAR(1023)
);

CREATE TABLE Subcategories
(
  ID SERIAL PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  Img_Url VARCHAR(1024)
);

CREATE TABLE Categories
(
  Name VARCHAR(255) PRIMARY KEY,
  Img_Url VARCHAR(1024)
);

CREATE TABLE Users
(
  ID SERIAL PRIMARY KEY,
  User_Name VARCHAR(31) DEFAULT CONCAT('USER', cast(random()*10000 AS TEXT)) NOT NULL,
  First_Name VARCHAR(63),
  Last_Name VARCHAR(63),
  Date_Of_Registration DATE DEFAULT current_date NOT NULL,
  Password VARCHAR(127) NOT NULL,
  Img_URL VARCHAR(1023),
  About VARCHAR(1023),
  Phone_Number VARCHAR(63) NOT NULL,
  EMAIL VARCHAR(127) NOT NULL,
  City VARCHAR(63) NOT NULL
);

  -- Connections
CREATE TABLE Item_User
(
  Item_ID INT PRIMARY KEY REFERENCES Items(ID),
  User_ID INT REFERENCES Users(ID)
);

CREATE TABLE Item_Subcategory
(
  Item_ID INT PRIMARY KEY REFERENCES Items(ID),
  Subcategory_ID INT REFERENCES Subcategories(ID)
);

CREATE TABLE Subcategory_Category
(
  Subcategory_ID INT PRIMARY KEY REFERENCES Subcategories(ID),
  Category_ID VARCHAR(255) REFERENCES Categories(Name)
);