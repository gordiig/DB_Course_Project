CREATE OR REPLACE FUNCTION add_to_Category_Subcategory(category_ VARCHAR(255), subcategoryName VARCHAR(255)) RETURNS VOID AS $$
  BEGIN

    WITH newID AS
    (
      INSERT INTO Subcategories (Name)
        VALUES (subcategoryName)
        RETURNING ID
    )
    INSERT INTO Subcategory_Category
      VALUES ((SELECT ID FROM newID), category_);

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_to_User_Item(username VARCHAR(31), itemId int) RETURNS VOID AS $$
  BEGIN

      INSERT INTO item_user
      VALUES(itemId, username);

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_to_Item_Subcategory(_itemId int, _subcategoryIDs int[]) RETURNS VOID AS $$
DECLARE isThere INT;
  BEGIN

    SELECT count(*)
    FROM Item_Subcategory
    WHERE Item_Subcategory.Item_Id = _itemId
    INTO isThere;

    IF isThere = 0
    THEN
      INSERT INTO Item_Subcategory
        VALUES (_itemId, _subcategoryIDs);

      RETURN;
    END IF;

--     SELECT Subcategory_ID
--     FROM Item_Subcategory
--     WHERE Item_Subcategory.Item_Id = _itemId
--     INTO subcats;
--
--     FOR i IN 1..array_length(_subcategoryIDs, 1)
--     LOOP
--
--       IF (array_position(subcats, _subcategoryIDs[i]) IS NULL) AND (_subcategoryIDs[i] IS NOT NULL)
--       THEN
--         subcats = array_append(subcats, _subcategoryIDs[i]);
--       END IF;
--
--     END LOOP;

    UPDATE Item_Subcategory SET Subcategory_ID = _subcategoryIDs
    WHERE Item_ID = _itemId;

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_Item(_username VARCHAR(31), _password VARCHAR(127), _name VARCHAR(255),
                                    _price INT, _about VARCHAR(1023), _img VARCHAR(100000), _subcats INT[])
RETURNS INT AS $$
DECLARE newID INT;
  BEGIN

    IF (SELECT count(*) FROM Users WHERE user_name = _username AND password = _password) = 0 THEN
      RETURN -1;
    END IF;

    INSERT INTO Items (Name, Price, About, Image)
    VALUES (_name, _price, _about, _img)
    RETURNING ID INTO newID;

    EXECUTE add_to_User_Item(_username, newID);
    EXECUTE add_to_Item_Subcategory(newID, _subcats);

    RETURN 1;

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION edit_Item(_ID INT, _name VARCHAR(255), _price INT, _about VARCHAR(1023),
                                     _subcats INT[], _isSold BOOLEAN)
RETURNS INT AS $$
BEGIN

  UPDATE Items
  SET Name = _name, Price = _price, About = _about, Is_Sold = _isSold
  WHERE ID = _id;

  EXECUTE add_to_Item_Subcategory(_ID, _subcats);

  RETURN 1;
END;
$$ LANGUAGE plpgsql;
