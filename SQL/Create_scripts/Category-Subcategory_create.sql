DROP TABLE IF EXISTS Category_Subcategory;

CREATE TABLE Category_Subcategory
(
  Category_Name VARCHAR(255) REFERENCES category(name),
  Subcategory_Name VARCHAR(255) REFERENCES subcategory(name)
);