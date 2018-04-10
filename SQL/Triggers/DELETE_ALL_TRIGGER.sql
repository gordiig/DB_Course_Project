DROP TRIGGER IF EXISTS restart_item_sequence_after_delete ON items;
DROP TRIGGER IF EXISTS restart_subcategories_sequence_after_delete ON subcategories;
-- DROP TRIGGER IF EXISTS restart_users_sequence_after_delete ON users;
DROP FUNCTION IF EXISTS restart_item_sequence();
DROP FUNCTION IF EXISTS restart_subcategories_sequence();
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