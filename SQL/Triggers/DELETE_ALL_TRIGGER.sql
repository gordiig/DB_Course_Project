DROP TRIGGER IF EXISTS restart_item_sequence_after_delete ON items;
DROP TRIGGER IF EXISTS restart_subcategories_sequence_after_delete ON subcategories;
DROP TRIGGER IF EXISTS delete_from_item_after_delete_from_item_user ON item_user;
-- DROP TRIGGER IF EXISTS restart_users_sequence_after_delete ON users;
DROP FUNCTION IF EXISTS restart_item_sequence();
DROP FUNCTION IF EXISTS restart_subcategories_sequence();
DROP FUNCTION IF EXISTS delete_from_item();
-- DROP FUNCTION IF EXISTS restart_users_sequence();

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


-- DELETE FROM item_user AFTER DELETE IN items
CREATE OR REPLACE FUNCTION delete_from_item() RETURNS TRIGGER AS $$
BEGIN

  DELETE FROM items WHERE ID = old.item_ID;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_from_item_after_delete_from_item_user
  AFTER DELETE ON item_user FOR EACH ROW
    EXECUTE PROCEDURE delete_from_item();

-- -- USERS
-- CREATE OR REPLACE FUNCTION restart_users_sequence() RETURNS TRIGGER AS $$
-- BEGIN
--
--   IF ((select count(*) from users) = 0) THEN
--     ALTER SEQUENCE users_id_seq RESTART WITH 1;
--   END IF;
--
--   RETURN NULL;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- CREATE TRIGGER restart_users_sequence_after_delete
--   AFTER DELETE ON users
--     EXECUTE PROCEDURE restart_users_sequence();