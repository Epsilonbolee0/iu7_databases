-- Получение всех преподавателей, имеющих ровно один курс
SELECT name, sex, email FROM (
	SELECT name, sex, email, ROW_NUMBER() OVER (PARTITION BY name) AS counter
	FROM teachers INNER JOIN accounts
	ON teachers.id = accounts.id
	FULL JOIN courses
	ON courses.teacher_id = teachers.id
) AS teachers_info
