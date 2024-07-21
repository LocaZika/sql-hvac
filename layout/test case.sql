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

EXPLAIN ANALYZE SELECT * FROM LAYOUT.GET_LAYOUT();





