-- Получение таблицы с ценами курсов
SELECT id, name,
	CASE
		WHEN price <= 5000.00 THEN 'cheap'
		WHEN price <= 10000.0 THEN 'budgetary'
		WHEN price <= 20000.0 THEN 'reasonable'
		WHEN price <= 35000.0 THEN 'expensive'
		ELSE 'exorbiant'
	END AS type
FROM courses
INNER JOIN subjects
ON subjects.code = courses.subject_code
