CREATE TABLE HOMEPAGE.HERO (TITLE VARCHAR(20) NOT NULL);
INSERT INTO HOMEPAGE.HERO VALUES ('find your dream car');
CREATE TABLE HOMEPAGE.MODELS(MODEL SMALLINT NOT NULL);
INSERT INTO HOMEPAGE.MODELS VALUES (2019), (2020), (2021), (2022), (2023), (2024);
CREATE TABLE HOMEPAGE.BRANDS (BRAND VARCHAR(15) NOT NULL);
INSERT INTO HOMEPAGE.BRANDS VALUES ('audi'), ('lamborghini'), ('porscher'), ('bmw'), ('ford');
CREATE TABLE HOMEPAGE.TRANSMISSIONS (TRANSMISSION VARCHAR(15) NOT NULL);
INSERT INTO HOMEPAGE.TRANSMISSIONS VALUES ('auto'), ('manual');
CREATE TABLE HOMEPAGE.TYPES (TYPE VARCHAR(20) NOT NULL);
INSERT INTO HOMEPAGE.TYPES VALUES ('sedan'), ('suv'), ('sport'), ('hatchback');
---GET HOMEPAGE IN JSONB---
SELECT JSONB_BUILD_OBJECT(
	'hero', (SELECT TO_JSONB(TITLE) FROM HOMEPAGE.HERO),
	'models', (SELECT JSON_AGG(MODEL)::JSONB FROM HOMEPAGE.MODELS),
	'brands', (SELECT JSON_AGG(BRAND)::JSONB FROM HOMEPAGE.BRANDS),
	'transmissions', (SELECT JSON_AGG(TRANSMISSION)::JSONB FROM HOMEPAGE.TRANSMISSIONS),
	'types', (SELECT JSON_AGG(TYPE)::JSONB FROM HOMEPAGE.TYPES)
);
---CREATE FUNCTION GET HOEPAGE---
CREATE OR REPLACE FUNCTION HOMEPAGE.GET_HOMEPAGE()
RETURNS JSONB AS
$$
DECLARE
	HOMEPAGE JSONB;
BEGIN
	SELECT JSONB_BUILD_OBJECT(
		'hero', (SELECT TO_JSONB(TITLE) FROM HOMEPAGE.HERO),
		'models', (SELECT JSON_AGG(MODEL)::JSONB FROM HOMEPAGE.MODELS),
		'brands', (SELECT JSON_AGG(BRAND)::JSONB FROM HOMEPAGE.BRANDS),
		'transmissions', (SELECT JSON_AGG(TRANSMISSION)::JSONB FROM HOMEPAGE.TRANSMISSIONS),
		'types', (SELECT JSON_AGG(TYPE)::JSONB FROM HOMEPAGE.TYPES)
	)
	INTO HOMEPAGE;
	RETURN HOMEPAGE;
END;
$$
LANGUAGE PLPGSQL;
---GET HOMEPAGE IN JSONB BY FUNCTION---
SELECT * FROM HOMEPAGE.GET_HOMEPAGE();