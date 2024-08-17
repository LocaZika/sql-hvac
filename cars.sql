CREATE SCHEMA PRODUCT;

CREATE TABLE PRODUCT.CARS(
	ID SMALLINT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(50) NOT NULL,
	BRAND VARCHAR(15) NOT NULL,
	PRICE NUMERIC(10,2) NOT NULL,
	TRANSMISSION VARCHAR(6) NOT NULL,
	TRADETYPE VARCHAR(4) NOT NULL,
	FUELTYPE VARCHAR(10) NOT NULL,
	TYPE VARCHAR(10) NOT NULL,
	HP SMALLINT NOT NULL,
	MODEL SMALLINT NOT NULL,
	MILEAGE SMALLINT NOT NULL,
	CREATED_AT DATE NOT NULL DEFAULT CURRENT_DATE,
	CONSTRAINT PK_PRODUCT_CARS_ID PRIMARY KEY (ID, BRAND)
) PARTITION BY LIST (BRAND);

CREATE TABLE AUDI PARTITION OF PRODUCT.CARS FOR VALUES IN ('audi');
CREATE TABLE BMW PARTITION OF PRODUCT.CARS FOR VALUES IN ('bmw');
CREATE TABLE FERRARI PARTITION OF PRODUCT.CARS FOR VALUES IN ('ferrari');
CREATE TABLE FORD PARTITION OF PRODUCT.CARS FOR VALUES IN ('ford');
CREATE TABLE HONDA PARTITION OF PRODUCT.CARS FOR VALUES IN ('honda');
CREATE TABLE LAMBORGHINI PARTITION OF PRODUCT.CARS FOR VALUES IN ('lamborghini');
CREATE TABLE MAZDA PARTITION OF PRODUCT.CARS FOR VALUES IN ('mazda');
CREATE TABLE MERCEDES PARTITION OF PRODUCT.CARS FOR VALUES IN ('mercedes');
CREATE TABLE OTHER_BRAND PARTITION OF PRODUCT.CARS DEFAULT;

INSERT INTO PRODUCT.CARS(NAME, BRAND, PRICE, TRANSMISSION, TRADETYPE, FUELTYPE, TYPE, HP, MODEL, MILEAGE)
SELECT NAME, BRAND, PRICE, TRANSMISSION, TRADETYPE, FUELTYPE, TYPE, HP, MODEL, MILEAGE
FROM JSON_POPULATE_RECORDSET(NULL::PRODUCT.CARS, '
	[
    {
      "name": "audi a6",
      "brand": "audi",
      "price": 327,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "sedan",
      "hp": 250,
      "model" : 2022,
      "mileage": 16458
    },
    {
      "name": "audi a7",
      "brand": "audi",
      "price": 471,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "sportback",
      "hp": 250,
      "model" : 2023,
      "mileage": 18321
    },
    {
      "name": "bmw 530i sedan",
      "brand": "bmw",
      "price": 71846.41,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "sedan",
      "hp": 184,
      "model" : 2021,
      "mileage": 10154
    },
    {
      "name": "bmw 735i m sport",
      "brand": "bmw",
      "price": 176671.51,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "gasoline",
      "type": "sedan",
      "hp": 286,
      "model" : 2023,
      "mileage": 13552
    },
    {
      "name": "LaFerrari Aperta",
      "brand": "ferrari",
      "price": 5000000,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "sport",
      "hp": 700,
      "model" : 2016,
      "mileage": 10423
    },
    {
      "name": "ferrari SF90 stradale",
      "brand": "ferrari",
      "price": 990000,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "sport",
      "hp": 986,
      "model" : 2020,
      "mileage": 10645
    },
    {
      "name": "ford mustang® dark horse™ premium",
      "brand": "ford",
      "price": 62930,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "gasoline",
      "type": "suv",
      "hp": 500,
      "model" : 2024,
      "mileage": 11785
    },
    {
      "name": "ford ranger raptor®",
      "brand": "ford",
      "price": 55620,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "gasoline",
      "type": "truck",
      "hp": 315,
      "model" : 2024,
      "mileage": 10985
    },
    {
      "name": "honda CR-V EX-L",
      "brand": "honda",
      "price": 35000,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "suv",
      "hp": 190,
      "model" : 2024,
      "mileage": 14300
    },
    {
      "name": "honda pilot black edition",
      "brand": "honda",
      "price": 54280,
      "transmission": "manual",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "suv",
      "hp": 285,
      "model" : 2024,
      "mileage": 9536
    },
    {
      "name": "lamborghini revuelto",
      "brand": "lamborghini",
      "price": 608.358,
      "transmission": "manual",
      "tradetype": "sale",
      "fueltype": "mixed",
      "type": "sport",
      "hp": 813,
      "model" : 2024,
      "mileage": 6595
    },
    {
      "name": "lamborghini sian roadster",
      "brand": "lamborghini",
      "price": 3800000,
      "transmission": "auto",
      "tradetype": "sale",
      "fueltype": "electric",
      "type": "sport",
      "hp": 800,
      "model" : 2024,
      "mileage": 9452
    },
    {
      "name": "mazda 6",
      "brand": "mazda",
      "price": 605,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "sedan",
      "hp": 154,
      "model" : 2021,
      "mileage": 24160
    },
    {
      "name": "mazda CX-8",
      "brand": "mazda",
      "price": 526,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "suv",
      "hp": 188,
      "model" : 2021,
      "mileage": 24452
    },
    {
      "name": "mercedes C-200",
      "brand": "mercedes",
      "price": 213,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "sedan",
      "hp": 258,
      "model" : 2022,
      "mileage": 16584
    },
    {
      "name": "maybach s450",
      "brand": "mercedes",
      "price": 447,
      "transmission": "auto",
      "tradetype": "rent",
      "fueltype": "gasoline",
      "type": "sedan",
      "hp": 367,
      "model" : 2024,
      "mileage": 25400
    }
  ]
');

CREATE INDEX IDX_PRODUCT_CAR_ID ON PRODUCT.CARS(ID);
CREATE INDEX IDX_PRODUCT_CAR_BRAND ON PRODUCT.CARS(BRAND);
CREATE INDEX IDX_PRODUCT_CAR_NAME ON PRODUCT.CARS(NAME);

EXPLAIN ANALYZE SELECT * FROM PRODUCT.CARS WHERE NAME ILIKE '%C-200%' AND BRAND = 'mercedes';






