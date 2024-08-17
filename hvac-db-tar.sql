toc.dat                                                                                             0000600 0004000 0002000 00000243315 14660144432 0014453 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP                        |            hvac    16.3    16.3    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         �           1262    16678    hvac    DATABASE     �   CREATE DATABASE hvac WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252' TABLESPACE = hvac_tbs;
    DROP DATABASE hvac;
                postgres    false                     2615    16886 	   aboutpage    SCHEMA        CREATE SCHEMA aboutpage;
    DROP SCHEMA aboutpage;
                postgres    false         
            2615    16985    carpage    SCHEMA        CREATE SCHEMA carpage;
    DROP SCHEMA carpage;
                postgres    false         	            2615    16965    contactpage    SCHEMA        CREATE SCHEMA contactpage;
    DROP SCHEMA contactpage;
                postgres    false                     2615    30298    customer    SCHEMA        CREATE SCHEMA customer;
    DROP SCHEMA customer;
                postgres    false                     2615    52235    employee    SCHEMA        CREATE SCHEMA employee;
    DROP SCHEMA employee;
                postgres    false                     2615    16736    homepage    SCHEMA        CREATE SCHEMA homepage;
    DROP SCHEMA homepage;
                postgres    false                     2615    16789    layout    SCHEMA        CREATE SCHEMA layout;
    DROP SCHEMA layout;
                postgres    false                     2615    51933    product    SCHEMA        CREATE SCHEMA product;
    DROP SCHEMA product;
                postgres    false         6           1247    30359 
   email_type    DOMAIN     �   CREATE DOMAIN customer.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));
 !   DROP DOMAIN customer.email_type;
       customer          postgres    false    11         2           1247    30356 
   phone_type    DOMAIN     �   CREATE DOMAIN customer.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));
 !   DROP DOMAIN customer.phone_type;
       customer          postgres    false    11                    1247    52240 
   email_type    DOMAIN     �   CREATE DOMAIN employee.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));
 !   DROP DOMAIN employee.email_type;
       employee          postgres    false    13                    1247    52237 
   phone_type    DOMAIN     �   CREATE DOMAIN employee.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));
 !   DROP DOMAIN employee.phone_type;
       employee          postgres    false    13         .           1247    36460 
   email_type    DOMAIN     �   CREATE DOMAIN public.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));
    DROP DOMAIN public.email_type;
       public          postgres    false         *           1247    36457 
   phone_type    DOMAIN     �   CREATE DOMAIN public.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));
    DROP DOMAIN public.phone_type;
       public          postgres    false         4           1255    16964    get_aboutpage()    FUNCTION     �  CREATE FUNCTION aboutpage.get_aboutpage() RETURNS jsonb
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
 )   DROP FUNCTION aboutpage.get_aboutpage();
    	   aboutpage          postgres    false    8         %           1255    16994    get_carpage()    FUNCTION     m  CREATE FUNCTION carpage.get_carpage() RETURNS jsonb
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
 %   DROP FUNCTION carpage.get_carpage();
       carpage          postgres    false    10         $           1255    16982    get_contactpage()    FUNCTION     S  CREATE FUNCTION contactpage.get_contactpage() RETURNS jsonb
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
 -   DROP FUNCTION contactpage.get_contactpage();
       contactpage          postgres    false    9                     1255    16876 	   get_car()    FUNCTION     �   CREATE FUNCTION homepage.get_car() RETURNS jsonb
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
 "   DROP FUNCTION homepage.get_car();
       homepage          postgres    false    6         !           1255    16877    get_chooseus()    FUNCTION     }  CREATE FUNCTION homepage.get_chooseus() RETURNS jsonb
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
 '   DROP FUNCTION homepage.get_chooseus();
       homepage          postgres    false    6         "           1255    16884 	   get_cta()    FUNCTION     �   CREATE FUNCTION homepage.get_cta() RETURNS jsonb
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
 "   DROP FUNCTION homepage.get_cta();
       homepage          postgres    false    6                    1255    16875    get_features()    FUNCTION     v  CREATE FUNCTION homepage.get_features() RETURNS jsonb
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
 '   DROP FUNCTION homepage.get_features();
       homepage          postgres    false    6         +           1255    16787 
   get_hero()    FUNCTION     �  CREATE FUNCTION homepage.get_hero() RETURNS jsonb
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
 #   DROP FUNCTION homepage.get_hero();
       homepage          postgres    false    6         #           1255    16885    get_homepage()    FUNCTION     �  CREATE FUNCTION homepage.get_homepage() RETURNS jsonb
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
 '   DROP FUNCTION homepage.get_homepage();
       homepage          postgres    false    6                    1255    16874    get_services()    FUNCTION     w  CREATE FUNCTION homepage.get_services() RETURNS jsonb
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
 '   DROP FUNCTION homepage.get_services();
       homepage          postgres    false    6         3           1255    16806    get_layout()    FUNCTION     �  CREATE FUNCTION layout.get_layout() RETURNS jsonb
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
 #   DROP FUNCTION layout.get_layout();
       layout          postgres    false    7         5           1255    52231 &   check_product_id_customer_id_existed()    FUNCTION     G  CREATE FUNCTION public.check_product_id_customer_id_existed() RETURNS trigger
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
 =   DROP FUNCTION public.check_product_id_customer_id_existed();
       public          postgres    false         &           1255    36453    check_unique_email_phone()    FUNCTION       CREATE FUNCTION public.check_unique_email_phone() RETURNS trigger
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
 1   DROP FUNCTION public.check_unique_email_phone();
       public          postgres    false         �            1259    16902    about    TABLE     �   CREATE TABLE aboutpage.about (
    _id integer NOT NULL,
    title text[] NOT NULL,
    text text,
    img character varying(20) NOT NULL
);
    DROP TABLE aboutpage.about;
    	   aboutpage         heap    postgres    false    8         �            1259    16901    about__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.about ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    241    8         �            1259    16918    about_items    TABLE     �   CREATE TABLE aboutpage.about_items (
    _id integer NOT NULL,
    title character varying(15) NOT NULL,
    text text NOT NULL
);
 "   DROP TABLE aboutpage.about_items;
    	   aboutpage         heap    postgres    false    8         �            1259    16917    about_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.about_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    245    8         �            1259    16956    clients    TABLE     z   CREATE TABLE aboutpage.clients (
    title character varying(30) NOT NULL,
    subtitle character varying(20) NOT NULL
);
    DROP TABLE aboutpage.clients;
    	   aboutpage         heap    postgres    false    8                     1259    16960    clients_items    TABLE     �   CREATE TABLE aboutpage.clients_items (
    _id smallint NOT NULL,
    img character varying(30) NOT NULL,
    alt character varying(30)
);
 $   DROP TABLE aboutpage.clients_items;
    	   aboutpage         heap    postgres    false    8         �            1259    16959    clients_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.clients_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.clients_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    256         �            1259    16909    features    TABLE     �   CREATE TABLE aboutpage.features (
    _id integer NOT NULL,
    title character varying(50) NOT NULL,
    text text NOT NULL,
    img character varying(30) NOT NULL
);
    DROP TABLE aboutpage.features;
    	   aboutpage         heap    postgres    false    8         �            1259    16908    features__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.features ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.features__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    243         �            1259    16953    quantities_items    TABLE     �   CREATE TABLE aboutpage.quantities_items (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    value smallint NOT NULL
);
 '   DROP TABLE aboutpage.quantities_items;
    	   aboutpage         heap    postgres    false    8         �            1259    16952    quantities_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.quantities_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.quantities_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    253         �            1259    16923    teams    TABLE     x   CREATE TABLE aboutpage.teams (
    title character varying(15) NOT NULL,
    subtitle character varying(30) NOT NULL
);
    DROP TABLE aboutpage.teams;
    	   aboutpage         heap    postgres    false    8         �            1259    16927    teams_items    TABLE     �   CREATE TABLE aboutpage.teams_items (
    _id integer NOT NULL,
    name character varying(50) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL
);
 "   DROP TABLE aboutpage.teams_items;
    	   aboutpage         heap    postgres    false    8         �            1259    16926    teams_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.teams_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.teams_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    248         �            1259    16941    testimonials    TABLE     �   CREATE TABLE aboutpage.testimonials (
    title character varying(30) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text
);
 #   DROP TABLE aboutpage.testimonials;
    	   aboutpage         heap    postgres    false    8         �            1259    16947    testimonials_items    TABLE     �   CREATE TABLE aboutpage.testimonials_items (
    _id smallint NOT NULL,
    name character varying(30) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL,
    rate numeric NOT NULL,
    text text NOT NULL
);
 )   DROP TABLE aboutpage.testimonials_items;
    	   aboutpage         heap    postgres    false    8         �            1259    16946    testimonials_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.testimonials_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.testimonials_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    251    8                    1259    16987 
   filterform    TABLE     �   CREATE TABLE carpage.filterform (
    _id smallint NOT NULL,
    name character varying(15) NOT NULL,
    label character varying(15) NOT NULL,
    options character varying(12)[] NOT NULL
);
    DROP TABLE carpage.filterform;
       carpage         heap    postgres    false    10                    1259    16986    filterform__id_seq    SEQUENCE     �   ALTER TABLE carpage.filterform ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME carpage.filterform__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            carpage          postgres    false    262    10                    1259    16966    contact    TABLE     ^   CREATE TABLE contactpage.contact (
    title character varying(30) NOT NULL,
    text text
);
     DROP TABLE contactpage.contact;
       contactpage         heap    postgres    false    9                    1259    16971    schedule    TABLE     �   CREATE TABLE contactpage.schedule (
    weekdays character varying(20) NOT NULL,
    saturday character varying(20) NOT NULL,
    sunday character varying(20) NOT NULL
);
 !   DROP TABLE contactpage.schedule;
       contactpage         heap    postgres    false    9                    1259    16975 	   showrooms    TABLE     �   CREATE TABLE contactpage.showrooms (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    address text NOT NULL,
    email character varying(30) NOT NULL,
    phone character varying(17) NOT NULL
);
 "   DROP TABLE contactpage.showrooms;
       contactpage         heap    postgres    false    9                    1259    16974    showrooms__id_seq    SEQUENCE     �   ALTER TABLE contactpage.showrooms ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME contactpage.showrooms__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            contactpage          postgres    false    9    260                    1259    52107 	   customers    TABLE       CREATE TABLE customer.customers (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);
    DROP TABLE customer.customers;
       customer            postgres    false    1070    1066    11                    1259    52106    customers_id_seq    SEQUENCE     �   ALTER TABLE customer.customers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME customer.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            customer          postgres    false    275    11                    1259    52171    orders    TABLE     A  CREATE TABLE customer.orders (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);
    DROP TABLE customer.orders;
       customer            postgres    false    11                    1259    52170    orders_id_seq    SEQUENCE     �   ALTER TABLE customer.orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME customer.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            customer          postgres    false    11    279                    1259    52269 	   employees    TABLE     l  CREATE TABLE employee.employees (
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
    DROP TABLE employee.employees;
       employee            postgres    false    1066    1070    13                    1259    52268    employees_id_seq    SEQUENCE     �   ALTER TABLE employee.employees ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME employee.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            employee          postgres    false    13    283         �            1259    16837    car    TABLE     u   CREATE TABLE homepage.car (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL
);
    DROP TABLE homepage.car;
       homepage         heap    postgres    false    6         �            1259    16847    chooseus    TABLE     x   CREATE TABLE homepage.chooseus (
    title character varying(25) NOT NULL,
    text text,
    videourl text NOT NULL
);
    DROP TABLE homepage.chooseus;
       homepage         heap    postgres    false    6         �            1259    16853    chooseus_items    TABLE     [   CREATE TABLE homepage.chooseus_items (
    _id integer NOT NULL,
    text text NOT NULL
);
 $   DROP TABLE homepage.chooseus_items;
       homepage         heap    postgres    false    6         �            1259    16852    chooseus_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.chooseus_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.chooseus_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    6    237         �            1259    16868    cta    TABLE     �   CREATE TABLE homepage.cta (
    title character varying(25) NOT NULL,
    text text,
    img character varying(10) NOT NULL,
    _id integer NOT NULL
);
    DROP TABLE homepage.cta;
       homepage         heap    postgres    false    6         �            1259    16878    cta__id_seq    SEQUENCE     �   ALTER TABLE homepage.cta ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.cta__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    238    6         �            1259    16828    features    TABLE     �   CREATE TABLE homepage.features (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text[]
);
    DROP TABLE homepage.features;
       homepage         heap    postgres    false    6         �            1259    16834    features_items    TABLE     �   CREATE TABLE homepage.features_items (
    _id integer NOT NULL,
    text character varying(10) NOT NULL,
    img character varying(15) NOT NULL
);
 $   DROP TABLE homepage.features_items;
       homepage         heap    postgres    false    6         �            1259    16833    features_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.features_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.features_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    6    233         �            1259    16775    hero    TABLE     �   CREATE TABLE homepage.hero (
    title character varying(20) NOT NULL,
    models smallint[] NOT NULL,
    brands character varying(15)[] NOT NULL,
    transmissions character varying(15)[] NOT NULL,
    types character varying(10)[] NOT NULL
);
    DROP TABLE homepage.hero;
       homepage         heap    postgres    false    6         �            1259    16815    services    TABLE     �   CREATE TABLE homepage.services (
    title character varying(20) NOT NULL,
    subtitle character varying(20) NOT NULL,
    text text
);
    DROP TABLE homepage.services;
       homepage         heap    postgres    false    6         �            1259    16821    services_items    TABLE     �   CREATE TABLE homepage.services_items (
    _id integer NOT NULL,
    title character varying(20) NOT NULL,
    text text NOT NULL,
    img character varying(20) NOT NULL
);
 $   DROP TABLE homepage.services_items;
       homepage         heap    postgres    false    6         �            1259    16820    services_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.services_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.services_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    6    230         �            1259    16801    contactInfo    TABLE     �   CREATE TABLE layout."contactInfo" (
    email character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    schedule character varying(30) NOT NULL,
    socials jsonb NOT NULL
);
 !   DROP TABLE layout."contactInfo";
       layout         heap    postgres    false    7         �            1259    16796    footer    TABLE     �   CREATE TABLE layout.footer (
    "contactTitle" character varying(20) NOT NULL,
    "aboutContent" character varying(100) NOT NULL,
    imgs jsonb NOT NULL
);
    DROP TABLE layout.footer;
       layout         heap    postgres    false    7         �            1259    16791    navbar    TABLE     �   CREATE TABLE layout.navbar (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    path character varying(11) NOT NULL
);
    DROP TABLE layout.navbar;
       layout         heap    postgres    false    7         �            1259    16790    navbar_id_seq    SEQUENCE     �   ALTER TABLE layout.navbar ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME layout.navbar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            layout          postgres    false    225    7                    1259    51935    cars    TABLE       CREATE TABLE product.cars (
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
    DROP TABLE product.cars;
       product            postgres    false    12                    1259    51934    cars_id_seq    SEQUENCE     �   ALTER TABLE product.cars ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME product.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            product          postgres    false    12    264         	           1259    51941    audi    TABLE     �  CREATE TABLE public.audi (
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
    DROP TABLE public.audi;
       public         heap    postgres    false    264         
           1259    51947    bmw    TABLE     �  CREATE TABLE public.bmw (
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
    DROP TABLE public.bmw;
       public         heap    postgres    false    264                    1259    52113    customers_2024    TABLE     �   CREATE TABLE public.customers_2024 (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
 "   DROP TABLE public.customers_2024;
       public         heap    postgres    false    275    1066    1070                    1259    52121    customers_default    TABLE     �   CREATE TABLE public.customers_default (
    id integer NOT NULL,
    email public.email_type,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone public.phone_type,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
 %   DROP TABLE public.customers_default;
       public         heap    postgres    false    275    1070    1066                    1259    52276    emp_2024    TABLE     I  CREATE TABLE public.emp_2024 (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    power character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.emp_2024;
       public         heap    postgres    false    1070    283    1066                    1259    52285 
   emp_others    TABLE     K  CREATE TABLE public.emp_others (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    power character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.emp_others;
       public         heap    postgres    false    283    1066    1070                    1259    51953    ferrari    TABLE     �  CREATE TABLE public.ferrari (
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
    DROP TABLE public.ferrari;
       public         heap    postgres    false    264                    1259    51959    ford    TABLE     �  CREATE TABLE public.ford (
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
    DROP TABLE public.ford;
       public         heap    postgres    false    264                    1259    51965    honda    TABLE     �  CREATE TABLE public.honda (
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
    DROP TABLE public.honda;
       public         heap    postgres    false    264                    1259    51971    lamborghini    TABLE     �  CREATE TABLE public.lamborghini (
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
    DROP TABLE public.lamborghini;
       public         heap    postgres    false    264                    1259    51977    mazda    TABLE     �  CREATE TABLE public.mazda (
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
    DROP TABLE public.mazda;
       public         heap    postgres    false    264                    1259    51983    mercedes    TABLE     �  CREATE TABLE public.mercedes (
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
    DROP TABLE public.mercedes;
       public         heap    postgres    false    264                    1259    52179 
   order_2024    TABLE     #  CREATE TABLE public.order_2024 (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.order_2024;
       public         heap    postgres    false    279                    1259    52187    order_others    TABLE     %  CREATE TABLE public.order_others (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
     DROP TABLE public.order_others;
       public         heap    postgres    false    279                    1259    51989    other_brand    TABLE     �  CREATE TABLE public.other_brand (
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
    DROP TABLE public.other_brand;
       public         heap    postgres    false    264         >           0    0    audi    TABLE ATTACH     S   ALTER TABLE ONLY product.cars ATTACH PARTITION public.audi FOR VALUES IN ('audi');
          public          postgres    false    265    264         ?           0    0    bmw    TABLE ATTACH     Q   ALTER TABLE ONLY product.cars ATTACH PARTITION public.bmw FOR VALUES IN ('bmw');
          public          postgres    false    266    264         G           0    0    customers_2024    TABLE ATTACH     }   ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    276    275         H           0    0    customers_default    TABLE ATTACH     W   ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_default DEFAULT;
          public          postgres    false    277    275         K           0    0    emp_2024    TABLE ATTACH     w   ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    284    283         L           0    0 
   emp_others    TABLE ATTACH     P   ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_others DEFAULT;
          public          postgres    false    285    283         @           0    0    ferrari    TABLE ATTACH     Y   ALTER TABLE ONLY product.cars ATTACH PARTITION public.ferrari FOR VALUES IN ('ferrari');
          public          postgres    false    267    264         A           0    0    ford    TABLE ATTACH     S   ALTER TABLE ONLY product.cars ATTACH PARTITION public.ford FOR VALUES IN ('ford');
          public          postgres    false    268    264         B           0    0    honda    TABLE ATTACH     U   ALTER TABLE ONLY product.cars ATTACH PARTITION public.honda FOR VALUES IN ('honda');
          public          postgres    false    269    264         C           0    0    lamborghini    TABLE ATTACH     a   ALTER TABLE ONLY product.cars ATTACH PARTITION public.lamborghini FOR VALUES IN ('lamborghini');
          public          postgres    false    270    264         D           0    0    mazda    TABLE ATTACH     U   ALTER TABLE ONLY product.cars ATTACH PARTITION public.mazda FOR VALUES IN ('mazda');
          public          postgres    false    271    264         E           0    0    mercedes    TABLE ATTACH     [   ALTER TABLE ONLY product.cars ATTACH PARTITION public.mercedes FOR VALUES IN ('mercedes');
          public          postgres    false    272    264         I           0    0 
   order_2024    TABLE ATTACH     v   ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    280    279         J           0    0    order_others    TABLE ATTACH     O   ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_others DEFAULT;
          public          postgres    false    281    279         F           0    0    other_brand    TABLE ATTACH     K   ALTER TABLE ONLY product.cars ATTACH PARTITION public.other_brand DEFAULT;
          public          postgres    false    273    264         �          0    16902    about 
   TABLE DATA           9   COPY aboutpage.about (_id, title, text, img) FROM stdin;
 	   aboutpage          postgres    false    241       5256.dat �          0    16918    about_items 
   TABLE DATA           :   COPY aboutpage.about_items (_id, title, text) FROM stdin;
 	   aboutpage          postgres    false    245       5260.dat �          0    16956    clients 
   TABLE DATA           5   COPY aboutpage.clients (title, subtitle) FROM stdin;
 	   aboutpage          postgres    false    254       5269.dat �          0    16960    clients_items 
   TABLE DATA           9   COPY aboutpage.clients_items (_id, img, alt) FROM stdin;
 	   aboutpage          postgres    false    256       5271.dat �          0    16909    features 
   TABLE DATA           <   COPY aboutpage.features (_id, title, text, img) FROM stdin;
 	   aboutpage          postgres    false    243       5258.dat �          0    16953    quantities_items 
   TABLE DATA           ?   COPY aboutpage.quantities_items (_id, name, value) FROM stdin;
 	   aboutpage          postgres    false    253       5268.dat �          0    16923    teams 
   TABLE DATA           3   COPY aboutpage.teams (title, subtitle) FROM stdin;
 	   aboutpage          postgres    false    246       5261.dat �          0    16927    teams_items 
   TABLE DATA           D   COPY aboutpage.teams_items (_id, name, img, "position") FROM stdin;
 	   aboutpage          postgres    false    248       5263.dat �          0    16941    testimonials 
   TABLE DATA           @   COPY aboutpage.testimonials (title, subtitle, text) FROM stdin;
 	   aboutpage          postgres    false    249       5264.dat �          0    16947    testimonials_items 
   TABLE DATA           W   COPY aboutpage.testimonials_items (_id, name, img, "position", rate, text) FROM stdin;
 	   aboutpage          postgres    false    251       5266.dat �          0    16987 
   filterform 
   TABLE DATA           @   COPY carpage.filterform (_id, name, label, options) FROM stdin;
    carpage          postgres    false    262       5277.dat �          0    16966    contact 
   TABLE DATA           3   COPY contactpage.contact (title, text) FROM stdin;
    contactpage          postgres    false    257       5272.dat �          0    16971    schedule 
   TABLE DATA           C   COPY contactpage.schedule (weekdays, saturday, sunday) FROM stdin;
    contactpage          postgres    false    258       5273.dat �          0    16975 	   showrooms 
   TABLE DATA           J   COPY contactpage.showrooms (_id, name, address, email, phone) FROM stdin;
    contactpage          postgres    false    260       5275.dat �          0    16837    car 
   TABLE DATA           0   COPY homepage.car (title, subtitle) FROM stdin;
    homepage          postgres    false    234       5249.dat �          0    16847    chooseus 
   TABLE DATA           ;   COPY homepage.chooseus (title, text, videourl) FROM stdin;
    homepage          postgres    false    235       5250.dat �          0    16853    chooseus_items 
   TABLE DATA           5   COPY homepage.chooseus_items (_id, text) FROM stdin;
    homepage          postgres    false    237       5252.dat �          0    16868    cta 
   TABLE DATA           6   COPY homepage.cta (title, text, img, _id) FROM stdin;
    homepage          postgres    false    238       5253.dat ~          0    16828    features 
   TABLE DATA           ;   COPY homepage.features (title, subtitle, text) FROM stdin;
    homepage          postgres    false    231       5246.dat �          0    16834    features_items 
   TABLE DATA           :   COPY homepage.features_items (_id, text, img) FROM stdin;
    homepage          postgres    false    233       5248.dat v          0    16775    hero 
   TABLE DATA           M   COPY homepage.hero (title, models, brands, transmissions, types) FROM stdin;
    homepage          postgres    false    223       5238.dat {          0    16815    services 
   TABLE DATA           ;   COPY homepage.services (title, subtitle, text) FROM stdin;
    homepage          postgres    false    228       5243.dat }          0    16821    services_items 
   TABLE DATA           A   COPY homepage.services_items (_id, title, text, img) FROM stdin;
    homepage          postgres    false    230       5245.dat z          0    16801    contactInfo 
   TABLE DATA           H   COPY layout."contactInfo" (email, phone, schedule, socials) FROM stdin;
    layout          postgres    false    227       5242.dat y          0    16796    footer 
   TABLE DATA           F   COPY layout.footer ("contactTitle", "aboutContent", imgs) FROM stdin;
    layout          postgres    false    226       5241.dat x          0    16791    navbar 
   TABLE DATA           0   COPY layout.navbar (id, name, path) FROM stdin;
    layout          postgres    false    225       5240.dat �          0    51941    audi 
   TABLE DATA              COPY public.audi (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    265       5279.dat �          0    51947    bmw 
   TABLE DATA           ~   COPY public.bmw (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    266       5280.dat �          0    52113    customers_2024 
   TABLE DATA           V   COPY public.customers_2024 (id, email, password, name, phone, created_at) FROM stdin;
    public          postgres    false    276       5289.dat �          0    52121    customers_default 
   TABLE DATA           Y   COPY public.customers_default (id, email, password, name, phone, created_at) FROM stdin;
    public          postgres    false    277       5290.dat �          0    52276    emp_2024 
   TABLE DATA           c   COPY public.emp_2024 (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
    public          postgres    false    284       5295.dat �          0    52285 
   emp_others 
   TABLE DATA           e   COPY public.emp_others (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
    public          postgres    false    285       5296.dat �          0    51953    ferrari 
   TABLE DATA           �   COPY public.ferrari (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    267       5281.dat �          0    51959    ford 
   TABLE DATA              COPY public.ford (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    268       5282.dat �          0    51965    honda 
   TABLE DATA           �   COPY public.honda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    269       5283.dat �          0    51971    lamborghini 
   TABLE DATA           �   COPY public.lamborghini (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    270       5284.dat �          0    51977    mazda 
   TABLE DATA           �   COPY public.mazda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    271       5285.dat �          0    51983    mercedes 
   TABLE DATA           �   COPY public.mercedes (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    272       5286.dat �          0    52179 
   order_2024 
   TABLE DATA           g   COPY public.order_2024 (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
    public          postgres    false    280       5292.dat �          0    52187    order_others 
   TABLE DATA           i   COPY public.order_others (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
    public          postgres    false    281       5293.dat �          0    51989    other_brand 
   TABLE DATA           �   COPY public.other_brand (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
    public          postgres    false    273       5287.dat �           0    0    about__id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('aboutpage.about__id_seq', 1, true);
       	   aboutpage          postgres    false    240         �           0    0    about_items__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('aboutpage.about_items__id_seq', 2, true);
       	   aboutpage          postgres    false    244         �           0    0    clients_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('aboutpage.clients_items__id_seq', 6, true);
       	   aboutpage          postgres    false    255         �           0    0    features__id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('aboutpage.features__id_seq', 3, true);
       	   aboutpage          postgres    false    242         �           0    0    quantities_items__id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('aboutpage.quantities_items__id_seq', 4, true);
       	   aboutpage          postgres    false    252         �           0    0    teams_items__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('aboutpage.teams_items__id_seq', 4, true);
       	   aboutpage          postgres    false    247         �           0    0    testimonials_items__id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('aboutpage.testimonials_items__id_seq', 2, true);
       	   aboutpage          postgres    false    250         �           0    0    filterform__id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('carpage.filterform__id_seq', 5, true);
          carpage          postgres    false    261         �           0    0    showrooms__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('contactpage.showrooms__id_seq', 3, true);
          contactpage          postgres    false    259         �           0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('customer.customers_id_seq', 1, true);
          customer          postgres    false    274         �           0    0    orders_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('customer.orders_id_seq', 9, true);
          customer          postgres    false    278         �           0    0    employees_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('employee.employees_id_seq', 1, true);
          employee          postgres    false    282         �           0    0    chooseus_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.chooseus_items__id_seq', 4, true);
          homepage          postgres    false    236         �           0    0    cta__id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('homepage.cta__id_seq', 2, true);
          homepage          postgres    false    239         �           0    0    features_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.features_items__id_seq', 6, true);
          homepage          postgres    false    232         �           0    0    services_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.services_items__id_seq', 4, true);
          homepage          postgres    false    229         �           0    0    navbar_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('layout.navbar_id_seq', 4, true);
          layout          postgres    false    224         �           0    0    cars_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('product.cars_id_seq', 16, true);
          product          postgres    false    263         s           2606    16915 !   features pk_aboutpage_features_id 
   CONSTRAINT     c   ALTER TABLE ONLY aboutpage.features
    ADD CONSTRAINT pk_aboutpage_features_id PRIMARY KEY (_id);
 N   ALTER TABLE ONLY aboutpage.features DROP CONSTRAINT pk_aboutpage_features_id;
    	   aboutpage            postgres    false    243         w           2606    16993 #   filterform pk_carpage_filterform_id 
   CONSTRAINT     c   ALTER TABLE ONLY carpage.filterform
    ADD CONSTRAINT pk_carpage_filterform_id PRIMARY KEY (_id);
 N   ALTER TABLE ONLY carpage.filterform DROP CONSTRAINT pk_carpage_filterform_id;
       carpage            postgres    false    262         u           2606    16981    showrooms pk_showrooms_id 
   CONSTRAINT     ]   ALTER TABLE ONLY contactpage.showrooms
    ADD CONSTRAINT pk_showrooms_id PRIMARY KEY (_id);
 H   ALTER TABLE ONLY contactpage.showrooms DROP CONSTRAINT pk_showrooms_id;
       contactpage            postgres    false    260         �           2606    52112 #   customers pk_customer_id_created_at 
   CONSTRAINT     o   ALTER TABLE ONLY customer.customers
    ADD CONSTRAINT pk_customer_id_created_at PRIMARY KEY (id, created_at);
 O   ALTER TABLE ONLY customer.customers DROP CONSTRAINT pk_customer_id_created_at;
       customer            postgres    false    275    275         �           2606    52178    orders pk_customer_order_id 
   CONSTRAINT     g   ALTER TABLE ONLY customer.orders
    ADD CONSTRAINT pk_customer_order_id PRIMARY KEY (id, created_at);
 G   ALTER TABLE ONLY customer.orders DROP CONSTRAINT pk_customer_order_id;
       customer            postgres    false    279    279         �           2606    52275    employees pk_emp_id 
   CONSTRAINT     _   ALTER TABLE ONLY employee.employees
    ADD CONSTRAINT pk_emp_id PRIMARY KEY (id, created_at);
 ?   ALTER TABLE ONLY employee.employees DROP CONSTRAINT pk_emp_id;
       employee            postgres    false    283    283         q           2606    16859 #   chooseus_items pk_chooseus_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.chooseus_items
    ADD CONSTRAINT pk_chooseus_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.chooseus_items DROP CONSTRAINT pk_chooseus_items_id;
       homepage            postgres    false    237         n           2606    16841 #   features_items pk_features_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.features_items
    ADD CONSTRAINT pk_features_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.features_items DROP CONSTRAINT pk_features_items_id;
       homepage            postgres    false    233         l           2606    16827 #   services_items pk_services_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.services_items
    ADD CONSTRAINT pk_services_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.services_items DROP CONSTRAINT pk_services_items_id;
       homepage            postgres    false    230         j           2606    16795    navbar pk_navbar_id 
   CONSTRAINT     Q   ALTER TABLE ONLY layout.navbar
    ADD CONSTRAINT pk_navbar_id PRIMARY KEY (id);
 =   ALTER TABLE ONLY layout.navbar DROP CONSTRAINT pk_navbar_id;
       layout            postgres    false    225         |           2606    51940    cars pk_product_cars_id 
   CONSTRAINT     ]   ALTER TABLE ONLY product.cars
    ADD CONSTRAINT pk_product_cars_id PRIMARY KEY (id, brand);
 B   ALTER TABLE ONLY product.cars DROP CONSTRAINT pk_product_cars_id;
       product            postgres    false    264    264         �           2606    51946    audi audi_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.audi
    ADD CONSTRAINT audi_pkey PRIMARY KEY (id, brand);
 8   ALTER TABLE ONLY public.audi DROP CONSTRAINT audi_pkey;
       public            postgres    false    265    4988    265    265         �           2606    51952    bmw bmw_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.bmw
    ADD CONSTRAINT bmw_pkey PRIMARY KEY (id, brand);
 6   ALTER TABLE ONLY public.bmw DROP CONSTRAINT bmw_pkey;
       public            postgres    false    266    266    266    4988         �           2606    52118 "   customers_2024 customers_2024_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.customers_2024
    ADD CONSTRAINT customers_2024_pkey PRIMARY KEY (id, created_at);
 L   ALTER TABLE ONLY public.customers_2024 DROP CONSTRAINT customers_2024_pkey;
       public            postgres    false    276    276    5035    276         �           2606    52126 (   customers_default customers_default_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.customers_default
    ADD CONSTRAINT customers_default_pkey PRIMARY KEY (id, created_at);
 R   ALTER TABLE ONLY public.customers_default DROP CONSTRAINT customers_default_pkey;
       public            postgres    false    5035    277    277    277         �           2606    52282    emp_2024 emp_2024_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.emp_2024
    ADD CONSTRAINT emp_2024_pkey PRIMARY KEY (id, created_at);
 @   ALTER TABLE ONLY public.emp_2024 DROP CONSTRAINT emp_2024_pkey;
       public            postgres    false    5047    284    284    284         �           2606    52291    emp_others emp_others_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.emp_others
    ADD CONSTRAINT emp_others_pkey PRIMARY KEY (id, created_at);
 D   ALTER TABLE ONLY public.emp_others DROP CONSTRAINT emp_others_pkey;
       public            postgres    false    285    285    285    5047         �           2606    51958    ferrari ferrari_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.ferrari
    ADD CONSTRAINT ferrari_pkey PRIMARY KEY (id, brand);
 >   ALTER TABLE ONLY public.ferrari DROP CONSTRAINT ferrari_pkey;
       public            postgres    false    267    267    4988    267         �           2606    51964    ford ford_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.ford
    ADD CONSTRAINT ford_pkey PRIMARY KEY (id, brand);
 8   ALTER TABLE ONLY public.ford DROP CONSTRAINT ford_pkey;
       public            postgres    false    4988    268    268    268         �           2606    51970    honda honda_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.honda
    ADD CONSTRAINT honda_pkey PRIMARY KEY (id, brand);
 :   ALTER TABLE ONLY public.honda DROP CONSTRAINT honda_pkey;
       public            postgres    false    269    269    269    4988         �           2606    51976    lamborghini lamborghini_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.lamborghini
    ADD CONSTRAINT lamborghini_pkey PRIMARY KEY (id, brand);
 F   ALTER TABLE ONLY public.lamborghini DROP CONSTRAINT lamborghini_pkey;
       public            postgres    false    4988    270    270    270         �           2606    51982    mazda mazda_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.mazda
    ADD CONSTRAINT mazda_pkey PRIMARY KEY (id, brand);
 :   ALTER TABLE ONLY public.mazda DROP CONSTRAINT mazda_pkey;
       public            postgres    false    271    271    4988    271         �           2606    51988    mercedes mercedes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.mercedes
    ADD CONSTRAINT mercedes_pkey PRIMARY KEY (id, brand);
 @   ALTER TABLE ONLY public.mercedes DROP CONSTRAINT mercedes_pkey;
       public            postgres    false    4988    272    272    272         �           2606    52186    order_2024 order_2024_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.order_2024
    ADD CONSTRAINT order_2024_pkey PRIMARY KEY (id, created_at);
 D   ALTER TABLE ONLY public.order_2024 DROP CONSTRAINT order_2024_pkey;
       public            postgres    false    280    280    280    5041         �           2606    52194    order_others order_others_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.order_others
    ADD CONSTRAINT order_others_pkey PRIMARY KEY (id, created_at);
 H   ALTER TABLE ONLY public.order_others DROP CONSTRAINT order_others_pkey;
       public            postgres    false    281    281    281    5041         �           2606    51994    other_brand other_brand_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.other_brand
    ADD CONSTRAINT other_brand_pkey PRIMARY KEY (id, brand);
 F   ALTER TABLE ONLY public.other_brand DROP CONSTRAINT other_brand_pkey;
       public            postgres    false    273    273    4988    273         o           1259    16860    idx_chooseus_items    INDEX     N   CREATE INDEX idx_chooseus_items ON homepage.chooseus_items USING btree (_id);
 (   DROP INDEX homepage.idx_chooseus_items;
       homepage            postgres    false    237         x           1259    52015    idx_product_car_brand    INDEX     M   CREATE INDEX idx_product_car_brand ON ONLY product.cars USING btree (brand);
 *   DROP INDEX product.idx_product_car_brand;
       product            postgres    false    264         y           1259    51995    idx_product_car_id    INDEX     G   CREATE INDEX idx_product_car_id ON ONLY product.cars USING btree (id);
 '   DROP INDEX product.idx_product_car_id;
       product            postgres    false    264         z           1259    52005    idx_product_car_name    INDEX     K   CREATE INDEX idx_product_car_name ON ONLY product.cars USING btree (name);
 )   DROP INDEX product.idx_product_car_name;
       product            postgres    false    264         }           1259    52016    audi_brand_idx    INDEX     @   CREATE INDEX audi_brand_idx ON public.audi USING btree (brand);
 "   DROP INDEX public.audi_brand_idx;
       public            postgres    false    4984    265    265         ~           1259    51996    audi_id_idx    INDEX     :   CREATE INDEX audi_id_idx ON public.audi USING btree (id);
    DROP INDEX public.audi_id_idx;
       public            postgres    false    265    265    4985                    1259    52006    audi_name_idx    INDEX     >   CREATE INDEX audi_name_idx ON public.audi USING btree (name);
 !   DROP INDEX public.audi_name_idx;
       public            postgres    false    4986    265    265         �           1259    52017    bmw_brand_idx    INDEX     >   CREATE INDEX bmw_brand_idx ON public.bmw USING btree (brand);
 !   DROP INDEX public.bmw_brand_idx;
       public            postgres    false    4984    266    266         �           1259    51997 
   bmw_id_idx    INDEX     8   CREATE INDEX bmw_id_idx ON public.bmw USING btree (id);
    DROP INDEX public.bmw_id_idx;
       public            postgres    false    4985    266    266         �           1259    52007    bmw_name_idx    INDEX     <   CREATE INDEX bmw_name_idx ON public.bmw USING btree (name);
     DROP INDEX public.bmw_name_idx;
       public            postgres    false    266    266    4986         �           1259    52018    ferrari_brand_idx    INDEX     F   CREATE INDEX ferrari_brand_idx ON public.ferrari USING btree (brand);
 %   DROP INDEX public.ferrari_brand_idx;
       public            postgres    false    267    4984    267         �           1259    51998    ferrari_id_idx    INDEX     @   CREATE INDEX ferrari_id_idx ON public.ferrari USING btree (id);
 "   DROP INDEX public.ferrari_id_idx;
       public            postgres    false    267    4985    267         �           1259    52008    ferrari_name_idx    INDEX     D   CREATE INDEX ferrari_name_idx ON public.ferrari USING btree (name);
 $   DROP INDEX public.ferrari_name_idx;
       public            postgres    false    4986    267    267         �           1259    52019    ford_brand_idx    INDEX     @   CREATE INDEX ford_brand_idx ON public.ford USING btree (brand);
 "   DROP INDEX public.ford_brand_idx;
       public            postgres    false    268    268    4984         �           1259    51999    ford_id_idx    INDEX     :   CREATE INDEX ford_id_idx ON public.ford USING btree (id);
    DROP INDEX public.ford_id_idx;
       public            postgres    false    268    4985    268         �           1259    52009    ford_name_idx    INDEX     >   CREATE INDEX ford_name_idx ON public.ford USING btree (name);
 !   DROP INDEX public.ford_name_idx;
       public            postgres    false    268    268    4986         �           1259    52020    honda_brand_idx    INDEX     B   CREATE INDEX honda_brand_idx ON public.honda USING btree (brand);
 #   DROP INDEX public.honda_brand_idx;
       public            postgres    false    4984    269    269         �           1259    52000    honda_id_idx    INDEX     <   CREATE INDEX honda_id_idx ON public.honda USING btree (id);
     DROP INDEX public.honda_id_idx;
       public            postgres    false    269    4985    269         �           1259    52010    honda_name_idx    INDEX     @   CREATE INDEX honda_name_idx ON public.honda USING btree (name);
 "   DROP INDEX public.honda_name_idx;
       public            postgres    false    269    269    4986         �           1259    52021    lamborghini_brand_idx    INDEX     N   CREATE INDEX lamborghini_brand_idx ON public.lamborghini USING btree (brand);
 )   DROP INDEX public.lamborghini_brand_idx;
       public            postgres    false    270    270    4984         �           1259    52001    lamborghini_id_idx    INDEX     H   CREATE INDEX lamborghini_id_idx ON public.lamborghini USING btree (id);
 &   DROP INDEX public.lamborghini_id_idx;
       public            postgres    false    270    270    4985         �           1259    52011    lamborghini_name_idx    INDEX     L   CREATE INDEX lamborghini_name_idx ON public.lamborghini USING btree (name);
 (   DROP INDEX public.lamborghini_name_idx;
       public            postgres    false    4986    270    270         �           1259    52022    mazda_brand_idx    INDEX     B   CREATE INDEX mazda_brand_idx ON public.mazda USING btree (brand);
 #   DROP INDEX public.mazda_brand_idx;
       public            postgres    false    271    271    4984         �           1259    52002    mazda_id_idx    INDEX     <   CREATE INDEX mazda_id_idx ON public.mazda USING btree (id);
     DROP INDEX public.mazda_id_idx;
       public            postgres    false    271    4985    271         �           1259    52012    mazda_name_idx    INDEX     @   CREATE INDEX mazda_name_idx ON public.mazda USING btree (name);
 "   DROP INDEX public.mazda_name_idx;
       public            postgres    false    271    4986    271         �           1259    52023    mercedes_brand_idx    INDEX     H   CREATE INDEX mercedes_brand_idx ON public.mercedes USING btree (brand);
 &   DROP INDEX public.mercedes_brand_idx;
       public            postgres    false    272    4984    272         �           1259    52003    mercedes_id_idx    INDEX     B   CREATE INDEX mercedes_id_idx ON public.mercedes USING btree (id);
 #   DROP INDEX public.mercedes_id_idx;
       public            postgres    false    272    272    4985         �           1259    52013    mercedes_name_idx    INDEX     F   CREATE INDEX mercedes_name_idx ON public.mercedes USING btree (name);
 %   DROP INDEX public.mercedes_name_idx;
       public            postgres    false    272    272    4986         �           1259    52024    other_brand_brand_idx    INDEX     N   CREATE INDEX other_brand_brand_idx ON public.other_brand USING btree (brand);
 )   DROP INDEX public.other_brand_brand_idx;
       public            postgres    false    273    4984    273         �           1259    52004    other_brand_id_idx    INDEX     H   CREATE INDEX other_brand_id_idx ON public.other_brand USING btree (id);
 &   DROP INDEX public.other_brand_id_idx;
       public            postgres    false    273    273    4985         �           1259    52014    other_brand_name_idx    INDEX     L   CREATE INDEX other_brand_name_idx ON public.other_brand USING btree (name);
 (   DROP INDEX public.other_brand_name_idx;
       public            postgres    false    4986    273    273         �           0    0    audi_brand_idx    INDEX ATTACH     R   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.audi_brand_idx;
          public          postgres    false    4989    4984    265    264         �           0    0    audi_id_idx    INDEX ATTACH     L   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.audi_id_idx;
          public          postgres    false    4990    4985    265    264         �           0    0    audi_name_idx    INDEX ATTACH     P   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.audi_name_idx;
          public          postgres    false    4991    4986    265    264         �           0    0 	   audi_pkey    INDEX ATTACH     J   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.audi_pkey;
          public          postgres    false    265    4988    4993    4988    265    264         �           0    0    bmw_brand_idx    INDEX ATTACH     Q   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.bmw_brand_idx;
          public          postgres    false    4994    4984    266    264         �           0    0 
   bmw_id_idx    INDEX ATTACH     K   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.bmw_id_idx;
          public          postgres    false    4995    4985    266    264         �           0    0    bmw_name_idx    INDEX ATTACH     O   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.bmw_name_idx;
          public          postgres    false    4996    4986    266    264         �           0    0    bmw_pkey    INDEX ATTACH     I   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.bmw_pkey;
          public          postgres    false    266    4988    4998    4988    266    264         �           0    0    customers_2024_pkey    INDEX ATTACH     \   ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_2024_pkey;
          public          postgres    false    5035    5037    276    5035    276    275         �           0    0    customers_default_pkey    INDEX ATTACH     _   ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_default_pkey;
          public          postgres    false    5039    5035    277    5035    277    275         �           0    0    emp_2024_pkey    INDEX ATTACH     F   ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_2024_pkey;
          public          postgres    false    284    5049    5047    5047    284    283         �           0    0    emp_others_pkey    INDEX ATTACH     H   ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_others_pkey;
          public          postgres    false    285    5051    5047    5047    285    283         �           0    0    ferrari_brand_idx    INDEX ATTACH     U   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ferrari_brand_idx;
          public          postgres    false    4999    4984    267    264         �           0    0    ferrari_id_idx    INDEX ATTACH     O   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ferrari_id_idx;
          public          postgres    false    5000    4985    267    264         �           0    0    ferrari_name_idx    INDEX ATTACH     S   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ferrari_name_idx;
          public          postgres    false    5001    4986    267    264         �           0    0    ferrari_pkey    INDEX ATTACH     M   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ferrari_pkey;
          public          postgres    false    5003    267    4988    4988    267    264         �           0    0    ford_brand_idx    INDEX ATTACH     R   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ford_brand_idx;
          public          postgres    false    5004    4984    268    264         �           0    0    ford_id_idx    INDEX ATTACH     L   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ford_id_idx;
          public          postgres    false    5005    4985    268    264         �           0    0    ford_name_idx    INDEX ATTACH     P   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ford_name_idx;
          public          postgres    false    5006    4986    268    264         �           0    0 	   ford_pkey    INDEX ATTACH     J   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ford_pkey;
          public          postgres    false    4988    5008    268    4988    268    264         �           0    0    honda_brand_idx    INDEX ATTACH     S   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.honda_brand_idx;
          public          postgres    false    5009    4984    269    264         �           0    0    honda_id_idx    INDEX ATTACH     M   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.honda_id_idx;
          public          postgres    false    5010    4985    269    264         �           0    0    honda_name_idx    INDEX ATTACH     Q   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.honda_name_idx;
          public          postgres    false    5011    4986    269    264         �           0    0 
   honda_pkey    INDEX ATTACH     K   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.honda_pkey;
          public          postgres    false    269    5013    4988    4988    269    264         �           0    0    lamborghini_brand_idx    INDEX ATTACH     Y   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.lamborghini_brand_idx;
          public          postgres    false    5014    4984    270    264         �           0    0    lamborghini_id_idx    INDEX ATTACH     S   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.lamborghini_id_idx;
          public          postgres    false    5015    4985    270    264         �           0    0    lamborghini_name_idx    INDEX ATTACH     W   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.lamborghini_name_idx;
          public          postgres    false    5016    4986    270    264         �           0    0    lamborghini_pkey    INDEX ATTACH     Q   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.lamborghini_pkey;
          public          postgres    false    5018    270    4988    4988    270    264         �           0    0    mazda_brand_idx    INDEX ATTACH     S   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mazda_brand_idx;
          public          postgres    false    5019    4984    271    264         �           0    0    mazda_id_idx    INDEX ATTACH     M   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mazda_id_idx;
          public          postgres    false    5020    4985    271    264         �           0    0    mazda_name_idx    INDEX ATTACH     Q   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mazda_name_idx;
          public          postgres    false    5021    4986    271    264         �           0    0 
   mazda_pkey    INDEX ATTACH     K   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mazda_pkey;
          public          postgres    false    271    5023    4988    4988    271    264         �           0    0    mercedes_brand_idx    INDEX ATTACH     V   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mercedes_brand_idx;
          public          postgres    false    5024    4984    272    264         �           0    0    mercedes_id_idx    INDEX ATTACH     P   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mercedes_id_idx;
          public          postgres    false    5025    4985    272    264         �           0    0    mercedes_name_idx    INDEX ATTACH     T   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mercedes_name_idx;
          public          postgres    false    5026    4986    272    264         �           0    0    mercedes_pkey    INDEX ATTACH     N   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mercedes_pkey;
          public          postgres    false    5028    272    4988    4988    272    264         �           0    0    order_2024_pkey    INDEX ATTACH     S   ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_2024_pkey;
          public          postgres    false    280    5041    5043    5041    280    279         �           0    0    order_others_pkey    INDEX ATTACH     U   ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_others_pkey;
          public          postgres    false    5045    5041    281    5041    281    279         �           0    0    other_brand_brand_idx    INDEX ATTACH     Y   ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.other_brand_brand_idx;
          public          postgres    false    5029    4984    273    264         �           0    0    other_brand_id_idx    INDEX ATTACH     S   ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.other_brand_id_idx;
          public          postgres    false    5030    4985    273    264         �           0    0    other_brand_name_idx    INDEX ATTACH     W   ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.other_brand_name_idx;
          public          postgres    false    5031    4986    273    264         �           0    0    other_brand_pkey    INDEX ATTACH     Q   ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.other_brand_pkey;
          public          postgres    false    5033    4988    273    4988    273    264         �           2620    52232 3   orders check_product_id_customer_id_existed_trigger    TRIGGER     �   CREATE TRIGGER check_product_id_customer_id_existed_trigger BEFORE INSERT ON customer.orders FOR EACH ROW EXECUTE FUNCTION public.check_product_id_customer_id_existed();
 N   DROP TRIGGER check_product_id_customer_id_existed_trigger ON customer.orders;
       customer          postgres    false    279    309                                                                                                                                                                                                                                                                                                                           5256.dat                                                                                            0000600 0004000 0002000 00000000553 14660144432 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	{"welcome to hvac auto online","we provide everything you need to a car"}	First I will explain what contextual advertising is. Contextual advertising means the advertising of products on a website according to the content the page is displaying. For example if the content of a website was information on a Ford truck then the advertisements	about-pic.jpg
\.


                                                                                                                                                     5260.dat                                                                                            0000600 0004000 0002000 00000001246 14660144432 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	our mission	now, i’m not like Robin, that weirdo from my cultural anthropology class; I think that advertising is something that has its place in our society; which for better or worse is structured along a marketplace economy. But, simply because i feel advertising has a right to exist, doesn’t mean that i like or agree with it, in its
2	our vision	where do you register your complaints? How can you protest in any form against companies whose advertising techniques you don’t agree with? You don’t. And on another point of difference between traditional products and their advertising and those of the internet nature, simply ignoring internet advertising is
\.


                                                                                                                                                                                                                                                                                                                                                          5269.dat                                                                                            0000600 0004000 0002000 00000000031 14660144432 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        partner	our clients
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       5271.dat                                                                                            0000600 0004000 0002000 00000000277 14660144432 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	client-1.png	emotion in motion logo
2	client-2.png	eater logo
3	client-3.png	fotografr logo
4	client-4.png	pencl sketches logo
5	client-5.png	good food logo
6	client-6.png	envato logo
\.


                                                                                                                                                                                                                                                                                                                                 5258.dat                                                                                            0000600 0004000 0002000 00000000720 14660144432 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	quality assurance system	it seems though that some of the biggest problems with the internet advertising trends are the lack of	features/af-1.png
2	accurate testing processes	where do you register your complaints? How can you protest in any form against companies whose	features/af-2.png
3	infrastructure integration technology	So in final analysis: it’s true, I hate peeping Toms, but if I had to choose, I’d take one any day over an	features/af-3.png
\.


                                                5268.dat                                                                                            0000600 0004000 0002000 00000000133 14660144432 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	vehicles stock	1922
2	vehicles sale	1500
3	dealer reviews	2214
4	happy clients	5100
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                     5261.dat                                                                                            0000600 0004000 0002000 00000000036 14660144432 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        our team	meet our expert
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  5263.dat                                                                                            0000600 0004000 0002000 00000000212 14660144432 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	john smith	team-1.jpg	marketing
2	christine wise	team-2.jpg	CEO
3	sean robbins	team-3.jpg	manager
4	lucy myers	team-4.jpg	delivary
\.


                                                                                                                                                                                                                                                                                                                                                                                      5264.dat                                                                                            0000600 0004000 0002000 00000000160 14660144432 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        testimonials	what people say about us?	Our customers are our biggest supporters. What do they think of us?
\.


                                                                                                                                                                                                                                                                                                                                                                                                                5266.dat                                                                                            0000600 0004000 0002000 00000000570 14660144432 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	john smith	testimonial-1.png	CEO ABC	5	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.
2	emma sandoval	testimonial-1.png	CEO ABC	4.5	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta purus vel fermentum maximus. Aliquam rhoncus iaculis justo in molestie.
\.


                                                                                                                                        5277.dat                                                                                            0000600 0004000 0002000 00000000363 14660144432 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	brand	brand	{honda,mazda,ford,audi,mercedes,bmw,ferrari,lamborghini}
2	model	model	{2019,2020,2021,2022,2023}
3	carType	car type	{SUV,sedan,sport,hatchback}
4	transmission	transmission	{auto,manual}
5	mileage	mileage	{1000,10000,15000}
\.


                                                                                                                                                                                                                                                                             5272.dat                                                                                            0000600 0004000 0002000 00000000147 14660144432 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        let's work together	to make requests for further information, contact us via our social channels.
\.


                                                                                                                                                                                                                                                                                                                                                                                                                         5273.dat                                                                                            0000600 0004000 0002000 00000000066 14660144432 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        08:00 am to 18:00 pm	10:00 am to 16:00 pm	closed
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                          5275.dat                                                                                            0000600 0004000 0002000 00000000473 14660144432 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	california showroom	625 Gloria Union, California, United Stated	hvac.california@gmail.com	(+01) 123 456 789
2	new york showroom	8235 South Ave. Jamestown, NewYork	hvac.newyork@gmail.com	(+01) 123 456 789
3	florida showroom	497 Beaver Ridge St. Daytona Beach, Florida	hvac.florida@gmail.com	(+01) 123 456 789
\.


                                                                                                                                                                                                     5249.dat                                                                                            0000600 0004000 0002000 00000000042 14660144432 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        our cars	best vihicle offers
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              5250.dat                                                                                            0000600 0004000 0002000 00000000273 14660144432 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        why people choose us	Duis aute irure dolorin reprehenderits volupta velit dolore fugiat nulla pariatur excepteur sint occaecat cupidatat.	https://www.youtube.com/watch?v=sitXeGjm4Mc
\.


                                                                                                                                                                                                                                                                                                                                     5252.dat                                                                                            0000600 0004000 0002000 00000000336 14660144432 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Lorem ipsum dolor sit amet, consectetur adipiscing elit.
2	Integer et nisl et massa tempor ornare vel id orci.
3	Nunc consectetur ligula vitae nisl placerat tempus.
4	Curabitur quis ante vitae lacus varius pretium.
\.


                                                                                                                                                                                                                                                                                                  5253.dat                                                                                            0000600 0004000 0002000 00000000340 14660144432 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        do you want to buy a car	lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	cta-1.jpg	1
do you want to rent a car	lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod	cta-2.jpg	2
\.


                                                                                                                                                                                                                                                                                                5246.dat                                                                                            0000600 0004000 0002000 00000000577 14660144432 0014267 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        our features	we are a trusted name in auto	{"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et","Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis ipsum suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel facilisis."}
\.


                                                                                                                                 5248.dat                                                                                            0000600 0004000 0002000 00000000227 14660144432 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	engine	feature-1.png
2	turbo	feature-2.png
3	cooling	feature-3.png
4	suspension	feature-4.png
5	electrical	feature-5.png
6	brakes	feature-6.png
\.


                                                                                                                                                                                                                                                                                                                                                                         5238.dat                                                                                            0000600 0004000 0002000 00000000210 14660144432 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        find your dream car	{2019,2020,2021,2022,2023,2024}	{audi,lamborghini,porscher,bmw,ford}	{auto,manual}	{sedan,suv,sport,hatchback}
\.


                                                                                                                                                                                                                                                                                                                                                                                        5243.dat                                                                                            0000600 0004000 0002000 00000000160 14660144432 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        our services	what we offers	Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
\.


                                                                                                                                                                                                                                                                                                                                                                                                                5245.dat                                                                                            0000600 0004000 0002000 00000001044 14660144432 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	rental a car	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-1.png
2	buying a car	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-2.png
3	car maintenance	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-3.png
4	support 24/7	Consectetur adipiscing elit incididunt ut labore et dolore magna aliqua. Risus commodo viverra maecenas.	services-4.png
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            5242.dat                                                                                            0000600 0004000 0002000 00000000354 14660144432 0014254 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        hvac@mail.com	(+84) 123 456 789	weekday: 08:00am to 09:00pm	{"skype": "https://skype.com", "google": "https://google.com", "twitter": "https://twitter.com", "facebook": "https://facebook.com", "instagram": "https://instagram.com"}
\.


                                                                                                                                                                                                                                                                                    5241.dat                                                                                            0000600 0004000 0002000 00000000240 14660144432 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        contact us now!	Any questions? Let us know in store at Ha Noi, Viet Nam or call us on (+84) 123 456 789	{"bg": "footer-bg.jpg", "logo": "footer-logo.png"}
\.


                                                                                                                                                                                                                                                                                                                                                                5240.dat                                                                                            0000600 0004000 0002000 00000000075 14660144432 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	home	/
2	cars	/cars
3	about	/about
4	contact	/contact
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                   5279.dat                                                                                            0000600 0004000 0002000 00000000233 14660144432 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	audi a6	audi	327.00	auto	rent	gasoline	sedan	250	2022	16458	2024-08-17
2	audi a7	audi	471.00	auto	rent	gasoline	sportback	250	2023	18321	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                                     5280.dat                                                                                            0000600 0004000 0002000 00000000252 14660144432 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	bmw 530i sedan	bmw	71846.41	auto	sale	electric	sedan	184	2021	10154	2024-08-17
4	bmw 735i m sport	bmw	176671.51	auto	sale	gasoline	sedan	286	2023	13552	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                      5289.dat                                                                                            0000600 0004000 0002000 00000000005 14660144432 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5290.dat                                                                                            0000600 0004000 0002000 00000000005 14660144432 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5295.dat                                                                                            0000600 0004000 0002000 00000000111 14660144432 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	admin@mail.com	admin	0123456789	admin	admin	2024-08-17	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                       5296.dat                                                                                            0000600 0004000 0002000 00000000005 14660144432 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5281.dat                                                                                            0000600 0004000 0002000 00000000273 14660144432 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        5	LaFerrari Aperta	ferrari	5000000.00	auto	sale	electric	sport	700	2016	10423	2024-08-17
6	ferrari SF90 stradale	ferrari	990000.00	auto	sale	electric	sport	986	2020	10645	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                     5282.dat                                                                                            0000600 0004000 0002000 00000000303 14660144432 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        7	ford mustang® dark horse™ premium	ford	62930.00	auto	sale	gasoline	suv	500	2024	11785	2024-08-17
8	ford ranger raptor®	ford	55620.00	auto	sale	gasoline	truck	315	2024	10985	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                             5283.dat                                                                                            0000600 0004000 0002000 00000000265 14660144432 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        9	honda CR-V EX-L	honda	35000.00	auto	sale	electric	suv	190	2024	14300	2024-08-17
10	honda pilot black edition	honda	54280.00	manual	sale	electric	suv	285	2024	9536	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                           5284.dat                                                                                            0000600 0004000 0002000 00000000307 14660144432 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        11	lamborghini revuelto	lamborghini	608.36	manual	sale	mixed	sport	813	2024	6595	2024-08-17
12	lamborghini sian roadster	lamborghini	3800000.00	auto	sale	electric	sport	800	2024	9452	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                         5285.dat                                                                                            0000600 0004000 0002000 00000000234 14660144432 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        13	mazda 6	mazda	605.00	auto	rent	gasoline	sedan	154	2021	24160	2024-08-17
14	mazda CX-8	mazda	526.00	auto	rent	gasoline	suv	188	2021	24452	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                                    5286.dat                                                                                            0000600 0004000 0002000 00000000255 14660144432 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        15	mercedes C-200	mercedes	213.00	auto	rent	gasoline	sedan	258	2022	16584	2024-08-17
16	maybach s450	mercedes	447.00	auto	rent	gasoline	sedan	367	2024	25400	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                   5292.dat                                                                                            0000600 0004000 0002000 00000000036 14660144432 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        8	1	1	1	180	0	2024-08-17
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  5293.dat                                                                                            0000600 0004000 0002000 00000000005 14660144432 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           5287.dat                                                                                            0000600 0004000 0002000 00000000005 14660144432 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           restore.sql                                                                                         0000600 0004000 0002000 00000206131 14660144432 0015373 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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

DROP DATABASE hvac;
--
-- Name: hvac; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE hvac WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252' TABLESPACE = hvac_tbs;


ALTER DATABASE hvac OWNER TO postgres;

\connect hvac

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
-- Name: aboutpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA aboutpage;


ALTER SCHEMA aboutpage OWNER TO postgres;

--
-- Name: carpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA carpage;


ALTER SCHEMA carpage OWNER TO postgres;

--
-- Name: contactpage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contactpage;


ALTER SCHEMA contactpage OWNER TO postgres;

--
-- Name: customer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA customer;


ALTER SCHEMA customer OWNER TO postgres;

--
-- Name: employee; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA employee;


ALTER SCHEMA employee OWNER TO postgres;

--
-- Name: homepage; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA homepage;


ALTER SCHEMA homepage OWNER TO postgres;

--
-- Name: layout; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA layout;


ALTER SCHEMA layout OWNER TO postgres;

--
-- Name: product; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA product;


ALTER SCHEMA product OWNER TO postgres;

--
-- Name: email_type; Type: DOMAIN; Schema: customer; Owner: postgres
--

CREATE DOMAIN customer.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN customer.email_type OWNER TO postgres;

--
-- Name: phone_type; Type: DOMAIN; Schema: customer; Owner: postgres
--

CREATE DOMAIN customer.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN customer.phone_type OWNER TO postgres;

--
-- Name: email_type; Type: DOMAIN; Schema: employee; Owner: postgres
--

CREATE DOMAIN employee.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN employee.email_type OWNER TO postgres;

--
-- Name: phone_type; Type: DOMAIN; Schema: employee; Owner: postgres
--

CREATE DOMAIN employee.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN employee.phone_type OWNER TO postgres;

--
-- Name: email_type; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


ALTER DOMAIN public.email_type OWNER TO postgres;

--
-- Name: phone_type; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));


ALTER DOMAIN public.phone_type OWNER TO postgres;

--
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
-- Name: about_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.about_items (
    _id integer NOT NULL,
    title character varying(15) NOT NULL,
    text text NOT NULL
);


ALTER TABLE aboutpage.about_items OWNER TO postgres;

--
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
-- Name: clients; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.clients (
    title character varying(30) NOT NULL,
    subtitle character varying(20) NOT NULL
);


ALTER TABLE aboutpage.clients OWNER TO postgres;

--
-- Name: clients_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.clients_items (
    _id smallint NOT NULL,
    img character varying(30) NOT NULL,
    alt character varying(30)
);


ALTER TABLE aboutpage.clients_items OWNER TO postgres;

--
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
-- Name: quantities_items; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.quantities_items (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    value smallint NOT NULL
);


ALTER TABLE aboutpage.quantities_items OWNER TO postgres;

--
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
-- Name: teams; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.teams (
    title character varying(15) NOT NULL,
    subtitle character varying(30) NOT NULL
);


ALTER TABLE aboutpage.teams OWNER TO postgres;

--
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
-- Name: testimonials; Type: TABLE; Schema: aboutpage; Owner: postgres
--

CREATE TABLE aboutpage.testimonials (
    title character varying(30) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text
);


ALTER TABLE aboutpage.testimonials OWNER TO postgres;

--
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
-- Name: contact; Type: TABLE; Schema: contactpage; Owner: postgres
--

CREATE TABLE contactpage.contact (
    title character varying(30) NOT NULL,
    text text
);


ALTER TABLE contactpage.contact OWNER TO postgres;

--
-- Name: schedule; Type: TABLE; Schema: contactpage; Owner: postgres
--

CREATE TABLE contactpage.schedule (
    weekdays character varying(20) NOT NULL,
    saturday character varying(20) NOT NULL,
    sunday character varying(20) NOT NULL
);


ALTER TABLE contactpage.schedule OWNER TO postgres;

--
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
-- Name: car; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.car (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL
);


ALTER TABLE homepage.car OWNER TO postgres;

--
-- Name: chooseus; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.chooseus (
    title character varying(25) NOT NULL,
    text text,
    videourl text NOT NULL
);


ALTER TABLE homepage.chooseus OWNER TO postgres;

--
-- Name: chooseus_items; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.chooseus_items (
    _id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE homepage.chooseus_items OWNER TO postgres;

--
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
-- Name: features; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.features (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text[]
);


ALTER TABLE homepage.features OWNER TO postgres;

--
-- Name: features_items; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.features_items (
    _id integer NOT NULL,
    text character varying(10) NOT NULL,
    img character varying(15) NOT NULL
);


ALTER TABLE homepage.features_items OWNER TO postgres;

--
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
-- Name: services; Type: TABLE; Schema: homepage; Owner: postgres
--

CREATE TABLE homepage.services (
    title character varying(20) NOT NULL,
    subtitle character varying(20) NOT NULL,
    text text
);


ALTER TABLE homepage.services OWNER TO postgres;

--
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
-- Name: footer; Type: TABLE; Schema: layout; Owner: postgres
--

CREATE TABLE layout.footer (
    "contactTitle" character varying(20) NOT NULL,
    "aboutContent" character varying(100) NOT NULL,
    imgs jsonb NOT NULL
);


ALTER TABLE layout.footer OWNER TO postgres;

--
-- Name: navbar; Type: TABLE; Schema: layout; Owner: postgres
--

CREATE TABLE layout.navbar (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    path character varying(11) NOT NULL
);


ALTER TABLE layout.navbar OWNER TO postgres;

--
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
-- Name: audi; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.audi FOR VALUES IN ('audi');


--
-- Name: bmw; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.bmw FOR VALUES IN ('bmw');


--
-- Name: customers_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- Name: customers_default; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.customers ATTACH PARTITION public.customers_default DEFAULT;


--
-- Name: emp_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- Name: emp_others; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY employee.employees ATTACH PARTITION public.emp_others DEFAULT;


--
-- Name: ferrari; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.ferrari FOR VALUES IN ('ferrari');


--
-- Name: ford; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.ford FOR VALUES IN ('ford');


--
-- Name: honda; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.honda FOR VALUES IN ('honda');


--
-- Name: lamborghini; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.lamborghini FOR VALUES IN ('lamborghini');


--
-- Name: mazda; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.mazda FOR VALUES IN ('mazda');


--
-- Name: mercedes; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.mercedes FOR VALUES IN ('mercedes');


--
-- Name: order_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');


--
-- Name: order_others; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customer.orders ATTACH PARTITION public.order_others DEFAULT;


--
-- Name: other_brand; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY product.cars ATTACH PARTITION public.other_brand DEFAULT;


--
-- Data for Name: about; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.about (_id, title, text, img) FROM stdin;
\.
COPY aboutpage.about (_id, title, text, img) FROM '$$PATH$$/5256.dat';

--
-- Data for Name: about_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.about_items (_id, title, text) FROM stdin;
\.
COPY aboutpage.about_items (_id, title, text) FROM '$$PATH$$/5260.dat';

--
-- Data for Name: clients; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.clients (title, subtitle) FROM stdin;
\.
COPY aboutpage.clients (title, subtitle) FROM '$$PATH$$/5269.dat';

--
-- Data for Name: clients_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.clients_items (_id, img, alt) FROM stdin;
\.
COPY aboutpage.clients_items (_id, img, alt) FROM '$$PATH$$/5271.dat';

--
-- Data for Name: features; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.features (_id, title, text, img) FROM stdin;
\.
COPY aboutpage.features (_id, title, text, img) FROM '$$PATH$$/5258.dat';

--
-- Data for Name: quantities_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.quantities_items (_id, name, value) FROM stdin;
\.
COPY aboutpage.quantities_items (_id, name, value) FROM '$$PATH$$/5268.dat';

--
-- Data for Name: teams; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.teams (title, subtitle) FROM stdin;
\.
COPY aboutpage.teams (title, subtitle) FROM '$$PATH$$/5261.dat';

--
-- Data for Name: teams_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.teams_items (_id, name, img, "position") FROM stdin;
\.
COPY aboutpage.teams_items (_id, name, img, "position") FROM '$$PATH$$/5263.dat';

--
-- Data for Name: testimonials; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.testimonials (title, subtitle, text) FROM stdin;
\.
COPY aboutpage.testimonials (title, subtitle, text) FROM '$$PATH$$/5264.dat';

--
-- Data for Name: testimonials_items; Type: TABLE DATA; Schema: aboutpage; Owner: postgres
--

COPY aboutpage.testimonials_items (_id, name, img, "position", rate, text) FROM stdin;
\.
COPY aboutpage.testimonials_items (_id, name, img, "position", rate, text) FROM '$$PATH$$/5266.dat';

--
-- Data for Name: filterform; Type: TABLE DATA; Schema: carpage; Owner: postgres
--

COPY carpage.filterform (_id, name, label, options) FROM stdin;
\.
COPY carpage.filterform (_id, name, label, options) FROM '$$PATH$$/5277.dat';

--
-- Data for Name: contact; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.contact (title, text) FROM stdin;
\.
COPY contactpage.contact (title, text) FROM '$$PATH$$/5272.dat';

--
-- Data for Name: schedule; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.schedule (weekdays, saturday, sunday) FROM stdin;
\.
COPY contactpage.schedule (weekdays, saturday, sunday) FROM '$$PATH$$/5273.dat';

--
-- Data for Name: showrooms; Type: TABLE DATA; Schema: contactpage; Owner: postgres
--

COPY contactpage.showrooms (_id, name, address, email, phone) FROM stdin;
\.
COPY contactpage.showrooms (_id, name, address, email, phone) FROM '$$PATH$$/5275.dat';

--
-- Data for Name: car; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.car (title, subtitle) FROM stdin;
\.
COPY homepage.car (title, subtitle) FROM '$$PATH$$/5249.dat';

--
-- Data for Name: chooseus; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.chooseus (title, text, videourl) FROM stdin;
\.
COPY homepage.chooseus (title, text, videourl) FROM '$$PATH$$/5250.dat';

--
-- Data for Name: chooseus_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.chooseus_items (_id, text) FROM stdin;
\.
COPY homepage.chooseus_items (_id, text) FROM '$$PATH$$/5252.dat';

--
-- Data for Name: cta; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.cta (title, text, img, _id) FROM stdin;
\.
COPY homepage.cta (title, text, img, _id) FROM '$$PATH$$/5253.dat';

--
-- Data for Name: features; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.features (title, subtitle, text) FROM stdin;
\.
COPY homepage.features (title, subtitle, text) FROM '$$PATH$$/5246.dat';

--
-- Data for Name: features_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.features_items (_id, text, img) FROM stdin;
\.
COPY homepage.features_items (_id, text, img) FROM '$$PATH$$/5248.dat';

--
-- Data for Name: hero; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.hero (title, models, brands, transmissions, types) FROM stdin;
\.
COPY homepage.hero (title, models, brands, transmissions, types) FROM '$$PATH$$/5238.dat';

--
-- Data for Name: services; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.services (title, subtitle, text) FROM stdin;
\.
COPY homepage.services (title, subtitle, text) FROM '$$PATH$$/5243.dat';

--
-- Data for Name: services_items; Type: TABLE DATA; Schema: homepage; Owner: postgres
--

COPY homepage.services_items (_id, title, text, img) FROM stdin;
\.
COPY homepage.services_items (_id, title, text, img) FROM '$$PATH$$/5245.dat';

--
-- Data for Name: contactInfo; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout."contactInfo" (email, phone, schedule, socials) FROM stdin;
\.
COPY layout."contactInfo" (email, phone, schedule, socials) FROM '$$PATH$$/5242.dat';

--
-- Data for Name: footer; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout.footer ("contactTitle", "aboutContent", imgs) FROM stdin;
\.
COPY layout.footer ("contactTitle", "aboutContent", imgs) FROM '$$PATH$$/5241.dat';

--
-- Data for Name: navbar; Type: TABLE DATA; Schema: layout; Owner: postgres
--

COPY layout.navbar (id, name, path) FROM stdin;
\.
COPY layout.navbar (id, name, path) FROM '$$PATH$$/5240.dat';

--
-- Data for Name: audi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audi (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.audi (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5279.dat';

--
-- Data for Name: bmw; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bmw (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.bmw (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5280.dat';

--
-- Data for Name: customers_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_2024 (id, email, password, name, phone, created_at) FROM stdin;
\.
COPY public.customers_2024 (id, email, password, name, phone, created_at) FROM '$$PATH$$/5289.dat';

--
-- Data for Name: customers_default; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers_default (id, email, password, name, phone, created_at) FROM stdin;
\.
COPY public.customers_default (id, email, password, name, phone, created_at) FROM '$$PATH$$/5290.dat';

--
-- Data for Name: emp_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_2024 (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
\.
COPY public.emp_2024 (id, email, password, phone, name, power, created_at, updated_at) FROM '$$PATH$$/5295.dat';

--
-- Data for Name: emp_others; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp_others (id, email, password, phone, name, power, created_at, updated_at) FROM stdin;
\.
COPY public.emp_others (id, email, password, phone, name, power, created_at, updated_at) FROM '$$PATH$$/5296.dat';

--
-- Data for Name: ferrari; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ferrari (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.ferrari (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5281.dat';

--
-- Data for Name: ford; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ford (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.ford (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5282.dat';

--
-- Data for Name: honda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.honda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.honda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5283.dat';

--
-- Data for Name: lamborghini; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lamborghini (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.lamborghini (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5284.dat';

--
-- Data for Name: mazda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mazda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.mazda (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5285.dat';

--
-- Data for Name: mercedes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mercedes (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.mercedes (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5286.dat';

--
-- Data for Name: order_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_2024 (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
\.
COPY public.order_2024 (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM '$$PATH$$/5292.dat';

--
-- Data for Name: order_others; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_others (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
\.
COPY public.order_others (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM '$$PATH$$/5293.dat';

--
-- Data for Name: other_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.other_brand (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM stdin;
\.
COPY public.other_brand (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage, created_at) FROM '$$PATH$$/5287.dat';

--
-- Name: about__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.about__id_seq', 1, true);


--
-- Name: about_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.about_items__id_seq', 2, true);


--
-- Name: clients_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.clients_items__id_seq', 6, true);


--
-- Name: features__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.features__id_seq', 3, true);


--
-- Name: quantities_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.quantities_items__id_seq', 4, true);


--
-- Name: teams_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.teams_items__id_seq', 4, true);


--
-- Name: testimonials_items__id_seq; Type: SEQUENCE SET; Schema: aboutpage; Owner: postgres
--

SELECT pg_catalog.setval('aboutpage.testimonials_items__id_seq', 2, true);


--
-- Name: filterform__id_seq; Type: SEQUENCE SET; Schema: carpage; Owner: postgres
--

SELECT pg_catalog.setval('carpage.filterform__id_seq', 5, true);


--
-- Name: showrooms__id_seq; Type: SEQUENCE SET; Schema: contactpage; Owner: postgres
--

SELECT pg_catalog.setval('contactpage.showrooms__id_seq', 3, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.customers_id_seq', 1, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: customer; Owner: postgres
--

SELECT pg_catalog.setval('customer.orders_id_seq', 9, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: employee; Owner: postgres
--

SELECT pg_catalog.setval('employee.employees_id_seq', 1, true);


--
-- Name: chooseus_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.chooseus_items__id_seq', 4, true);


--
-- Name: cta__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.cta__id_seq', 2, true);


--
-- Name: features_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.features_items__id_seq', 6, true);


--
-- Name: services_items__id_seq; Type: SEQUENCE SET; Schema: homepage; Owner: postgres
--

SELECT pg_catalog.setval('homepage.services_items__id_seq', 4, true);


--
-- Name: navbar_id_seq; Type: SEQUENCE SET; Schema: layout; Owner: postgres
--

SELECT pg_catalog.setval('layout.navbar_id_seq', 4, true);


--
-- Name: cars_id_seq; Type: SEQUENCE SET; Schema: product; Owner: postgres
--

SELECT pg_catalog.setval('product.cars_id_seq', 16, true);


--
-- Name: features pk_aboutpage_features_id; Type: CONSTRAINT; Schema: aboutpage; Owner: postgres
--

ALTER TABLE ONLY aboutpage.features
    ADD CONSTRAINT pk_aboutpage_features_id PRIMARY KEY (_id);


--
-- Name: filterform pk_carpage_filterform_id; Type: CONSTRAINT; Schema: carpage; Owner: postgres
--

ALTER TABLE ONLY carpage.filterform
    ADD CONSTRAINT pk_carpage_filterform_id PRIMARY KEY (_id);


--
-- Name: showrooms pk_showrooms_id; Type: CONSTRAINT; Schema: contactpage; Owner: postgres
--

ALTER TABLE ONLY contactpage.showrooms
    ADD CONSTRAINT pk_showrooms_id PRIMARY KEY (_id);


--
-- Name: customers pk_customer_id_created_at; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.customers
    ADD CONSTRAINT pk_customer_id_created_at PRIMARY KEY (id, created_at);


--
-- Name: orders pk_customer_order_id; Type: CONSTRAINT; Schema: customer; Owner: postgres
--

ALTER TABLE ONLY customer.orders
    ADD CONSTRAINT pk_customer_order_id PRIMARY KEY (id, created_at);


--
-- Name: employees pk_emp_id; Type: CONSTRAINT; Schema: employee; Owner: postgres
--

ALTER TABLE ONLY employee.employees
    ADD CONSTRAINT pk_emp_id PRIMARY KEY (id, created_at);


--
-- Name: chooseus_items pk_chooseus_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.chooseus_items
    ADD CONSTRAINT pk_chooseus_items_id PRIMARY KEY (_id);


--
-- Name: features_items pk_features_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.features_items
    ADD CONSTRAINT pk_features_items_id PRIMARY KEY (_id);


--
-- Name: services_items pk_services_items_id; Type: CONSTRAINT; Schema: homepage; Owner: postgres
--

ALTER TABLE ONLY homepage.services_items
    ADD CONSTRAINT pk_services_items_id PRIMARY KEY (_id);


--
-- Name: navbar pk_navbar_id; Type: CONSTRAINT; Schema: layout; Owner: postgres
--

ALTER TABLE ONLY layout.navbar
    ADD CONSTRAINT pk_navbar_id PRIMARY KEY (id);


--
-- Name: cars pk_product_cars_id; Type: CONSTRAINT; Schema: product; Owner: postgres
--

ALTER TABLE ONLY product.cars
    ADD CONSTRAINT pk_product_cars_id PRIMARY KEY (id, brand);


--
-- Name: audi audi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audi
    ADD CONSTRAINT audi_pkey PRIMARY KEY (id, brand);


--
-- Name: bmw bmw_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bmw
    ADD CONSTRAINT bmw_pkey PRIMARY KEY (id, brand);


--
-- Name: customers_2024 customers_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_2024
    ADD CONSTRAINT customers_2024_pkey PRIMARY KEY (id, created_at);


--
-- Name: customers_default customers_default_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_default
    ADD CONSTRAINT customers_default_pkey PRIMARY KEY (id, created_at);


--
-- Name: emp_2024 emp_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_2024
    ADD CONSTRAINT emp_2024_pkey PRIMARY KEY (id, created_at);


--
-- Name: emp_others emp_others_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emp_others
    ADD CONSTRAINT emp_others_pkey PRIMARY KEY (id, created_at);


--
-- Name: ferrari ferrari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ferrari
    ADD CONSTRAINT ferrari_pkey PRIMARY KEY (id, brand);


--
-- Name: ford ford_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ford
    ADD CONSTRAINT ford_pkey PRIMARY KEY (id, brand);


--
-- Name: honda honda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.honda
    ADD CONSTRAINT honda_pkey PRIMARY KEY (id, brand);


--
-- Name: lamborghini lamborghini_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lamborghini
    ADD CONSTRAINT lamborghini_pkey PRIMARY KEY (id, brand);


--
-- Name: mazda mazda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mazda
    ADD CONSTRAINT mazda_pkey PRIMARY KEY (id, brand);


--
-- Name: mercedes mercedes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mercedes
    ADD CONSTRAINT mercedes_pkey PRIMARY KEY (id, brand);


--
-- Name: order_2024 order_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_2024
    ADD CONSTRAINT order_2024_pkey PRIMARY KEY (id, created_at);


--
-- Name: order_others order_others_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_others
    ADD CONSTRAINT order_others_pkey PRIMARY KEY (id, created_at);


--
-- Name: other_brand other_brand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.other_brand
    ADD CONSTRAINT other_brand_pkey PRIMARY KEY (id, brand);


--
-- Name: idx_chooseus_items; Type: INDEX; Schema: homepage; Owner: postgres
--

CREATE INDEX idx_chooseus_items ON homepage.chooseus_items USING btree (_id);


--
-- Name: idx_product_car_brand; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_brand ON ONLY product.cars USING btree (brand);


--
-- Name: idx_product_car_id; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_id ON ONLY product.cars USING btree (id);


--
-- Name: idx_product_car_name; Type: INDEX; Schema: product; Owner: postgres
--

CREATE INDEX idx_product_car_name ON ONLY product.cars USING btree (name);


--
-- Name: audi_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_brand_idx ON public.audi USING btree (brand);


--
-- Name: audi_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_id_idx ON public.audi USING btree (id);


--
-- Name: audi_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audi_name_idx ON public.audi USING btree (name);


--
-- Name: bmw_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_brand_idx ON public.bmw USING btree (brand);


--
-- Name: bmw_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_id_idx ON public.bmw USING btree (id);


--
-- Name: bmw_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bmw_name_idx ON public.bmw USING btree (name);


--
-- Name: ferrari_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_brand_idx ON public.ferrari USING btree (brand);


--
-- Name: ferrari_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_id_idx ON public.ferrari USING btree (id);


--
-- Name: ferrari_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ferrari_name_idx ON public.ferrari USING btree (name);


--
-- Name: ford_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_brand_idx ON public.ford USING btree (brand);


--
-- Name: ford_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_id_idx ON public.ford USING btree (id);


--
-- Name: ford_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ford_name_idx ON public.ford USING btree (name);


--
-- Name: honda_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_brand_idx ON public.honda USING btree (brand);


--
-- Name: honda_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_id_idx ON public.honda USING btree (id);


--
-- Name: honda_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX honda_name_idx ON public.honda USING btree (name);


--
-- Name: lamborghini_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_brand_idx ON public.lamborghini USING btree (brand);


--
-- Name: lamborghini_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_id_idx ON public.lamborghini USING btree (id);


--
-- Name: lamborghini_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lamborghini_name_idx ON public.lamborghini USING btree (name);


--
-- Name: mazda_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_brand_idx ON public.mazda USING btree (brand);


--
-- Name: mazda_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_id_idx ON public.mazda USING btree (id);


--
-- Name: mazda_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mazda_name_idx ON public.mazda USING btree (name);


--
-- Name: mercedes_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_brand_idx ON public.mercedes USING btree (brand);


--
-- Name: mercedes_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_id_idx ON public.mercedes USING btree (id);


--
-- Name: mercedes_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mercedes_name_idx ON public.mercedes USING btree (name);


--
-- Name: other_brand_brand_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_brand_idx ON public.other_brand USING btree (brand);


--
-- Name: other_brand_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_id_idx ON public.other_brand USING btree (id);


--
-- Name: other_brand_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX other_brand_name_idx ON public.other_brand USING btree (name);


--
-- Name: audi_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.audi_brand_idx;


--
-- Name: audi_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.audi_id_idx;


--
-- Name: audi_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.audi_name_idx;


--
-- Name: audi_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.audi_pkey;


--
-- Name: bmw_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.bmw_brand_idx;


--
-- Name: bmw_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.bmw_id_idx;


--
-- Name: bmw_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.bmw_name_idx;


--
-- Name: bmw_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.bmw_pkey;


--
-- Name: customers_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_2024_pkey;


--
-- Name: customers_default_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_id_created_at ATTACH PARTITION public.customers_default_pkey;


--
-- Name: emp_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_2024_pkey;


--
-- Name: emp_others_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX employee.pk_emp_id ATTACH PARTITION public.emp_others_pkey;


--
-- Name: ferrari_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ferrari_brand_idx;


--
-- Name: ferrari_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ferrari_id_idx;


--
-- Name: ferrari_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ferrari_name_idx;


--
-- Name: ferrari_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ferrari_pkey;


--
-- Name: ford_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.ford_brand_idx;


--
-- Name: ford_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.ford_id_idx;


--
-- Name: ford_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.ford_name_idx;


--
-- Name: ford_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.ford_pkey;


--
-- Name: honda_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.honda_brand_idx;


--
-- Name: honda_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.honda_id_idx;


--
-- Name: honda_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.honda_name_idx;


--
-- Name: honda_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.honda_pkey;


--
-- Name: lamborghini_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.lamborghini_brand_idx;


--
-- Name: lamborghini_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.lamborghini_id_idx;


--
-- Name: lamborghini_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.lamborghini_name_idx;


--
-- Name: lamborghini_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.lamborghini_pkey;


--
-- Name: mazda_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mazda_brand_idx;


--
-- Name: mazda_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mazda_id_idx;


--
-- Name: mazda_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mazda_name_idx;


--
-- Name: mazda_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mazda_pkey;


--
-- Name: mercedes_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.mercedes_brand_idx;


--
-- Name: mercedes_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.mercedes_id_idx;


--
-- Name: mercedes_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.mercedes_name_idx;


--
-- Name: mercedes_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.mercedes_pkey;


--
-- Name: order_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_2024_pkey;


--
-- Name: order_others_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX customer.pk_customer_order_id ATTACH PARTITION public.order_others_pkey;


--
-- Name: other_brand_brand_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_brand ATTACH PARTITION public.other_brand_brand_idx;


--
-- Name: other_brand_id_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_id ATTACH PARTITION public.other_brand_id_idx;


--
-- Name: other_brand_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.idx_product_car_name ATTACH PARTITION public.other_brand_name_idx;


--
-- Name: other_brand_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX product.pk_product_cars_id ATTACH PARTITION public.other_brand_pkey;


--
-- Name: orders check_product_id_customer_id_existed_trigger; Type: TRIGGER; Schema: customer; Owner: postgres
--

CREATE TRIGGER check_product_id_customer_id_existed_trigger BEFORE INSERT ON customer.orders FOR EACH ROW EXECUTE FUNCTION public.check_product_id_customer_id_existed();


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       