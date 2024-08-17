---CREATE SCHEMA CONTACT PAGE---
CREATE SCHEMA CONTACTPAGE;
---CONTACT---
CREATE TABLE CONTACTPAGE.CONTACT(TITLE VARCHAR(30) NOT NULL, TEXT TEXT);
INSERT INTO CONTACTPAGE.CONTACT VALUES
	('let''s work together', 'to make requests for further information, contact us via our social channels.');

---SCHEDULE---
CREATE TABLE CONTACTPAGE.SCHEDULE(WEEKDAYS VARCHAR(20) NOT NULL, SATURDAY VARCHAR(20) NOT NULL, SUNDAY VARCHAR(20) NOT NULL);
INSERT INTO CONTACTPAGE.SCHEDULE VALUES
	('08:00 am to 18:00 pm', '10:00 am to 16:00 pm', 'closed');

---SHOWROOMS---
CREATE TABLE CONTACTPAGE.SHOWROOMS(
	_ID SMALLINT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(20) NOT NULL,
	ADDRESS TEXT NOT NULL,
	EMAIL VARCHAR(30) NOT NULL,
	PHONE VARCHAR(17) NOT NULL,
	CONSTRAINT pk_showrooms_id PRIMARY KEY (_ID)
);
INSERT INTO CONTACTPAGE.SHOWROOMS VALUES
	(DEFAULT, 'california showroom', '625 Gloria Union, California, United Stated', 'hvac.california@gmail.com', '(+01) 123 456 789  '),
	(DEFAULT, 'new york showroom', '8235 South Ave. Jamestown, NewYork', 'hvac.newyork@gmail.com', '(+01) 123 456 789  '),
	(DEFAULT, 'florida showroom', '497 Beaver Ridge St. Daytona Beach, Florida', 'hvac.florida@gmail.com', '(+01) 123 456 789  ');

---GET CONTACTPAGE IN JSONB---
EXPLAIN ANALYZE SELECT JSONB_BUILD_OBJECT(
	'title', C.TITLE,
	'text', C.TEXT,
	'schedule', JSONB_BUILD_OBJECT(
		'weekdays', S.WEEKDAYS,
		'saturday', S.SATURDAY,
		'sunday',  S.SUNDAY
	),
	'showrooms', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
		'_id', SH._ID,
		'name', SH.NAME,
		'address', SH.ADDRESS,
		'email', SH.EMAIL,
		'phone', SH.PHONE
	)) FROM CONTACTPAGE.SHOWROOMS SH)
) FROM CONTACTPAGE.CONTACT C, CONTACTPAGE.SCHEDULE S;

---CREATE FUNCTION GET CONTACTPAGE---
CREATE FUNCTION CONTACTPAGE.GET_CONTACTPAGE()
RETURNS JSONB AS
$$
DECLARE CONTACTPAGE JSONB;
BEGIN
	CONTACTPAGE := JSONB_BUILD_OBJECT(
		'title', C.TITLE,
		'text', C.TEXT,
		'schedule', JSONB_BUILD_OBJECT(
			'weekdays', S.WEEKDAYS,
			'saturday', S.SATURDAY,
			'sunday',  S.SUNDAY
		),
		'showrooms', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', SH._ID,
			'name', SH.NAME,
			'address', SH.ADDRESS,
			'email', SH.EMAIL,
			'phone', SH.PHONE
		)) FROM CONTACTPAGE.SHOWROOMS SH)
	) FROM CONTACTPAGE.CONTACT C, CONTACTPAGE.SCHEDULE S;
	RETURN CONTACTPAGE;
END;
$$
LANGUAGE PLPGSQL;
