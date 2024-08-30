---CREATE USERS SCHEMA---
CREATE SCHEMA USERS;
---CREATE USER DEFINED DATA TYPE---
CREATE DOMAIN USERS.PHONE_TYPE AS VARCHAR(20) NOT NULL CHECK (VALUE ~ '^\+?[(\+)?[0-9\s\-]+$');

CREATE DOMAIN USERS.EMAIL_TYPE AS VARCHAR(30) NOT NULL CHECK (VALUE ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

---CREATE ENUMS---
CREATE TYPE USERS.ACCOUNT_TYPE AS ENUM ('local', 'google');


---CREATE CUSTOMER TABLE---
CREATE TABLE USERS.CUSTOMERS(
	ID INT GENERATED ALWAYS AS IDENTITY,
	EMAIL EMAIL_TYPE,
	PASSWORD TEXT NOT NULL,
	NAME VARCHAR(50) NOT NULL,
	PHONE PHONE_TYPE,
	ADDRESS TEXT NOT NULL,
	ACCOUNT_TYPE USERS.ACCOUNT_TYPE NOT NULL,
	IS_ACTIVE BOOLEAN NOT NULL DEFAULT FALSE,
	CODE_ID TEXT NOT NULL,
	CODE_EXPIRE TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CREATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UPDATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT PK_CUSTOMER_ID_CREATED_AT PRIMARY KEY (ID, CREATED_AT)
) PARTITION BY RANGE (CREATED_AT);

INSERT INTO USERS.CUSTOMERS(EMAIL, PASSWORD, NAME, PHONE, ADDRESS, ACCOUNT_TYPE, IS_ACTIVE, CODE_ID)
VALUES ('admin@mail.com', '123', 'admin', '015348975', 'HN', 'local', true, 'code id in here');

TRUNCATE TABLE USERS.CUSTOMERS;

DROP TABLE USERS.CUSTOMERS;

CREATE TABLE CUSTOMERS_2024 PARTITION OF USERS.CUSTOMERS FOR VALUES FROM ('01-01-2024') TO ('31-12-2024');
CREATE TABLE CUSTOMERS_DEFAULT PARTITION OF USERS.CUSTOMERS DEFAULT;

---FUNCTION GENERATE PARTITION TABLE BY CREATED_AT---
CREATE FUNCTION USERS.CREATE_CUSTOMERS_PARTITION_TABLE()
RETURNS VOID
AS $$
DECLARE
	YEAR_OF_CURRENT_DATE SMALLINT;
	PARTITION_NAME TEXT;
BEGIN
	YEAR_OF_CURRENT_DATE := EXTRACT(YEAR FROM CURRENT_DATE);
	PARTITION_NAME := 'customers_' || YEAR_OF_CURRENT_DATE;
	EXECUTE FORMAT('
		CREATE TABLE %I PARTITION OF USERS.CUSTOMERS FOR VALUES FROM (%L) TO (%L)
	', PARTITION_NAME, '01-01-' || YEAR_OF_CURRENT_DATE, '31-12-' || YEAR_OF_CURRENT_DATE);
END;
$$ LANGUAGE PLPGSQL;

SELECT USERS.CREATE_CUSTOMERS_PARTITION_TABLE();

---CREATE INDEXES---
CREATE INDEX IDX_CUSTOMER_ID ON USERS.CUSTOMERS(ID);

CREATE INDEX IDX_CUSTOMER_EMAIL_PASSWORD ON USERS.CUSTOMERS(EMAIL, PASSWORD);

---CREATE TRIGGER FUNCTION TO CHECK UNIQUE ON EMAIL OR PHONE---
CREATE FUNCTION USERS.CHECK_UNIQUE_EMAIL_PHONE()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS(
		SELECT 1 FROM USERS.CUSTOMERS WHERE EMAIL = NEW.EMAIL OR PHONE = NEW.PHONE
	) THEN RAISE EXCEPTION 'Email or Phone was existed!';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP FUNCTION CHECK_UNIQUE_EMAIL_PHONE;

---CREATE TRIGGER ON ALL PARTITION---
CREATE TRIGGER USERS.CHECK_EMAIL_PHONE_TRIGGER
BEFORE INSERT ON USERS.CUSTOMERS
FOR EACH ROW EXECUTE FUSERSCHECK_UNIQUE_EMAIL_PHONE();

SELECT * FROM USERS.CUSTOMERS where id = 2;





