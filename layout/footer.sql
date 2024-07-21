--create table footer
CREATE TABLE ui.FOOTER(
	"contactTitle" VARCHAR(20) NOT NULL,
	"aboutContent" VARCHAR(100) NOT NULL,
	imgs JSONB NOT NULL
);
--insert data
INSERT INTO UI.FOOTER VALUES (
	'contact us now!',
	'Any questions? Let us know in store at Ha Noi, Viet Nam or call us on (+84) 123 456 789',
	'{"bg": "footer-bg.jpg", "logo": "footer-logo.png"}'
);
--check data
SELECT * FROM UI.FOOTER;