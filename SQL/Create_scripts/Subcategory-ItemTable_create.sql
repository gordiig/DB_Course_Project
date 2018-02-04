DROP TABLE IF EXISTS Subcategory_ItemTable;

CREATE TABLE Subcategory_ItemTable
(
  Subcategory_Name VARCHAR(255) REFERENCES subcategory(name),
  Item_Table_ID INT REFERENCES itemtablenames(id)
);