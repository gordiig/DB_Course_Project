CREATE OR REPLACE FUNCTION add_to_User_Item(username VARCHAR(31), password_ VARCHAR(127), itemId int) RETURNS INT AS $$
  BEGIN

    IF (SELECT count(*) FROM Users WHERE user_name = username AND password_ = password) = 0 THEN
      DELETE FROM Items WHERE id = itemId;
      RETURN -1;
    ELSE
      INSERT INTO item_user
      VALUES(itemId, username);
      RETURN 0;
    END IF;

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_to_Item_Subcategory(itemId int, subcategoryId int) RETURNS VOID AS $$
  BEGIN

    INSERT INTO item_subcategory
      VALUES (itemId, subcategoryId);

  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_to_Items(username VARCHAR(31), password VARCHAR(127), item Items) RETURNS VOID AS $$
  BEGIN

    item

  END;
$$ LANGUAGE plpgsql;

