-- USERS
ALTER TABLE Users
    ADD CONSTRAINT password_len CHECK (length(Password) >= 6);

ALTER TABLE Users
    ADD CONSTRAINT contains_email_characters CHECK(EMAIL LIKE '%@%.%');


-- ITEMS
ALTER TABLE Items
    ADD CONSTRAINT positive_price CHECK (Price > 0);

ALTER TABLE Items
    ADD CONSTRAINT with_price_or_exchangeable CHECK ((Price IS NOT NULL) OR Is_Exchangeable);
