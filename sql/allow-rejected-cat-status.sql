-- The dashboard uses 0 = pending, 1 = accepted, and 2 = rejected.
-- Run once against the Oracle schema before using the Reject action.
ALTER TABLE cats DROP CONSTRAINT ck_cat_approved;

ALTER TABLE cats ADD CONSTRAINT ck_cat_approved
    CHECK (is_approved IN (0, 1, 2));
