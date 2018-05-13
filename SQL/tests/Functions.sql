CREATE OR REPLACE FUNCTION add_to_User_Item(username VARCHAR(31), itemId int) RETURNS VOID AS $$
  BEGIN

      INSERT INTO item_user
      VALUES(itemId, username);

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_to_Item_Subcategory(_itemId int, _subcategoryIDs int[]) RETURNS VOID AS $$
DECLARE isThere INT; subcats INT[];
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

    SELECT Subcategory_ID
    FROM Item_Subcategory
    WHERE Item_Subcategory.Item_Id = _itemId
    INTO subcats;

    FOR i IN 1..array_length(_subcategoryIDs, 1)
    LOOP

      IF (array_position(subcats, _subcategoryIDs[i]) IS NULL) AND (_subcategoryIDs[i] IS NOT NULL)
      THEN
        subcats = array_append(subcats, _subcategoryIDs[i]);
      END IF;

    END LOOP;

    UPDATE Item_Subcategory SET Subcategory_ID = subcats
    WHERE Item_ID = itemId;

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

