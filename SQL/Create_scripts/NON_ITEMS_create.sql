-- Dropping before create
DROP TABLE IF EXISTS Category_Subcategory;
DROP TABLE IF EXISTS Subcategory_ItemTable;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Subcategory;
DROP TABLE IF EXISTS ItemTableNames;


-- Creating all non-items tables
CREATE TABLE Category
(
  Name VARCHAR(255) PRIMARY KEY,
  Img_Link VARCHAR(1023)
);

CREATE TABLE Subcategory
(
  Name VARCHAR(255) PRIMARY KEY,
  Img_Link VARCHAR(1023)
);

CREATE TABLE ItemTableNames
(
  ID INT PRIMARY KEY,
  Table_Name VARCHAR(255)
);

CREATE TABLE Category_Subcategory
(
  Category_Name VARCHAR(255) REFERENCES category(name),
  Subcategory_Name VARCHAR(255) REFERENCES subcategory(name)
);

CREATE TABLE Subcategory_ItemTable
(
  Subcategory_Name VARCHAR(255) REFERENCES subcategory(name),
  Item_Table_ID INT REFERENCES itemtablenames(id)
);