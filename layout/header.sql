-- Create Database Navbar
CREATE TABLE UI.NAVBAR(
	ID INT GENERATED ALWAYS AS IDENTITY,
	CONSTRAINT PK_NAVBAR_ID PRIMARY KEY (ID)
);
-- Add Columns
ALTER TABLE UI.NAVBAR
ADD COLUMN NAME VARCHAR(10) NOT NULL,
ADD COLUMN PATH VARCHAR(11) NOT NULL;
-- Insert Data
INSERT INTO UI.NAVBAR
	VALUES
		(DEFAULT, 'home', '/'),
		(DEFAULT, 'cars', '/cars'),
		(DEFAULT, 'about', '/about'),
		(DEFAULT, 'contact', '/contact');
-- Check Data
select * from ui.navbar;
