-- Получение всех преподавателей, имеющих курс
SELECT name, sex, email FROM (
	SELECT name, sex, email, ROW_NUMBER() OVER (PARTITION BY name) AS counter
	FROM teachers INNER JOIN accounts
	ON teachers.id = accounts.id
) AS teachers_info
WHERE counter = 1