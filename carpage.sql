---CREATE SCHEMA CARPAGE---
CREATE SCHEMA CARPAGE;

---FILTERFORM---
CREATE TABLE CARPAGE.FILTERFORM(
	_ID SMALLINT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(15) NOT NULL,
	LABEL VARCHAR(15) NOT NULL,
	OPTIONS VARCHAR(12) [] NOT NULL,
	CONSTRAINT pk_carpage_filterform_id PRIMARY KEY (_ID)
);
INSERT INTO CARPAGE.FILTERFORM VALUES
	(DEFAULT, 'brand', 'brand', ARRAY['honda', 'mazda', 'ford', 'audi', 'mercedes', 'bmw', 'ferrari', 'lamborghini']),
	(DEFAULT, 'model', 'model', ARRAY['2019', '2020', '2021', '2022', '2023']),
	(DEFAULT, 'carType', 'car type', ARRAY['SUV', 'sedan', 'sport', 'hatchback']),
	(DEFAULT, 'transmission', 'transmission', ARRAY['auto', 'manual']),
	(DEFAULT, 'mileage', 'mileage', ARRAY['1000', '10000', '15000']);

---GET CARPAGE---
SELECT JSONB_BUILD_OBJECT(
	'carpage', JSONB_BUILD_OBJECT(
	'filterForm', JSONB_AGG(JSONB_BUILD_OBJECT(
		'_id', F._ID,
		'name', F.NAME,
		'label', F.LABEL,
		'options', F.OPTIONS
	)))
) FROM CARPAGE.FILTERFORM F;

---CREATE FUNCTION GET CARPAGE---
CREATE FUNCTION CARPAGE.GET_CARPAGE()
RETURNS JSONB AS
$$
DECLARE CARPAGE JSONB;
BEGIN
	CARPAGE := JSONB_BUILD_OBJECT(
	'carpage', JSONB_BUILD_OBJECT(
		'filterForm', JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', F._ID,
			'name', F.NAME,
			'label', F.LABEL,
			'options', F.OPTIONS
		)))
	) FROM CARPAGE.FILTERFORM F;
	RETURN CARPAGE;
END;
$$
LANGUAGE PLPGSQL;
