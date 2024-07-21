---NAVBAR---
CREATE IF NOT EXISTS TABLE UI.NAVBAR(
	ID INT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(10) NOT NULL,
	PATH VARCHAR(11) NOT NULL,
	CONSTRAINT PK_NAVBAR_ID PRIMARY KEY (ID)
);
INSERT INTO UI.NAVBAR
	VALUES
		(DEFAULT, 'home', '/'),
		(DEFAULT, 'cars', '/cars'),
		(DEFAULT, 'about', '/about'),
		(DEFAULT, 'contact', '/contact');
---FOOTER---
CREATE TABLE ui.FOOTER(
	"contactTitle" VARCHAR(20) NOT NULL,
	"aboutContent" VARCHAR(100) NOT NULL,
	imgs JSONB NOT NULL
);
INSERT INTO UI.FOOTER VALUES (
	'contact us now!',
	'Any questions? Let us know in store at Ha Noi, Viet Nam or call us on (+84) 123 456 789',
	'{"bg": "footer-bg.jpg", "logo": "footer-logo.png"}'
);
---CONTACT INFO TABLE---
CREATE TABLE LAYOUT."contactInfo" (
	EMAIL VARCHAR(50) NOT NULL,
	PHONE VARCHAR(20) NOT NULL
);
INSERT INTO LAYOUT."contactInfo" VALUES (
	'hvac@mail.com',
	'(+84) 123 456 789'
);
---SCHEDULE TABLE---
CREATE TABLE LAYOUT.SCHEDULE (
	STARTAT VARCHAR(7) NOT NULL,
	ENDAT VARCHAR(7) NOT NULL
);
INSERT INTO LAYOUT.SCHEDULE VALUES ('08:00am', '09:00pm');
---SOCIALS TABLE---
CREATE TABLE LAYOUT.SOCIALS (
	FACEBOOK VARCHAR(50) NOT NULL,
	TWITTER VARCHAR(50) NOT NULL,
	INSTAGRAM VARCHAR(50) NOT NULL,
	GOOGLE VARCHAR(50) NOT NULL,
	SKYPE VARCHAR(50) NOT NULL
);
INSERT INTO LAYOUT.SOCIALS VALUES (
	'https://facebook.com',
	'https://twitter.com',
	'https://instagram.com',
	'https://google.com',
	'https://skype.com'
);
---GET LAYOUT IN JSONB---
SELECT JSONB_BUILD_OBJECT(
	'navbar', (SELECT JSON_AGG(NAVBAR)::JSONB AS NAVBAR FROM LAYOUT.NAVBAR),
	'footer', (SELECT TO_JSONB(FOOTER) AS FOOTER FROM LAYOUT.FOOTER),
	'contactInfo', (
		SELECT JSONB_BUILD_OBJECT(
			'email', C.EMAIL,
			'phone', C.PHONE,
			'schedule', CONCAT('Weekday: ', SC.STARTAT, ' to ', SC.ENDAT),
			'socials', (SELECT JSONB_BUILD_OBJECT(
				'facebook', SO.FACEBOOK,
				'twitter', SO.TWITTER,
				'instagram', SO.INSTAGRAM,
				'google', SO.GOOGLE,
				'skype', SO.SKYPE
			))
			)
		FROM LAYOUT."contactInfo" C, LAYOUT.SCHEDULE SC, LAYOUT.SOCIALS SO
	)
);
---CREATE FUNCTION GET LAYOUT---
CREATE OR REPLACE FUNCTION LAYOUT.GET_LAYOUT()
RETURNS JSONB AS
$$
DECLARE
    LAYOUT JSONB;
BEGIN
    SELECT jsonb_build_object(
        'navbar', (SELECT jsonb_agg(navbar)::jsonb FROM layout.navbar),
        'footer', (SELECT to_jsonb(footer) FROM layout.footer),
        'contactInfo', (
            SELECT jsonb_build_object(
                'email', C.email,
                'phone', C.phone,
                'schedule', CONCAT('Weekday: ', SC.startat, ' to ', SC.endat),
                'socials', (
                    SELECT jsonb_build_object(
                        'facebook', SO.facebook,
                        'twitter', SO.twitter,
                        'instagram', SO.instagram,
                        'google', SO.google,
                        'skype', SO.skype
                    )
                )
            )
            FROM layout."contactInfo" C, layout.schedule SC, layout.socials SO
        )
    ) INTO LAYOUT;

    RETURN LAYOUT;
END;
$$ LANGUAGE PLPGSQL;
---GET LAYOUT IN JSONB BY FUNCTION---
SELECT * FROM LAYOUT.GET_LAYOUT();