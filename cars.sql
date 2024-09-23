CREATE SCHEMA PRODUCTS;

CREATE TYPE PRODUCTS.ENUM_CAR_TRANSMISSION AS ENUM('auto', 'manual', 'mixed');
CREATE TYPE PRODUCTS.ENUM_CAR_TRADETYPE AS ENUM('sale', 'rent');
CREATE TYPE PRODUCTS.ENUM_CAR_FUELTYPE AS ENUM('gasoline', 'electric', 'mixed');

----(BEGIN) CARS----
CREATE TABLE PRODUCTS.CARS(
	ID INT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(50) NOT NULL,
	BRAND VARCHAR(15) NOT NULL,
	PRICE NUMERIC(10,2) NOT NULL,
	TRANSMISSION PRODUCTS.ENUM_CAR_TRANSMISSION NOT NULL,
	"tradeType" PRODUCTS.ENUM_CAR_TRADETYPE NOT NULL,
	"fuelType" PRODUCTS.ENUM_CAR_FUELTYPE NOT NULL,
	TYPE VARCHAR(10) NOT NULL,
	HP SMALLINT NOT NULL,
	MODEL SMALLINT NOT NULL,
	MILEAGE SMALLINT NOT NULL,
	IMGS JSONB NOT NULL,
	"detailImgs" JSONB,
	CREATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UPDATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT PK_PRODUCT_CARS_ID PRIMARY KEY (ID, BRAND)
) PARTITION BY LIST (BRAND);

CREATE TABLE AUDI PARTITION OF PRODUCTs.CARS FOR VALUES IN ('audi');
CREATE TABLE BMW PARTITION OF PRODUCTs.CARS FOR VALUES IN ('bmw');
CREATE TABLE FERRARI PARTITION OF PRODUCTs.CARS FOR VALUES IN ('ferrari');
CREATE TABLE FORD PARTITION OF PRODUCTs.CARS FOR VALUES IN ('ford');
CREATE TABLE HONDA PARTITION OF PRODUCTs.CARS FOR VALUES IN ('honda');
CREATE TABLE LAMBORGHINI PARTITION OF PRODUCTs.CARS FOR VALUES IN ('lamborghini');
CREATE TABLE MAZDA PARTITION OF PRODUCTs.CARS FOR VALUES IN ('mazda');
CREATE TABLE MERCEDES PARTITION OF PRODUCTs.CARS FOR VALUES IN ('mercedes');
CREATE TABLE OTHER_BRAND PARTITION OF PRODUCTs.CARS DEFAULT;

CREATE FUNCTION PRODUCTS.SET_UPDATED_AT_CAR_FUNC()
RETURNS TRIGGER AS $$
BEGIN
	NEW.UPDATED_AT = CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER PRODUCTS.SET_UPDATED_AT_CAR_TRIGGER
BEFORE UPDATE ON PRODUCTS.CARS
FOR EACH ROW EXECUTE PROCEDURE PRODUCTS.SET_UPDATED_AT_CAR_FUNC();

INSERT INTO PRODUCTs.CARS(NAME, BRAND, PRICE, TRANSMISSION, "tradeType", "fuelType", TYPE, HP, MODEL, MILEAGE, IMGS, "detailImgs")
SELECT NAME, BRAND, PRICE, TRANSMISSION, "tradeType", "fuelType", TYPE, HP, MODEL, MILEAGE, IMGS, "detailImgs"
FROM JSON_POPULATE_RECORDSET(NULL::PRODUCTS.CARS, '
[
  {
    "name": "audi a6",
    "brand": "audi",
    "price": 327,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "sedan",
    "hp": 250,
    "model" : 2022,
    "mileage": 16458,
    "imgs": [
      {"id": "1", "path": "audi/a6/1.jpg"},
      {"id": "2", "path": "audi/a6/2.jpg"},
      {"id": "3", "path": "audi/a6/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "audi/a6/detail.jpg"}
    ]
  },
  {
    "name": "audi a7",
    "brand": "audi",
    "price": 471,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "sportback",
    "hp": 250,
    "model" : 2023,
    "mileage": 18321,
    "imgs": [
      {"id": "1", "path": "audi/a7/1.jpg"},
      {"id": "2", "path": "audi/a7/2.jpg"},
      {"id": "3", "path": "audi/a7/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "audi/a7/detail-1.jpg"},
      {"id": "2", "path": "audi/a7/detail-2.jpg"},
      {"id": "3", "path": "audi/a7/detail-3.jpg"}
    ]
  },
  {
    "name": "bmw 530i sedan",
    "brand": "bmw",
    "price": 71846.41,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "sedan",
    "hp": 184,
    "model" : 2021,
    "mileage": 10154,
    "imgs": [
      {"id": "1", "path": "bmw/530i/1.jpg"},
      {"id": "2", "path": "bmw/530i/2.jpg"},
      {"id": "3", "path": "bmw/530i/3.jpg"}
          ],
    "detailImgs": [
      {"id": "1", "path": "bmw/530i/detail-1.jpg"},
      {"id": "2", "path": "bmw/530i/detail-2.jpg"},
      {"id": "3", "path": "bmw/530i/detail-3.jpg"},
      {"id": "4", "path": "bmw/530i/detail-4.jpg"}
    ]
  },
  {
    "name": "bmw 735i m sport",
    "brand": "bmw",
    "price": 176671.51,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "gasoline",
    "type": "sedan",
    "hp": 286,
    "model" : 2023,
    "mileage": 13552,
    "imgs": [
      {"id": "1", "path": "bmw/735i/1.jpg"},
      {"id": "2", "path": "bmw/735i/2.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "bmw/735i/detail.jpg"}
    ]
  },
  {
    "name": "LaFerrari Aperta",
    "brand": "ferrari",
    "price": 5000000,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "sport",
    "hp": 700,
    "model" : 2016,
    "mileage": 10423,
    "imgs": [
      {"id": "1", "path": "ferrari/laFerrari-aperta/1.jpg"},
      {"id": "2", "path": "ferrari/laFerrari-aperta/2.jpg"},
      {"id": "3", "path": "ferrari/laFerrari-aperta/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "ferrari/laFerrari-aperta/detail-1.jpg"},
      {"id": "2", "path": "ferrari/laFerrari-aperta/detail-2.jpg"},
      {"id": "3", "path": "ferrari/laFerrari-aperta/detail-3.jpg"},
      {"id": "4", "path": "ferrari/laFerrari-aperta/detail-4.jpg"}
    ]
  },
  {
    "name": "ferrari SF90 stradale",
    "brand": "ferrari",
    "price": 990000,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "sport",
    "hp": 986,
    "model" : 2020,
    "mileage": 10645,
    "imgs": [
      {"id": "1", "path": "ferrari/sf90-stradale/1.jpg"},
      {"id": "2", "path": "ferrari/sf90-stradale/2.jpg"},
      {"id": "3", "path": "ferrari/sf90-stradale/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "ferrari/sf90-stradale/detail-1.jpg"},
      {"id": "2", "path": "ferrari/sf90-stradale/detail-2.jpg"},
      {"id": "3", "path": "ferrari/sf90-stradale/detail-3.jpg"},
      {"id": "4", "path": "ferrari/sf90-stradale/detail-4.jpg"}
    ]
  },
  {
    "name": "ford mustang® dark horse™ premium",
    "brand": "ford",
    "price": 62930,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "gasoline",
    "type": "suv",
    "hp": 500,
    "model" : 2024,
    "mileage": 11785,
    "imgs": [
      {"id": "1", "path": "ford/mustang/1.jpg"},
      {"id": "2", "path": "ford/mustang/2.jpg"},
      {"id": "3", "path": "ford/mustang/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "ford/mustang/detail-1.jpg"},
      {"id": "2", "path": "ford/mustang/detail-2.jpg"},
      {"id": "3", "path": "ford/mustang/detail-3.jpg"},
      {"id": "4", "path": "ford/mustang/detail-4.jpg"},
      {"id": "5", "path": "ford/mustang/detail-5.jpg"}
    ]
  },
  {
    "name": "ford ranger raptor®",
    "brand": "ford",
    "price": 55620,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "gasoline",
    "type": "truck",
    "hp": 315,
    "model" : 2024,
    "mileage": 10985,
    "imgs": [
      {"id": "1", "path": "ford/ranger/1.jpg"},
      {"id": "2", "path": "ford/ranger/2.jpg"},
      {"id": "3", "path": "ford/ranger/3.jpg"},
      {"id": "4", "path": "ford/ranger/4.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "ford/ranger/detail-1.jpg"},
      {"id": "2", "path": "ford/ranger/detail-2.jpg"},
      {"id": "3", "path": "ford/ranger/detail-3.jpg"},
      {"id": "4", "path": "ford/ranger/detail-4.jpg"},
      {"id": "5", "path": "ford/ranger/detail-5.jpg"},
      {"id": "6", "path": "ford/ranger/detail-6.jpg"},
      {"id": "7", "path": "ford/ranger/detail-7.jpg"}
]
  },
  {
    "name": "honda CR-V EX-L",
    "brand": "honda",
    "price": 35000,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "suv",
    "hp": 190,
    "model" : 2024,
    "mileage": 14300,
    "imgs": [
      {"id": "1", "path": "honda/cr-v/1.jpg"},
      {"id": "2", "path": "honda/cr-v/2.jpg"},
      {"id": "3", "path": "honda/cr-v/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "honda/cr-v/detail-1.jpg"},
      {"id": "2", "path": "honda/cr-v/detail-2.jpg"},
      {"id": "3", "path": "honda/cr-v/detail-3.jpg"},
      {"id": "4", "path": "honda/cr-v/detail-4.jpg"},
      {"id": "5", "path": "honda/cr-v/detail-5.jpg"}
    ]
  },
  {
    "name": "honda pilot black edition",
    "brand": "honda",
    "price": 54280,
    "transmission": "manual",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "suv",
    "hp": 285,
    "model" : 2024,
    "mileage": 9536,
    "imgs": [
      {"id": "1", "path": "honda/pilot/1.jpg"},
      {"id": "2", "path": "honda/pilot/2.jpg"},
      {"id": "3", "path": "honda/pilot/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "honda/pilot/detail-1.jpg"},
      {"id": "2", "path": "honda/pilot/detail-2.jpg"},
      {"id": "3", "path": "honda/pilot/detail-3.jpg"},
      {"id": "4", "path": "honda/pilot/detail-4.jpg"},
      {"id": "5", "path": "honda/pilot/detail-5.jpg"}
]
  },
  {
    "name": "lamborghini revuelto",
    "brand": "lamborghini ",
    "price": 608.358,
    "transmission": "manual",
    "tradeType": "sale",
    "fuelType": "mixed",
    "type": "sport",
    "hp": 813,
    "model" : 2024,
    "mileage": 6595,
    "imgs": [
      {"id": "1", "path": "lamborghini/revuelto/1.webp"},
      {"id": "2", "path": "lamborghini/revuelto/2.webp"},
      {"id": "3", "path": "lamborghini/revuelto/3.webp"}
    ],
    "detailImgs": [
      {"id": "1", "path": "lamborghini/revuelto/detail-1.jpg"},
      {"id": "2", "path": "lamborghini/revuelto/detail-2.jpg"},
      {"id": "3", "path": "lamborghini/revuelto/detail-3.jpg"}
    ]
  },
  {
    "name": "lamborghini sian roadster",
    "brand": "lamborghini",
    "price": 3800000,
    "transmission": "auto",
    "tradeType": "sale",
    "fuelType": "electric",
    "type": "sport",
    "hp": 800,
    "model" : 2024,
    "mileage": 9452,
    "imgs": [
      {"id": "1", "path": "lamborghini/sain-roadster/1.jpg"},
      {"id": "2", "path": "lamborghini/sain-roadster/2.jpg"},
      {"id": "3", "path": "lamborghini/sain-roadster/3.webp"},
      {"id": "3", "path": "lamborghini/sain-roadster/4.webp"}
    ],
    "detailImgs": [
      {"id": "1", "path": "lamborghini/sain-roadster/detail-1.jpg"},
      {"id": "2", "path": "lamborghini/sain-roadster/detail-2.jpg"},
      {"id": "3", "path": "lamborghini/sain-roadster/detail-3.jpg"},
      {"id": "4", "path": "lamborghini/sain-roadster/detail-4.jpg"},
      {"id": "5", "path": "lamborghini/sain-roadster/detail-5.jpg"}
]
  },
  {
    "name": "mazda 6",
    "brand": "mazda",
    "price": 605,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "sedan",
    "hp": 154,
    "model" : 2021,
    "mileage": 24160,
    "imgs": [
      {"id": "1", "path": "mazda/6/1.jpg"},
      {"id": "2", "path": "mazda/6/2.jpg"},
      {"id": "3", "path": "mazda/6/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "mazda/6/detail-1.jpg"},
      {"id": "2", "path": "mazda/6/detail-2.jpg"},
      {"id": "3", "path": "mazda/6/detail-3.jpg"},
      {"id": "4", "path": "mazda/6/detail-4.jpg"},
      {"id": "5", "path": "mazda/6/detail-5.jpg"}
    ]
  },
  {
    "name": "mazda CX-8",
    "brand": "mazda",
    "price": 526,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "suv",
    "hp": 188,
    "model" : 2021,
    "mileage": 24452,
    "imgs": [
      {"id": "1", "path": "mazda/cx-8/1.jpg"},
      {"id": "2", "path": "mazda/cx-8/2.jpg"},
      {"id": "3", "path": "mazda/cx-8/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "mazda/cx-8/detail-1.jpg"},
      {"id": "2", "path": "mazda/cx-8/detail-2.jpg"},
      {"id": "3", "path": "mazda/cx-8/detail-3.jpg"},
      {"id": "4", "path": "mazda/cx-8/detail-4.jpg"},
      {"id": "5", "path": "mazda/cx-8/detail-5.jpg"}
    ]
  },
  {
    "name": "mercedes C-200",
    "brand": "mercedes",
    "price": 213,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "sedan",
    "hp": 258,
    "model" : 2022,
    "mileage": 16584,
    "imgs": [
      {"id": "1", "path": "mercedes/c-200/1.jpg"},
      {"id": "2", "path": "mercedes/c-200/2.jpg"},
      {"id": "3", "path": "mercedes/c-200/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "mercedes/c-200/detail-1.jpg"}
    ]
  },
  {
    "name": "maybach s450",
    "brand": "mercedes",
    "price": 447,
    "transmission": "auto",
    "tradeType": "rent",
    "fuelType": "gasoline",
    "type": "sedan",
    "hp": 367,
    "model" : 2024,
    "mileage": 25400,
    "imgs": [
      {"id": "1", "path": "mercedes/maybach-s450/1.jpg"},
      {"id": "2", "path": "mercedes/maybach-s450/2.jpg"},
      {"id": "3", "path": "mercedes/maybach-s450/3.jpg"}
    ],
    "detailImgs": [
      {"id": "1", "path": "mercedes/maybach-s450/detail-1.jpg"}
    ]
  }
]
');
----(END) CARS----

----(BEGIN) CAR IMG----
CREATE TABLE PRODUCTS.CAR_IMGS(
    ID SMALLINT GENERATED ALWAYS AS IDENTITY,
    PRODUCT_ID INT NOT NULL,
    PATH TEXT NOT NULL,
	CREATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UPDATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PRODUCT_CAR_IMG PRIMARY KEY(ID, CREATED_AT)
) PARTITION BY RANGE(CREATED_AT);

CREATE TABLE IMGS_2024 PARTITION OF PRODUCTS.CAR_IMGS FOR VALUES FROM ('01-01-2024') TO ('01-01-2025');
CREATE TABLE IMGS_ANOTHER_YEAR PARTITION OF PRODUCTS.CAR_IMGS DEFAULT;

INSERT INTO PRODUCTS.CAR_IMGS(PRODUCT_ID, PATH)
SELECT PRODUCT_ID, PATH
FROM JSON_POPULATE_RECORDSET(NULL::PRODUCTS.CAR_IMGS, '
[
	{
	"product_id": "1",
	"path": "audi/a6/1.jpg"
	},
	{
	"product_id": "1",
	"path": "audi/a6/2.jpg"
	},
	{
	"product_id": "1",
	"path": "audi/a6/3.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/1.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/2.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/3.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/1.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/2.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/3.jpg"
	},
	{
	"product_id": "4",
	"path": "bmw/735i/1.jpg"
	},
	{
	"product_id": "4",
	"path": "bmw/735i/2.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/1.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/2.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/3.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/1.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/2.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/3.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/1.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/2.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/3.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/1.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/2.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/3.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/4.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/1.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/2.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/3.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/1.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/2.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/3.jpg"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/1.webp"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/2.webp"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/3.webp"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/1.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/2.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/3.webp"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/4.webp"
	},
	{
	"product_id": "13",
	"path": "mazda/6/1.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/2.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/3.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/1.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/2.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/3.jpg"
	},
	{
	  "product_id": "15",
	  "path": "mercedes/c-200/1.jpg"
	},
	{
	  "product_id": "15",
	  "path": "mercedes/c-200/2.jpg"
	},
	{
	  "product_id": "15",
	  "path": "mercedes/c-200/3.jpg"
	},
	{
	"product_id": "16",
	"path": "mercedes/maybach-s450/1.jpg"
	},
	{
	"product_id": "16",
	"path": "mercedes/maybach-s450/2.jpg"
	},
	{
	"product_id": "16",
	"path": "mercedes/maybach-s450/3.jpg"
	}
]
');

CREATE FUNCTION SET_UPDATED_AT_CAR_IMGS_FUNC()
RETURNS TRIGGER AS $$
BEGIN
	NEW.UPDATED_AT = CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER SET_UPDATED_AT_CAR_IMGS_TRIGGER
BEFORE UPDATE ON PRODUCTS.CAR_IMGS
FOR EACH ROW EXECUTE PROCEDURE SET_UPDATED_AT_CAR_IMGS_FUNC();
----(END) CAR IMG----

----(BEGIN) CAR IMG DETAIL----
CREATE TABLE PRODUCTS.CAR_DETAIL_IMGS(
    ID SMALLINT GENERATED ALWAYS AS IDENTITY,
    PRODUCT_ID INT NOT NULL,
    PATH TEXT NOT NULL,
	CREATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UPDATED_AT TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PRODUCT_CAR_DETAIL_IMG PRIMARY KEY(ID, CREATED_AT)
) PARTITION BY RANGE(CREATED_AT);

CREATE TABLE DETAIL_IMGS_2024 PARTITION OF PRODUCTS.CAR_DETAIL_IMGS FOR VALUES FROM ('01-01-2024') TO ('01-01-2025');
CREATE TABLE DETAIL_IMGS_ANOTHER_YEAR PARTITION OF PRODUCTS.CAR_DETAIL_IMGS DEFAULT;

INSERT INTO PRODUCTS.CAR_DETAIL_IMGS(PRODUCT_ID, PATH)
SELECT PRODUCT_ID, PATH
FROM JSON_POPULATE_RECORDSET(NULL::PRODUCTS.CAR_DETAIL_IMGS, '
[
	{
	"product_id": "1",
	"path": "audi/a6/detail.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/detail-1.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/detail-2.jpg"
	},
	{
	"product_id": "2",
	"path": "audi/a7/detail-3.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/detail-1.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/detail-2.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/detail-3.jpg"
	},
	{
	"product_id": "3",
	"path": "bmw/530i/detail-4.jpg"
	},
	{
	"product_id": "4",
	"path": "bmw/735i/detail.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/detail-1.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/detail-2.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/detail-3.jpg"
	},
	{
	"product_id": "5",
	"path": "ferrari/laFerrari-aperta/detail-4.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/detail-1.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/detail-2.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/detail-3.jpg"
	},
	{
	"product_id": "6",
	"path": "ferrari/sf90-stradale/detail-4.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/detail-1.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/detail-2.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/detail-3.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/detail-4.jpg"
	},
	{
	"product_id": "7",
	"path": "ford/mustang/detail-5.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-1.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-2.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-3.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-4.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-5.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-6.jpg"
	},
	{
	"product_id": "8",
	"path": "ford/ranger/detail-7.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/detail-1.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/detail-2.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/detail-3.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/detail-4.jpg"
	},
	{
	"product_id": "9",
	"path": "honda/cr-v/detail-5.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/detail-1.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/detail-2.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/detail-3.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/detail-4.jpg"
	},
	{
	"product_id": "10",
	"path": "honda/pilot/detail-5.jpg"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/detail-1.jpg"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/detail-2.jpg"
	},
	{
	"product_id": "11",
	"path": "lamborghini/revuelto/detail-3.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/detail-1.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/detail-2.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/detail-3.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/detail-4.jpg"
	},
	{
	"product_id": "12",
	"path": "lamborghini/sain-roadster/detail-5.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/detail-1.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/detail-2.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/detail-3.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/detail-4.jpg"
	},
	{
	"product_id": "13",
	"path": "mazda/6/detail-5.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/detail-1.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/detail-2.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/detail-3.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/detail-4.jpg"
	},
	{
	"product_id": "14",
	"path": "mazda/cx-8/detail-5.jpg"
	},
	{
	"product_id": "15",
	"path": "mercedes/c-200/detail-1.jpg"
	},
	{
	"product_id": "16",
	"path": "mercedes/maybach-s450/detail-1.jpg"
	}
]
');

CREATE FUNCTION SET_UPDATED_AT_CAR_DETAIL_IMGS_FUNC()
RETURNS TRIGGER AS $$
BEGIN
	NEW.UPDATED_AT = CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER SET_UPDATED_AT_CAR_DETAIL_IMGS_TRIGGER
BEFORE UPDATE ON PRODUCTS.CAR_DETAIL_IMGS
FOR EACH ROW EXECUTE PROCEDURE SET_UPDATED_AT_CAR_DETAIL_IMGS_FUNC();

----(END) CAR IMGS DETAIL----

SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename, indexname;

EXPLAIN ANALYZE SELECT * FROM PRODUCTS.CARS WHERE NAME = 'LaFerrari Aperta' AND BRAND = 'ferrari';
EXPLAIN ANALYZE SELECT * FROM PRODUCTS.CARS WHERE BRAND = 'ferrari';
EXPLAIN ANALYZE SELECT * FROM PRODUCTS.CARS WHERE ID = 2 AND BRAND = 'audi';

SELECT * FROM PRODUCTS.CARS;







