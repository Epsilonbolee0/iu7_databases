-- Получение среднестатистической девочки
INSERT INTO courses (subject_code, teacher_id, price)
SELECT DISTINCT subject_code, (
	SELECT id
	FROM teachers
	WHERE teachers.profile_subject_id = subject_code
	LIMIT 1
), AVG(price)
FROM courses
GROUP BY subject_code;

SELECT * FROM courses;