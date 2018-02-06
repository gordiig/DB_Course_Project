INSERT INTO items (Name, price, phone_number)
    VALUES ('Phone', 1000, '89152370506'),
      ('Car', 30000, '9999999'),
      ('Nothing', 0, '0'),
      ('iPhone', 2000, '9898');

INSERT INTO subcategories (name)
    VALUES ('Phones'),
      ('Cars'),
      ('Nothing');

INSERT INTO categories (name)
    VALUES ('Electronics'),
      ('Transport'),
      ('Nothing');

INSERT INTO users (user_name, first_name, last_name, date_of_registration, password, phone_number, email, city)
    VALUES ('DJ', 'John', 'Johnson', '2012-02-03', 'qwerty', '999999', 'hehe@hehe.com', 'New York'),
      ('NaGiBaToR', 'Denis', 'Ebat', '2010-12-04', 'OPA', '916', 'vasya@mail.ru', 'Saransk');

INSERT INTO item_user
    VALUES (1, 1),
      (2, 2),
      (3, 1),
      (4, 2);

INSERT INTO item_subcategory
    VALUES (1, 1),
      (2, 2),
      (3, 3),
      (4, 1);

INSERT INTO subcategory_category
    VALUES (1, 'Electronics'),
      (2, 'Transport'),
      (3, 'Nothing');

SELECT *
FROM items;

SELECT *
FROM subcategories;

SELECT *
FROM categories;

SELECT *
FROM users;

SELECT *
FROM item_user;

SELECT *
FROM item_subcategory;

SELECT *
FROM subcategory_category;

-- All items with category 'Electronics'
SELECT *
FROM items
WHERE items.id IN
      (
        SELECT item_id
        FROM
          (
            SELECT subcategory_id
            FROM categories
              JOIN subcategory_category sc ON categories.name = sc.category_id
            WHERE categories.name = 'Electronics'
          ) AS t JOIN item_subcategory ON item_subcategory.subcategory_id = t.subcategory_id
      );

-- All items by User 'DJ'
Select *
FROM items
WHERE items.id IN
      (
        SELECT user2.item_id
        FROM users JOIN item_user user2 ON users.id = user2.user_id
        WHERE user_name = 'DJ'
      );

DELETE FROM item_user;
DELETE FROM item_subcategory;
DELETE FROM subcategory_category;
DELETE FROM users;
DELETE FROM items;
DELETE FROM categories;
DELETE FROM subcategories;