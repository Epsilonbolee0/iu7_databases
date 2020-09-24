-- Получение "отображаемых" комментариев
SELECT data, 
	CASE (rating >= 0)
		WHEN true THEN 'displayed'
		ELSE'not displayed'
	END AS status
FROM commentary;
