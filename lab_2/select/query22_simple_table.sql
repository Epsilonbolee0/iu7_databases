-- Найти все курсы, где преподаватель ведёт не свою тему
WITH course_teachers AS (
	SELECT name, courses.id AS id, profile_subject_id, subject_code FROM courses
	INNER JOIN teachers
	ON teachers.id = courses.teacher_id
	INNER JOIN accounts
	ON accounts.id = teachers.id
)

SELECT name, id FROM course_teachers
WHERE profile_subject_id != subject_code;