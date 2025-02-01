DROP TABLE IF EXISTS Contacts;
CREATE TABLE IF NOT EXISTS Contacts (ContactId INTEGER PRIMARY KEY, CompanyName TEXT, ContactName TEXT);
INSERT INTO Contacts (ContactID, CompanyName, ContactName) VALUES (1, 'Alfreds Futterkiste', 'Maria Anders'), (4, 'Around the Horn', 'Thomas Hardy'), (11, 'Bs Beverages', 'Victoria Ashworth'), (13, 'Bs Beverages', 'Random Name');
