PGDMP  "                    |            hvac    16.3    16.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16678    hvac    DATABASE     �   CREATE DATABASE hvac WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252' TABLESPACE = hvac_tbs;
    DROP DATABASE hvac;
                postgres    false                        2615    16886 	   aboutpage    SCHEMA        CREATE SCHEMA aboutpage;
    DROP SCHEMA aboutpage;
                postgres    false            
            2615    16985    carpage    SCHEMA        CREATE SCHEMA carpage;
    DROP SCHEMA carpage;
                postgres    false            	            2615    16965    contactpage    SCHEMA        CREATE SCHEMA contactpage;
    DROP SCHEMA contactpage;
                postgres    false                        2615    16736    homepage    SCHEMA        CREATE SCHEMA homepage;
    DROP SCHEMA homepage;
                postgres    false                        2615    16789    layout    SCHEMA        CREATE SCHEMA layout;
    DROP SCHEMA layout;
                postgres    false                        2615    52452    products    SCHEMA        CREATE SCHEMA products;
    DROP SCHEMA products;
                postgres    false                        2615    52313    users    SCHEMA        CREATE SCHEMA users;
    DROP SCHEMA users;
                postgres    false            �           1247    52296    account_type    TYPE     G   CREATE TYPE public.account_type AS ENUM (
    'local',
    'google'
);
    DROP TYPE public.account_type;
       public          postgres    false            7           1247    36460 
   email_type    DOMAIN     �   CREATE DOMAIN public.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));
    DROP DOMAIN public.email_type;
       public          postgres    false            3           1247    36457 
   phone_type    DOMAIN     �   CREATE DOMAIN public.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));
    DROP DOMAIN public.phone_type;
       public          postgres    false            �           1247    52302 	   role_type    TYPE     j   CREATE TYPE public.role_type AS ENUM (
    'emp',
    'admin',
    'ceo',
    'leader',
    'customer'
);
    DROP TYPE public.role_type;
       public          postgres    false            
           1247    52367 
   email_type    DOMAIN     �   CREATE DOMAIN users.email_type AS character varying(30) NOT NULL
	CONSTRAINT email_type_check CHECK (((VALUE)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));
    DROP DOMAIN users.email_type;
       users          postgres    false    11                       1247    52370 
   phone_type    DOMAIN     �   CREATE DOMAIN users.phone_type AS character varying(20) NOT NULL
	CONSTRAINT phone_type_check CHECK (((VALUE)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text));
    DROP DOMAIN users.phone_type;
       users          postgres    false    11            4           1255    16964    get_aboutpage()    FUNCTION     �  CREATE FUNCTION aboutpage.get_aboutpage() RETURNS jsonb
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
    	   aboutpage          postgres    false    8            &           1255    16994    get_carpage()    FUNCTION     m  CREATE FUNCTION carpage.get_carpage() RETURNS jsonb
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
       carpage          postgres    false    10            %           1255    16982    get_contactpage()    FUNCTION     S  CREATE FUNCTION contactpage.get_contactpage() RETURNS jsonb
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
       contactpage          postgres    false    9                        1255    16876 	   get_car()    FUNCTION     �   CREATE FUNCTION homepage.get_car() RETURNS jsonb
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
       homepage          postgres    false    6            !           1255    16877    get_chooseus()    FUNCTION     }  CREATE FUNCTION homepage.get_chooseus() RETURNS jsonb
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
       homepage          postgres    false    6            "           1255    16884 	   get_cta()    FUNCTION     �   CREATE FUNCTION homepage.get_cta() RETURNS jsonb
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
       homepage          postgres    false    6                       1255    16875    get_features()    FUNCTION     v  CREATE FUNCTION homepage.get_features() RETURNS jsonb
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
       homepage          postgres    false    6            +           1255    16787 
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
       homepage          postgres    false    6            #           1255    16885    get_homepage()    FUNCTION     �  CREATE FUNCTION homepage.get_homepage() RETURNS jsonb
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
       homepage          postgres    false    6                       1255    16874    get_services()    FUNCTION     w  CREATE FUNCTION homepage.get_services() RETURNS jsonb
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
       homepage          postgres    false    6            3           1255    16806    get_layout()    FUNCTION     �  CREATE FUNCTION layout.get_layout() RETURNS jsonb
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
       layout          postgres    false    7            5           1255    52231 &   check_product_id_customer_id_existed()    FUNCTION     G  CREATE FUNCTION public.check_product_id_customer_id_existed() RETURNS trigger
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
       public          postgres    false            $           1255    52372 #   check_unique_email_phone_customer()    FUNCTION       CREATE FUNCTION users.check_unique_email_phone_customer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF EXISTS(
		SELECT 1 FROM USERS.CUSTOMERS WHERE EMAIL = NEW.EMAIL OR PHONE = NEW.PHONE
	) THEN RAISE EXCEPTION 'Email or Phone was existed!';
	END IF;
	RETURN NEW;
END;
$$;
 9   DROP FUNCTION users.check_unique_email_phone_customer();
       users          postgres    false    11            �            1259    16902    about    TABLE     �   CREATE TABLE aboutpage.about (
    _id integer NOT NULL,
    title text[] NOT NULL,
    text text,
    img character varying(20) NOT NULL
);
    DROP TABLE aboutpage.about;
    	   aboutpage         heap    postgres    false    8            �            1259    16901    about__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.about ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    240            �            1259    16918    about_items    TABLE     �   CREATE TABLE aboutpage.about_items (
    _id integer NOT NULL,
    title character varying(15) NOT NULL,
    text text NOT NULL
);
 "   DROP TABLE aboutpage.about_items;
    	   aboutpage         heap    postgres    false    8            �            1259    16917    about_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.about_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.about_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    244    8            �            1259    16956    clients    TABLE     z   CREATE TABLE aboutpage.clients (
    title character varying(30) NOT NULL,
    subtitle character varying(20) NOT NULL
);
    DROP TABLE aboutpage.clients;
    	   aboutpage         heap    postgres    false    8            �            1259    16960    clients_items    TABLE     �   CREATE TABLE aboutpage.clients_items (
    _id smallint NOT NULL,
    img character varying(30) NOT NULL,
    alt character varying(30)
);
 $   DROP TABLE aboutpage.clients_items;
    	   aboutpage         heap    postgres    false    8            �            1259    16959    clients_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.clients_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.clients_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    8    255            �            1259    16909    features    TABLE     �   CREATE TABLE aboutpage.features (
    _id integer NOT NULL,
    title character varying(50) NOT NULL,
    text text NOT NULL,
    img character varying(30) NOT NULL
);
    DROP TABLE aboutpage.features;
    	   aboutpage         heap    postgres    false    8            �            1259    16908    features__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.features ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.features__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    242    8            �            1259    16953    quantities_items    TABLE     �   CREATE TABLE aboutpage.quantities_items (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    value smallint NOT NULL
);
 '   DROP TABLE aboutpage.quantities_items;
    	   aboutpage         heap    postgres    false    8            �            1259    16952    quantities_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.quantities_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.quantities_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    252    8            �            1259    16923    teams    TABLE     x   CREATE TABLE aboutpage.teams (
    title character varying(15) NOT NULL,
    subtitle character varying(30) NOT NULL
);
    DROP TABLE aboutpage.teams;
    	   aboutpage         heap    postgres    false    8            �            1259    16927    teams_items    TABLE     �   CREATE TABLE aboutpage.teams_items (
    _id integer NOT NULL,
    name character varying(50) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL
);
 "   DROP TABLE aboutpage.teams_items;
    	   aboutpage         heap    postgres    false    8            �            1259    16926    teams_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.teams_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.teams_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    247    8            �            1259    16941    testimonials    TABLE     �   CREATE TABLE aboutpage.testimonials (
    title character varying(30) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text
);
 #   DROP TABLE aboutpage.testimonials;
    	   aboutpage         heap    postgres    false    8            �            1259    16947    testimonials_items    TABLE     �   CREATE TABLE aboutpage.testimonials_items (
    _id smallint NOT NULL,
    name character varying(30) NOT NULL,
    img character varying(30) NOT NULL,
    "position" character varying(30) NOT NULL,
    rate numeric NOT NULL,
    text text NOT NULL
);
 )   DROP TABLE aboutpage.testimonials_items;
    	   aboutpage         heap    postgres    false    8            �            1259    16946    testimonials_items__id_seq    SEQUENCE     �   ALTER TABLE aboutpage.testimonials_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME aboutpage.testimonials_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
         	   aboutpage          postgres    false    250    8                       1259    16987 
   filterform    TABLE     �   CREATE TABLE carpage.filterform (
    _id smallint NOT NULL,
    name character varying(15) NOT NULL,
    label character varying(15) NOT NULL,
    options character varying(12)[] NOT NULL
);
    DROP TABLE carpage.filterform;
       carpage         heap    postgres    false    10                       1259    16986    filterform__id_seq    SEQUENCE     �   ALTER TABLE carpage.filterform ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME carpage.filterform__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            carpage          postgres    false    261    10                        1259    16966    contact    TABLE     ^   CREATE TABLE contactpage.contact (
    title character varying(30) NOT NULL,
    text text
);
     DROP TABLE contactpage.contact;
       contactpage         heap    postgres    false    9                       1259    16971    schedule    TABLE     �   CREATE TABLE contactpage.schedule (
    weekdays character varying(20) NOT NULL,
    saturday character varying(20) NOT NULL,
    sunday character varying(20) NOT NULL
);
 !   DROP TABLE contactpage.schedule;
       contactpage         heap    postgres    false    9                       1259    16975 	   showrooms    TABLE     �   CREATE TABLE contactpage.showrooms (
    _id smallint NOT NULL,
    name character varying(20) NOT NULL,
    address text NOT NULL,
    email character varying(30) NOT NULL,
    phone character varying(17) NOT NULL
);
 "   DROP TABLE contactpage.showrooms;
       contactpage         heap    postgres    false    9                       1259    16974    showrooms__id_seq    SEQUENCE     �   ALTER TABLE contactpage.showrooms ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME contactpage.showrooms__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            contactpage          postgres    false    259    9            �            1259    16837    car    TABLE     u   CREATE TABLE homepage.car (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL
);
    DROP TABLE homepage.car;
       homepage         heap    postgres    false    6            �            1259    16847    chooseus    TABLE     x   CREATE TABLE homepage.chooseus (
    title character varying(25) NOT NULL,
    text text,
    videourl text NOT NULL
);
    DROP TABLE homepage.chooseus;
       homepage         heap    postgres    false    6            �            1259    16853    chooseus_items    TABLE     [   CREATE TABLE homepage.chooseus_items (
    _id integer NOT NULL,
    text text NOT NULL
);
 $   DROP TABLE homepage.chooseus_items;
       homepage         heap    postgres    false    6            �            1259    16852    chooseus_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.chooseus_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.chooseus_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    236    6            �            1259    16868    cta    TABLE     �   CREATE TABLE homepage.cta (
    title character varying(25) NOT NULL,
    text text,
    img character varying(10) NOT NULL,
    _id integer NOT NULL
);
    DROP TABLE homepage.cta;
       homepage         heap    postgres    false    6            �            1259    16878    cta__id_seq    SEQUENCE     �   ALTER TABLE homepage.cta ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.cta__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    237    6            �            1259    16828    features    TABLE     �   CREATE TABLE homepage.features (
    title character varying(15) NOT NULL,
    subtitle character varying(50) NOT NULL,
    text text[]
);
    DROP TABLE homepage.features;
       homepage         heap    postgres    false    6            �            1259    16834    features_items    TABLE     �   CREATE TABLE homepage.features_items (
    _id integer NOT NULL,
    text character varying(10) NOT NULL,
    img character varying(15) NOT NULL
);
 $   DROP TABLE homepage.features_items;
       homepage         heap    postgres    false    6            �            1259    16833    features_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.features_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.features_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    232    6            �            1259    16775    hero    TABLE     �   CREATE TABLE homepage.hero (
    title character varying(20) NOT NULL,
    models smallint[] NOT NULL,
    brands character varying(15)[] NOT NULL,
    transmissions character varying(15)[] NOT NULL,
    types character varying(10)[] NOT NULL
);
    DROP TABLE homepage.hero;
       homepage         heap    postgres    false    6            �            1259    16815    services    TABLE     �   CREATE TABLE homepage.services (
    title character varying(20) NOT NULL,
    subtitle character varying(20) NOT NULL,
    text text
);
    DROP TABLE homepage.services;
       homepage         heap    postgres    false    6            �            1259    16821    services_items    TABLE     �   CREATE TABLE homepage.services_items (
    _id integer NOT NULL,
    title character varying(20) NOT NULL,
    text text NOT NULL,
    img character varying(20) NOT NULL
);
 $   DROP TABLE homepage.services_items;
       homepage         heap    postgres    false    6            �            1259    16820    services_items__id_seq    SEQUENCE     �   ALTER TABLE homepage.services_items ALTER COLUMN _id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME homepage.services_items__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            homepage          postgres    false    229    6            �            1259    16801    contactInfo    TABLE     �   CREATE TABLE layout."contactInfo" (
    email character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    schedule character varying(30) NOT NULL,
    socials jsonb NOT NULL
);
 !   DROP TABLE layout."contactInfo";
       layout         heap    postgres    false    7            �            1259    16796    footer    TABLE     �   CREATE TABLE layout.footer (
    "contactTitle" character varying(20) NOT NULL,
    "aboutContent" character varying(100) NOT NULL,
    imgs jsonb NOT NULL
);
    DROP TABLE layout.footer;
       layout         heap    postgres    false    7            �            1259    16791    navbar    TABLE     �   CREATE TABLE layout.navbar (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    path character varying(11) NOT NULL
);
    DROP TABLE layout.navbar;
       layout         heap    postgres    false    7            �            1259    16790    navbar_id_seq    SEQUENCE     �   ALTER TABLE layout.navbar ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME layout.navbar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            layout          postgres    false    7    224                       1259    52454    cars    TABLE     �  CREATE TABLE products.cars (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
)
PARTITION BY LIST (brand);
    DROP TABLE products.cars;
       products            postgres    false    12                       1259    52453    cars_id_seq    SEQUENCE     �   ALTER TABLE products.cars ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME products.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            products          postgres    false    12    276                       1259    52460    audi    TABLE     �  CREATE TABLE public.audi (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.audi;
       public         heap    postgres    false    276                       1259    52466    bmw    TABLE     �  CREATE TABLE public.bmw (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.bmw;
       public         heap    postgres    false    276                       1259    52322 	   customers    TABLE     �  CREATE TABLE users.customers (
    id integer NOT NULL,
    email character varying(30) NOT NULL,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    account_type public.account_type NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    code_id text,
    code_expire timestamp with time zone,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    update_at date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT customers_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT customers_phone_check CHECK (((phone)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text))
)
PARTITION BY RANGE (created_at);
    DROP TABLE users.customers;
       users            postgres    false    11    1001                       1259    52332    customers_2024    TABLE     �  CREATE TABLE public.customers_2024 (
    id integer NOT NULL,
    email character varying(30) NOT NULL,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    account_type public.account_type NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    code_id text,
    code_expire timestamp with time zone,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    update_at date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT customers_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT customers_phone_check CHECK (((phone)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text))
);
 "   DROP TABLE public.customers_2024;
       public         heap    postgres    false    1001    263            	           1259    52344    customers_default    TABLE     �  CREATE TABLE public.customers_default (
    id integer NOT NULL,
    email character varying(30) NOT NULL,
    password text NOT NULL,
    name character varying(50) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    account_type public.account_type NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    code_id text,
    code_expire timestamp with time zone,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    update_at date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT customers_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT customers_phone_check CHECK (((phone)::text ~ '^\+?[(\+)?[0-9\s\-]+$'::text))
);
 %   DROP TABLE public.customers_default;
       public         heap    postgres    false    263    1001                       1259    52377 	   employees    TABLE     �  CREATE TABLE users.employees (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    role character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);
    DROP TABLE users.employees;
       users            postgres    false    1079    1075    11                       1259    52384    emp_2024    TABLE     c  CREATE TABLE public.emp_2024 (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    role character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.emp_2024;
       public         heap    postgres    false    267    1075    1079                       1259    52393 
   emp_others    TABLE     e  CREATE TABLE public.emp_others (
    id smallint NOT NULL,
    email public.email_type,
    password text NOT NULL,
    phone public.phone_type,
    name character varying(50) NOT NULL,
    address text NOT NULL,
    role character varying(8) NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL,
    updated_at date DEFAULT CURRENT_DATE NOT NULL
);
    DROP TABLE public.emp_others;
       public         heap    postgres    false    1079    1075    267                       1259    52472    ferrari    TABLE     �  CREATE TABLE public.ferrari (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.ferrari;
       public         heap    postgres    false    276                       1259    52478    ford    TABLE     �  CREATE TABLE public.ford (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.ford;
       public         heap    postgres    false    276                       1259    52484    honda    TABLE     �  CREATE TABLE public.honda (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.honda;
       public         heap    postgres    false    276                       1259    52490    lamborghini    TABLE     �  CREATE TABLE public.lamborghini (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.lamborghini;
       public         heap    postgres    false    276                       1259    52496    mazda    TABLE     �  CREATE TABLE public.mazda (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.mazda;
       public         heap    postgres    false    276                       1259    52502    mercedes    TABLE     �  CREATE TABLE public.mercedes (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.mercedes;
       public         heap    postgres    false    276                       1259    52403    orders    TABLE     >  CREATE TABLE users.orders (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
)
PARTITION BY RANGE (created_at);
    DROP TABLE users.orders;
       users            postgres    false    11                       1259    52411 
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
       public         heap    postgres    false    271                       1259    52419    order_others    TABLE     %  CREATE TABLE public.order_others (
    id smallint NOT NULL,
    customer_id integer NOT NULL,
    product_id smallint NOT NULL,
    quantity smallint DEFAULT 1 NOT NULL,
    paid integer NOT NULL,
    sale_off smallint DEFAULT 0 NOT NULL,
    created_at date DEFAULT CURRENT_DATE NOT NULL
);
     DROP TABLE public.order_others;
       public         heap    postgres    false    271                       1259    52508    other_brand    TABLE     �  CREATE TABLE public.other_brand (
    id smallint NOT NULL,
    name character varying(50) NOT NULL,
    brand character varying(15) NOT NULL,
    price numeric(10,2) NOT NULL,
    transmission character varying(6) NOT NULL,
    "tradeType" character varying(4) NOT NULL,
    "fuelType" character varying(10) NOT NULL,
    type character varying(10) NOT NULL,
    hp smallint NOT NULL,
    model smallint NOT NULL,
    mileage smallint NOT NULL
);
    DROP TABLE public.other_brand;
       public         heap    postgres    false    276                       1259    52428    product    TABLE     �  CREATE TABLE public.product (
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
    mileage smallint NOT NULL
);
    DROP TABLE public.product;
       public         heap    postgres    false                       1259    52321    customers_id_seq    SEQUENCE     �   ALTER TABLE users.customers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME users.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            users          postgres    false    263    11            
           1259    52376    employees_id_seq    SEQUENCE     �   ALTER TABLE users.employees ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME users.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            users          postgres    false    267    11                       1259    52402    orders_id_seq    SEQUENCE     �   ALTER TABLE users.orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME users.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            users          postgres    false    11    271            E           0    0    audi    TABLE ATTACH     T   ALTER TABLE ONLY products.cars ATTACH PARTITION public.audi FOR VALUES IN ('audi');
          public          postgres    false    277    276            F           0    0    bmw    TABLE ATTACH     R   ALTER TABLE ONLY products.cars ATTACH PARTITION public.bmw FOR VALUES IN ('bmw');
          public          postgres    false    278    276            ?           0    0    customers_2024    TABLE ATTACH     z   ALTER TABLE ONLY users.customers ATTACH PARTITION public.customers_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    264    263            @           0    0    customers_default    TABLE ATTACH     T   ALTER TABLE ONLY users.customers ATTACH PARTITION public.customers_default DEFAULT;
          public          postgres    false    265    263            A           0    0    emp_2024    TABLE ATTACH     t   ALTER TABLE ONLY users.employees ATTACH PARTITION public.emp_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    268    267            B           0    0 
   emp_others    TABLE ATTACH     M   ALTER TABLE ONLY users.employees ATTACH PARTITION public.emp_others DEFAULT;
          public          postgres    false    269    267            G           0    0    ferrari    TABLE ATTACH     Z   ALTER TABLE ONLY products.cars ATTACH PARTITION public.ferrari FOR VALUES IN ('ferrari');
          public          postgres    false    279    276            H           0    0    ford    TABLE ATTACH     T   ALTER TABLE ONLY products.cars ATTACH PARTITION public.ford FOR VALUES IN ('ford');
          public          postgres    false    280    276            I           0    0    honda    TABLE ATTACH     V   ALTER TABLE ONLY products.cars ATTACH PARTITION public.honda FOR VALUES IN ('honda');
          public          postgres    false    281    276            J           0    0    lamborghini    TABLE ATTACH     b   ALTER TABLE ONLY products.cars ATTACH PARTITION public.lamborghini FOR VALUES IN ('lamborghini');
          public          postgres    false    282    276            K           0    0    mazda    TABLE ATTACH     V   ALTER TABLE ONLY products.cars ATTACH PARTITION public.mazda FOR VALUES IN ('mazda');
          public          postgres    false    283    276            L           0    0    mercedes    TABLE ATTACH     \   ALTER TABLE ONLY products.cars ATTACH PARTITION public.mercedes FOR VALUES IN ('mercedes');
          public          postgres    false    284    276            C           0    0 
   order_2024    TABLE ATTACH     s   ALTER TABLE ONLY users.orders ATTACH PARTITION public.order_2024 FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
          public          postgres    false    272    271            D           0    0    order_others    TABLE ATTACH     L   ALTER TABLE ONLY users.orders ATTACH PARTITION public.order_others DEFAULT;
          public          postgres    false    273    271            M           0    0    other_brand    TABLE ATTACH     L   ALTER TABLE ONLY products.cars ATTACH PARTITION public.other_brand DEFAULT;
          public          postgres    false    285    276            ^          0    16902    about 
   TABLE DATA           9   COPY aboutpage.about (_id, title, text, img) FROM stdin;
 	   aboutpage          postgres    false    240   �"      b          0    16918    about_items 
   TABLE DATA           :   COPY aboutpage.about_items (_id, title, text) FROM stdin;
 	   aboutpage          postgres    false    244   �#      k          0    16956    clients 
   TABLE DATA           5   COPY aboutpage.clients (title, subtitle) FROM stdin;
 	   aboutpage          postgres    false    253   0%      m          0    16960    clients_items 
   TABLE DATA           9   COPY aboutpage.clients_items (_id, img, alt) FROM stdin;
 	   aboutpage          postgres    false    255   a%      `          0    16909    features 
   TABLE DATA           <   COPY aboutpage.features (_id, title, text, img) FROM stdin;
 	   aboutpage          postgres    false    242   �%      j          0    16953    quantities_items 
   TABLE DATA           ?   COPY aboutpage.quantities_items (_id, name, value) FROM stdin;
 	   aboutpage          postgres    false    252    '      c          0    16923    teams 
   TABLE DATA           3   COPY aboutpage.teams (title, subtitle) FROM stdin;
 	   aboutpage          postgres    false    245   �'      e          0    16927    teams_items 
   TABLE DATA           D   COPY aboutpage.teams_items (_id, name, img, "position") FROM stdin;
 	   aboutpage          postgres    false    247   �'      f          0    16941    testimonials 
   TABLE DATA           @   COPY aboutpage.testimonials (title, subtitle, text) FROM stdin;
 	   aboutpage          postgres    false    248   @(      h          0    16947    testimonials_items 
   TABLE DATA           W   COPY aboutpage.testimonials_items (_id, name, img, "position", rate, text) FROM stdin;
 	   aboutpage          postgres    false    250   �(      s          0    16987 
   filterform 
   TABLE DATA           @   COPY carpage.filterform (_id, name, label, options) FROM stdin;
    carpage          postgres    false    261   v)      n          0    16966    contact 
   TABLE DATA           3   COPY contactpage.contact (title, text) FROM stdin;
    contactpage          postgres    false    256   3*      o          0    16971    schedule 
   TABLE DATA           C   COPY contactpage.schedule (weekdays, saturday, sunday) FROM stdin;
    contactpage          postgres    false    257   �*      q          0    16975 	   showrooms 
   TABLE DATA           J   COPY contactpage.showrooms (_id, name, address, email, phone) FROM stdin;
    contactpage          postgres    false    259   �*      W          0    16837    car 
   TABLE DATA           0   COPY homepage.car (title, subtitle) FROM stdin;
    homepage          postgres    false    233   �+      X          0    16847    chooseus 
   TABLE DATA           ;   COPY homepage.chooseus (title, text, videourl) FROM stdin;
    homepage          postgres    false    234   �+      Z          0    16853    chooseus_items 
   TABLE DATA           5   COPY homepage.chooseus_items (_id, text) FROM stdin;
    homepage          postgres    false    236   �,      [          0    16868    cta 
   TABLE DATA           6   COPY homepage.cta (title, text, img, _id) FROM stdin;
    homepage          postgres    false    237   D-      T          0    16828    features 
   TABLE DATA           ;   COPY homepage.features (title, subtitle, text) FROM stdin;
    homepage          postgres    false    230   �-      V          0    16834    features_items 
   TABLE DATA           :   COPY homepage.features_items (_id, text, img) FROM stdin;
    homepage          postgres    false    232   �.      L          0    16775    hero 
   TABLE DATA           M   COPY homepage.hero (title, models, brands, transmissions, types) FROM stdin;
    homepage          postgres    false    222   /      Q          0    16815    services 
   TABLE DATA           ;   COPY homepage.services (title, subtitle, text) FROM stdin;
    homepage          postgres    false    227   �/      S          0    16821    services_items 
   TABLE DATA           A   COPY homepage.services_items (_id, title, text, img) FROM stdin;
    homepage          postgres    false    229   0      P          0    16801    contactInfo 
   TABLE DATA           H   COPY layout."contactInfo" (email, phone, schedule, socials) FROM stdin;
    layout          postgres    false    226   �0      O          0    16796    footer 
   TABLE DATA           F   COPY layout.footer ("contactTitle", "aboutContent", imgs) FROM stdin;
    layout          postgres    false    225   g1      N          0    16791    navbar 
   TABLE DATA           0   COPY layout.navbar (id, name, path) FROM stdin;
    layout          postgres    false    224   2                0    52460    audi 
   TABLE DATA           w   COPY public.audi (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    277   N2      �          0    52466    bmw 
   TABLE DATA           v   COPY public.bmw (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    278   �2      u          0    52332    customers_2024 
   TABLE DATA           �   COPY public.customers_2024 (id, email, password, name, phone, address, account_type, is_active, code_id, code_expire, created_at, update_at) FROM stdin;
    public          postgres    false    264   E3      v          0    52344    customers_default 
   TABLE DATA           �   COPY public.customers_default (id, email, password, name, phone, address, account_type, is_active, code_id, code_expire, created_at, update_at) FROM stdin;
    public          postgres    false    265   �3      x          0    52384    emp_2024 
   TABLE DATA           k   COPY public.emp_2024 (id, email, password, phone, name, address, role, created_at, updated_at) FROM stdin;
    public          postgres    false    268   �3      y          0    52393 
   emp_others 
   TABLE DATA           m   COPY public.emp_others (id, email, password, phone, name, address, role, created_at, updated_at) FROM stdin;
    public          postgres    false    269   4      �          0    52472    ferrari 
   TABLE DATA           z   COPY public.ferrari (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    279   #4      �          0    52478    ford 
   TABLE DATA           w   COPY public.ford (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    280   �4      �          0    52484    honda 
   TABLE DATA           x   COPY public.honda (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    281   B5      �          0    52490    lamborghini 
   TABLE DATA           ~   COPY public.lamborghini (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    282   �5      �          0    52496    mazda 
   TABLE DATA           x   COPY public.mazda (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    283   ]6      �          0    52502    mercedes 
   TABLE DATA           {   COPY public.mercedes (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    284   �6      {          0    52411 
   order_2024 
   TABLE DATA           g   COPY public.order_2024 (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
    public          postgres    false    272   N7      |          0    52419    order_others 
   TABLE DATA           i   COPY public.order_others (id, customer_id, product_id, quantity, paid, sale_off, created_at) FROM stdin;
    public          postgres    false    273   7      �          0    52508    other_brand 
   TABLE DATA           ~   COPY public.other_brand (id, name, brand, price, transmission, "tradeType", "fuelType", type, hp, model, mileage) FROM stdin;
    public          postgres    false    285   �7      }          0    52428    product 
   TABLE DATA           v   COPY public.product (id, name, brand, price, transmission, tradetype, fueltype, type, hp, model, mileage) FROM stdin;
    public          postgres    false    274   �7      �           0    0    about__id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('aboutpage.about__id_seq', 1, true);
       	   aboutpage          postgres    false    239            �           0    0    about_items__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('aboutpage.about_items__id_seq', 2, true);
       	   aboutpage          postgres    false    243            �           0    0    clients_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('aboutpage.clients_items__id_seq', 6, true);
       	   aboutpage          postgres    false    254            �           0    0    features__id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('aboutpage.features__id_seq', 3, true);
       	   aboutpage          postgres    false    241            �           0    0    quantities_items__id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('aboutpage.quantities_items__id_seq', 4, true);
       	   aboutpage          postgres    false    251            �           0    0    teams_items__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('aboutpage.teams_items__id_seq', 4, true);
       	   aboutpage          postgres    false    246            �           0    0    testimonials_items__id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('aboutpage.testimonials_items__id_seq', 2, true);
       	   aboutpage          postgres    false    249            �           0    0    filterform__id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('carpage.filterform__id_seq', 5, true);
          carpage          postgres    false    260            �           0    0    showrooms__id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('contactpage.showrooms__id_seq', 3, true);
          contactpage          postgres    false    258            �           0    0    chooseus_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.chooseus_items__id_seq', 4, true);
          homepage          postgres    false    235            �           0    0    cta__id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('homepage.cta__id_seq', 2, true);
          homepage          postgres    false    238            �           0    0    features_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.features_items__id_seq', 6, true);
          homepage          postgres    false    231            �           0    0    services_items__id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('homepage.services_items__id_seq', 4, true);
          homepage          postgres    false    228            �           0    0    navbar_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('layout.navbar_id_seq', 4, true);
          layout          postgres    false    223            �           0    0    cars_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('products.cars_id_seq', 16, true);
          products          postgres    false    275            �           0    0    customers_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('users.customers_id_seq', 2, true);
          users          postgres    false    262            �           0    0    employees_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('users.employees_id_seq', 1, true);
          users          postgres    false    266            �           0    0    orders_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('users.orders_id_seq', 1, true);
          users          postgres    false    270            v           2606    16915 !   features pk_aboutpage_features_id 
   CONSTRAINT     c   ALTER TABLE ONLY aboutpage.features
    ADD CONSTRAINT pk_aboutpage_features_id PRIMARY KEY (_id);
 N   ALTER TABLE ONLY aboutpage.features DROP CONSTRAINT pk_aboutpage_features_id;
    	   aboutpage            postgres    false    242            z           2606    16993 #   filterform pk_carpage_filterform_id 
   CONSTRAINT     c   ALTER TABLE ONLY carpage.filterform
    ADD CONSTRAINT pk_carpage_filterform_id PRIMARY KEY (_id);
 N   ALTER TABLE ONLY carpage.filterform DROP CONSTRAINT pk_carpage_filterform_id;
       carpage            postgres    false    261            x           2606    16981    showrooms pk_showrooms_id 
   CONSTRAINT     ]   ALTER TABLE ONLY contactpage.showrooms
    ADD CONSTRAINT pk_showrooms_id PRIMARY KEY (_id);
 H   ALTER TABLE ONLY contactpage.showrooms DROP CONSTRAINT pk_showrooms_id;
       contactpage            postgres    false    259            t           2606    16859 #   chooseus_items pk_chooseus_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.chooseus_items
    ADD CONSTRAINT pk_chooseus_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.chooseus_items DROP CONSTRAINT pk_chooseus_items_id;
       homepage            postgres    false    236            q           2606    16841 #   features_items pk_features_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.features_items
    ADD CONSTRAINT pk_features_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.features_items DROP CONSTRAINT pk_features_items_id;
       homepage            postgres    false    232            o           2606    16827 #   services_items pk_services_items_id 
   CONSTRAINT     d   ALTER TABLE ONLY homepage.services_items
    ADD CONSTRAINT pk_services_items_id PRIMARY KEY (_id);
 O   ALTER TABLE ONLY homepage.services_items DROP CONSTRAINT pk_services_items_id;
       homepage            postgres    false    229            m           2606    16795    navbar pk_navbar_id 
   CONSTRAINT     Q   ALTER TABLE ONLY layout.navbar
    ADD CONSTRAINT pk_navbar_id PRIMARY KEY (id);
 =   ALTER TABLE ONLY layout.navbar DROP CONSTRAINT pk_navbar_id;
       layout            postgres    false    224            �           2606    52459    cars pk_product_cars_id 
   CONSTRAINT     ^   ALTER TABLE ONLY products.cars
    ADD CONSTRAINT pk_product_cars_id PRIMARY KEY (id, brand);
 C   ALTER TABLE ONLY products.cars DROP CONSTRAINT pk_product_cars_id;
       products            postgres    false    276    276            �           2606    52432 &   product PK_bebc9158e480b949565b4dc7a82 
   CONSTRAINT     f   ALTER TABLE ONLY public.product
    ADD CONSTRAINT "PK_bebc9158e480b949565b4dc7a82" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.product DROP CONSTRAINT "PK_bebc9158e480b949565b4dc7a82";
       public            postgres    false    274            �           2606    52465    audi audi_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.audi
    ADD CONSTRAINT audi_pkey PRIMARY KEY (id, brand);
 8   ALTER TABLE ONLY public.audi DROP CONSTRAINT audi_pkey;
       public            postgres    false    5014    277    277    277            �           2606    52471    bmw bmw_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.bmw
    ADD CONSTRAINT bmw_pkey PRIMARY KEY (id, brand);
 6   ALTER TABLE ONLY public.bmw DROP CONSTRAINT bmw_pkey;
       public            postgres    false    278    278    278    5014            ~           2606    52331    customers pk_user_id_created_at 
   CONSTRAINT     h   ALTER TABLE ONLY users.customers
    ADD CONSTRAINT pk_user_id_created_at PRIMARY KEY (id, created_at);
 H   ALTER TABLE ONLY users.customers DROP CONSTRAINT pk_user_id_created_at;
       users            postgres    false    263    263            �           2606    52341 "   customers_2024 customers_2024_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.customers_2024
    ADD CONSTRAINT customers_2024_pkey PRIMARY KEY (id, created_at);
 L   ALTER TABLE ONLY public.customers_2024 DROP CONSTRAINT customers_2024_pkey;
       public            postgres    false    264    264    4990    264            �           2606    52353 (   customers_default customers_default_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.customers_default
    ADD CONSTRAINT customers_default_pkey PRIMARY KEY (id, created_at);
 R   ALTER TABLE ONLY public.customers_default DROP CONSTRAINT customers_default_pkey;
       public            postgres    false    265    265    4990    265            �           2606    52383    employees pk_emp_id 
   CONSTRAINT     \   ALTER TABLE ONLY users.employees
    ADD CONSTRAINT pk_emp_id PRIMARY KEY (id, created_at);
 <   ALTER TABLE ONLY users.employees DROP CONSTRAINT pk_emp_id;
       users            postgres    false    267    267            �           2606    52390    emp_2024 emp_2024_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.emp_2024
    ADD CONSTRAINT emp_2024_pkey PRIMARY KEY (id, created_at);
 @   ALTER TABLE ONLY public.emp_2024 DROP CONSTRAINT emp_2024_pkey;
       public            postgres    false    268    268    5000    268            �           2606    52399    emp_others emp_others_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.emp_others
    ADD CONSTRAINT emp_others_pkey PRIMARY KEY (id, created_at);
 D   ALTER TABLE ONLY public.emp_others DROP CONSTRAINT emp_others_pkey;
       public            postgres    false    269    5000    269    269            �           2606    52477    ferrari ferrari_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.ferrari
    ADD CONSTRAINT ferrari_pkey PRIMARY KEY (id, brand);
 >   ALTER TABLE ONLY public.ferrari DROP CONSTRAINT ferrari_pkey;
       public            postgres    false    5014    279    279    279            �           2606    52483    ford ford_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.ford
    ADD CONSTRAINT ford_pkey PRIMARY KEY (id, brand);
 8   ALTER TABLE ONLY public.ford DROP CONSTRAINT ford_pkey;
       public            postgres    false    280    280    280    5014            �           2606    52489    honda honda_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.honda
    ADD CONSTRAINT honda_pkey PRIMARY KEY (id, brand);
 :   ALTER TABLE ONLY public.honda DROP CONSTRAINT honda_pkey;
       public            postgres    false    281    281    5014    281            �           2606    52495    lamborghini lamborghini_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.lamborghini
    ADD CONSTRAINT lamborghini_pkey PRIMARY KEY (id, brand);
 F   ALTER TABLE ONLY public.lamborghini DROP CONSTRAINT lamborghini_pkey;
       public            postgres    false    282    282    5014    282            �           2606    52501    mazda mazda_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.mazda
    ADD CONSTRAINT mazda_pkey PRIMARY KEY (id, brand);
 :   ALTER TABLE ONLY public.mazda DROP CONSTRAINT mazda_pkey;
       public            postgres    false    5014    283    283    283            �           2606    52507    mercedes mercedes_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.mercedes
    ADD CONSTRAINT mercedes_pkey PRIMARY KEY (id, brand);
 @   ALTER TABLE ONLY public.mercedes DROP CONSTRAINT mercedes_pkey;
       public            postgres    false    284    284    5014    284            �           2606    52410    orders pk_customer_order_id 
   CONSTRAINT     d   ALTER TABLE ONLY users.orders
    ADD CONSTRAINT pk_customer_order_id PRIMARY KEY (id, created_at);
 D   ALTER TABLE ONLY users.orders DROP CONSTRAINT pk_customer_order_id;
       users            postgres    false    271    271            �           2606    52418    order_2024 order_2024_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.order_2024
    ADD CONSTRAINT order_2024_pkey PRIMARY KEY (id, created_at);
 D   ALTER TABLE ONLY public.order_2024 DROP CONSTRAINT order_2024_pkey;
       public            postgres    false    272    272    272    5006            �           2606    52426    order_others order_others_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.order_others
    ADD CONSTRAINT order_others_pkey PRIMARY KEY (id, created_at);
 H   ALTER TABLE ONLY public.order_others DROP CONSTRAINT order_others_pkey;
       public            postgres    false    273    273    273    5006            �           2606    52513    other_brand other_brand_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.other_brand
    ADD CONSTRAINT other_brand_pkey PRIMARY KEY (id, brand);
 F   ALTER TABLE ONLY public.other_brand DROP CONSTRAINT other_brand_pkey;
       public            postgres    false    285    285    285    5014            r           1259    16860    idx_chooseus_items    INDEX     N   CREATE INDEX idx_chooseus_items ON homepage.chooseus_items USING btree (_id);
 (   DROP INDEX homepage.idx_chooseus_items;
       homepage            postgres    false    236            {           1259    52359    idx_customer_email_password    INDEX     `   CREATE INDEX idx_customer_email_password ON ONLY users.customers USING btree (email, password);
 .   DROP INDEX users.idx_customer_email_password;
       users            postgres    false    263    263                       1259    52360 !   customers_2024_email_password_idx    INDEX     g   CREATE INDEX customers_2024_email_password_idx ON public.customers_2024 USING btree (email, password);
 5   DROP INDEX public.customers_2024_email_password_idx;
       public            postgres    false    264    4987    264    264            |           1259    52356    idx_customer_id    INDEX     G   CREATE INDEX idx_customer_id ON ONLY users.customers USING btree (id);
 "   DROP INDEX users.idx_customer_id;
       users            postgres    false    263            �           1259    52357    customers_2024_id_idx    INDEX     N   CREATE INDEX customers_2024_id_idx ON public.customers_2024 USING btree (id);
 )   DROP INDEX public.customers_2024_id_idx;
       public            postgres    false    264    264    4988            �           1259    52361 $   customers_default_email_password_idx    INDEX     m   CREATE INDEX customers_default_email_password_idx ON public.customers_default USING btree (email, password);
 8   DROP INDEX public.customers_default_email_password_idx;
       public            postgres    false    265    4987    265    265            �           1259    52358    customers_default_id_idx    INDEX     T   CREATE INDEX customers_default_id_idx ON public.customers_default USING btree (id);
 ,   DROP INDEX public.customers_default_id_idx;
       public            postgres    false    4988    265    265            �           0    0 	   audi_pkey    INDEX ATTACH     K   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.audi_pkey;
          public          postgres    false    5016    5014    277    5014    277    276            �           0    0    bmw_pkey    INDEX ATTACH     J   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.bmw_pkey;
          public          postgres    false    5014    5018    278    5014    278    276            �           0    0 !   customers_2024_email_password_idx    INDEX ATTACH     i   ALTER INDEX users.idx_customer_email_password ATTACH PARTITION public.customers_2024_email_password_idx;
          public          postgres    false    4991    4987    264    263            �           0    0    customers_2024_id_idx    INDEX ATTACH     Q   ALTER INDEX users.idx_customer_id ATTACH PARTITION public.customers_2024_id_idx;
          public          postgres    false    4992    4988    264    263            �           0    0    customers_2024_pkey    INDEX ATTACH     U   ALTER INDEX users.pk_user_id_created_at ATTACH PARTITION public.customers_2024_pkey;
          public          postgres    false    4990    264    4994    4990    264    263            �           0    0 $   customers_default_email_password_idx    INDEX ATTACH     l   ALTER INDEX users.idx_customer_email_password ATTACH PARTITION public.customers_default_email_password_idx;
          public          postgres    false    4995    4987    265    263            �           0    0    customers_default_id_idx    INDEX ATTACH     T   ALTER INDEX users.idx_customer_id ATTACH PARTITION public.customers_default_id_idx;
          public          postgres    false    4996    4988    265    263            �           0    0    customers_default_pkey    INDEX ATTACH     X   ALTER INDEX users.pk_user_id_created_at ATTACH PARTITION public.customers_default_pkey;
          public          postgres    false    265    4998    4990    4990    265    263            �           0    0    emp_2024_pkey    INDEX ATTACH     C   ALTER INDEX users.pk_emp_id ATTACH PARTITION public.emp_2024_pkey;
          public          postgres    false    5002    5000    268    5000    268    267            �           0    0    emp_others_pkey    INDEX ATTACH     E   ALTER INDEX users.pk_emp_id ATTACH PARTITION public.emp_others_pkey;
          public          postgres    false    5004    5000    269    5000    269    267            �           0    0    ferrari_pkey    INDEX ATTACH     N   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.ferrari_pkey;
          public          postgres    false    5014    5020    279    5014    279    276            �           0    0 	   ford_pkey    INDEX ATTACH     K   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.ford_pkey;
          public          postgres    false    5014    280    5022    5014    280    276            �           0    0 
   honda_pkey    INDEX ATTACH     L   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.honda_pkey;
          public          postgres    false    5024    5014    281    5014    281    276            �           0    0    lamborghini_pkey    INDEX ATTACH     R   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.lamborghini_pkey;
          public          postgres    false    5026    282    5014    5014    282    276            �           0    0 
   mazda_pkey    INDEX ATTACH     L   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.mazda_pkey;
          public          postgres    false    5028    5014    283    5014    283    276            �           0    0    mercedes_pkey    INDEX ATTACH     O   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.mercedes_pkey;
          public          postgres    false    5014    5030    284    5014    284    276            �           0    0    order_2024_pkey    INDEX ATTACH     P   ALTER INDEX users.pk_customer_order_id ATTACH PARTITION public.order_2024_pkey;
          public          postgres    false    272    5008    5006    5006    272    271            �           0    0    order_others_pkey    INDEX ATTACH     R   ALTER INDEX users.pk_customer_order_id ATTACH PARTITION public.order_others_pkey;
          public          postgres    false    5006    273    5010    5006    273    271            �           0    0    other_brand_pkey    INDEX ATTACH     R   ALTER INDEX products.pk_product_cars_id ATTACH PARTITION public.other_brand_pkey;
          public          postgres    false    5014    285    5032    5014    285    276            �           2620    52373 ,   customers check_email_phone_customer_trigger    TRIGGER     �   CREATE TRIGGER check_email_phone_customer_trigger BEFORE INSERT OR UPDATE ON users.customers FOR EACH ROW EXECUTE FUNCTION users.check_unique_email_phone_customer();
 D   DROP TRIGGER check_email_phone_customer_trigger ON users.customers;
       users          postgres    false    263    292            ^   �   x�m�Kj�0���)D�m`�P����J�ֱ�-'J�^9��N�}�u��N��J�ˆ��%1p���THY6��Q>t�8�!"�o!�y���;��3���
N��S+@o%ʥ�p��i%�t�˫L��W�� mx�Ga5�s�}�OK��Q�;�L���1��.�qM�������p�$��l�窅�㹺��LZ��t����������c����ȃ<      b   �  x�U�=n�0�k�� ��օ�TI�.@�I��f6�Ȋ�\���I�B�lG�������ׂEkU���}����<0�E�͟�N�)6��;���y�c-iF���_}���9����\Q����Z�FhE�EZw<�S�Ш��)�И�g���M�'^�,R����M)ʚ	!=��LXR�HZ��|�����	U��S&���c���IB�q
�C~i�^�R��Iv0�Y�XD�iL4qj���}����\�I�P��(2R�>�6��LI-������ԵxH�&�lo���A��N2��l�F�w�'ӟ+�M����	���g|���� $�N��^�����&B�%���'^��������66J�Mtl��^��[�h^n�����W�~����E<��      k   !   x�+H,*�K-��/-RH��L�+)����� y�       m   s   x�5�K
�0E�q�
o��|WӉqe������K�h"��X�������)`_�?�"ÍV�Z�Se2��$�ң���� ��_I�ҥ�b�Ғ||�O��t����w��(?h      `   ,  x�U�1R1Ek�)t� �����Jū�=�Z�%�َkp=N��.�Fҗ����aN������.J�K
B�
h���
��XBpI!�(l�/�oI�褢T)��MU��@+�Y +MF�Mn!�VI�py8>n%L'�������Y��$B�n�l�̰s�J!k�I��Ѽ�^��P�p�cT�e���
Lh�>�%��G��9��Ke�(Z��q\0����|,�9���
f���K�gH���k/�����m��^� �fd��͠>������W�w�A>�l���<@?�i��¨      j   W   x�3�,K��L�I-V(.�O��4�42�2BM�I�4450�2�LIr��R�2Sˋ9��M�L83
*�s2S�J�9M�Jc���� {      c   $   x��/-R(IM���MM-Q��R+
R�J�b���� �S	�      e   u   x�-�K�0Eѱ��l�J�� 1fL�b%.����݃�Ξt�^�4x���0�K������E4bS2��������z�cΤ��q�C��C)�� �6Ր+����O^�CV�� �w-	      f   f   x����0k2�O�
�@IC、���b{Bsş����-9ѥ�s������􂢸�u�F�X\Mn�
�iKL���P/E�5�c���~R>!��sB� A�'�      h   �   x���AN1��u�� �P*v .Ѝ�1Wqb���.������C����*��`QkB��{����'������m�B�O�j�\�(֜Kp�Z��ip����9��m��17����bS��N�8V������τʬ{z�iP��B��SbU�S[�F��s�o�s^��"u��      s   �   x�U�M� �5��LE�����L�����(��BbL�|��������<o����p5�H�"�	7bF���O���H-\0�|�Zu�J�F�Ѝ]�;1"�^j�I�����z���	fL�<�x/r/R=����?2�)ԯ~ť�^8�N���)��Q��E^�R��OF      n   [   x��1�0�ٞ�o.�'r!��
�^__^��ځН��M�8�`_�=��a�ɧ���,(*A%0w#�0��F��w�i�)�ɭ$�      o   ,   x�3��20PH�U(�W0�r9�͠��9�ũ)\1z\\\ o'\      q   �   x�}�;�@���Wl��\�%���&��pn����=�+�Mfw��X����V�YR��j��#8T��vQ���ߕ�IF����f|Y5ʊg6e2�{S�� �h�2q|�Doҏ���Rz�֍�p�Z<�z�����쌣��w��W�$���Fh8˼�6��)�Y�¾7��o�(���� x�c      W   *   x��/-RHN,*�LJ-.Q(���L�IU�OKK-*����� ��2      X   �   x�%�1��@F᚜�'H��V4HT�4^�1�ь�!�'�v�I_OX� If�pm�� �QA�e��PE�HXfT�F��(δ"��#�#��NK��T�����^M'a��$�����!���3M��q����(��:������o���ǫ�q�/��D�      Z   �   x�U�I
B1D��)� p��+A<��6��4d��~�qU�z��.T��z���.�l��l�7�ld.���m*l)¥�$@�����*�QSԥ�lT���2�x7o��\x����!}E�`&A��\S<��>��?�p^��u��g!c�)�S��zNo      [   v   x���A
�0����}@H�Ӌj��[��)�}Mo���,�2l�l�M-��@(��a]*��Q�6\T%n(�\JH�b=Ջ�r�]x :��t_�׹�5�/�e�����m���?�M�      T   �   x���;NAD�S�6^�IH &1��QI�����;�����=�Xx�x,�˗BV|��V�
H��|__��u��`td�o(s��$A*Z�ء�Z��2��
�~䘣���p���G�~�������4~����?��:*��|��a_r�f��;=M'O]K�E����&#}%{�6<���h��s{�o��1勛      V   `   x�=�1� @ѹ��&(r$�I!�����8&�)�w����7��j�����Z8����N,��-�� ���()V[�� ׈�qP>WD� �1w      L   w   x��A� @�u9��n�����B,���4����K~�TH��&	��G�vk�;Xc�`��up;�;%X1;�gL%����\���B��1d,׳j ,P���Dl>:��C=.J��,�      Q   c   x����0��U������ ��)��ݾ�����_�������}���1�BFLE���)���������k�!��������2C�#�ü|ߥ�#.(      S   �   x����	�0г=��K�@�=���"9��@���%r��?��pJb�!��W�J�Ț&޸F�(�K�ĩ�A3�8% �T�V\3xsmbYג
켓*�E��Uҝ#��#l�����w<]�N���{�Y����xJ&W۶5����t2>�{�AO�u      P   �   x�U�A�0��u{�IWTE��<���V P��DB�wWњ�����T7��u�hg�l�gsX�7�mw��6ӜqT s%%Z �x�޲����@TD�Wi:��+�Q:W�󧄝���t1�� .��ɹ&&�S_{²C�_�ԃ��v+J      O   �   x�Mʱ�0F�>�o'�H����qs0�N.�)M�ދ���N�'��LQ�.��9J�£3!:�������!DnT�Q�d�����Twp��f&��E>�|�D�ZcSl�����A��Ѵ��f���ҳ�?2k�ʏ�dB�/sW1�      N   9   x�3����M���2�LN,*���\Ɯ�I��%��`�˄39?�$1( ep��qqq =�         b   x�u�M@0����S8Aә�c3hDH+�������o~���0Z�'�X{uN�B�uO��0h�TbE�uY5$���.=��5m��~��q��":�3$A      �   u   x�M�1� @��>'@c�a��Ԫ�H�U��&���K_�a^�F�����#!���5�\��2���u}���#	N%����l�8J1&��=ro�l�����X���"��'�      u   H   x�3�,I-.q�M���K���442�p��XX��r��q��''�p�q�������������%�+F��� V��      v      x������ � �      x   <   x�3�LL���s�M���K�υp9��ML��-,�a~P����������%�+F��� G�9      y      x������ � �      �   u   x��̱�0������M #K'6V��R�V���Pgn;��%�dT3�9\75�~���!����(t��m�P���6F�3z��q��p�n������b��&Fnb=:"za/N      �   �   x�u��� ���R8zɅ��8�8k��,�R�$L�5���~����I�1ٹ?v�Y�+Pt�{�9?�����m�"XN���6�i�D^��Q�@��1��hʮ�<K
t�eL��Q��1B���6c�B���5�      �   |   x�m�;�0 ��>E.����fFlL��Ť��0	�	�G����k�Y�O�Y.�q5XOD#po�IRl�a�Ё��q��%BM���R��	ǇJsn��m��L��ɥ��9���3x��눈_;,�      �      x�U�]
� ���9���ܥ/�diʪ��o(4�8�h	���K���A����
�z�X&h�r|��U�C��23x�8��l���։/����8O���������q�B���6-      �   d   x�34��M�JIT0�Мf�z���%��E�y%����9�y��ũ)�y���&�FF��F&�f\�&P���P#L��pQZ�iha3��Ԉ+F��� �o#�      �   m   x�}�1�0���\ �'��,.Xm�$�/]�N�oy!b�u��Ku���GHh�ӶoV�V��+;�O�!���B��RH�������ƿG��|��}=Ce��!�x)�      {   !   x�3�4C#N id�k`�kh����� Bfc      |      x������ � �      �      x������ � �      }      x������ � �     