--GET NAVBAR IN JSONB
SELECT JSON_AGG(NAVBAR)::JSONB AS NAVBAR FROM LAYOUT.NAVBAR;
--GET FOOTER IN JSONB
SELECT TO_JSONB(FOOTER) AS FOOTER FROM LAYOUT.FOOTER;
--GET EMAIL, PHONE IN JSONB
SELECT TO_JSONB("contactInfo") AS CONTACTINFO FROM LAYOUT."contactInfo";
--GET SCHEDULE IN JSONB
SELECT CONCAT('Weekday: ', STARTAT, ' to ', ENDAT) FROM LAYOUT.SCHEDULE;
--GET SOCIALS IN JSONB
SELECT TO_JSONB(SOCIALS) AS SOSCIAL FROM LAYOUT.SOCIALS;
---COMBINE ALL RESULT TO JSONB---
--TEST COMBINE
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
---CREATE FUNCTION---
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
$$ LANGUAGE plpgsql;

DROP FUNCTION get_combined_json();

SELECT * FROM LAYOUT.GET_LAYOUT();
