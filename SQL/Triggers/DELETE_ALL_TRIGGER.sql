DROP TRIGGER IF EXISTS restart_item_sequence_after_delete ON items;
DROP TRIGGER IF EXISTS restart_subcategories_sequence_after_delete ON subcategories;
DROP TRIGGER IF EXISTS item_delete_all_info ON Items;
DROP TRIGGER IF EXISTS User_Delete_All ON Users;

DROP FUNCTION IF EXISTS restart_item_sequence();
DROP FUNCTION IF EXISTS restart_subcategories_sequence();
DROP FUNCTION IF EXISTS func_for_delete_from_items_trigger();
DROP FUNCTION IF EXISTS func_for_delete_from_users_trigger();



-- ITEMS
CREATE OR REPLACE FUNCTION restart_item_sequence() RETURNS TRIGGER AS $$
BEGIN

  IF ((select count(*) from items) = 0) THEN
    ALTER SEQUENCE items_id_seq RESTART WITH 1;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER restart_item_sequence_after_delete
  AFTER DELETE ON items
    EXECUTE PROCEDURE restart_item_sequence();

-- SUBCATEGORIES
CREATE OR REPLACE FUNCTION restart_subcategories_sequence() RETURNS TRIGGER AS $$
BEGIN

  IF ((select count(*) from subcategories) = 0) THEN
    ALTER SEQUENCE subcategories_id_seq RESTART WITH 1;
  END IF;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER restart_subcategories_sequence_after_delete
  AFTER DELETE ON subcategories
    EXECUTE PROCEDURE restart_subcategories_sequence();


--------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION func_for_delete_from_items_trigger() RETURNS TRIGGER AS $$
BEGIN

  DELETE FROM Item_Subcategory WHERE Item_Subcategory.Item_ID = OLD.ID;
  DELETE FROM Item_User WHERE Item_User.Item_ID = OLD.ID;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER item_delete_all_info
  BEFORE DELETE ON Items FOR EACH ROW
    EXECUTE PROCEDURE func_for_delete_from_items_trigger();
---------------------------------------------------------------------------------------------------------------

 ---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION func_for_delete_from_users_trigger() RETURNS TRIGGER AS $$
 DECLARE _User_Name VARCHAR(255);
BEGIN

   _User_Name := old.User_Name;

  DELETE
  FROM Items
  WHERE ID IN
        (
          SELECT ID
          FROM Items JOIN Item_User ON ID = Item_ID
          WHERE User_Name = _User_Name
        );

  DELETE
  FROM Item_User
  WHERE Item_User.User_name = old.User_name;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER User_Delete_All
  BEFORE DELETE ON Users FOR EACH ROW
    EXECUTE PROCEDURE func_for_delete_from_users_trigger();
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION func_for_delete_from_categories_trigger() RETURNS TRIGGER AS $$
BEGIN

  DELETE FROM subcategory_category
  WHERE Category_Name = OLD.Name;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Categories_Delete_All
  BEFORE DELETE ON Categories FOR EACH ROW
    EXECUTE PROCEDURE func_for_delete_from_categories_trigger();
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION func_for_delete_from_subcategories_trigger() RETURNS TRIGGER AS $$
BEGIN

  DELETE FROM subcategory_category
  WHERE Subcategory_ID = OLD.ID;

  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Subcategories_Delete_All
  BEFORE DELETE ON Subcategories FOR EACH ROW
    EXECUTE PROCEDURE func_for_delete_from_subcategories_trigger();
---------------------------------------------------------------------------------------------------------------