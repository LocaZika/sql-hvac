-----CHECK UNIQUE COLUMN ON PARTITIONS-----
---CREATE TRIGGER FUNCTION TO CHECK UNIQUE ON NAME OR AGE---
CREATE FUNCTION CHECK_UNIQUE_NAME_AGE()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS(
		SELECT 1 FROM CUSTOMERS WHERE NAME = NEW.NAME OR AGE = NEW.AGE
	) THEN RAISE EXCEPTION 'Duplicate name or age found!';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

---CREATE TRIGGER ON ALL PARTITION---
CREATE TRIGGER CHECK_NAME_AGE_TRIGGER
BEFORE INSERT OR UPDATE ON CUSTOMERS
FOR EACH ROW EXECUTE FUNCTION CHECK_UNIQUE_NAME_AGE();
