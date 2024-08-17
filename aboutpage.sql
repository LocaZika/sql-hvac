---CREATE SCHEMA---
CREATE SCHEMA ABOUTPAGE;

---ABOUT---
CREATE TABLE ABOUTPAGE.ABOUT(_ID SMALLINT GENERATED ALWAYS AS IDENTITY, TITLE TEXT [] NOT NULL, TEXT TEXT, IMG VARCHAR(20) NOT NULL);
INSERT INTO ABOUTPAGE.ABOUT VALUES (
	DEFAULT,
	ARRAY ['welcome to hvac auto online', 'we provide everything you need to a car'],
	'First I will explain what contextual advertising is. Contextual advertising means the advertising of products on a website according to the content the page is displaying. For example if the content of a website was information on a Ford truck then the advertisements',
	'about-pic.jpg'
);

---FEATURES---
CREATE TABLE ABOUTPAGE.FEATURES(_ID SMALLINT GENERATED ALWAYS AS IDENTITY, TITLE VARCHAR(50) NOT NULL, TEXT TEXT NOT NULL, IMG VARCHAR(30) NOT NULL);
INSERT INTO ABOUTPAGE.FEATURES VALUES
	(DEFAULT, 'quality assurance system', 'it seems though that some of the biggest problems with the internet advertising trends are the lack of', 'features/af-1.png'),
	(DEFAULT, 'accurate testing processes', 'where do you register your complaints? How can you protest in any form against companies whose', 'features/af-2.png'),
	(DEFAULT, 'infrastructure integration technology', 'So in final analysis: it’s true, I hate peeping Toms, but if I had to choose, I’d take one any day over an', 'features/af-3.png');

---ABOUT ITEMS---
CREATE TABLE ABOUTPAGE.ABOUT_ITEMS(_ID SMALLINT GENERATED ALWAYS AS IDENTITY, TITLE VARCHAR(15) NOT NULL, TEXT TEXT NOT NULL);
INSERT INTO ABOUTPAGE.ABOUT_ITEMS VALUES
	(DEFAULT, 'our mission', 'now, i’m not like Robin, that weirdo from my cultural anthropology class; I think that advertising is something that has its place in our society; which for better or worse is structured along a marketplace economy. But, simply because i feel advertising has a right to exist, doesn’t mean that i like or agree with it, in its'),
	(DEFAULT, 'our vision', 'where do you register your complaints? How can you protest in any form against companies whose advertising techniques you don’t agree with? You don’t. And on another point of difference between traditional products and their advertising and those of the internet nature, simply ignoring internet advertising is');

---TEAMS---
CREATE TABLE ABOUTPAGE.TEAMS(TITLE VARCHAR(15) NOT NULL, SUBTITLE VARCHAR(30) NOT NULL);
INSERT INTO ABOUTPAGE.TEAMS VALUES (
	'our team',
	'meet our expert'
);
CREATE TABLE ABOUTPAGE.TEAMS_ITEMS (_ID SMALLINT GENERATED ALWAYS AS IDENTITY, NAME VARCHAR(50) NOT NULL, IMG VARCHAR(30) NOT NULL, POSITION VARCHAR(30) NOT NULL);
INSERT INTO ABOUTPAGE.TEAMS_ITEMS VALUES
	(DEFAULT, 'john smith', 'team-1.jpg', 'marketing'),
	(DEFAULT, 'christine wise', 'team-2.jpg', 'CEO'),
	(DEFAULT, 'sean robbins', 'team-3.jpg', 'manager'),
	(DEFAULT, 'lucy myers', 'team-4.jpg', 'delivary');

---TESTIMONIALS---
CREATE TABLE ABOUTPAGE.TESTIMONIALS(TITLE VARCHAR(30) NOT NULL, SUBTITLE VARCHAR(50) NOT NULL, TEXT TEXT);
INSERT INTO ABOUTPAGE.TESTIMONIALS VALUES
	('testimonials', 'what people say about us?', 'Our customers are our biggest supporters. What do they think of us?');
CREATE TABLE ABOUTPAGE.TESTIMONIALS_ITEMS(
	_ID SMALLINT GENERATED ALWAYS AS IDENTITY,
	NAME VARCHAR(30) NOT NULL,
	IMG VARCHAR(30) NOT NULL,
	POSITION VARCHAR(30) NOT NULL,
	RATE NUMERIC NOT NULL,
	TEXT TEXT NOT NULL);
INSERT INTO ABOUTPAGE.TESTIMONIALS_ITEMS VALUES
	(DEFAULT, 'john smith', 'testimonial-1.png', 'CEO ABC', 5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.'),
	(DEFAULT, 'emma sandoval', 'testimonial-1.png', 'CEO ABC', 4.5, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.');

---QUANTITIES---
CREATE TABLE ABOUTPAGE.QUANTITIES_ITEMS(_ID SMALLINT GENERATED ALWAYS AS IDENTITY, NAME VARCHAR(20) NOT NULL, VALUE SMALLINT NOT NULL);
INSERT INTO ABOUTPAGE.QUANTITIES_ITEMS VALUES
	(DEFAULT, 'vehicles stock', 1922),
	(DEFAULT, 'vehicles sale', 1500),
	(DEFAULT, 'dealer reviews', 2214),
	(DEFAULT, 'happy clients', 5100);

---CLIENTS---
CREATE TABLE ABOUTPAGE.CLIENTS(TITLE VARCHAR(30) NOT NULL, SUBTITLE VARCHAR(20) NOT NULL);
INSERT INTO ABOUTPAGE.CLIENTS VALUES ('partner', 'our clients');
CREATE TABLE ABOUTPAGE.CLIENTS_ITEMS (_ID SMALLINT GENERATED ALWAYS AS IDENTITY, IMG VARCHAR(30) NOT NULL, ALT VARCHAR(30));
INSERT INTO ABOUTPAGE.CLIENTS_ITEMS VALUES
	(DEFAULT, 'client-1.png', 'emotion in motion logo'),
	(DEFAULT, 'client-2.png', 'eater logo'),
	(DEFAULT, 'client-3.png', 'fotografr logo'),
	(DEFAULT, 'client-4.png', 'pencl sketches logo'),
	(DEFAULT, 'client-5.png', 'good food logo'),
	(DEFAULT, 'client-6.png', 'envato logo');

---GET ABOUTPAGE IN JSONB---
SELECT JSONB_BUILD_OBJECT(
	'title', (SELECT A.TITLE),
	'text', (SELECT A.TEXT),
	'img', (SELECT A.IMG),
	'features', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
		'_id', (SELECT F._ID),
		'title', (SELECT F.TITLE),
		'text', (SELECT F.TEXT),
		'img', (SELECT F.IMG)
	)) FROM ABOUTPAGE.FEATURES F),
	'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
		'_id', (SELECT AI._ID),
		'title', (SELECT AI.TITLE),
		'text', (SELECT AI.TEXT)
	)) FROM ABOUTPAGE.ABOUT_ITEMS AI),
	'teams', (SELECT JSONB_BUILD_OBJECT(
		'title', (SELECT T.TITLE),
		'subTitle', (SELECT T.SUBTITLE),
		'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', (SELECT TI._ID),
			'name', (SELECT TI.NAME),
			'img', (SELECT TI.IMG),
			'position', (SELECT TI.POSITION)
		)) FROM ABOUTPAGE.TEAMS_ITEMS TI)
	) FROM ABOUTPAGE.TEAMS T),
	'testimonials', (SELECT JSONB_BUILD_OBJECT(
		'title', (SELECT TE.TITLE),
		'subTitle', (SELECT TE.SUBTITLE),
		'text', (SELECT TE.TEXT),
		'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', (SELECT TEI._ID),
			'name', (SELECT TEI.NAME),
			'img', (SELECT TEI.IMG),
			'position', (SELECT TEI.POSITION),
			'rate', (SELECT TEI.RATE),
			'text', (SELECT TEI.TEXT)
		)) FROM ABOUTPAGE.TESTIMONIALS_ITEMS TEI)
	) FROM ABOUTPAGE.TESTIMONIALS TE),
	'quantities', (SELECT JSONB_AGG(QI) FROM ABOUTPAGE.QUANTITIES_ITEMS QI),
	'clients', (SELECT JSONB_BUILD_OBJECT(
		'title', (SELECT C.TITLE),
		'subTitle', (SELECT C.SUBTITLE),
		'items', (SELECT JSONB_AGG(CI) FROM ABOUTPAGE.CLIENTS_ITEMS CI)
	) FROM ABOUTPAGE.CLIENTS C)
) FROM ABOUTPAGE.ABOUT A;

---CREATE FUNCTION GET ABOUTPAGE---
CREATE FUNCTION ABOUTPAGE.GET_ABOUTPAGE()
RETURNS JSONB AS
$$
DECLARE
	ABOUTPAGE JSONB;
BEGIN
	ABOUTPAGE := JSONB_BUILD_OBJECT(
		'title', (SELECT A.TITLE),
		'text', (SELECT A.TEXT),
		'img', (SELECT A.IMG),
		'features', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', (SELECT F._ID),
			'title', (SELECT F.TITLE),
			'text', (SELECT F.TEXT),
			'img', (SELECT F.IMG)
		)) FROM ABOUTPAGE.FEATURES F),
		'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
			'_id', (SELECT AI._ID),
			'title', (SELECT AI.TITLE),
			'text', (SELECT AI.TEXT)
		)) FROM ABOUTPAGE.ABOUT_ITEMS AI),
		'teams', (SELECT JSONB_BUILD_OBJECT(
			'title', (SELECT T.TITLE),
			'subTitle', (SELECT T.SUBTITLE),
			'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
				'_id', (SELECT TI._ID),
				'name', (SELECT TI.NAME),
				'img', (SELECT TI.IMG),
				'position', (SELECT TI.POSITION)
			)) FROM ABOUTPAGE.TEAMS_ITEMS TI)
		) FROM ABOUTPAGE.TEAMS T),
		'testimonials', (SELECT JSONB_BUILD_OBJECT(
			'title', (SELECT TE.TITLE),
			'subTitle', (SELECT TE.SUBTITLE),
			'text', (SELECT TE.TEXT),
			'items', (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
				'_id', (SELECT TEI._ID),
				'name', (SELECT TEI.NAME),
				'img', (SELECT TEI.IMG),
				'position', (SELECT TEI.POSITION),
				'rate', (SELECT TEI.RATE),
				'text', (SELECT TEI.TEXT)
			)) FROM ABOUTPAGE.TESTIMONIALS_ITEMS TEI)
		) FROM ABOUTPAGE.TESTIMONIALS TE),
		'quantities', (SELECT JSONB_AGG(QI) FROM ABOUTPAGE.QUANTITIES_ITEMS QI),
		'clients', (SELECT JSONB_BUILD_OBJECT(
			'title', (SELECT C.TITLE),
			'subTitle', (SELECT C.SUBTITLE),
			'items', (SELECT JSONB_AGG(CI) FROM ABOUTPAGE.CLIENTS_ITEMS CI)
		) FROM ABOUTPAGE.CLIENTS C)
	) FROM ABOUTPAGE.ABOUT A;
	RETURN ABOUTPAGE;
END;
$$
LANGUAGE PLPGSQL;

EXPLAIN ANALYZE SELECT * FROM ABOUTPAGE.GET_ABOUTPAGE();

