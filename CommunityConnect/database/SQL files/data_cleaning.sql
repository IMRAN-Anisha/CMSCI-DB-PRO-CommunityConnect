PRAGMA foreign_keys = ON;

-- Delete users with UserID 6 to 10
DELETE FROM Users
WHERE UserID BETWEEN 6 AND 10;
