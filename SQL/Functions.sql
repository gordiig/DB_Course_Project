--------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_to_User_Item(username VARCHAR(31), itemId int) RETURNS VOID AS $$
  BEGIN

      INSERT INTO item_user
      VALUES(itemId, username);

  END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_to_Item_University(itemID INT, universityID INT) RETURNS VOID AS $$
DECLARE isThere INT;
BEGIN

  SELECT count(*)
  FROM Item_University
  WHERE Item_ID = itemID
  INTO isThere;

  IF isThere = 0
  THEN
    INSERT INTO Item_University
    VALUES (itemID, universityID);

    RETURN;
  END IF;

  UPDATE Item_University
  SET University_ID = universityID
  WHERE Item_ID = itemID;

END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION add_to_User_University(username VARCHAR(31), universityID INT) RETURNS VOID AS $$
DECLARE isThere INT;
BEGIN

  SELECT count(*)
  FROM User_University
  WHERE User_Name = username
  INTO isThere;

  IF isThere = 0
  THEN
    INSERT INTO User_University
    VALUES (username, universityID);

    RETURN;
  END IF;

  UPDATE User_University
  SET University_ID = universityID
  WHERE User_Name = username;

END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS add_Item();
CREATE OR REPLACE FUNCTION add_Item(_username VARCHAR(31), _password VARCHAR(127), _name VARCHAR(255),
                                    _price INT, _about VARCHAR(1023), _img VARCHAR(100000), _subcats INT[],
                                    _exchangeable BOOLEAN, _university INT)
RETURNS INT AS $$
DECLARE newID INT;
  BEGIN

    IF (SELECT count(*) FROM Users WHERE user_name = _username AND password = _password) = 0 THEN
      RETURN -1;
    END IF;

    INSERT INTO Items (Name, Price, About, Image, Is_Exchangeable)
    VALUES (_name, _price, _about, _img, _exchangeable)
    RETURNING ID INTO newID;

    EXECUTE add_to_User_Item(_username, newID);
    EXECUTE add_to_Item_Subcategory(newID, _subcats);
    EXECUTE add_to_Item_University(newID, _university);

    RETURN 1;

  END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS edit_Item();
CREATE OR REPLACE FUNCTION edit_Item(_ID INT, _name VARCHAR(255), _price INT, _about VARCHAR(1023),
                                     _subcats INT[], _isSold BOOLEAN, _isEx BOOLEAN, _universityID INT)
RETURNS INT AS $$
BEGIN

  UPDATE Items
  SET Name = _name, Price = _price, About = _about, Is_Sold = _isSold, Is_Exchangeable = _isEx
  WHERE ID = _id;

  EXECUTE add_to_Item_Subcategory(_ID, _subcats);
  EXECUTE add_to_Item_University(_ID, _universityID);

  RETURN 1;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS add_User();
CREATE OR REPLACE FUNCTION add_User(_username VARCHAR(31), _firstName VARCHAR(63), _lastName VARCHAR(63),
                                    _password VARCHAR(127), _phoneNumber VARCHAR(63), _email VARCHAR(127),
                                    _city VARCHAR(63), _universityID INT)
RETURNS INT AS $$
BEGIN

  INSERT INTO Users (User_Name, First_Name, Last_Name, Password, Phone_Number, Email, City)
    VALUES (_username, _firstName, _lastName, _password, _phoneNumber, _email, _city;

  EXECUTE add_to_User_University(_username, _universityID);

  RETURN 1;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS edit_User();
CREATE OR REPLACE FUNCTION edit_User(_username VARCHAR(31), _firstName VARCHAR(63), _lastName VARCHAR(63),
                                    _password VARCHAR(127), _phoneNumber VARCHAR(63), _email VARCHAR(127),
                                    _city VARCHAR(63), _universityID INT)
RETURNS INT AS $$
BEGIN

  UPDATE Users
  SET First_Name = _firstName, Last_Name = _lastName, Password = _password, Phone_Number = _phoneNumber,
    Email = _email, City = _city
  WHERE User_Name = _username;

  EXECUTE add_to_User_University(_username, _universityID);

  RETURN 1;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------------------------------------
