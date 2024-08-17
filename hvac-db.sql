--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-08-17 23:00:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 16886)
-- Name: aboutpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA aboutpage;


ALTER SCHEMA aboutpage OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 16985)
-- Name: carpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA carpage;


ALTER SCHEMA carpage OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 16965)
-- Name: contactpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contactpage;


ALTER SCHEMA contactpage OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 30298)
-- Name: customer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA customer;


ALTER SCHEMA customer OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 52235)
-- Name: employee; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA employee;


ALTER SCHEMA employee OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 16736)
-- Name: homepage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA homepage;


ALTER SCHEMA homepage OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 16789)
-- Name: layout; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA layout;


ALTER SCHEMA layout OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 51933)
-- Name: product; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA product;


ALTER SCHEMA product OWNER TO postgres;

--
-- TOC entry 1078 (class 1247 OID 30359)
-- Name: email_type; Type: DOMAIN; Schema: customer; Owner: postgres
--

CREATE DOMAIN customer.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN customer.email_type OWNER TO postgres;

--
-- TOC entry 1074 (class 1247 OID 30356)
-- Name: phone_type; Type: DOMAIN; Schema: customer; Owner: postgres
--

CREATE DOMAIN customer.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN customer.phone_type OWNER TO postgres;

--
-- TOC entry 1053 (class 1247 OID 52240)
-- Name: email_type; Type: DOMAIN; Schema: employee; Owner: postgres
--

CREATE DOMAIN employee.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN employee.email_type OWNER TO postgres;

--
-- TOC entry 1049 (class 1247 OID 52237)
-- Name: phone_type; Type: DOMAIN; Schema: employee; Owner: postgres
--

CREATE DOMAIN employee.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN employee.phone_type OWNER TO postgres;

--
-- TOC entry 1070 (class 1247 OID 36460)
-- Name: email_type; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN public.email_type OWNER TO postgres;

--
-- TOC entry 1066 (class 1247 OID 36457)
-- Name: phone_type; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN public.phone_type OWNER TO postgres;

--
-- TOC entry 308 (class 1255 OID 16964)
-- Name: get_aboutpage(); Type: FUNCTION; Schema: aboutpage; Owner: postgres
--

CREATE FUNCTION aboutpage.get_aboutpage() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION aboutpage.get_aboutpage() OWNER TO postgres;

--
-- TOC entry 293 (class 1255 OID 16994)
-- Name: get_carpage(); Type: FUNCTION; Schema: carpage; Owner: postgres
--

CREATE FUNCTION carpage.get_carpage() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION carpage.get_carpage() OWNER TO postgres;

--
-- TOC entry 292 (class 1255 OID 16982)
-- Name: get_contactpage(); Type: FUNCTION; Schema: contactpage; Owner: postgres
--

CREATE FUNCTION contactpage.get_contactpage() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION contactpage.get_contactpage() OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 16876)
-- Name: get_car(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_car() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	CAR JSONB;
BEGIN
	CAR := JSONB_BUILD_OBJECT(
		'title', (SELECT C.TITLE),
		'subTitle', (SELECT C.SUBTITLE)
	) FROM HOMEPAGE.CAR C;
	RETURN CAR;
END;
$$;


ALTER FUNCTION homepage.get_car() OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 16877)
-- Name: get_chooseus(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_chooseus() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	CHOOSEUS JSONB;
BEGIN
	CHOOSEUS := JSONB_BUILD_OBJECT(
		'title', (SELECT CU.TITLE),
		'text', (SELECT CU.TEXT),
		'videoUrl', (SELECT CU.VIDEOURL),
		'items', (SELECT JSONB_AGG(ROW_TO_JSON(CUI)) FROM HOMEPAGE.CHOOSEUS_ITEMS CUI)
	) FROM HOMEPAGE.CHOOSEUS CU;
	RETURN CHOOSEUS;
END;
$$;


ALTER FUNCTION homepage.get_chooseus() OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 16884)
-- Name: get_cta(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_cta() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	CTA JSONB;
BEGIN
	CTA := JSONB_BUILD_OBJECT(
		'items', (SELECT JSONB_AGG(ROW_TO_JSON(C)) FROM HOMEPAGE.CTA C)
	);
	RETURN CTA;
END;
$$;


ALTER FUNCTION homepage.get_cta() OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 16875)
-- Name: get_features(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_features() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	FEATURES JSONB;
BEGIN
	FEATURES := JSON_BUILD_OBJECT(
		'title', (SELECT F.TITLE),
		'subTitle', (SELECT F.SUBTITLE),
		'text', (SELECT F.TEXT),
		'items', (SELECT JSONB_AGG(ROW_TO_JSON(FI)) FROM HOMEPAGE.FEATURES_ITEMS FI)
	) FROM HOMEPAGE.FEATURES F;
	RETURN FEATURES;
END;
$$;


ALTER FUNCTION homepage.get_features() OWNER TO postgres;

--
-- TOC entry 299 (class 1255 OID 16787)
-- Name: get_hero(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_hero() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	HERO JSONB;
BEGIN
	HERO := JSONB_BUILD_OBJECT(
		'title', (SELECT H.TITLE),
		'filterForm', (SELECT JSONB_BUILD_OBJECT(
			'models', (SELECT TO_JSONB(H.MODELS)),
			'brands', (SELECT TO_JSONB(H.BRANDS)),
			'transmissions', (SELECT TO_JSONB(H.TRANSMISSIONS)),
			'types', (SELECT TO_JSONB(H.TYPES))
		))
	) FROM HOMEPAGE.HERO H;
	RETURN HERO;
END;
$$;


ALTER FUNCTION homepage.get_hero() OWNER TO postgres;

--
-- TOC entry 291 (class 1255 OID 16885)
-- Name: get_homepage(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_homepage() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	HOMEPAGE JSONB;
BEGIN
	HOMEPAGE := JSONB_BUILD_OBJECT(
		'hero', (SELECT * FROM HOMEPAGE.GET_HERO()),
		'services', (SELECT * FROM HOMEPAGE.GET_SERVICES()),
		'features', (SELECT * FROM HOMEPAGE.GET_FEATURES()),
		'car', (SELECT * FROM HOMEPAGE.GET_CAR()),
		'chooseus', (SELECT * FROM HOMEPAGE.GET_CHOOSEUS()),
		'cta', (SELECT * FROM HOMEPAGE.GET_CTA())
	);
	RETURN HOMEPAGE;
END;
$$;


ALTER FUNCTION homepage.get_homepage() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 16874)
-- Name: get_services(); Type: FUNCTION; Schema: homepage; Owner: postgres
--

CREATE FUNCTION homepage.get_services() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
	SERVICES JSONB;
BEGIN
	SERVICES := JSONB_BUILD_OBJECT(
		'title', (SELECT S.TITLE),
		'subTitle', (SELECT S.SUBTITLE),
		'text', (SELECT S.TEXT),
		'items', (SELECT JSONB_AGG(ROW_TO_JSON(SI)) FROM HOMEPAGE.SERVICES_ITEMS SI)
	) FROM HOMEPAGE.SERVICES S;
	RETURN SERVICES;
END;
$$;


ALTER FUNCTION homepage.get_services() OWNER TO postgres;

--
-- TOC entry 307 (class 1255 OID 16806)
-- Name: get_layout(); Type: FUNCTION; Schema: layout; Owner: postgres
--

CREATE FUNCTION layout.get_layout() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION layout.get_layout() OWNER TO postgres;

--
-- TOC entry 309 (class 1255 OID 52231)
-- Name: check_product_id_customer_id_existed(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_product_id_customer_id_existed() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS (
		SELECT ID FROM CUSTOMER.ORDERS WHERE CUSTOMER_ID = NEW.CUSTOMER_ID AND PRODUCT_ID = NEW.PRODUCT_ID
	) THEN RAISE EXCEPTION 'Product was existed with this customer!';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_product_id_customer_id_existed() OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 36453)
-- Name: check_unique_email_phone(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_unique_email_phone() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS(
		SELECT 1 FROM CUSTOMER.CUSTOMERS WHERE EMAIL = NEW.EMAIL OR PHONE = NEW.PHONE
	) THEN RAISE EXCEPTION 'Email or Phone was existed!';
	END IF;
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_unique_email_phone() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 241 (class 1259 OID 16902)
-- Name: about; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.about (
    _id integer NOT NULL,
    title text[] NOT NULL,
    text text,
    img character varying(20) NOT NULL
);


ALTER TABLE aboutpage.about OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16901)
-- Name: about__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.about ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 16918)
-- Name: about_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.about_items (
    _id integer NOT NULL,
    title character varying(15) NOT NULL,
    text text NOT NULL
);


ALTER TABLE aboutpage.about_items OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16917)
-- Name: about_items__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.about_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 254 (class 1259 OID 16956)
-- Name: clients; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.clients (
    title character varying(30) NOT NULL,
    subtitle character varying(20) NOT NULL
);


ALTER TABLE aboutpage.clients OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 16960)
-- Name: clients_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.clients_items (
    _id smallint NOT NULL,
    img character varying(30) NOT NULL,
    alt character varying(30)
);


ALTER TABLE aboutpage.clients_items OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 16959)
-- Name: clients_items__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.clients_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.clients_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 16909)
-- Name: features; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.features (
    _id integer NOT NULL,
    title character varying(50) NOT NULL,
    text text NOT NULL,
    img character varying(30) NOT NULL
);


ALTER TABLE aboutpage.features OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16908)
-- Name: features__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.features ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.features__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 253 (class 1259 OID 16953)
-- Name: quantities_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.quantities_items (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    value smallint NOT NULL
);


ALTER TABLE aboutpage.quantities_items OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16952)
-- Name: quantities_items__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.quantities_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.quantities_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 16923)
-- Name: teams; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.teams (
    title character varying(15) NOT NULL,
    subtitle character varying(30) NOT NULL
);


ALTER TABLE aboutpage.teams OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16927)
-- Name: teams_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.teams_items (
    _id integer NOT NULL,
    name character varying(50) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL
);


ALTER TABLE aboutpage.teams_items OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16926)
-- Name: teams_items__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.teams_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.teams_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 249 (class 1259 OID 16941)
-- Name: testimonials; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.testimonials (
    title character varying(30) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text
);


ALTER TABLE aboutpage.testimonials OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16947)
-- Name: testimonials_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.testimonials_items (
    _id smallint NOT NULL,
    name character varying(30) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL,
    rate numeric NOT NULL,
    text text NOT NULL
);


ALTER TABLE aboutpage.testimonials_items OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16946)
-- Name: testimonials_items__id_seq; Type: SEQUENCE; Schema: aboutpage; Owner: postgres
--

ALTER TABLE aboutpage.testimonials_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.testimonials_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 262 (class 1259 OID 16987)
-- Name: filterform; Type: TABLE; Schema: carpage; Owner: postgres
--

CREATE TABLE carpage.filterform (
    _id smallint NOT NULL,
    name character varying(15) NOT NULL,
    label character varying(15) NOT NULL,
    options character varying(12)[] NOT NULL
);


ALTER TABLE carpage.filterform OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 16986)
-- Name: filterform__id_seq; Type: SEQUENCE; Schema: carpage; Owner: postgres
--

ALTER TABLE carpage.filterform ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME carpage.filterform__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 257 (class 1259 OID 16966)
-- Name: contact; Type: TABLE; Schema: contactpage; Owner: postgres
--

CREATE TABLE contactpage.contact (
    title character varying(30) NOT NULL,
    text text
);


ALTER TABLE contactpage.contact OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 16971)
-- Name: schedule; Type: TABLE; Schema: contactpage; Owner: postgres
--

CREATE TABLE contactpage.schedule (
    weekdays character varying(20) NOT NULL,
    saturday character varying(20) NOT NULL,
    sunday character varying(20) NOT NULL
);


ALTER TABLE contactpage.schedule OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 16975)
-- Name: showrooms; Type: TABLE; Schema: contactpage; Owner: postgres
--

CREATE TABLE contactpage.showrooms (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    address text NOT NULL,
    email character varying(30) NOT NULL,
    phone character varying(17) NOT NULL
);


ALTER TABLE contactpage.showrooms OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16974)
-- Name: showrooms__id_seq; Type: SEQUENCE; Schema: contactpage; Owner: postgres
--

ALTER TABLE contactpage.showrooms ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME contactpage.showrooms__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 275 (class 1259 OID 52107)
-- Name: customers; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.customers (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);


ALTER TABLE customer.customers OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 52106)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

ALTER TABLE customer.customers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME customer.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 279 (class 1259 OID 52171)
-- Name: orders; Type: TABLE; Schema: customer; Owner: postgres
--

CREATE TABLE customer.orders (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);


ALTER TABLE customer.orders OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 52170)
-- Name: orders_id_seq; Type: SEQUENCE; Schema: customer; Owner: postgres
--

ALTER TABLE customer.orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME customer.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 283 (class 1259 OID 52269)
-- Name: employees; Type: TABLE; Schema: employee; Owner: postgres
--

CREATE TABLE employee.employees (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    power character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);


ALTER TABLE employee.employees OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 52268)
-- Name: employees_id_seq; Type: SEQUENCE; Schema: employee; Owner: postgres
--

ALTER TABLE employee.employees ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME employee.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16837)
-- Name: car; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.car (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL
);


ALTER TABLE homepage.car OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16847)
-- Name: chooseus; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.chooseus (
    title character varying(25) NOT NULL,
    text text,
    videourl text NOT NULL
);


ALTER TABLE homepage.chooseus OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16853)
-- Name: chooseus_items; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.chooseus_items (
    _id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE homepage.chooseus_items OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16852)
-- Name: chooseus_items__id_seq; Type: SEQUENCE; Schema: homepage; Owner: postgres
--

ALTER TABLE homepage.chooseus_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.chooseus_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 16868)
-- Name: cta; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.cta (
    title character varying(25) NOT NULL,
    text text,
    img character varying(10) NOT NULL,
    _id integer NOT NULL
);


ALTER TABLE homepage.cta OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16878)
-- Name: cta__id_seq; Type: SEQUENCE; Schema: homepage; Owner: postgres
--

ALTER TABLE homepage.cta ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.cta__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 16828)
-- Name: features; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.features (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text[]
);


ALTER TABLE homepage.features OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16834)
-- Name: features_items; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.features_items (
    _id integer NOT NULL,
    text character varying(10) NOT NULL,
    img character varying(15) NOT NULL
);


ALTER TABLE homepage.features_items OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16833)
-- Name: features_items__id_seq; Type: SEQUENCE; Schema: homepage; Owner: postgres
--

ALTER TABLE homepage.features_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.features_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 16775)
-- Name: hero; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.hero (
    title character varying(20) NOT NULL,
    models smallint[] NOT NULL,
    brands character varying(15)[] NOT NULL,
    transmissions character varying(15)[] NOT NULL,
    types character varying(10)[] NOT NULL
);


ALTER TABLE homepage.hero OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16815)
-- Name: services; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.services (
    title character varying(20) NOT NULL,
    subtitle character varying(20) NOT NULL,
    text text
);


ALTER TABLE homepage.services OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16821)
-- Name: services_items; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.services_items (
    _id integer NOT NULL,
    title character varying(20) NOT NULL,
    text text NOT NULL,
    img character varying(20) NOT NULL
);


ALTER TABLE homepage.services_items OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16820)
-- Name: services_items__id_seq; Type: SEQUENCE; Schema: homepage; Owner: postgres
--

ALTER TABLE homepage.services_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.services_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 16801)
-- Name: contactInfo; Type: TABLE; Schema: layout; Owner: postgres
--

CREATE TABLE layout."contactInfo" (
    email character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    schedule character varying(30) NOT NULL,
    socials jsonb NOT NULL
);


ALTER TABLE layout."contactInfo" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16796)
-- Name: footer; Type: TABLE; Schema: layout; Owner: postgres
--

CREATE TABLE layout.footer (
    "contactTitle" character varying(20) NOT NULL,
    "aboutContent" character varying(100) NOT NULL,
    imgs jsonb NOT NULL
);


ALTER TABLE layout.footer OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16791)
-- Name: navbar; Type: TABLE; Schema: layout; Owner: postgres
--

CREATE TABLE layout.navbar (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    path character varying(11) NOT NULL
);


ALTER TABLE layout.navbar OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16790)
-- Name: navbar_id_seq; Type: SEQUENCE; Schema: layout; Owner: postgres
--

ALTER TABLE layout.navbar ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME layout.navbar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 264 (class 1259 OID 51935)
-- Name: cars; Type: TABLE; Schema: product; Owner: postgres
--

CREATE TABLE product.cars (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY LIST (brand);


ALTER TABLE product.cars OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 51934)
-- Name: cars_id_seq; Type: SEQUENCE; Schema: product; Owner: postgres
--

ALTER TABLE product.cars ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 265 (class 1259 OID 51941)
-- Name: audi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audi (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.audi OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 51947)
-- Name: bmw; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bmw (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.bmw OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 52113)
-- Name: customers_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_2024 (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.customers_2024 OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 52121)
-- Name: customers_default; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_default (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.customers_default OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 52276)
-- Name: emp_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_2024 (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    power character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.emp_2024 OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 52285)
-- Name: emp_others; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp_others (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    power character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.emp_others OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 51953)
-- Name: ferrari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ferrari (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.ferrari OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 51959)
-- Name: ford; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ford (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.ford OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 51965)
-- Name: honda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.honda (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.honda OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 51971)
-- Name: lamborghini; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lamborghini (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.lamborghini OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 51977)
-- Name: mazda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mazda (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.mazda OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 51983)
-- Name: mercedes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mercedes (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.mercedes OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 52179)
-- Name: order_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_2024 (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.order_2024 OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 52187)
-- Name: order_others; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_others (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.order_others OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 51989)
-- Name: other_brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.other_brand (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    tradetype character varying(4) NOT NULL,
    fueltype character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.other_brand OWNER TO postgres;

--
-- TOC entry 4926 (class 0 OID 0)
-- Name: audi; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.audi FOR VALUES IN ('audi');


--
-- TOC entry 4927 (class 0 OID 0)
-- Name: bmw; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.bmw FOR VALUES IN ('bmw');


--
-- TOC entry 4935 (class 0 OID 0)
-- Name: customers_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- TOC entry 4936 (class 0 OID 0)
-- Name: customers_default; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_default DEFAULT;


--
-- TOC entry 4939 (class 0 OID 0)
-- Name: emp_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- TOC entry 4940 (class 0 OID 0)
-- Name: emp_others; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_others DEFAULT;


--
-- TOC entry 4928 (class 0 OID 0)
-- Name: ferrari; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.ferrari FOR VALUES IN ('ferrari');


--
-- TOC entry 4929 (class 0 OID 0)
-- Name: ford; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.ford FOR VALUES IN ('ford');


--
-- TOC entry 4930 (class 0 OID 0)
-- Name: honda; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.honda FOR VALUES IN ('honda');


--
-- TOC entry 4931 (class 0 OID 0)
-- Name: lamborghini; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.lamborghini FOR VALUES IN ('lamborghini');


--
-- TOC entry 4932 (class 0 OID 0)
-- Name: mazda; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.mazda FOR VALUES IN ('mazda');


--
-- TOC entry 4933 (class 0 OID 0)
-- Name: mercedes; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.mercedes FOR VALUES IN ('mercedes');


--
-- TOC entry 4937 (class 0 OID 0)
-- Name: order_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- TOC entry 4938 (class 0 OID 0)
-- Name: order_others; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_others DEFAULT;


--
-- TOC entry 4934 (class 0 OID 0)
-- Name: other_brand; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.other_brand DEFAULT;


--
-- TOC entry 5256 (class 0 OID 16902)
-- Dependencies: 241
-- Data for Name: about; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.about (_id, title, text, img) FROM stdin;
1	{"welcome to hvac auto online","we provide everything you need to a car"}	First I will explain what contextual advertising is. Contextual advertising means the advertising of products on a website according to the content the page is displaying. For example if the content of a website was information on a Ford truck then the advertisements	about-pic.jpg
\.


--
-- TOC entry 5260 (class 0 OID 16918)
-- Dependencies: 245
-- Data for Name: about_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.about_items (_id, title, text) FROM stdin;
1	our mission	now, i’m not like Robin, that weirdo from my cultural anthropology class; I think that advertising is something that has its place in our society; which for better or worse is structured along a marketplace economy. But, simply because i feel advertising has a right to exist, doesn’t mean that i like or agree with it, in its
2	our vision	where do you register your complaints? How can you protest in any form against companies whose advertising techniques you don’t agree with? You don’t. And on another point of difference between traditional products and their advertising and those of the internet nature, simply ignoring internet advertising is
\.


--
-- TOC entry 5269 (class 0 OID 16956)
-- Dependencies: 254
-- Data for Name: clients; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.clients (title, subtitle) FROM stdin;
partner	our clients
\.


--
-- TOC entry 5271 (class 0 OID 16960)
-- Dependencies: 256
-- Data for Name: clients_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.clients_items (_id, img, alt) FROM stdin;
1	client-1.png	emotion in motion logo
2	client-2.png	eater logo
3	client-3.png	fotografr logo
4	client-4.png	pencl sketches logo
5	client-5.png	good food logo
6	client-6.png	envato logo
\.


--
-- TOC entry 5258 (class 0 OID 16909)
-- Dependencies: 243
-- Data for Name: features; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.features (_id, title, text, img) FROM stdin;
1	quality assurance system	it seems though that some of the biggest problems with the internet advertising trends are the lack of	features/af-1.png
2	accurate testing processes	where do you register your complaints? How can you protest in any form against companies whose	features/af-2.png
3	infrastructure integration technology	So in final analysis: it’s true, I hate peeping Toms, but if I had to choose, I’d take one any day over an	features/af-3.png
\.


--
-- TOC entry 5268 (class 0 OID 16953)
-- Dependencies: 253
-- Data for Name: quantities_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.quantities_items (_id, name, value) FROM stdin;
1	vehicles stock	1922
2	vehicles sale	1500
3	dealer reviews	2214
4	happy clients	5100
\.


--
-- TOC entry 5261 (class 0 OID 16923)
-- Dependencies: 246
-- Data for Name: teams; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.teams (title, subtitle) FROM stdin;
our team	meet our expert
\.


--
-- TOC entry 5263 (class 0 OID 16927)
-- Dependencies: 248
-- Data for Name: teams_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.teams_items (_id, name, img, "position") FROM stdin;
1	john smith	team-1.jpg	marketing
2	christine wise	team-2.jpg	CEO
3	sean robbins	team-3.jpg	manager
4	lucy myers	team-4.jpg	delivary
\.


--
-- TOC entry 5264 (class 0 OID 16941)
-- Dependencies: 249
-- Data for Name: testimonials; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.testimonials (title, subtitle, text) FROM stdin;
testimonials	what people say about us?	Our customers are our biggest supporters. What do they think of us?
\.


--
-- TOC entry 5266 (class 0 OID 16947)
-- Dependencies: 251
-- Data for Name: testimonials_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.testimonials_items (_id, name, img, "position", rate, text) FROM stdin;
1	john smith	testimonial-1.png	CEO ABC	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.
2	emma sandoval	testimonial-1.png	CEO ABC	4.5	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.
\.


--
-- TOC entry 5277 (class 0 OID 16987)
-- Dependencies: 262
-- Data for Name: filterform; Type: TABLE DATA; Schema: carpage; Owner: postgres
--

COPY carpage.filterform (_id, name, label, options) FROM stdin;
1	brand	brand	{honda,mazda,ford,audi,mercedes,bmw,ferrari,lamborghini}
2	model	model	{2019,2020,2021,2022,2023}
3	carType	car type	{SUV,sedan,sport,hatchback}
4	transmission	transmission	{auto,manual}
5	mileage	mileage	{1000,10000,15000}
\.


--
-- TOC entry 5272 (class 0 OID 16966)
-- Dependencies: 257
-- Data for Name: contact; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.contact (title, text) FROM stdin;
let's work together	to make requests for further information, contact us via our social channels.
\.


--
-- TOC entry 5273 (class 0 OID 16971)
-- Dependencies: 258
-- Data for Name: schedule; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.schedule (weekdays, saturday, sunday) FROM stdin;
08:00 am to 18:00 pm	10:00 am to 16:00 pm	closed
\.


--
-- TOC entry 5275 (class 0 OID 16975)
-- Dependencies: 260
-- Data for Name: showrooms; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.showrooms (_id, name, address, email, phone) FROM stdin;
1	california showroom	625 Gloria Union, California, United Stated	hvac.california@gmail.com	(+01) 123 456 789
2	new york showroom	8235 South Ave. Jamestown, NewYork	hvac.newyork@gmail.com	(+01) 123 456 789
3	florida showroom	497 Beaver Ridge St. Daytona Beach, Florida	hvac.florida@gmail.com	(+01) 123 456 789
\.


--
-- TOC entry 5249 (class 0 OID 16837)
-- Dependencies: 234
-- Data for Name: car; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.car (title, subtitle) FROM stdin;
our cars	best vihicle offers
\.


--
-- TOC entry 5250 (class 0 OID 16847)
-- Dependencies: 235
-- Data for Name: chooseus; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.chooseus (title, text, videourl) FROM stdin;
why people choose us	Duis aute irure dolorin reprehenderits volupta velit dolore fugiat nulla pariatur excepteur sint occaecat cupidatat.	https://www.youtube.com/watch?v=sitXeGjm4Mc
\.


--
-- TOC entry 5252 (class 0 OID 16853)
-- Dependencies: 237
-- Data for Name: chooseus_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.chooseus_items (_id, text) FROM stdin;
1	Lorem ipsum dolor sit amet, consectetur adipiscing elit.
2	Integer et nisl et massa tempor ornare vel id orci.
3	Nunc consectetur ligula vitae nisl placerat tempus.
4	Curabitur quis ante vitae lacus varius pretium.
\.


--
-- TOC entry 5253 (class 0 OID 16868)
-- Dependencies: 238
-- Data for Name: cta; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.cta (title, text, img, _id) FROM stdin;
do you want to buy a car	lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	cta-1.jpg	1
do you want to rent a car	lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	cta-2.jpg	2
\.


--
-- TOC entry 5246 (class 0 OID 16828)
-- Dependencies: 231
-- Data for Name: features; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.features (title, subtitle, text) FROM stdin;
our features	we are a trusted name in auto	{"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel facilisis."}
\.


--
-- TOC entry 5248 (class 0 OID 16834)
-- Dependencies: 233
-- Data for Name: features_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.features_items (_id, text, img) FROM stdin;
1	engine	feature-1.png
2	turbo	feature-2.png
3	cooling	feature-3.png
4	suspension	feature-4.png
5	electrical	feature-5.png
6	brakes	feature-6.png
\.


--
-- TOC entry 5238 (class 0 OID 16775)
-- Dependencies: 223
-- Data for Name: hero; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.hero (title, models, brands, transmissions, types) FROM stdin;
find your dream car	{2019,2020,2021,2022,2023,2024}	{audi,lamborghini,porscher,bmw,ford}	{auto,manual}	{sedan,suv,sport,hatchback}
\.


--
-- TOC entry 5243 (class 0 OID 16815)
-- Dependencies: 228
-- Data for Name: services; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.services (title, subtitle, text) FROM stdin;
our services	what we offers	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
\.


--
-- TOC entry 5245 (class 0 OID 16821)
-- Dependencies: 230
-- Data for Name: services_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.services_items (_id, title, text, img) FROM stdin;
1	rental a car	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-1.png
2	buying a car	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-2.png
3	car maintenance	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-3.png
4	support 24/7	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-4.png
\.


--
-- TOC entry 5242 (class 0 OID 16801)
-- Dependencies: 227
-- Data for Name: contactInfo; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout."contactInfo" (email, phone, schedule, socials) FROM stdin;
hvac@mail.com	(+84) 123 456 789	weekday: 08:00am to 09:00pm	{"skype": "https://skype.com", "google": "https://google.com", "twitter": "https://twitter.com", "facebook": "https://facebook.com", "instagram": "https://instagram.com"}
\.


--
-- TOC entry 5241 (class 0 OID 16796)
-- Dependencies: 226
-- Data for Name: footer; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout.footer ("contactTitle", "aboutContent", imgs) FROM stdin;
contact us now!	Any questions? Let us know in store at Ha Noi, Viet Nam or call us on (+84) 123 456 789	{"bg": "footer-bg.jpg", "logo": "footer-logo.png"}
\.


--
-- TOC entry 5240 (class 0 OID 16791)
-- Dependencies: 225
-- Data for Name: navbar; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout.navbar (id, name, path) FROM stdin;
1	home	/
2	cars	/cars
3	about	/about
4	contact	/contact
\.


--
-- TOC entry 5279 (class 0 OID 51941)
-- Dependencies: 265
-- Data for Name: audi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audi (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
1	audi a6	audi	327.00	auto	rent	gasoline	sedan	250	2022	16458	2024-08-17
2	audi a7	audi	471.00	auto	rent	gasoline	sportback	250	2023	18321	2024-08-17
\.


--
-- TOC entry 5280 (class 0 OID 51947)
-- Dependencies: 266
-- Data for Name: bmw; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bmw (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
3	bmw 530i sedan	bmw	71846.41	auto	sale	electric	sedan	184	2021	10154	2024-08-17
4	bmw 735i m sport	bmw	176671.51	auto	sale	gasoline	sedan	286	2023	13552	2024-08-17
\.


--
-- TOC entry 5289 (class 0 OID 52113)
-- Dependencies: 276
-- Data for Name: customers_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_2024 (id, email, password, name, phone, created_at) FROM stdin;
\.


--
-- TOC entry 5290 (class 0 OID 52121)
-- Dependencies: 277
-- Data for Name: customers_default; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_default (id, email, password, name, phone, created_at) FROM stdin;
\.


--
-- TOC entry 5295 (class 0 OID 52276)
-- Dependencies: 284
-- Data for Name: emp_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_2024 (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
1	admin@mail.com	admin	0123456789	admin	admin	2024-08-17	2024-08-17
\.


--
-- TOC entry 5296 (class 0 OID 52285)
-- Dependencies: 285
-- Data for Name: emp_others; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_others (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5281 (class 0 OID 51953)
-- Dependencies: 267
-- Data for Name: ferrari; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ferrari (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
5	LaFerrari Aperta	ferrari	5000000.00	auto	sale	electric	sport	700	2016	10423	2024-08-17
6	ferrari SF90 stradale	ferrari	990000.00	auto	sale	electric	sport	986	2020	10645	2024-08-17
\.


--
-- TOC entry 5282 (class 0 OID 51959)
-- Dependencies: 268
-- Data for Name: ford; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ford (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
7	ford mustang® dark horse™ premium	ford	62930.00	auto	sale	gasoline	suv	500	2024	11785	2024-08-17
8	ford ranger raptor®	ford	55620.00	auto	sale	gasoline	truck	315	2024	10985	2024-08-17
\.


--
-- TOC entry 5283 (class 0 OID 51965)
-- Dependencies: 269
-- Data for Name: honda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.honda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
9	honda CR-V EX-L	honda	35000.00	auto	sale	electric	suv	190	2024	14300	2024-08-17
10	honda pilot black edition	honda	54280.00	manual	sale	electric	suv	285	2024	9536	2024-08-17
\.


--
-- TOC entry 5284 (class 0 OID 51971)
-- Dependencies: 270
-- Data for Name: lamborghini; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lamborghini (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
11	lamborghini revuelto	lamborghini	608.36	manual	sale	mixed	sport	813	2024	6595	2024-08-17
12	lamborghini sian roadster	lamborghini	3800000.00	auto	sale	electric	sport	800	2024	9452	2024-08-17
\.


--
-- TOC entry 5285 (class 0 OID 51977)
-- Dependencies: 271
-- Data for Name: mazda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mazda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
13	mazda 6	mazda	605.00	auto	rent	gasoline	sedan	154	2021	24160	2024-08-17
14	mazda CX-8	mazda	526.00	auto	rent	gasoline	suv	188	2021	24452	2024-08-17
\.


--
-- TOC entry 5286 (class 0 OID 51983)
-- Dependencies: 272
-- Data for Name: mercedes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mercedes (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
15	mercedes C-200	mercedes	213.00	auto	rent	gasoline	sedan	258	2022	16584	2024-08-17
16	maybach s450	mercedes	447.00	auto	rent	gasoline	sedan	367	2024	25400	2024-08-17
\.


--
-- TOC entry 5292 (class 0 OID 52179)
-- Dependencies: 280
-- Data for Name: order_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_2024 (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
8	1	1	1	180	0	2024-08-17
\.


--
-- TOC entry 5293 (class 0 OID 52187)
-- Dependencies: 281
-- Data for Name: order_others; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_others (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
\.


--
-- TOC entry 5287 (class 0 OID 51989)
-- Dependencies: 273
-- Data for Name: other_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.other_brand (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.


--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 240
-- Name: about__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.about__id_seq', 1, true);


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 244
-- Name: about_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.about_items__id_seq', 2, true);


--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 255
-- Name: clients_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.clients_items__id_seq', 6, true);


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 242
-- Name: features__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.features__id_seq', 3, true);


--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 252
-- Name: quantities_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.quantities_items__id_seq', 4, true);


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 247
-- Name: teams_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.teams_items__id_seq', 4, true);


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 250
-- Name: testimonials_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.testimonials_items__id_seq', 2, true);


--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 261
-- Name: filterform__id_seq; Type: SEQUENCE SET; Schema: carpage; Owner: postgres
--

SELECT pg_catalog.setval('carpage.filterform__id_seq', 5, true);


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 259
-- Name: showrooms__id_seq; Type: SEQUENCE SET; Schema: contactpage; Owner: postgres
--

SELECT pg_catalog.setval('contactpage.showrooms__id_seq', 3, true);


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 274
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.customers_id_seq', 1, true);


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 278
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.orders_id_seq', 9, true);


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 282
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: employee; Owner: postgres
--

SELECT pg_catalog.setval('employee.employees_id_seq', 1, true);


--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 236
-- Name: chooseus_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.chooseus_items__id_seq', 4, true);


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 239
-- Name: cta__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.cta__id_seq', 2, true);


--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 232
-- Name: features_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.features_items__id_seq', 6, true);


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 229
-- Name: services_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.services_items__id_seq', 4, true);


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 224
-- Name: navbar_id_seq; Type: SEQUENCE SET; Schema: layout; Owner: postgres
--

SELECT pg_catalog.setval('layout.navbar_id_seq', 4, true);


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 263
-- Name: cars_id_seq; Type: SEQUENCE SET; Schema: product; Owner: postgres
--

SELECT pg_catalog.setval('product.cars_id_seq', 16, true);


--
-- TOC entry 4979 (class 2606 OID 16915)
-- Name: features pk_aboutpage_features_id; Type: CONSTRAINT; Schema: aboutpage; Owner: postgres
--

ALTER TABLE ONLY aboutpage.features
    ADD CONSTRAINT pk_aboutpage_features_id PRIMARY KEY (_id);


--
-- TOC entry 4983 (class 2606 OID 16993)
-- Name: filterform pk_carpage_filterform_id; Type: CONSTRAINT; Schema: carpage; Owner: postgres
--

ALTER TABLE ONLY carpage.filterform
    ADD CONSTRAINT pk_carpage_filterform_id PRIMARY KEY (_id);


--
-- TOC entry 4981 (class 2606 OID 16981)
-- Name: showrooms pk_showrooms_id; Type: CONSTRAINT; Schema: contactpage; Owner: postgres
--

ALTER TABLE ONLY contactpage.showrooms
    ADD CONSTRAINT pk_showrooms_id PRIMARY KEY (_id);


--
-- TOC entry 5035 (class 2606 OID 52112)
-- Name: customers pk_customer_id_created_at; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customers
    ADD CONSTRAINT pk_customer_id_created_at PRIMARY KEY (id, created_at);


--
-- TOC entry 5041 (class 2606 OID 52178)
-- Name: orders pk_customer_order_id; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.orders
    ADD CONSTRAINT pk_customer_order_id PRIMARY KEY (id, created_at);


--
-- TOC entry 5047 (class 2606 OID 52275)
-- Name: employees pk_emp_id; Type: CONSTRAINT; Schema: employee; Owner: postgres
--

ALTER TABLE ONLY employee.employees
    ADD CONSTRAINT pk_emp_id PRIMARY KEY (id, created_at);


--
-- TOC entry 4977 (class 2606 OID 16859)
-- Name: chooseus_items pk_chooseus_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.chooseus_items
    ADD CONSTRAINT pk_chooseus_items_id PRIMARY KEY (_id);


--
-- TOC entry 4974 (class 2606 OID 16841)
-- Name: features_items pk_features_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.features_items
    ADD CONSTRAINT pk_features_items_id PRIMARY KEY (_id);


--
-- TOC entry 4972 (class 2606 OID 16827)
-- Name: services_items pk_services_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.services_items
    ADD CONSTRAINT pk_services_items_id PRIMARY KEY (_id);


--
-- TOC entry 4970 (class 2606 OID 16795)
-- Name: navbar pk_navbar_id; Type: CONSTRAINT; Schema: layout; Owner: postgres
--

ALTER TABLE ONLY layout.navbar
    ADD CONSTRAINT pk_navbar_id PRIMARY KEY (id);


--
-- TOC entry 4988 (class 2606 OID 51940)
-- Name: cars pk_product_cars_id; Type: CONSTRAINT; Schema: product; Owner: postgres
--

ALTER TABLE ONLY product.cars
    ADD CONSTRAINT pk_product_cars_id PRIMARY KEY (id, brand);


--
-- TOC entry 4993 (class 2606 OID 51946)
-- Name: audi audi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audi
    ADD CONSTRAINT audi_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 4998 (class 2606 OID 51952)
-- Name: bmw bmw_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bmw
    ADD CONSTRAINT bmw_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5037 (class 2606 OID 52118)
-- Name: customers_2024 customers_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_2024
    ADD CONSTRAINT customers_2024_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5039 (class 2606 OID 52126)
-- Name: customers_default customers_default_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_default
    ADD CONSTRAINT customers_default_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5049 (class 2606 OID 52282)
-- Name: emp_2024 emp_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_2024
    ADD CONSTRAINT emp_2024_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5051 (class 2606 OID 52291)
-- Name: emp_others emp_others_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_others
    ADD CONSTRAINT emp_others_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5003 (class 2606 OID 51958)
-- Name: ferrari ferrari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ferrari
    ADD CONSTRAINT ferrari_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5008 (class 2606 OID 51964)
-- Name: ford ford_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ford
    ADD CONSTRAINT ford_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5013 (class 2606 OID 51970)
-- Name: honda honda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.honda
    ADD CONSTRAINT honda_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5018 (class 2606 OID 51976)
-- Name: lamborghini lamborghini_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lamborghini
    ADD CONSTRAINT lamborghini_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5023 (class 2606 OID 51982)
-- Name: mazda mazda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mazda
    ADD CONSTRAINT mazda_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5028 (class 2606 OID 51988)
-- Name: mercedes mercedes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mercedes
    ADD CONSTRAINT mercedes_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 5043 (class 2606 OID 52186)
-- Name: order_2024 order_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_2024
    ADD CONSTRAINT order_2024_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5045 (class 2606 OID 52194)
-- Name: order_others order_others_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_others
    ADD CONSTRAINT order_others_pkey PRIMARY KEY (id, created_at);


--
-- TOC entry 5033 (class 2606 OID 51994)
-- Name: other_brand other_brand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_brand
    ADD CONSTRAINT other_brand_pkey PRIMARY KEY (id, brand);


--
-- TOC entry 4975 (class 1259 OID 16860)
-- Name: idx_chooseus_items; Type: INDEX; Schema: homepage; Owner: postgres
--

CREATE INDEX idx_chooseus_items ON homepage.chooseus_items USING btree (_id);


--
-- TOC entry 4984 (class 1259 OID 52015)
-- Name: idx_product_car_brand; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_brand ON ONLY product.cars USING btree (brand);


--
-- TOC entry 4985 (class 1259 OID 51995)
-- Name: idx_product_car_id; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_id ON ONLY product.cars USING btree (id);


--
-- TOC entry 4986 (class 1259 OID 52005)
-- Name: idx_product_car_name; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_name ON ONLY product.cars USING btree (name);


--
-- TOC entry 4989 (class 1259 OID 52016)
-- Name: audi_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_brand_idx ON public.audi USING btree (brand);


--
-- TOC entry 4990 (class 1259 OID 51996)
-- Name: audi_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_id_idx ON public.audi USING btree (id);


--
-- TOC entry 4991 (class 1259 OID 52006)
-- Name: audi_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_name_idx ON public.audi USING btree (name);


--
-- TOC entry 4994 (class 1259 OID 52017)
-- Name: bmw_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_brand_idx ON public.bmw USING btree (brand);


--
-- TOC entry 4995 (class 1259 OID 51997)
-- Name: bmw_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_id_idx ON public.bmw USING btree (id);


--
-- TOC entry 4996 (class 1259 OID 52007)
-- Name: bmw_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_name_idx ON public.bmw USING btree (name);


--
-- TOC entry 4999 (class 1259 OID 52018)
-- Name: ferrari_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_brand_idx ON public.ferrari USING btree (brand);


--
-- TOC entry 5000 (class 1259 OID 51998)
-- Name: ferrari_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_id_idx ON public.ferrari USING btree (id);


--
-- TOC entry 5001 (class 1259 OID 52008)
-- Name: ferrari_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_name_idx ON public.ferrari USING btree (name);


--
-- TOC entry 5004 (class 1259 OID 52019)
-- Name: ford_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_brand_idx ON public.ford USING btree (brand);


--
-- TOC entry 5005 (class 1259 OID 51999)
-- Name: ford_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_id_idx ON public.ford USING btree (id);


--
-- TOC entry 5006 (class 1259 OID 52009)
-- Name: ford_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_name_idx ON public.ford USING btree (name);


--
-- TOC entry 5009 (class 1259 OID 52020)
-- Name: honda_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_brand_idx ON public.honda USING btree (brand);


--
-- TOC entry 5010 (class 1259 OID 52000)
-- Name: honda_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_id_idx ON public.honda USING btree (id);


--
-- TOC entry 5011 (class 1259 OID 52010)
-- Name: honda_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_name_idx ON public.honda USING btree (name);


--
-- TOC entry 5014 (class 1259 OID 52021)
-- Name: lamborghini_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_brand_idx ON public.lamborghini USING btree (brand);


--
-- TOC entry 5015 (class 1259 OID 52001)
-- Name: lamborghini_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_id_idx ON public.lamborghini USING btree (id);


--
-- TOC entry 5016 (class 1259 OID 52011)
-- Name: lamborghini_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_name_idx ON public.lamborghini USING btree (name);


--
-- TOC entry 5019 (class 1259 OID 52022)
-- Name: mazda_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_brand_idx ON public.mazda USING btree (brand);


--
-- TOC entry 5020 (class 1259 OID 52002)
-- Name: mazda_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_id_idx ON public.mazda USING btree (id);


--
-- TOC entry 5021 (class 1259 OID 52012)
-- Name: mazda_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_name_idx ON public.mazda USING btree (name);


--
-- TOC entry 5024 (class 1259 OID 52023)
-- Name: mercedes_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_brand_idx ON public.mercedes USING btree (brand);


--
-- TOC entry 5025 (class 1259 OID 52003)
-- Name: mercedes_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_id_idx ON public.mercedes USING btree (id);


--
-- TOC entry 5026 (class 1259 OID 52013)
-- Name: mercedes_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_name_idx ON public.mercedes USING btree (name);


--
-- TOC entry 5029 (class 1259 OID 52024)
-- Name: other_brand_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_brand_idx ON public.other_brand USING btree (brand);


--
-- TOC entry 5030 (class 1259 OID 52004)
-- Name: other_brand_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_id_idx ON public.other_brand USING btree (id);


--
-- TOC entry 5031 (class 1259 OID 52014)
-- Name: other_brand_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_name_idx ON public.other_brand USING btree (name);


--
-- TOC entry 5052 (class 0 OID 0)
-- Name: audi_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.audi_brand_idx;


--
-- TOC entry 5053 (class 0 OID 0)
-- Name: audi_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.audi_id_idx;


--
-- TOC entry 5054 (class 0 OID 0)
-- Name: audi_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.audi_name_idx;


--
-- TOC entry 5055 (class 0 OID 0)
-- Name: audi_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.audi_pkey;


--
-- TOC entry 5056 (class 0 OID 0)
-- Name: bmw_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.bmw_brand_idx;


--
-- TOC entry 5057 (class 0 OID 0)
-- Name: bmw_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.bmw_id_idx;


--
-- TOC entry 5058 (class 0 OID 0)
-- Name: bmw_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.bmw_name_idx;


--
-- TOC entry 5059 (class 0 OID 0)
-- Name: bmw_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.bmw_pkey;


--
-- TOC entry 5088 (class 0 OID 0)
-- Name: customers_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_2024_pkey;


--
-- TOC entry 5089 (class 0 OID 0)
-- Name: customers_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_default_pkey;


--
-- TOC entry 5092 (class 0 OID 0)
-- Name: emp_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_2024_pkey;


--
-- TOC entry 5093 (class 0 OID 0)
-- Name: emp_others_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_others_pkey;


--
-- TOC entry 5060 (class 0 OID 0)
-- Name: ferrari_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ferrari_brand_idx;


--
-- TOC entry 5061 (class 0 OID 0)
-- Name: ferrari_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ferrari_id_idx;


--
-- TOC entry 5062 (class 0 OID 0)
-- Name: ferrari_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ferrari_name_idx;


--
-- TOC entry 5063 (class 0 OID 0)
-- Name: ferrari_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ferrari_pkey;


--
-- TOC entry 5064 (class 0 OID 0)
-- Name: ford_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ford_brand_idx;


--
-- TOC entry 5065 (class 0 OID 0)
-- Name: ford_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ford_id_idx;


--
-- TOC entry 5066 (class 0 OID 0)
-- Name: ford_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ford_name_idx;


--
-- TOC entry 5067 (class 0 OID 0)
-- Name: ford_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ford_pkey;


--
-- TOC entry 5068 (class 0 OID 0)
-- Name: honda_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.honda_brand_idx;


--
-- TOC entry 5069 (class 0 OID 0)
-- Name: honda_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.honda_id_idx;


--
-- TOC entry 5070 (class 0 OID 0)
-- Name: honda_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.honda_name_idx;


--
-- TOC entry 5071 (class 0 OID 0)
-- Name: honda_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.honda_pkey;


--
-- TOC entry 5072 (class 0 OID 0)
-- Name: lamborghini_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.lamborghini_brand_idx;


--
-- TOC entry 5073 (class 0 OID 0)
-- Name: lamborghini_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.lamborghini_id_idx;


--
-- TOC entry 5074 (class 0 OID 0)
-- Name: lamborghini_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.lamborghini_name_idx;


--
-- TOC entry 5075 (class 0 OID 0)
-- Name: lamborghini_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.lamborghini_pkey;


--
-- TOC entry 5076 (class 0 OID 0)
-- Name: mazda_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mazda_brand_idx;


--
-- TOC entry 5077 (class 0 OID 0)
-- Name: mazda_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mazda_id_idx;


--
-- TOC entry 5078 (class 0 OID 0)
-- Name: mazda_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mazda_name_idx;


--
-- TOC entry 5079 (class 0 OID 0)
-- Name: mazda_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mazda_pkey;


--
-- TOC entry 5080 (class 0 OID 0)
-- Name: mercedes_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mercedes_brand_idx;


--
-- TOC entry 5081 (class 0 OID 0)
-- Name: mercedes_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mercedes_id_idx;


--
-- TOC entry 5082 (class 0 OID 0)
-- Name: mercedes_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mercedes_name_idx;


--
-- TOC entry 5083 (class 0 OID 0)
-- Name: mercedes_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mercedes_pkey;


--
-- TOC entry 5090 (class 0 OID 0)
-- Name: order_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_2024_pkey;


--
-- TOC entry 5091 (class 0 OID 0)
-- Name: order_others_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_others_pkey;


--
-- TOC entry 5084 (class 0 OID 0)
-- Name: other_brand_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.other_brand_brand_idx;


--
-- TOC entry 5085 (class 0 OID 0)
-- Name: other_brand_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.other_brand_id_idx;


--
-- TOC entry 5086 (class 0 OID 0)
-- Name: other_brand_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.other_brand_name_idx;


--
-- TOC entry 5087 (class 0 OID 0)
-- Name: other_brand_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.other_brand_pkey;


--
-- TOC entry 5094 (class 2620 OID 52232)
-- Name: orders check_product_id_customer_id_existed_trigger; Type: TRIGGER; Schema: customer; Owner: postgres
--

CREATE TRIGGER check_product_id_customer_id_existed_trigger BEFORE INSERT ON customer.orders FOR EACH ROW EXECUTE FUNCTION public.check_product_id_customer_id_existed();


-- Completed on 2024-08-17 23:00:55

--
-- PostgreSQL database dump complete
--

