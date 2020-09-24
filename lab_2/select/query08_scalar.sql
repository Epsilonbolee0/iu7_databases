-- Получить количество заданий по каждой теме
SELECT name, count FROM (
	SELECT name, code, (
		SELECT COUNT(*) FROM tasks
		WHERE code = tasks.theme_code
	) AS count FROM themes
) AS temp