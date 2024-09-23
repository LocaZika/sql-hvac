---CREATE SCHEMA---
CREATE SCHEMA LAYOUT;
---CREATE AND INSERT VALUES TABLES---
CREATE TABLE LAYOUT.NAVBAR(
	ID INT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(10) NOT NULL,
	PATH VARCHAR(11) NOT NULL,
	CONSTRAINT PK_NAVBAR_ID PRIMARY KEY (ID)
);
INSERT INTO LAYOUT.NAVBAR
	VALUES
		(DEFAULT, 'home', '/'),
		(DEFAULT, 'cars', '/cars'),
		(DEFAULT, 'about', '/about'),
		(DEFAULT, 'contact', '/contact');
CREATE TABLE LAYOUT.FOOTER(
	"contactTitle" VARCHAR(20) NOT NULL,
	"aboutContent" VARCHAR(100) NOT NULL,
	imgs JSONB NOT NULL
);
INSERT INTO LAYOUT.FOOTER VALUES (
	'contact us now!',
	'Any questions? Let us know in store at Ha Noi, Viet Nam or call us on (+84) 123 456 789',
	'{"bg": "footer-bg.jpg", "logo": "footer-logo.png"}'
);
CREATE TABLE LAYOUT."contactInfo" (
	EMAIL VARCHAR(50) NOT NULL,
	PHONE VARCHAR(20) NOT NULL,
	SCHEDULE VARCHAR(30) NOT NULL,
	SOCIALS JSONB NOT NULL
);
INSERT INTO LAYOUT."contactInfo" VALUES (
	'hvac@mail.com',
	'(+84) 123 456 789',
	'weekday: 08:00am to 09:00pm',
	'{
		"facebook": "https://facebook.com",
		"twitter": "https://twitter.com",
		"instagram": "https://instagram.com",
		"google": "https://google.com",
		"skype": "https://skype.com"
	}'
);
---GET LAYOUT IN JSONB---
SELECT JSONB_BUILD_OBJECT (
	'navbar', (SELECT JSON_AGG(N) FROM LAYOUT.NAVBAR N),
	'footer', (SELECT JSONB_BUILD_OBJECT (
				'contactTitle', (SELECT F."contactTitle"),
				'aboutContent', (SELECT F."aboutContent"),
				'imgs', (SELECT F.IMGS)
			) FROM LAYOUT.FOOTER F),
	'contactInfo', (SELECT JSONB_BUILD_OBJECT (
						'email', (SELECT C.EMAIL),
						'phone', (SELECT C.PHONE),
						'schedule', (SELECT C.SCHEDULE),
						'socials', (SELECT C.SOCIALS)
					) FROM LAYOUT."contactInfo" C)
)
AS DATA;
---CREATE FUNCTION GET LAYOUT---
CREATE OR REPLACE FUNCTION LAYOUT.GET_LAYOUT()
RETURNS JSONB AS
$$
DECLARE
    LAYOUT JSONB;
BEGIN
    SELECT JSONB_BUILD_OBJECT (
		'navbar', (SELECT JSON_AGG(N) FROM LAYOUT.NAVBAR N),
		'footer', (SELECT JSONB_BUILD_OBJECT (
					'contactTitle', (SELECT F."contactTitle"),
					'aboutContent', (SELECT F."aboutContent"),
					'imgs', (SELECT F.IMGS)
				) FROM LAYOUT.FOOTER F),
		'contactInfo', (SELECT JSONB_BUILD_OBJECT (
							'email', (SELECT C.EMAIL),
							'phone', (SELECT C.PHONE),
							'schedule', (SELECT C.SCHEDULE),
							'socials', (SELECT C.SOCIALS)
						) FROM LAYOUT."contactInfo" C)
	) INTO LAYOUT;
    RETURN LAYOUT;
END;
$$ LANGUAGE PLPGSQL;
---GET LAYOUT IN JSONB BY FUNCTION---
SELECT LAYOUT.GET_LAYOUT() AS LAYOUT;

