DELETE FROM Categories;
DELETE FROM Subcategories;

INSERT INTO Categories VALUES
  ('Items for study'),
  ('Transport'),
  ('Services'),
  ('Clothes'),
  ('Food'),
  ('Items for home'),
  ('Electronics'),
  ('Hobby');

SELECT add_to_Category_Subcategory('Items for study', 'Stationery');
SELECT add_to_Category_Subcategory('Items for study', 'Electronics');
SELECT add_to_Category_Subcategory('Items for study', 'Clothes');
SELECT add_to_Category_Subcategory('Items for study', 'Misc');

SELECT add_to_Category_Subcategory('Transport', 'Cars');
SELECT add_to_Category_Subcategory('Transport', 'Motorbikes');
SELECT add_to_Category_Subcategory('Transport', 'Bikes');
SELECT add_to_Category_Subcategory('Transport', 'Skateboards');
SELECT add_to_Category_Subcategory('Transport', 'E-transport');
SELECT add_to_Category_Subcategory('Transport', 'Spare parts');
SELECT add_to_Category_Subcategory('Transport', 'Tools');
SELECT add_to_Category_Subcategory('Transport', 'Misc');

SELECT add_to_Category_Subcategory('Clothes', 'T-shirts');
SELECT add_to_Category_Subcategory('Clothes', 'Jeans');
SELECT add_to_Category_Subcategory('Clothes', 'Pants');
SELECT add_to_Category_Subcategory('Clothes', 'Shoes');
SELECT add_to_Category_Subcategory('Clothes', 'Sneakers');
SELECT add_to_Category_Subcategory('Clothes', 'Hats');
SELECT add_to_Category_Subcategory('Clothes', 'Socks');
SELECT add_to_Category_Subcategory('Clothes', 'Sport wear');
SELECT add_to_Category_Subcategory('Clothes', 'Accessories');
SELECT add_to_Category_Subcategory('Clothes', 'Misc');

SELECT add_to_Category_Subcategory('Services', 'Cleaning');
SELECT add_to_Category_Subcategory('Services', 'Repairing');
SELECT add_to_Category_Subcategory('Services', 'Cooking');
SELECT add_to_Category_Subcategory('Services', 'Solving');
SELECT add_to_Category_Subcategory('Services', 'Misc');

SELECT add_to_Category_Subcategory('Food', 'Fruits');
SELECT add_to_Category_Subcategory('Food', 'Vegetables');
SELECT add_to_Category_Subcategory('Food', 'Meat');
SELECT add_to_Category_Subcategory('Food', 'Fish');
SELECT add_to_Category_Subcategory('Food', 'Noodles');
SELECT add_to_Category_Subcategory('Food', 'Ready');
SELECT add_to_Category_Subcategory('Food', 'Snacks');
SELECT add_to_Category_Subcategory('Food', 'Expired');
SELECT add_to_Category_Subcategory('Food', 'Misc');

SELECT add_to_Category_Subcategory('Items for home', 'Electronics');
SELECT add_to_Category_Subcategory('Items for home', 'Furniture');
SELECT add_to_Category_Subcategory('Items for home', 'Tools');
SELECT add_to_Category_Subcategory('Items for home', 'Misc');

SELECT add_to_Category_Subcategory('Electronics', 'Phones');
SELECT add_to_Category_Subcategory('Electronics', 'Tablets');
SELECT add_to_Category_Subcategory('Electronics', 'Items for gadgets');
SELECT add_to_Category_Subcategory('Electronics', 'PCs');
SELECT add_to_Category_Subcategory('Electronics', 'Laptops');
SELECT add_to_Category_Subcategory('Electronics', 'Items for computer');
SELECT add_to_Category_Subcategory('Electronics', 'Audio/Video');
SELECT add_to_Category_Subcategory('Electronics', 'Misc');

SELECT add_to_Category_Subcategory('Hobby', 'Radioparts');
SELECT add_to_Category_Subcategory('Hobby', 'Fishing');
SELECT add_to_Category_Subcategory('Hobby', 'Books');
SELECT add_to_Category_Subcategory('Hobby', 'Sport');
SELECT add_to_Category_Subcategory('Hobby', 'Music');
SELECT add_to_Category_Subcategory('Hobby', 'Misc');